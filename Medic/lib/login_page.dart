import 'package:flutter/material.dart';
import 'package:medic/provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'firebase_function.dart';
import 'home.dart';


// class login_page extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Login App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: LoginPage(),
//     );
//   }
// }

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _phoneNumber = '';
  //String _password = '';
  TextEditingController otpController = TextEditingController();


  bool _isLoading = false;
  // void _navigateToAssessment() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => Home()),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Image(
                image: AssetImage('assets/medicLogo.jpg'),
                width: 60.0,
                height: 60.0,
              ),
                //Image.asset('assets/logo.jpg', fit: BoxFit.fitWidth), // Replace with your image path
                Text(
                  'MEDIC',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue,
                  Colors.blueAccent,
                ],
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Image.asset(
                          'assets/logo.png', // Replace with your logo
                          width: 150.0,
                        ),
                        SizedBox(height: 40.0),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Phone Number',
                            prefixIcon: Icon(Icons.phone),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (value) => value!.isEmpty ? 'Please enter email' : null,
                          onChanged: (value) => _phoneNumber = value,
                        ),

                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              _isLoading = true;
                            });
                            await verifyPhoneNumber(context, "+91"+_phoneNumber);
                            snackBar("OTP sent",context);
                            setState(() {
                              _isLoading = false;
                            });
                          }, //_verifyPhoneNumber,
                          child: Text('Get OTP'),
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
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });
                              await verifyOTPCodeForLogin(context,userData.verfID,otpController.text);
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 100.0, vertical: 20.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: Text(
                            'Login',
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if(_isLoading)
          fullScreenLoader(),
      ],
    );
  }
}






