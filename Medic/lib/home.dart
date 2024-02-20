import 'package:flutter/material.dart';
import 'package:medic/firebase_function.dart';
import 'package:medic/provider.dart';
import 'package:medic/view_doctors.dart';
import 'package:provider/provider.dart';
import 'assessment.dart';

class Home extends StatefulWidget {
  const Home({super.key});

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
        Scaffold(
          appBar: AppBar(
            title: Text('Home'),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Search for a doctor...',
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () async {
                        print("Search Button Clicked");
                      },
                      child: Text('Search'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyChatPage()),
                  );
                },
                child: Text('Preliminary medical assessment'),
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewDoctors()),
                  );
                },
                child: Text('View Doctors'),
              ),
              // Add advertisements here
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 5),
                IconButton(icon: Icon(Icons.home), onPressed: () {}),
                IconButton(icon: Icon(Icons.gamepad), onPressed: () {}),
                IconButton(icon: Icon(Icons.account_box), onPressed: () {}),
                SizedBox(width: 5),
              ],
            ),
          ),
        ),
        if (_isLoading) fullScreenLoader(),
      ],
    );
  }
}