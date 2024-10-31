import 'dart:convert';
import 'package:chilla_customer/Login.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'CustomerRegistration.dart';

class Pass extends StatefulWidget {
  final String email;
  const Pass({super.key, required this.email});

  @override
  State<Pass> createState() => _PassState();
}

class _PassState extends State<Pass> {
  bool _isPasswordVisible = false;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> _setPassword(String password) async{
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final Map<String, String> body = {
      'email': widget.email,
      'password': password,
    };

    var response = await http.post(
      Uri.parse("http://104.237.9.211:8007/karuthal/api/v1/usermanagement/users/resetpassword"),
      headers: headers,
      body: jsonEncode(body)
    );
    if(response.statusCode==200){
      print(response.body);
      if(jsonDecode(response.body)['status']==200){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const Login())
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(builder: (context, constraints) {
        return SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(height: 20),
              Text('Set your password',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: const Color.fromARGB(255, 110, 111, 111),
                        fontFamily: GoogleFonts.anekGurmukhi().fontFamily,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      )),
              Text(
                "Set a Strong Password",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF3A3A3A),
                      fontFamily: GoogleFonts.robotoFlex().fontFamily,
                      fontSize: 16.0,
                    ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLabelText(context, "Password"),
                  Row(children: [
                    IconButton(
                      icon: Icon(
                        color: Color(0xFF838181),
                        _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    Text(
                      _isPasswordVisible ? 'Unhide' : 'Hide',
                      style: TextStyle(
                        color: const Color(0xFF838181),
                        fontSize: 16,
                      ),
                    ),
                  ]),
                ],
              ),
              const SizedBox(height: 2),
              _buildPasswordField(),
              const SizedBox(height: 30),
              _buildLabelText(context, "Confirm Password"),
              _buildConfirmPasswordField(),
              const SizedBox(height: 30),
              Center(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF57CC99),
                    ),
                    onPressed: () {
                      if (_validatePasswords()) {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Customerregistration(email: "",token: "",),
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Set Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
      }),
    );
  }

  Widget _buildLabelText(BuildContext context, String labelText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Text(
        labelText,
        style: TextStyle(
          color: Color(0xFF838181),
          fontSize: 16,
          fontFamily: GoogleFonts.roboto().fontFamily,
        ),
      ),
    );
  }

  Widget _buildProjectedTextFormField({
    required TextEditingController controller,
    required bool isPassword,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: TextFormField(
          controller: controller,
          cursorColor: Color(0xFF838181),
          obscureText: isPassword ? !_isPasswordVisible : false,
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          ),
          validator: validator,
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return _buildProjectedTextFormField(
      controller: _passwordController,
      isPassword: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        } else if (value.length < 8) {
          return 'Password must be at least 8 characters long';
        } else if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
          return 'Password must contain at least one lowercase letter';
        } else if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
          return 'Password must contain at least one uppercase letter';
        } else if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
          return 'Password must contain at least one digit';
        } else if (!RegExp(r'(?=.*[!@#\$&*~])').hasMatch(value)) {
          return 'Password must contain at least one special character';
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return _buildProjectedTextFormField(
      controller: _confirmPasswordController,
      isPassword: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password';
        }
        return null;
      },
    );
  }

  bool _validatePasswords() {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    return true;
  }
}
