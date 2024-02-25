import 'package:flutter/material.dart';
import 'package:medic/firebase_function.dart';
import 'package:medic/provider.dart';
import 'package:provider/provider.dart';

class ViewDoctors extends StatefulWidget {
  const ViewDoctors({Key? key}) : super(key: key);

  @override
  _ViewDoctorsState createState() => _ViewDoctorsState();
}

class _ViewDoctorsState extends State<ViewDoctors> {
  bool _isLoading = false;
  bool _showDoctorList = true;
  TextEditingController _searchController = TextEditingController();
  List<Doctor> _filteredDoctors = [];
  String _sortingOrder = 'Low to High';
  String _selectedSpecialization = '';
  List<String> specializationOptions = ["Dermatologist", "Phlebologist", "Pediatrician", "Internal Medicine", "Otolaryngologist", "Pulmonologist", "Gastroenterologist", "Rheumatologists", "Cardiologist", "Neurologist", "Gyneocologist", "Allergist", "Endocrinologist"];

  @override
  Widget build(BuildContext context) {
    final doctorProvider = Provider.of<DoctorsProvider>(context);

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bg_color.jpg"), // Path to your background image
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
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.menu, color: Colors.white),
                          onPressed: () {
                            // Handle hamburger button press
                          },
                        ),
                        Text(
                          'View Doctors',
                          style: TextStyle(
                            fontSize: 20,
                            //fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'ProtestRiot',
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.settings, color: Colors.white),
                          onPressed: () {
                            // Handle settings button press
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.search),
                                  hintText: 'Search for a doctor...',
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () async {
                                _searchDoctors(doctorProvider);
                              },
                              child: Text('Search'),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 16.0),
                              child: Row(
                                children: [
                                  Text('Sort by Fees:'),
                                  SizedBox(width: 10),
                                  DropdownButton<String>(
                                    value: _sortingOrder,
                                    items: ['Low to High', 'High to Low']
                                        .map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _sortingOrder = newValue!;
                                        _sortDoctors(doctorProvider);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 16.0),
                              child: IconButton(
                                icon: Icon(Icons.filter_alt),
                                onPressed: () => _filterDoctors(doctorProvider),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  if (_showDoctorList)
                    _buildDoctorsList(_filteredDoctors.isNotEmpty
                        ? _filteredDoctors
                        : doctorProvider.doctors),
                ],
              ),
            ),
          ),
        ),
        if (_isLoading) fullScreenLoader(),
      ],
    );
  }

  void _searchDoctors(DoctorsProvider doctorProvider) {
    String searchTerm = _searchController.text.toLowerCase();
    if (searchTerm.isEmpty) {
      setState(() {
        _filteredDoctors = [];
      });
    } else {
      setState(() {
        _filteredDoctors = doctorProvider.doctors
            .where((doctor) =>
        doctor.name.toLowerCase().contains(searchTerm) ||
            doctor.doctortype.toLowerCase().contains(searchTerm))
            .toList();
      });
    }
  }

  void _sortDoctors(DoctorsProvider doctorProvider) {
    setState(() {
      _filteredDoctors = [...doctorProvider.doctors];
      if (_sortingOrder == 'Low to High') {
        _filteredDoctors.sort((a, b) => a.fees.compareTo(b.fees));
      } else {
        _filteredDoctors.sort((a, b) => b.fees.compareTo(a.fees));
      }
    });
  }

  void _filterDoctors(DoctorsProvider doctorProvider) async {
    final selectedSpecialization = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Specialization'),
        children: specializationOptions.map((specialization) {
          return SimpleDialogOption(
            child: Text(specialization),
            onPressed: () {
              Navigator.pop(context, specialization);
            },
          );
        }).toList(),
      ),
    );

    if (selectedSpecialization != null) {
      setState(() {
        _selectedSpecialization = selectedSpecialization;
        _filteredDoctors = doctorProvider.doctors
            .where((doctor) =>
        doctor.doctortype.toLowerCase() ==
            _selectedSpecialization.toLowerCase())
            .toList();
      });
    }
  }

  Widget _buildDoctorsList(List<Doctor> doctors) {
    return SizedBox(
      height: 100 * doctors.length.toDouble() + 170,
      width: double.infinity,
      child: ListView.builder(
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: Colors.purple.withOpacity(0.2),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 6,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10,),
                        Text("Name : ${doctors[index].name}"),
                        Text("Specialist : ${doctors[index].doctortype}"),
                        Text("Time : ${doctors[index].fromTime} to ${doctors[index].toTime}"),
                        Text("Age : ${doctors[index].age}"),
                        Text("Gender : ${doctors[index].gender}"),
                        Text("Fees : ${doctors[index].fees}"),
                      ],
                    ),
                    SizedBox(width: 40,),
                    SizedBox(
                      height: 50,
                      width: 120,
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          await bookAppointment(context, doctors[index].uid, doctors[index].name, doctors[index].fromTime, doctors[index].toTime);
                          setState(() {
                            _isLoading = false;
                          });
                        },
                        child: Text(
                          "Book\nAppointment",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
            ],
          );
        },
      ),
    );
  }
}
