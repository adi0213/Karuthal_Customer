import 'package:chilla_customer/Error.dart';
import 'package:chilla_customer/PatientEnrollment/AdditionalService.dart';
import 'package:chilla_customer/PatientEnrollment/ServieceNeeded.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Patientenroll extends StatefulWidget {
  const Patientenroll({super.key});

  @override
  State<Patientenroll> createState() => _PatientenrollState();
}

class _PatientenrollState extends State<Patientenroll> {
  bool _termsAccepted = false;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _healthDifficultiesController =
      TextEditingController();

  String? _serviceNeededSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Patient Enrollment',
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                color: const Color(0xFF57CC99),
                                fontFamily:
                                    GoogleFonts.anekGurmukhi().fontFamily,
                                fontWeight: FontWeight.normal,
                                fontSize: 27.0,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Fill out the form carefully",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color: const Color(0xFF3A3A3A),
                                fontFamily: GoogleFonts.robotoFlex().fontFamily,
                                fontSize: 16.0,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildLabelText(context, "Name"),
                  const SizedBox(height: 8),
                  _buildTextField(
                    context,
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabelText(context, "Age"),
                            const SizedBox(height: 8),
                            _buildTextField(
                              context,
                              controller: _ageController,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabelText(context, "Gender"),
                            const SizedBox(height: 8),
                            _buildTextField(
                              context,
                              controller: _genderController,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabelText(context, "Country"),
                            const SizedBox(height: 8),
                            _buildTextField(
                              context,
                              controller: _countryController,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabelText(context, "City"),
                            const SizedBox(height: 8),
                            _buildTextField(
                              context,
                              controller: _cityController,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  _buildLabelText(context, "Health Difficulties"),
                  const SizedBox(height: 8),
                  _buildTextLargeField(
                    context,
                    controller: _healthDifficultiesController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter health difficulties';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  _buildLabelText(context, "Service Needed"),
                  ServieceNeeded(
                    onSelectionChanged: (selected) {
                      setState(() {
                        _serviceNeededSelected = selected;
                      });
                    },
                  ),
                  const SizedBox(height: 30),
                  _buildLabelText(context, "Additional Service"),
                  AdditionalService(),
                  const SizedBox(height: 50),
                  const Text(
                    "Terms and Conditions",
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "If you read everything, select the checkbox",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14),
                        ),
                      ),
                      Checkbox(
                        value: _termsAccepted,
                        checkColor: Colors.white,
                        activeColor: const Color(0xFF57CC99),
                        onChanged: (value) {
                          setState(() {
                            _termsAccepted = value ?? false;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),
                  Center(
                    child: SizedBox(
                      height: 48.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF57CC99),
                        ),
                        onPressed: _termsAccepted
                            ? () {
                                if (_formKey.currentState!.validate()) {
                                  if (_serviceNeededSelected != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const work(),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        backgroundColor: Color(0xFF57CC99),
                                        content: Text(
                                          'Please select the required services',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    );
                                  }
                                }
                              }
                            : null,
                        child: const Text(
                          "Enroll Patient",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextFormField(
        controller: controller,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Color(0xFF57CC99)),
          ),
          errorStyle: const TextStyle(
            color: Colors.red,
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildTextLargeField(
    BuildContext context, {
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextFormField(
        controller: controller,
        cursorColor: Colors.black,
        maxLines: null,
        minLines: 5,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.greenAccent),
          ),
          errorStyle: const TextStyle(
            color: Colors.red,
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildLabelText(BuildContext context, String labelText) {
    Color labelColor;

    if (labelText == "Permanent Address") {
      labelColor = const Color(0xFF838181);
    } else {
      labelColor = Colors.black;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Text(
        labelText,
        style: TextStyle(
          color: labelColor,
          fontSize: 16,
          fontFamily: GoogleFonts.robotoFlex().fontFamily,
        ),
      ),
    );
  }
}
