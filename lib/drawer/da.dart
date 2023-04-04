import 'package:flutter/material.dart';

class Profile2 extends StatefulWidget {
  const Profile2({super.key});

  @override
  State<Profile2> createState() => _Profile2State();
}

class _Profile2State extends State<Profile2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                print("add icon press");
                Navigator.pushNamed(context, '/EditProfile');
              }),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
                child: Column(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(150),
                        child: Image(
                            image: NetworkImage(
                                'https://icons.veryicon.com/png/o/miscellaneous/management-system-icon-library/person-15.png'))),
                  ],
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Container(
                width: 350,
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 89, 205, 255),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    Icon(Icons.person, size: 30),
                    const Text('  ',
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0), fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Container(
                width: 350,
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 89, 205, 255),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    Icon(Icons.person, size: 30),
                    const Text('  ',
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0), fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Container(
                height: 150,
                width: 350,
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 89, 205, 255),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    Icon(Icons.home, size: 30),
                    const Text('  ',
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0), fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Container(
                width: 350,
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 89, 205, 255),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    Icon(Icons.phone, size: 30),
                    const Text('  ',
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0), fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
