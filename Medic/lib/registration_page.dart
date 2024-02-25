import 'dart:io';
import 'package:flutter/material.dart';
import 'package:medic/provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'firebase_function.dart';
import 'home.dart';
import 'package:file_picker/file_picker.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  String verificationId = '';
  int fees = 0;
  String? _selectedOption = "";
  String? _doctorType = "";
  String? _gender = "";
  String _fromTime = "";
  String _toTime = "";

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);
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
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                              'Registration',
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
                  SizedBox(height: 20),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: ageController,
                    decoration: InputDecoration(
                      labelText: 'Age',
                      counterText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 2,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: phoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: TextEditingController(text: _gender),
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      icon: const Icon(Icons.people),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      suffixIcon: PopupMenuButton<String>(
                        icon: const Icon(Icons.arrow_drop_down),
                        onSelected: (String newValue) {
                          setState(() {
                            _gender = newValue;
                            // Update the text field controller
                            (context as Element).markNeedsBuild();
                          });
                        },
                        itemBuilder: (BuildContext context) => <String>[
                          'M',
                          'F',
                        ].map<PopupMenuItem<String>>((String value) {
                          return PopupMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    readOnly: true, // Make the text field non-editable
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: TextEditingController(text: _selectedOption),
                    decoration: InputDecoration(
                      labelText: 'Role',
                      icon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      suffixIcon: PopupMenuButton<String>(
                        icon: const Icon(Icons.arrow_drop_down),
                        onSelected: (String newValue) {
                          setState(() {
                            _selectedOption = newValue;
                            // Update the text field controller
                            (context as Element).markNeedsBuild();
                          });
                        },
                        itemBuilder: (BuildContext context) => <String>[
                          'Patient',
                          'Doctor',
                        ].map<PopupMenuItem<String>>((String value) {
                          return PopupMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    readOnly: true, // Make the text field non-editable
                  ),
                  SizedBox(height: 16),
                  Visibility(
                    visible: _selectedOption == 'Doctor',
                    child: TextField(
                      controller: TextEditingController(text: _doctorType),
                      decoration: InputDecoration(
                        labelText: 'Specialization',
                        icon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        suffixIcon: PopupMenuButton<String>(
                          icon: const Icon(Icons.arrow_drop_down),
                          onSelected: (String newValue) {
                            setState(() {
                              _doctorType = newValue;
                            });
                          },
                          itemBuilder: (BuildContext context) =>
                              <String>[
                                "Dermatologist", "Phlebologist", "Pediatrician", "Internal Medicine", "Otolaryngologist", "Pulmonologist", "Gastroenterologist", "Rheumatologists", "Cardiologist", "Neurologist", "Gyneocologist", "Allergist", "Endocrinologist"
                              ].map<PopupMenuItem<String>>((String value) {
                                return PopupMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                        ),
                      ),
                      readOnly: true,
                    ),
                  ),
                  Visibility(
                    visible: _selectedOption=="Doctor",
                    child: Column(
                      children: [
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Fees"),
                            Text("₹ $fees"),
                          ],
                        ),
                        SizedBox(height: 16),
                        Slider(
                            max: 5000,
                            value: fees.toDouble(),
                            onChanged: (value){
                              setState(() {
                                fees = value.round();
                              });
                            }
                        ),
                        SizedBox(height: 16),
                        TextField(
                          controller: TextEditingController(text: _fromTime),
                          decoration: InputDecoration(
                            labelText: 'From Time',
                            icon: const Icon(Icons.watch_later_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            suffixIcon: PopupMenuButton<String>(
                              icon: const Icon(Icons.arrow_drop_down),
                              onSelected: (String newValue) {
                                setState(() {
                                  _fromTime = newValue;
                                });
                              },
                              itemBuilder: (BuildContext context) =>
                                  <String>[
                                    '12:00 AM',
                                    '01:00 AM',
                                    '01:30 AM',
                                    '02:00 AM',
                                    '02:30 AM',
                                    '03:00 AM',
                                    '03:30 AM',
                                    '04:00 AM',
                                    '04:30 AM',
                                    '05:00 AM',
                                    '05:30 AM',
                                    '06:00 AM',
                                    '06:30 AM',
                                    '07:00 AM',
                                    '07:30 AM',
                                    '08:00 AM',
                                    '08:30 AM',
                                    '09:00 AM',
                                    '09:30 AM',
                                    '10:00 AM',
                                    '10:30 AM',
                                    '11:00 AM',
                                    '11:30 AM',
                                    '12:00 PM',
                                    '01:00 PM',
                                    '01:30 PM',
                                    '02:00 PM',
                                    '02:30 PM',
                                    '03:00 PM',
                                    '03:30 PM',
                                    '04:00 PM',
                                    '04:30 PM',
                                    '05:00 PM',
                                    '05:30 PM',
                                    '06:00 PM',
                                    '06:30 PM',
                                    '07:00 PM',
                                    '07:30 PM',
                                    '08:00 PM',
                                    '08:30 PM',
                                    '09:00 PM',
                                    '09:30 PM',
                                    '10:00 PM',
                                    '10:30 PM',
                                    '11:00 PM',
                                    '11:30 PM',
                                  ].map<PopupMenuItem<String>>((String value) {
                                    return PopupMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                            ),
                          ),
                          readOnly: true,
                        ),
                        SizedBox(height: 16),
                        TextField(
                          controller: TextEditingController(text: _toTime),
                          decoration: InputDecoration(
                            labelText: 'To Time',
                            icon: const Icon(Icons.watch_later_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            suffixIcon: PopupMenuButton<String>(
                              icon: const Icon(Icons.arrow_drop_down),
                              onSelected: (String newValue) {
                                setState(() {
                                  _toTime = newValue;
                                });
                              },
                              itemBuilder: (BuildContext context) =>
                                  <String>[
                                    '12:00 AM',
                                    '01:00 AM',
                                    '01:30 AM',
                                    '02:00 AM',
                                    '02:30 AM',
                                    '03:00 AM',
                                    '03:30 AM',
                                    '04:00 AM',
                                    '04:30 AM',
                                    '05:00 AM',
                                    '05:30 AM',
                                    '06:00 AM',
                                    '06:30 AM',
                                    '07:00 AM',
                                    '07:30 AM',
                                    '08:00 AM',
                                    '08:30 AM',
                                    '09:00 AM',
                                    '09:30 AM',
                                    '10:00 AM',
                                    '10:30 AM',
                                    '11:00 AM',
                                    '11:30 AM',
                                    '12:00 PM',
                                    '01:00 PM',
                                    '01:30 PM',
                                    '02:00 PM',
                                    '02:30 PM',
                                    '03:00 PM',
                                    '03:30 PM',
                                    '04:00 PM',
                                    '04:30 PM',
                                    '05:00 PM',
                                    '05:30 PM',
                                    '06:00 PM',
                                    '06:30 PM',
                                    '07:00 PM',
                                    '07:30 PM',
                                    '08:00 PM',
                                    '08:30 PM',
                                    '09:00 PM',
                                    '09:30 PM',
                                    '10:00 PM',
                                    '10:30 PM',
                                    '11:00 PM',
                                    '11:30 PM',
                                  ].map<PopupMenuItem<String>>((String value){
                                    return PopupMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                            ),
                          ),
                          readOnly: true,
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              _isLoading = true;
                            });
                            FilePickerResult? result = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['pdf', 'png', 'jpeg','jpg'], // Specify the allowed file extensions
                              allowMultiple: false, // Set to true if you want to allow picking multiple files
                            );
                            if(result!=null){
                              userData.setLicenceFile(File(result.files.first.path as String));
                              await uploadLicence(context);
                            }
                            else{
                              snackBar("Please upload a file", context);
                            }
                            setState(() {
                              _isLoading = false;
                            });
                          }, //_verifyPhoneNumber,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text('Upload Licence'),
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        _isLoading = true;
                      });
                      print(phoneNumberController.text);
                      await verifyPhoneNumber(context, "+91"+phoneNumberController.text);
                      snackBar("OTP sent",context);
                      setState(() {
                        _isLoading = false;
                      });
                    }, //_verifyPhoneNumber,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text('Get OTP'),
                    ),
                  ),
                  SizedBox(height: 16),
                  PinCodeTextField(
                    appContext: context,
                    length: 6,
                    onChanged: (value) {
                      print(value);
                    },
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.underline,
                      activeColor: Colors.blue,
                      inactiveColor: Colors.grey,
                      selectedColor: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      userData.setUserName(nameController.text);
                      userData.setAge(ageController.text);
                      userData.setGender(_gender!);
                      userData.setEmail(emailController.text);
                      userData.setPhoneNumber(phoneNumberController.text);
                      userData.setType(_selectedOption!);
                      userData.setDoctorType(_doctorType!);
                      userData.setFee(fees);
                      userData.setFromTime(_fromTime);
                      userData.setToTime(_toTime);
                      await verifyOTPCodeForRegistration(context,userData.verfID,otpController.text,);
                      setState(() {
                        _isLoading = false;
                      });
                    }, //_verifyPhoneNumber,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text('Register'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if(_isLoading)
            fullScreenLoader(),
        ],
      ),
    );
  }
}
