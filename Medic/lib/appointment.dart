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
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text('Appointment History'),
          ),
          body: _isLoading
              ? Center(child: CircularProgressIndicator())
              : _buildAppointmentHistoryList(_appointmentHistory),
        ),
        if (_isLoading) fullScreenLoader(), // You can implement this function to show a full-screen loader
      ],
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

  Widget _buildAppointmentHistoryList(List<AppointmentHistory> appointments) {
    if (appointments.isEmpty) {
      return Center(child: Text('No appointment history available.'));
    }

    return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return ListTile(
          title: Text('Doctor: ${appointment.doctorName}'),
          subtitle: Text('From: ${appointment.fromTime}, To: ${appointment.toTime}'),
          // You can display additional information about the appointment here
        );
      },
    );
  }
}
