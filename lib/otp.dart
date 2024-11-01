import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'design.dart';
import 'pass.dart';
import 'package:http/http.dart' as http;

class OtpVerification extends StatefulWidget {
  final String email;
  const OtpVerification({super.key, required this.email});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  String getOtp() {
    return _otpControllers.map((controller) => controller.text).join();
  }

  Future<void> _verifyOtp(String otp) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final Map<String, String> body = {
      'email': 'application/json',
      'otp': otp,
    };

    var response = await http.post(
        Uri.parse("http://104.237.9.211:8007/karuthal/api/v1/email/verify-otp"),
        headers: headers,
        body: jsonEncode(body));
    if (response.statusCode == 200) {
      print(response.body);
      if (jsonDecode(response.body)['status'] == 200) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Pass(
                  email: widget.email,
                )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Text('Check your email',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: const Color.fromARGB(255, 110, 111, 111),
                          fontFamily: GoogleFonts.anekGurmukhi().fontFamily,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        )),
                const Text(
                  "We sent a code to your email. Enter the 6-digit code\nmentioned in the email.",
                  style: TextStyle(
                    color: Color(0xFF3A3A3A),
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) {
                    return _buildOtpField(index);
                  }),
                ),
                const SizedBox(height: 40),
                Center(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF57CC99),
                      ),
                      onPressed: () {
                        String otp = getOtp();
                        print("Entered OTP: $otp");
                        _verifyOtp(otp);
                      },
                      child: const Text(
                        'Verify Code',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Haven’t got the email yet? ',
                      style: const TextStyle(
                        color: Colors.black38,
                        fontSize: 18,
                      ),
                      children: [
                        TextSpan(
                          text: 'Resend OTP',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.normal,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Stack(
                    children: [
                      ClipPath(
                        clipper: BottomWaveClipper(),
                        child: Container(
                          width: double.infinity,
                          color: const Color(0xFFC7F9DE),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Image.asset(
                          'assets/image.png',
                          height: 275,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildOtpField(int index) {
    return Container(
      width: 50,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            offset: Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Center(
        child: TextField(
          controller: _otpControllers[index],
          focusNode: _focusNodes[index],
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: const InputDecoration(
            border: InputBorder.none,
            counterText: '',
          ),
          onChanged: (value) {
            if (value.isNotEmpty && index < 5) {
              FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
            } else if (value.isEmpty && index > 0) {
              FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
            }
          },
        ),
      ),
    );
  }
}
