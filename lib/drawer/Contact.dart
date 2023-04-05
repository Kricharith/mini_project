import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_project/drawer/map.dart';

class Contact extends StatefulWidget {
  const Contact({Key? key}) : super(key: key);

  @override
  State createState() => _HomepageState();
}

class _HomepageState extends State<Contact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              color: Color.fromARGB(255, 1, 82, 233),
            ),
            Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 35,
                  ),
                  Text(
                    "ติดต่อเรา",
                    style: TextStyle(fontSize: 45),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text("Burger Biger", style: TextStyle(fontSize: 40)),
                ],
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color.fromARGB(255, 134, 138, 255),
              ),
              child: Row(
                children: [
                  SizedBox(width: 20),
                  Icon(Icons.phone, size: 30),
                  const Text(' เบอร์โทร 080-0562114  คุณแจ็ก ',
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0), fontSize: 20)),
                ],
              ),
            ),
            SizedBox(height: 5),
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color.fromARGB(255, 134, 138, 255),
              ),
              child: Row(
                children: [
                  SizedBox(width: 20),
                  Icon(Icons.messenger, size: 30),
                  const Text(' Line : Burger_biger ',
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0), fontSize: 20)),
                ],
              ),
            ),
            SizedBox(height: 5),
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color.fromARGB(255, 134, 138, 255),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Icon(Icons.home, size: 30),
                      Text(' ที่อยู่  ร้าน Burger Biger ',
                          style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 20)),
                    ],
                  ),
                  Text('ต.คลองหก อ.คลองหลวง จ.ปทุมธานี 18130',
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0), fontSize: 20)),
                ],
              ),
            ),
            SizedBox(height: 50),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Image.asset('assets/images/mapicon.png'),
                      iconSize: 100,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MapsPage()));
                      },
                    ),
                  ],
                ),
                Text(
                  'แผนที่ร้าน BBurger biger',
                  style: TextStyle(fontSize: 25),
                ),
              ],
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
