import 'package:chilla_customer/BookServices/AdditionalService.dart';
import 'package:chilla_customer/BookServices/ServieceNeeded.dart';

import 'package:chilla_customer/dashboard.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookService extends StatefulWidget {
  const BookService({super.key});

  @override
  State<BookService> createState() => _BookServiceState();
}

class _BookServiceState extends State<BookService> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.greenAccent,
            iconTheme: IconThemeData(color: Colors.white)),
        drawer: Drawer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Text(
                  'Select the services required',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.black,
                        fontFamily: GoogleFonts.anekGurmukhi().fontFamily,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                ),
                _buildLabelText(context, "Service Needed"),
                SizedBox(
                  height: 5,
                ),
                ServieceNeeded(),
                SizedBox(height: 20),
                _buildLabelText(context, "Additional Service"),
                AdditionalService(),
                SizedBox(height: 20),
                _buildLabelText(context, "Caretaker Gender"),
                AdditionalService(),
                SizedBox(
                  height: 40,
                ),
                Text(
                  'Select patients',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.black,
                        fontFamily: GoogleFonts.anekGurmukhi().fontFamily,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                ),
                SizedBox(height: 30),
                _buildLabelText(context, "Patients list"),
                AdditionalService(),
                SizedBox(height: 80),
                Center(
                  child: SizedBox(
                    height: 48.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF57CC99),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Dashboard(
                                  email: "", token: "", customerId: 6),
                            ));
                      },
                      child: Text(
                        "Book",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontFamily: GoogleFonts.signika().fontFamily,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildLabelText(BuildContext context, String labelText) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    child: Text(
      labelText,
      style: TextStyle(
        color: Colors.black,
        fontSize: 22,
        fontFamily: GoogleFonts.roboto().fontFamily,
      ),
    ),
  );
}
