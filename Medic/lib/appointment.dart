import 'package:flutter/material.dart';
import 'firebase_function.dart';
import 'provider.dart';
import 'package:provider/provider.dart';

class ViewAppointmentHistory extends StatefulWidget {
  const ViewAppointmentHistory({Key? key}) : super(key: key);

  @override
  _ViewAppointmentHistoryState createState() => _ViewAppointmentHistoryState();
}

class _ViewAppointmentHistoryState extends State<ViewAppointmentHistory> {
  bool _isLoading = false;
  List<AppointmentHistory> _appointmentHistory = []; // List to store appointment history

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background Image Container
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg_color.jpg'), // Change path to your image
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 25, left: 25, top: 50),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    color: Colors.blue,
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
                          'Appointment History',
                          style: TextStyle(
                            fontSize: 20,
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
                ),
              ),
              Expanded(
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : _buildAppointmentHistory(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchAppointmentHistory(); // Fetch appointment history when the widget initializes
  }

  Future<void> _fetchAppointmentHistory() async {
    final userData = Provider.of<UserData>(context, listen: false); // Access user data

    setState(() {
      _isLoading = true;
    });

    // Fetch user's appointment history from Firestore
    List<AppointmentHistory> appointmentHistory = await fetchUserAppointments(userData.uid);

    setState(() {
      _isLoading = false;
      _appointmentHistory = appointmentHistory;
    });
  }

  Widget _buildAppointmentHistory() {
    return _appointmentHistory.isEmpty
        ? Center(child: Text('No appointment history available.', style: TextStyle(color: Colors.white)))
        : ListView.builder(
      itemCount: _appointmentHistory.length,
      itemBuilder: (context, index) {
        final appointment = _appointmentHistory[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.all(10),
              color: Colors.purple.withOpacity(0.2), // Adjust opacity here
              child: ListTile(
                title: Text('Doctor: ${appointment.doctorName}', style: TextStyle(color: Colors.black)),
                subtitle: Text('From: ${appointment.fromTime}, To: ${appointment.toTime}', style: TextStyle(color: Colors.black)),
                // You can display additional information about the appointment here
              ),
            ),
          ),
        );
      },
    );
  }
}
