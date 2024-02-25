import 'package:flutter/material.dart';
import 'package:medic/firebase_function.dart';
import 'package:medic/provider.dart';
import 'package:medic/view_doctors.dart';
import 'package:provider/provider.dart';
import 'assessment.dart';
import 'appointment.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isLoading = false;
  bool _showDoctorList = false;

  @override
  Widget build(BuildContext context) {
    final doctorProvider = Provider.of<DoctorsProvider>(context);

    return Stack(
      children: [
        // Background image
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bg_color.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent, // Make scaffold transparent
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(0), // Hide the default app bar
            child: Container(), // Empty container
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 20, left: 20, top: 10),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container( // Custom rectangular box
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton( // Hamburger button
                          icon: Icon(Icons.menu, color: Colors.white),
                          onPressed: () {
                            // Handle hamburger button press
                          },
                        ),
                        Text(
                          'HOME',
                          style: TextStyle(
                            fontSize: 20,
                            //fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'ProtestRiot',
                          ),
                        ),
                        IconButton( // Settings button
                          icon: Icon(Icons.settings, color: Colors.white),
                          onPressed: () {
                            // Handle settings button press
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 200), // Adjust spacing as needed
                  Container(
                    height: 40, // Set height to maintain consistency
                    width: 280, // Set width to match parent
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), // Add border radius for slight curve
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyChatPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue, // Button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15), // Button border radius
                        ),
                      ),
                      child: Text(
                        'Preliminary Medical Assessment',
                        style: TextStyle(
                          fontFamily: 'OldStandardTT',
                          fontWeight: FontWeight.w800,
                          color: Colors.white, // Text color
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  Container(
                    height: 40, // Set height to maintain consistency
                    width: 280, // Set width to match parent
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15), // Add border radius for slight curve
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ViewDoctors()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue, // Button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15), // Button border radius
                        ),
                      ),
                      child: Text(
                        'View Doctors',
                        style: TextStyle(
                          fontFamily: 'OldStandardTT',
                          fontWeight: FontWeight.w800,
                          color: Colors.white, // Text color
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  Container(
                    height: 40, // Set height to maintain consistency
                    width: 280, // Set width to match parent
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15), // Add border radius for slight curve
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ViewAppointmentHistory()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue, // Button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15), // Button border radius
                        ),
                      ),
                      child: Text(
                        'Appointment History',
                        style: TextStyle(
                          fontFamily: 'OldStandardTT',
                          fontWeight: FontWeight.w800,
                          color: Colors.white, // Text color
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.white.withOpacity(0.7), // White color with 60% opacity
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 2),
                IconButton(icon: Icon(Icons.home), onPressed: () {}),
                IconButton(icon: Icon(Icons.gamepad), onPressed: () {}),
                IconButton(icon: Icon(Icons.account_box), onPressed: () {}),
                SizedBox(width: 2),
              ],
            ),
          ),
        ),
        if (_isLoading) fullScreenLoader(),
      ],
    );
  }
}
