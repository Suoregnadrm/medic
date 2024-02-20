import 'package:flutter/material.dart';
import 'package:medic/provider.dart';
import 'package:provider/provider.dart';

class DoctorProfilePage extends StatefulWidget {
  const DoctorProfilePage({Key? key}) : super(key: key);

  @override
  State<DoctorProfilePage> createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {

  String? _selectedAppointment;

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);
    final appointmentsProvider = Provider.of<AppointmentsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Profile'),
        centerTitle: true,
        backgroundColor: Colors.teal, // Attractive color choice
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor profile section
            Text(
              'Doctor Profile',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.teal, // Consistent color theme
              ),
            ),
            const SizedBox(height: 10.0),
            Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ), // Rounded corners for visual appeal
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: ${userData.userName}'),
                    Text('Age: ${userData.age}'),
                    Text('Phone: ${userData.phoneNumber}'),
                    Text('Email: ${userData.email}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            // Dropdown button for appointments
            Text(
              'Appointments',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 10.0),
            DropdownButton<String>(
              value: _selectedAppointment,
              isExpanded: true,
              items: appointmentsProvider.appointments.map((app) {
                return DropdownMenuItem<String>(
                  value: app.name.toString(),
                  child: Text(
                      '${app.name.toString()} (${app.age} ${app.gender})'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedAppointment = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
