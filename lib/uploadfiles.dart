import 'dart:convert';
import 'dart:io' as dartIo;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;

class UploadPage extends StatefulWidget {
  final String token;
  final String userId;
  const UploadPage({super.key, required this.token, required this.userId});
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  String? _selectedType;
  //List<String> _uploadedFiles = [];
  List<List<dynamic>> _uploadedFiles = [];
  String _uploadedFileName = "";
  String _uploadedFilePath = "";
  Uint8List? _uploadedFileBytes;

  Future<void> uploadDocument(
      {required String fileName, Uint8List? fileBytes}) async {
    try {
      String apiUrl =
          "http://104.237.9.211:8007/karuthal/api/v1/documents?userId=${widget.userId}&documentType=DRIVING_LICENCE";
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      if (kIsWeb) {
        // Web-specific: Send file as bytes
        request.files.add(
          http.MultipartFile.fromBytes(
            'file', // field name in form-data
            fileBytes!, // bytes of the file
            filename: fileName,
          ),
        );
      } else {
        // Mobile/Desktop: Send file from path
        final file = dartIo.File(fileName);
        request.files.add(
          await http.MultipartFile.fromPath(
            'file', // field name in form-data
            file.path,
          ),
        );
      }

      // Add any additional headers if needed
      request.headers.addAll({
        'Content-Type': 'multipart/form-data',
        'Accept': '*/*',
        'Authorization': 'Bearer ${widget.token}',
      });

      // Add other form fields if needed
      request.fields['file_name'] = fileName;

      // Send the request
      var response = await request.send();

      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);

      if (response.statusCode == 200) {
        print('Upload successful');
        print("${jsonResponse['message']}");
        setState(() {
          _uploadedFiles.clear();
        });
      } else {
        print('Upload failed with status: ${response.statusCode}');
        print("${jsonResponse['message']}");
      }
    } catch (e) {
      print('Error uploading file: $e');
    }
  }

  Future<void> _pickFile() async {
    print("Hello");
    final result = await FilePicker.platform.pickFiles();
    print("Hello2");
    if (result != null) {
      if (kIsWeb) {
        // Use bytes property for web
        Uint8List? fileBytes = result.files.single.bytes;
        String fileName = result.files.single.name;

        final blob = html.Blob([fileBytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);

        // You can now use `fileBytes` and `fileName`
        print('File name: $fileName');
        print('File bytes length: ${fileBytes?.length}');

        setState(() {
          //_uploadedFiles.add(fileName);
          _uploadedFiles.clear();
          _uploadedFiles.add([fileName, url, fileBytes]);

          _uploadedFileName = fileName;
          _uploadedFilePath = url;
          _uploadedFileBytes = fileBytes;

          print("Uploaded: $_uploadedFiles");
        });

        // Handle the file bytes (e.g., upload to server or process data)
      } else {
        print("Hello3");
        final file = dartIo.File(result.files.single.path!);
        print("I am $file");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFC778CA),
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  'UPLOAD FILES',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Center(
                child: Text(
                  'Upload documents to share with the team',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Select Document Type',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text('Select Type'),
                  value: _selectedType,
                  underline: SizedBox(),
                  items: <String>['Driving Licence', 'Ration Card', 'Passport']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedType = newValue;
                    });
                  },
                ),
              ),
              if (_selectedType != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Selected Type: $_selectedType',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFC778CA),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              if (_uploadedFiles.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Uploaded Files',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        children: _uploadedFiles
                            .map((file) => Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: _buildFileContainer(
                                          _uploadedFileName, _uploadedFilePath),
                                    ),
                                    IconButton(
                                      icon:
                                          Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        setState(() {
                                          _uploadedFiles.remove(
                                              file); // Remove the file from the list
                                        });
                                        print("Deleted $file");
                                      },
                                    ),
                                  ],
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 20),
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.upload_file,
                      size: 50,
                      color: Color(0xFFC778CA),
                    ),
                    Text(
                      'Drag and drop files here',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _pickFile,
                      child: Text('Browse'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xFFC778CA),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_uploadedFiles.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("No document selected."),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      uploadDocument(
                          fileName: _uploadedFileName,
                          fileBytes: _uploadedFileBytes);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Files uploaded."),
                          backgroundColor: Color(0xFFC778CA),
                        ),
                      );
                    }
                  },
                  child: Text(
                    'Upload',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFC778CA),
                    minimumSize: Size(150, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFileContainer(String fileName, String url) {
    return GestureDetector(
      onTap: () async {
        if (kIsWeb) {
          // Web-specific: Download the file using bytes
          final anchor = html.AnchorElement(href: url)
            ..setAttribute("download", fileName)
            ..click();
          html.Url.revokeObjectUrl(url);
          // final result = await FilePicker.platform.pickFiles();
          // if (result != null && result.files.single.bytes != null) {
          //   final fileBytes = result.files.single.bytes!;
          //   final blob = html.Blob([fileBytes]);
          //   final url = html.Url.createObjectUrlFromBlob(blob);
          //   final anchor = html.AnchorElement(href: url)
          //     ..setAttribute("download", fileName)
          //     ..click();
          //   html.Url.revokeObjectUrl(url);
          // }
        } else {
          // Non-web platforms: Open file using url_launcher
          final path =
              'file:///${_uploadedFiles.firstWhere((file) => file == fileName)}';
          if (await canLaunch(path)) {
            await launch(path);
          } else {
            print("Could not open file: $fileName");
          }
        }
      },
      child: Container(
        height: 50,
        margin: EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            fileName,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
