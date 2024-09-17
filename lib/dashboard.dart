import 'package:chilla_customer/Caretakers.dart';
import 'package:chilla_customer/Error.dart';
import 'package:chilla_customer/PatientEnrollment/PatientEnroll.dart';
import 'package:chilla_customer/design.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  void _toggleDrawer(BuildContext context) {
    Navigator.pop(context);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff80ED99),
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: RotatedBox(
                quarterTurns: 1,
                child: IconButton(
                  icon: Icon(
                    Icons.menu,
                    size: 35,
                    color: Colors.green,
                  ),
                  onPressed: () => _toggleDrawer(context),
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Container(
              height: 2,
              color: const Color.fromARGB(255, 173, 211, 175),
              width: double.infinity,
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  SizedBox(height: 30),
                  ListTile(
                    leading: Icon(Icons.dashboard, color: Colors.green),
                    title: Text('Dashboard',
                        style: TextStyle(color: Colors.green, fontSize: 20)),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: 10),
                  ListTile(
                    leading: Icon(Icons.person, color: Colors.green),
                    title: Text('View Profile',
                        style: TextStyle(color: Colors.green, fontSize: 20)),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: 10),
                  ListTile(
                    leading:
                        Icon(Icons.calendar_today_rounded, color: Colors.green),
                    title: Text('Calendar',
                        style: TextStyle(color: Colors.green, fontSize: 20)),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: 10),
                  ListTile(
                    leading: Icon(Icons.logout, color: Colors.green),
                    title: Text(
                      'Logout',
                      style: TextStyle(color: Colors.green, fontSize: 20),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ClipPath(
                  clipper: BottomWaveClipper(),
                  child: Container(
                    height: 350,
                    width: double.infinity,
                    color: Color(0xffC7F9DE),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 80),
                  Center(
                    child: Text(
                      'Welcome !',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 249, 249, 249),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Color(0xff4D9173),
                            backgroundColor: Color(0xffC7F9CC),
                            minimumSize: Size(300, 150),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            shadowColor: Colors.grey.withOpacity(0.5),
                            elevation: 7,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Patientenroll(),
                              ),
                            );
                          },
                          child: Text(
                            'Enroll Patient',
                            style: TextStyle(
                              fontSize: 30,
                              color: Color(0xff4D9173),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Color(0xff4D9173),
                            backgroundColor: Color(0xffC7F9CC),
                            minimumSize: Size(300, 150),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            shadowColor: Colors.grey.withOpacity(0.5),
                            elevation: 7,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => work(),
                              ),
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Veiw Service',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Color(0xff4D9173),
                                ),
                              ),
                              Text(
                                'History',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Color(0xff4D9173),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Color(0xff4D9173),
                            backgroundColor: Color(0xffC7F9CC),
                            minimumSize: Size(300, 150),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            shadowColor: Colors.grey.withOpacity(0.5),
                            elevation: 7,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Caretakers(),
                              ),
                            );
                          },
                          child: Text(
                            'Book Caretaker',
                            style: TextStyle(
                              fontSize: 30,
                              color: Color(0xff4D9173),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 50,
                left: 10,
                child: Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.menu,
                        size: 35,
                        color: const Color.fromARGB(255, 247, 246, 246)),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
