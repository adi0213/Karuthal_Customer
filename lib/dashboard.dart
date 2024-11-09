import 'package:chilla_customer/PatientEnrollBooking/Booking.dart';
import 'package:chilla_customer/Error.dart';
import 'package:chilla_customer/PatientEnrollBooking/PatientEnroll.dart';
import 'package:chilla_customer/feedback.dart';
import 'package:flutter/material.dart';
import 'uploadedDocuments.dart';

class Dashboard extends StatefulWidget {
  final String email;
  final String token;
  final int customerId;
  final String userId;

  const Dashboard(
      {super.key,
      required this.email,
      required this.token,
      required this.customerId,
      required this.userId});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  void _toggleDrawer(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFFC778CA)),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Color(0xFFC778CA)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Color(0xFFC778CA)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Color(0xFFC778CA)),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: RotatedBox(
                quarterTurns: 1,
                child: IconButton(
                  icon: const Icon(
                    Icons.menu,
                    size: 35,
                    color: Color(0xFFC778CA),
                  ),
                  onPressed: () => _toggleDrawer(context),
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              height: 2,
              color: Color(0xFFEBBBED),
              width: double.infinity,
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const SizedBox(height: 30),
                  ListTile(
                    leading:
                        const Icon(Icons.dashboard, color: Color(0xFFEBBBED)),
                    title: const Text('Dashboard',
                        style:
                            TextStyle(color: Color(0xFFC778CA), fontSize: 20)),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    leading: const Icon(Icons.person, color: Color(0xFFEBBBED)),
                    title: const Text('View Profile',
                        style:
                            TextStyle(color: Color(0xFFC778CA), fontSize: 20)),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    leading: const Icon(Icons.person, color: Color(0xFFEBBBED)),
                    title: const Text('Uploaded Files',
                        style:
                            TextStyle(color: Color(0xFFC778CA), fontSize: 20)),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UploadedDocuments(
                                token: widget.token,
                                userId: widget.userId,
                              )));
                    },
                  ),
                  /*  const SizedBox(height: 10),
                  ListTile(
                    leading:
                        const Icon(Icons.calendar_today_rounded, color: Color(0xFFEBBBED)),
                    title: const Text('Calendar',
                        style: TextStyle(color: Color(0xFFC778CA), fontSize: 20)),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),*/
                  const SizedBox(height: 10),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Color(0xFFEBBBED)),
                    title: const Text(
                      'Logout',
                      style: TextStyle(color: Color(0xFFC778CA), fontSize: 20),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome!',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFC778CA),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Helping you find the right care for your loved ones with ease and trust.',
                style: TextStyle(fontSize: 20, color: Color(0xFFB67BB8)),
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  CustomButton(
                    height: 150,
                    width: 366,
                    topColor: Color(0xFFB66CB9),
                    bottomColor: Color(0xFFC778CA),
                    label: 'Enroll Patient',
                    fontSize: 38,
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Patientenroll(
                                  email: widget.email,
                                  token: 'Bearer ${widget.token}',
                                  customerId: widget.customerId,
                                )),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            CustomButton(
                              height: 140,
                              width: 172,
                              topColor: Color(0xFFD68BBD),
                              bottomColor: Color(0xFFE498CB),
                              label: 'Feedback',
                              fontSize: 28,
                              onPressed: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FeedbackPage(
                                            email: widget.email,
                                            token: "Bearer ${widget.token}",
                                            customerId: widget.customerId,
                                          )),
                                );
                              },
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            CustomButton(
                              height: 140,
                              width: 172,
                              topColor: Color(0xFFD68BBD),
                              bottomColor: Color(0xFFE498CB),
                              label: 'View Service \n      History',
                              fontSize: 24,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const work(),
                                    ));
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 1,
                        child: CustomButton(
                          height: 285,
                          width: 172,
                          topColor: Color(0xFFD2B5E4),
                          bottomColor: Color(0xFFDBC1EB),
                          label: '    Book \n  Service',
                          fontSize: 28,
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookService(
                                        token: widget.token,
                                        customerId: widget.customerId,
                                      )),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    height: 91,
                    width: 366,
                    topColor: Color(0xFF9A88CC),
                    bottomColor: Color(0xFFAC98E4),
                    label: 'Payment History',
                    fontSize: 32,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const work()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
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
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
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
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 4),
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
                      fontSize: fontSize,
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
