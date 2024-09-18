import 'package:chilla_customer/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Customerregistration extends StatefulWidget {
  const Customerregistration({super.key});

  @override
  State<Customerregistration> createState() => _CustomerregistrationState();
}

class _CustomerregistrationState extends State<Customerregistration> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
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
                            child: Column(children: [
                          Text(
                            "Customer Registration",
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
                          const SizedBox(height: 1),
                          Text(
                            "Fill out the form carefully for registration",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: const Color(0xFF3A3A3A),
                                  fontFamily:
                                      GoogleFonts.robotoFlex().fontFamily,
                                  fontSize: 16.0,
                                ),
                          ),
                        ])),
                        const SizedBox(height: 15),
                        _buildLabelText(context, "Name"),
                        const SizedBox(height: 8),
                        _buildTextField(
                          context,
                          controller: _nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        _buildLabelText(context, "Job"),
                        const SizedBox(height: 8),
                        _buildTextField(
                          context,
                          controller: _jobController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Job';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        _buildLabelText(context, "Address"),
                        const SizedBox(height: 8),
                        _buildTextField(
                          context,
                          controller: _addressController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your address';
                            }
                            return null;
                          },
                        ),
                        _buildLabelText(context, "Permanent Address"),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabelText(context, "Residing Country"),
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
                        const SizedBox(height: 80),
                        Center(
                          child: SizedBox(
                            height: 48.0,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF57CC99),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Dashboard(),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Color(0xFF57CC99),
                                      content: Text(
                                        'Please enter the required field',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: const Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ]))),
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
