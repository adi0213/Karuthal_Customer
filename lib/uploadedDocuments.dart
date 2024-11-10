import 'dart:convert';
import 'package:chilla_customer/uploadfiles.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'dart:html' as html;
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

class UploadedDocuments extends StatefulWidget {
  final String token;
  final String userId;
  const UploadedDocuments(
      {super.key, required this.token, required this.userId});

  @override
  State<UploadedDocuments> createState() => _UploadedDocumentsState();
}

class _UploadedDocumentsState extends State<UploadedDocuments> {
  late Future<List> documents;
  List documentsList = [];

  Future<void> fetchAndOpenDocument(int documentId, String documnetName) async {
    final apiUrl =
        'http://104.237.9.211:8007/karuthal/api/v1/documents/${documentId}';
    try {
      final Map<String, String> headers = {
        'Conten-type': 'application/pdf',
        'Accept': '*/*',
        'Authorization': 'Bearer ${widget.token}',
      };

      final response = await http.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        if (kIsWeb) {
          final fileBytes = response.bodyBytes;
          final blob = html.Blob([fileBytes]);
          final url = html.Url.createObjectUrlFromBlob(blob);

          final anchor = html.AnchorElement(href: url)
            ..setAttribute("download", "$documnetName.pdf")
            ..click();
          html.Url.revokeObjectUrl(url);
        } else {
          final directory = await getApplicationDocumentsDirectory();
          final filePath = '${directory.path}/$documnetName.pdf';

          final file = File(filePath);
          await file.writeAsBytes(response.bodyBytes);

          OpenFile.open(filePath);
        }
      } else {
        print('Failed to load document: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching document: $e');
    }
  }

  Future<List> getDocuments() async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': '*/*',
      'Authorization': 'Bearer ${widget.token}'
    };
    final customerDetails = await http.get(
      Uri.parse(
          "http://104.237.9.211:8007/karuthal/api/v1/documents/users/${widget.userId}/documents"),
      headers: headers,
    );

    var DocumentsList = jsonDecode(customerDetails.body);
    return DocumentsList['result'];
  }

  void initState() {
    super.initState();
    documents = getDocuments();
    print("I am ${documents}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFC778CA),
        title: const Text("Uploaded Documents"),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 30),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
          color: Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(child: getList()),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => UploadPage(
                          token: widget.token,
                          userId: widget.userId,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.add,
                        color: Color(0xFFC778CA),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getList() {
    return FutureBuilder<List>(
      future: documents,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          if (snapshot.data == null) {
            return Center(child: Text("No Documents Uploaded"));
          }
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData) {
          documentsList = snapshot.data ?? [];
          if (documentsList.isEmpty) {
            return Center(child: Text("No Documents Uploaded"));
          }
          return ListView.builder(
            itemCount: documentsList.length,
            itemBuilder: (context, index) {
              final document = documentsList[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  onTap: () {
                    fetchAndOpenDocument(
                        document['id'], document['documentType']);
                  },
                  leading: Icon(Icons.picture_as_pdf, color: Colors.red),
                  title: Text(
                    document['documentType'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("ID: ${document['id']}"),
                  trailing: Icon(Icons.download, color: Colors.blueAccent),
                ),
              );
            },
          );
        }
        return Center(child: Text("No data available"));
      },
    );
  }
}
