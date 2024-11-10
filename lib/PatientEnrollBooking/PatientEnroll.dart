import 'dart:async';
import 'dart:convert';
import 'package:chilla_customer/PatientEnrollBooking/SelectDistrict.dart';
import 'package:chilla_customer/dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Patientenroll extends StatefulWidget {
  final String email;
  final String token;
  final int customerId;
  final String userId;
  const Patientenroll(
      {super.key,
      required this.email,
      required this.token,
      required this.customerId,
      required this.userId});

  @override
  State<Patientenroll> createState() => _PatientenrollState();
}

class _PatientenrollState extends State<Patientenroll> {
  bool _termsAccepted = false;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  //final TextEditingController _genderController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _relationController = TextEditingController();
  final TextEditingController _healthDifficultiesController =
      TextEditingController();

  var genderSelected = "";
  var dropDownWidth;

  Future<void> _enrollPatient() async {
    const url =
        'http://104.237.9.211:8007/karuthal/api/v1/persona/enrollpatient';
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${widget.token}',
    };

    final body = jsonEncode({
      "age": int.tryParse(_ageController.text) ?? 0,
      "gender": genderSelected,
      "healthDescription": _healthDifficultiesController.text,
      "email": _emailController.text,
      "firstName": _firstnameController.text,
      "lastName": _lastnameController.text,
      "enrolledBy": {"customerId": widget.customerId},
    });

    print(body);

    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        print("Successful");
        print(response.body);
        showCongratulationsDialog(context, response);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to enroll patient: ${response.body}'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error occurred: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  void showCongratulationsDialog(BuildContext context, http.Response response) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Timer(Duration(seconds: 3), () {
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboard(
                email: widget.email,
                token: widget.token,
                customerId: widget.customerId,
                userId: widget.userId,
              ),
            ),
          );
        });

        return AlertDialog(
          title: Text("Congratulations!"),
          content: Text("You have successfully Enrolled."),
        );
      },
    );
  }

  void _showGenderSelectionOverlay(BuildContext context, var topMargin) {
    OverlayState overlayState = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(children: [
          GestureDetector(
            onTap: () {
              overlayEntry.remove();
            },
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Positioned(
            top: topMargin + 50,
            left: (MediaQuery.of(context).size.width / 2) + 15,
            width: dropDownWidth,
            child: Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(8),
              child: GenderNeeded(
                onSelectionChanged: (String gender) {
                  setState(() {
                    genderSelected = gender;
                  });
                  overlayEntry.remove();
                },
              ),
            ),
          ),
        ]);
      },
    );

    overlayState.insert(overlayEntry);
  }

  void _getDistanceFromTop(
      BuildContext context, Function(double) calculatedDistance) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      RenderBox renderBox = context.findRenderObject() as RenderBox;
      Offset offset = renderBox.localToGlobal(Offset.zero);
      double distanceFromTop = offset.dy;
      calculatedDistance(distanceFromTop);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(children: [
            Positioned.fill(
              child: Image.asset(
                'assets/purplebg.png',
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                    const SizedBox(height: 3),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Patient Enrollment',
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                  color: Color(0xFFC778CA),
                                  fontFamily:
                                      GoogleFonts.anekGurmukhi().fontFamily,
                                  fontWeight: FontWeight.bold,
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
                                  fontFamily:
                                      GoogleFonts.robotoFlex().fontFamily,
                                  fontSize: 16.0,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(children: [
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabelText(context, "FirstName"),
                              const SizedBox(height: 8),
                              _buildTextField(
                                context,
                                controller: _firstnameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter FirstName';
                                  }
                                  return null;
                                },
                              ),
                            ]),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabelText(context, "LastName"),
                              const SizedBox(height: 8),
                              _buildTextField(
                                context,
                                controller: _lastnameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter LastName';
                                  }
                                  return null;
                                },
                              ),
                            ]),
                      )
                    ]),
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
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      // _getDistanceFromTop(context);
                                      // dropDownWidth = constraints.maxWidth;
                                      // print(dropDownWidth);
                                      return GestureDetector(
                                        onTap: () {
                                          _getDistanceFromTop(context,
                                              (topDistance) {
                                            setState(() {
                                              print("Rdist $topDistance");
                                              dropDownWidth =
                                                  constraints.maxWidth;
                                              print(dropDownWidth);
                                              _showGenderSelectionOverlay(
                                                  context, topDistance);
                                            });
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 10),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black54),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                genderSelected,
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                              const Expanded(child: SizedBox()),
                                              const Icon(Icons.arrow_drop_down),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ]),
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
                              _buildLabelText(context, "Patient's E-Mail"),
                              const SizedBox(height: 8),
                              _buildTextField(
                                context,
                                controller: _emailController,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabelText(context, "Patient's Phone"),
                              const SizedBox(height: 8),
                              _buildTextField(
                                context,
                                controller: _phoneController,
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
                              _buildLabelText(context, "District"),
                              const SizedBox(height: 8),
                              DistrictDropdown(bearerToken: widget.token)
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabelText(context, "Area"),
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
                    _buildLabelText(context, "Relation with patient"),
                    const SizedBox(height: 8),
                    _buildTextField(
                      context,
                      controller: _relationController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Relation';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 50),
                    const Text(
                      "Terms and Conditions",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            "If you read everything, select the checkbox",
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ),
                        Checkbox(
                          value: _termsAccepted,
                          checkColor: Colors.white,
                          activeColor: Color(0xFFC778CA),
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
                            backgroundColor: Color(0xFFC778CA),
                          ),
                          onPressed: _termsAccepted
                              ? () {
                                  if (_formKey.currentState!.validate()) {
                                    _enrollPatient();
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
          ]),
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
            borderSide: const BorderSide(color: Color(0xFFEBBBED)),
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
            borderSide: const BorderSide(color: Color(0xFFEBBBED)),
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

class GenderNeeded extends StatefulWidget {
  final Function(String gender) onSelectionChanged;

  const GenderNeeded({
    super.key,
    required this.onSelectionChanged,
  });

  @override
  _GenderNeededState createState() => _GenderNeededState();
}

class _GenderNeededState extends State<GenderNeeded> {
  final genders = ['MALE', 'FEMALE', 'TRANSGENDER'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFFEBBBED)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: genders
            .map((gender) => GestureDetector(
                  onTap: () {
                    widget.onSelectionChanged(gender);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          gender,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
