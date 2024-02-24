import 'dart:io';
import 'package:flutter/material.dart';

class UserData extends ChangeNotifier{
  String userName = "";
  String age = "";
  String gender = "";
  String email = "";
  String phoneNumber = "";
  String uid = "";
  String verfID = "";
  String type="";
  String doctortype = "";
  int fees = 0;
  String fromTime = '';
  String toTime = "";
  String status="";
  
  String licence="";
  late File licenceFile;

  void setStatus(String value){
    status=value;
    notifyListeners();
  }

  void setLicenceFile(File value){
    licenceFile=value;
    notifyListeners();
  }
  void setLicence(String value){
    licence=value;
    notifyListeners();
  }

  void setFromTime(String value){
    fromTime = value;
    notifyListeners();
  }

  void setToTime(String value){
    toTime = value;
    notifyListeners();
  }

  void setFee(int value){
    fees = value;
    notifyListeners();
  }

  void setAge(String value){
    age = value;
    notifyListeners();
  }
  void setGender(String value){
    gender = value;
    notifyListeners();
  }
  void setType(String value){
    type = value;
    notifyListeners();
  }
  void setDoctorType(String value){
    doctortype = value;
    notifyListeners();
  }
  void setVerificationID(String value){
    verfID = value;
    notifyListeners();
  }

  void setUserName(String value){
    userName = value;
    notifyListeners();
  }
  void setEmail(String value){
    email = value;
    notifyListeners();
  }
  void setPhoneNumber(String value){
    phoneNumber = value;
    notifyListeners();
  }
  void setUid(String value){
    uid = value;
    notifyListeners();
  }
}

class Doctor {
  final String name;
  final String age;
  final String doctortype;
  final String email;
  final String fromTime;
  final String gender;
  final String phoneNumber;
  final String toTime;
  final String type;
  final String uid;
  final int fees;
  final int appointments;

  Doctor({
    required this.name,
    required this.age,
    required this.doctortype,
    required this.email,
    required this.fromTime,
    required this.gender,
    required this.phoneNumber,
    required this.toTime,
    required this.type,
    required this.uid,
    required this.fees,
    required this.appointments,
  });
}

class DoctorsProvider extends ChangeNotifier{
  List<Doctor> doctors = [];

  void setDoctors (List<Doctor> value){
    doctors = value;
    notifyListeners();
  }

}

class Appointment{
  String name;
  String age ;
  String gender;
  String email;
  String phoneNumber;
  String uid;

  Appointment({
    required this.name,
    required this.age,
    required this.gender,
    required this.email,
    required this.phoneNumber,
    required this.uid,

  });
}

class AppointmentHistory {
  String doctorName;
  String fromTime;
  String toTime;

  AppointmentHistory({
    required this.doctorName,
    required this.fromTime,
    required this.toTime,
  });

  factory AppointmentHistory.fromFirestore(Map<String, dynamic> data) {
    return AppointmentHistory(
      doctorName: data['doctorName'],
      fromTime: data['From'],
      toTime: data['To'],
    );
  }
}

class AppointmentsProvider extends ChangeNotifier{
  List<Appointment> appointments = [];

  void setAppointments (List<Appointment> value){
    appointments = value;
    notifyListeners();
  }
}

