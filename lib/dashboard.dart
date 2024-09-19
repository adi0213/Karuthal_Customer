import 'package:chilla_customer/Caretakers.dart';
import 'package:chilla_customer/Error.dart';
import 'package:chilla_customer/PatientEnrollment/PatientEnroll.dart';
import 'package:chilla_customer/feedback.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Color(0xFF57CC99)),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Color(0xFF57CC99)),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.settings, color: Color(0xFF57CC99)),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.person, color: Color(0xFF57CC99)),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome!',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00BA69),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Helping you find the right care for your loved ones with ease and trust.',
                style: TextStyle(fontSize: 20, color: Color(0xFF57CC99)),
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  CustomButton(
                    height: 150,
                    width: 366,
                    bottomColor: Color(0xFF80ED99),
                    topColor: Color(0xFF78DE90),
                    label: 'Enroll Patient',
                    fontSize: 38,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Patientenroll()),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            CustomButton(
                              height: 181,
                              width: 170,
                              topColor: Color(0xFF49C38E),
                              bottomColor: Color(0xFF57CC99),
                              label: 'Book Caretaker',
                              fontSize: 28,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Caretakers()),
                                );
                              },
                            ),
                            SizedBox(height: 20),
                            CustomButton(
                              height: 84,
                              width: 170,
                              topColor: Color(0xFF72CDD9),
                              bottomColor: Color(0xFF72CDD9),
                              label: 'Feedback',
                              fontSize: 27,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FeedbackPage()),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        flex: 1,
                        child: CustomButton(
                          height: 285,
                          width: 172,
                          topColor: Color(0xFF62CDB4),
                          bottomColor: Color(0xFF72D9C1),
                          label: '   View Service \n        History',
                          fontSize: 28,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => work()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    height: 91,
                    width: 366,
                    topColor: Color(0xFF7FD4C9),
                    bottomColor: Color(0xFF97E0D7),
                    label: 'Payment History',
                    fontSize: 32,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => work()),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final double height;
  final double width;
  final Color topColor;
  final Color bottomColor;
  final String label;
  final double fontSize;
  final VoidCallback onPressed; // Added fontSize parameter

  CustomButton({
    required this.height,
    required this.width,
    required this.topColor,
    required this.bottomColor,
    required this.label,
    this.fontSize = 38,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // Trigger the onPressed callback
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: SizedBox(
            height: height,
            width: double.infinity,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: bottomColor,
                  ),
                ),
                CustomPaint(
                  size: Size(double.infinity, height),
                  painter: DiagonalWavePainter(topColor),
                ),
                Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: fontSize, // Use the fontSize parameter
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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

class DiagonalWavePainter extends CustomPainter {
  final Color color;

  DiagonalWavePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;
    Path path = Path();

    // Start from the bottom-left corner
    path.moveTo(0, size.height * 1);

    // First cubic Bezier curve (smooth from left to center)
    path.cubicTo(
      size.width * 0.7, size.height * 0.95, // First control point
      size.width * 0.4, size.height * 0.1, // Second control point
      size.width * 1, size.height * 0, // End point
    );

    // Close the path by drawing to the bottom-right corner
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // Draw the path on the canvas
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
