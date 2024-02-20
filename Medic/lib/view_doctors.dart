import 'package:flutter/material.dart';
import 'package:medic/firebase_function.dart';
import 'package:medic/provider.dart';
import 'package:provider/provider.dart';
import 'assessment.dart';

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
        Scaffold(
          appBar: AppBar(
            title: Text('Home'),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                  color: Colors.purple.withOpacity(0.1),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 15,),
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
                    SizedBox(width: 60,),
                    SizedBox(
                      height: 50,
                      width: 120,
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          await bookAppointment(context, doctors[index].uid);
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





























/*import 'package:flutter/material.dart';
import 'package:medic/firebase_function.dart';
import 'package:medic/provider.dart';
import 'package:provider/provider.dart';
import 'assessment.dart';

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

  // Add filters for sorting
  String _selectedSortingOption = 'Price';

  // Add filters for doctors
  String _selectedSpecialist = '';
  String _selectedTime = '';
  String _selectedGender = '';

  DoctorsProvider? get doctorProvider => null;

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
              ),

              SizedBox(height: 20),
              if (_showDoctorList)
                _buildDoctorsList(_filteredDoctors.isNotEmpty
                    ? _filteredDoctors
                    : doctorProvider.doctors),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Add a button to sort doctors by price
                ElevatedButton(
                  onPressed: () {
                    _sortDoctorsByPrice(doctorProvider);
                  },
                  child: Text('Sort by Price'),
                ),
                // Add a filter button to filter doctors
                ElevatedButton(
                  onPressed: () {
                    _showFilterDialog(context);
                  },
                  child: Text('Filter'),
                ),
              ],
            ),
          ),
        ),
        if (_isLoading) fullScreenLoader(),
      ],
    );
  }

  void _sortDoctorsByPrice(DoctorsProvider doctorProvider) {
    setState(() {
      _filteredDoctors = List.from(doctorProvider.doctors);
      _filteredDoctors.sort((a, b) => a.fees.compareTo(b.fees));
    });
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter Doctors'),
          content: Column(
            children: [
              // Add filters for Specialist, Time, and Gender
              TextField(
                onChanged: (value) {
                  _selectedSpecialist = value;
                },
                decoration: InputDecoration(labelText: 'Specialist'),
              ),
              TextField(
                onChanged: (value) {
                  _selectedTime = value;
                },
                decoration: InputDecoration(labelText: 'Time'),
              ),
              TextField(
                onChanged: (value) {
                  _selectedGender = value;
                },
                decoration: InputDecoration(labelText: 'Gender'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _applyFilters(doctorProvider!);
                Navigator.pop(context);
              },
              child: Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  void _applyFilters(DoctorsProvider doctorProvider) {
    setState(() {
      _filteredDoctors = doctorProvider.doctors
          .where((doctor) =>
      doctor.doctortype.contains(_selectedSpecialist) &&
          doctor.fromTime.contains(_selectedTime) &&
          doctor.gender.contains(_selectedGender))
          .toList();
    });
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
                  color: Colors.purple.withOpacity(0.1),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 15,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10,),
                        Text("Name : ${doctors[index].name}"),
                        Text("Specialist : ${doctors[index].doctortype}"),
                        Text("Time : ${doctors[index].fromTime} to ${doctors[index].toTime}"),
                        Text("Fees : ${doctors[index].fees}"),
                        Text("Age : ${doctors[index].age}"),
                        Text("Gender : ${doctors[index].gender}"),
                      ],
                    ),
                    SizedBox(width: 60,),
                    SizedBox(
                      height: 50,
                      width: 120,
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          await bookAppointment(context, doctors[index].uid);
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


























import 'package:flutter/material.dart';
import 'package:medic/firebase_function.dart';
import 'package:medic/provider.dart';
import 'package:provider/provider.dart';
import 'assessment.dart';

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
              ),

              SizedBox(height: 20),
              if (_showDoctorList)
                _buildDoctorsList(_filteredDoctors.isNotEmpty
                    ? _filteredDoctors
                    : doctorProvider.doctors),
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

  void _searchDoctors(DoctorsProvider doctorProvider) {
    String searchTerm = _searchController.text.toLowerCase();
    if (searchTerm.isEmpty) {
      // Show all doctors if search term is empty
      setState(() {
        _filteredDoctors = [];
      });
    } else {
      // Filter doctors based on search term
      setState(() {
        _filteredDoctors = doctorProvider.doctors
            .where((doctor) =>
        doctor.name.toLowerCase().contains(searchTerm) ||
            doctor.doctortype.toLowerCase().contains(searchTerm))
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
                  color: Colors.purple.withOpacity(0.1),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 15,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10,),
                        Text("Name : ${doctors[index].name}"),
                        Text("Specialist : ${doctors[index].doctortype}"),
                        Text("Time : ${doctors[index].fromTime} to ${doctors[index].toTime}"),
                        Text("Fees : ${doctors[index].fees}"),
                        Text("Age : ${doctors[index].age}"),
                        Text("Gender : ${doctors[index].gender}"),
                      ],
                    ),
                    SizedBox(width: 60,),
                    SizedBox(
                      height: 50,
                      width: 120,
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          await bookAppointment(context, doctors[index].uid);
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
*/