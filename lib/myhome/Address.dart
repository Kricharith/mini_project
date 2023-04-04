import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_project/povider/model.dart';
import 'package:provider/provider.dart';

class Address extends StatefulWidget {
  const Address({Key? key}) : super(key: key);

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  final store = FirebaseFirestore.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance.currentUser!;
  final _usersStream = FirebaseFirestore.instance
      .collection('Profile')
      .doc(FirebaseAuth
          .instance.currentUser!.uid) // 👈 Your document id change accordingly
      .snapshots();
  dynamic _model;
  @override
  Widget build(BuildContext context) {
    return Consumer<Model>(
      builder: (context, modelpovider, child) => StreamBuilder<
              DocumentSnapshot<Map<String, dynamic>>>(
          stream: _usersStream,
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            _model = data;
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Color.fromARGB(255, 164, 145, 252),
                centerTitle: true,
                title: Text(
                  "ยืนยันที่อยู่",
                  style: TextStyle(fontSize: 30),
                ),
              ),
              body: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Color.fromARGB(255, 164, 145, 252),
                  Color.fromARGB(255, 210, 202, 255),
                  Color.fromARGB(255, 137, 110, 255)
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                constraints: BoxConstraints.expand(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                          padding: EdgeInsets.all(10),
                          height: 150,
                          width: 450,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color.fromARGB(255, 200, 200, 200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "ที่อยู่จัดส่ง",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                _model['address'].toString(),
                                style: TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                          padding: EdgeInsets.all(10),
                          //height: 50,
                          width: 450,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color.fromARGB(255, 200, 200, 200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "ชื่อผู้รับสินค้า",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  Text(
                                    _model['firstname'].toString(),
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    _model['lastname'].toString(),
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                          padding: EdgeInsets.all(10),
                          //height: 50,
                          width: 450,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color.fromARGB(255, 200, 200, 200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "เบอร์โทรผู้รับสินค้า",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                _model['tel'].toString(),
                                style: TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        ),
                        // Container(
                        //   margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                        //   padding: EdgeInsets.all(10),
                        //   //height: 50,
                        //   width: 450,
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(20),
                        //     color: Color.fromARGB(255, 200, 200, 200),
                        //   ),
                        // child: Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Text(
                        //       "ข้อความถึงพนักงานส่ง",
                        //       style: TextStyle(
                        //           fontSize: 20, fontWeight: FontWeight.bold),
                        //     ),
                        //     Text(
                        //       "ขอบคุณครับ",
                        //       style: TextStyle(fontSize: 20),
                        //     )
                        //   ],
                        // ),
                        //)
                      ],
                    )
                  ],
                ),
              ),
              bottomNavigationBar: BottomAppBar(
                  color: Color.fromARGB(255, 200, 200, 200),
                  child: Container(
                      height: 150,
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("ราคารวม", style: TextStyle(fontSize: 40)),
                              SizedBox(
                                width: 80,
                              ),
                              Text("${modelpovider.costtotal.toString()} บาท",
                                  style: TextStyle(fontSize: 40)),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: [
                              netxButton(context),
                            ],
                          )
                        ],
                      ))),
            );
          }),
    );
  }

  MaterialButton netxButton(BuildContext context) {
    return MaterialButton(
      color: Color.fromARGB(255, 255, 85, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Text(
        '        ถัดไป        ',
        style:
            TextStyle(color: Color.fromARGB(255, 255, 252, 252), fontSize: 40),
      ),
      onPressed: () {
        print('Goto  login pagge');
        Navigator.pushNamed(context, '/Confirm');
      },
    );
  }
}
