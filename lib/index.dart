import 'package:flutter/material.dart';

class Index extends StatefulWidget {
  const Index({Key? key}) : super(key: key);

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            // Background Image
            Container(
                constraints: BoxConstraints.expand(),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/index.png"),
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
                      'Welcome to Burger Biger',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: loginButton(context),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: registerButton(context),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

MaterialButton registerButton(BuildContext context) {
  return MaterialButton(
    color: Color.fromARGB(255, 102, 51, 255),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: Text(
      'Register',
      style: TextStyle(color: Color.fromARGB(255, 255, 252, 252), fontSize: 40),
    ),
    onPressed: () {
      print('Goto  Regis pagge');
      Navigator.pushNamed(context, '/register');
    },
  );
}

MaterialButton loginButton(BuildContext context) {
  return MaterialButton(
    color: Color.fromARGB(255, 102, 51, 255),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: Text(
      'Login',
      style: TextStyle(color: Color.fromARGB(255, 255, 252, 252), fontSize: 40),
    ),
    onPressed: () {
      print('Goto  login pagge');
      Navigator.pushNamed(context, '/login');
    },
  );
}
