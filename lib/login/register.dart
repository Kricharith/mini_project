import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mini_project/login/login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  @override
  State createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formstate = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _firstname = TextEditingController();
  final _lastname = TextEditingController();
  final _address = TextEditingController();
  final _tel = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        autovalidateMode: AutovalidateMode.always,
        key: _formstate,
        child: Container(
          child: Stack(
            children: <Widget>[
              // Background Image
              Container(
                  constraints: BoxConstraints.expand(),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/Register2.png"),
                        fit: BoxFit.cover),
                  ),
                  child: null),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        'Register',
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 40,
                        ),
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.only(bottom: 150),
                        child: Column(
                          children: [
                            buildUserNameField(),
                            buildEmailField(),
                            buildPasswordField(),
                            buildTelField(),
                            buildRegisterButton(),
                          ],
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton buildRegisterButton() {
    return ElevatedButton(
      child: const Text('Register'),
      onPressed: () async {
        print('Register new account');
        if (_formstate.currentState!.validate()) print(email.text);
        print(password.text);
        final user = await auth.createUserWithEmailAndPassword(
            email: email.text.trim(), password: password.text.trim());
        user.user!.sendEmailVerification().then((value) async {
          Map<String, dynamic> data = {
            'username': _username.text,
            'firstname': 'User firstname',
            'lastname': 'User lastname',
            'email': email.text,
            'address': 'User address',
            'tel': _tel.text,
            'urlprofile':
                'https://icons.veryicon.com/png/o/miscellaneous/management-system-icon-library/person-15.png',
          };
          await FirebaseFirestore.instance
              .collection("Profile")
              .doc(user.user!.uid)
              .set(data);
        });

        Navigator.pushReplacementNamed(context, '/login');
      },
    );
  }

  TextFormField buildPasswordField() {
    return TextFormField(
      controller: password,
      validator: (value) {
        if (value!.length < 8) {
          return 'Please Enter more than 8 Character';
        } else {
          return null;
        }
      },
      obscureText: true,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
        labelText: 'Password',
        icon: Icon(Icons.lock),
      ),
    );
  }

  TextFormField buildEmailField() {
    return TextFormField(
      controller: email,
      validator: (value) {
        if (!validateEmail(value!)) {
          return 'Please fill in E-mail field';
        } else {
          return null;
        }
      },
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'E-mail',
        icon: Icon(Icons.email),
        hintText: 'x@x.com',
      ),
    );
  }

  bool validateEmail(String value) {
    RegExp regex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

    return (!regex.hasMatch(value)) ? false : true;
  }

  TextFormField buildUserNameField() {
    return TextFormField(
      controller: _username,
      decoration: const InputDecoration(
        labelText: 'UserName',
        icon: Icon(Icons.person),
      ),
      validator: (value) => value!.isEmpty ? 'Please fill in title' : null,
    );
  }

  TextFormField buildFirstNameField() {
    return TextFormField(
      controller: _firstname,
      decoration: const InputDecoration(
        labelText: 'First name',
        icon: Icon(Icons.list),
      ),
      validator: (value) => value!.isEmpty ? 'Please fill in detail' : null,
    );
  }

  TextFormField buildLastNameField() {
    return TextFormField(
      controller: _lastname,
      decoration: const InputDecoration(
        labelText: 'Last name',
        icon: Icon(Icons.list),
      ),
      validator: (value) => value!.isEmpty ? 'Please fill in detail' : null,
    );
  }

  TextFormField buildAddressField() {
    return TextFormField(
      controller: _address,
      decoration: const InputDecoration(
        labelText: 'Address',
        icon: Icon(Icons.list),
      ),
      validator: (value) => value!.isEmpty ? 'Please fill in detail' : null,
    );
  }

  TextFormField buildTelField() {
    return TextFormField(
        controller: _tel,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: 'Telephone',
          icon: Icon(Icons.phone),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please fill in tel';
          } else {
            double tel = double.parse(value);
            if (tel < 0) {
              return 'Please fill in tel';
            } else {
              return null;
            }
          }
        });
  }
}
