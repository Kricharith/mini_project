import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_project/povider/model.dart';
import 'package:provider/provider.dart';

class Confirm extends StatefulWidget {
  const Confirm({Key? key}) : super(key: key);

  @override
  State createState() => _HomepageState();
}

class _HomepageState extends State<Confirm> {
  final store = FirebaseFirestore.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance.currentUser!;
  final _usersStream = FirebaseFirestore.instance
      .collection('Profile')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
  dynamic _model;
  int count = 0;
  int count2 = 0;
  @override
  Widget build(BuildContext context) {
    return Consumer<Model>(
      builder: (context, modelpovider, child) => StreamBuilder(
          stream: store.collection('Basket').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot1) {
            return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: _usersStream,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
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
                    resizeToAvoidBottomInset: false,
                    body: Container(
                        constraints: BoxConstraints.expand(),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/Confirm.png"),
                              fit: BoxFit.cover),
                        ),
                        child: ListView(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 78),
                                Row(
                                  children: [
                                    SizedBox(width: 20),
                                    Text('ราคารวม',
                                        style: TextStyle(fontSize: 24)),
                                    SizedBox(width: 150),
                                    Text(
                                        '${modelpovider.costtotal.toString()} บาท',
                                        style: TextStyle(fontSize: 24)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: 20),
                                    const Text('ค่าจัดส่ง',
                                        style: TextStyle(fontSize: 24)),
                                    SizedBox(width: 215),
                                    const Text('ฟรี',
                                        style: TextStyle(fontSize: 24)),
                                  ],
                                ),
                                SizedBox(height: 330),
                                Container(
                                  color: Colors.grey[400],
                                  height: 306,
                                  child: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(width: 20),
                                              Text('ยอดชำระ',
                                                  style:
                                                      TextStyle(fontSize: 30)),
                                              SizedBox(width: 100),
                                              Text(
                                                  '${modelpovider.costtotal.toString()} บาท',
                                                  style:
                                                      TextStyle(fontSize: 30)),
                                            ],
                                          ),
                                          SizedBox(height: 50),
                                          Row(
                                            children: [
                                              SizedBox(width: 40),
                                              ConfirmButton(
                                                  context,
                                                  snapshot1.data!,
                                                  modelpovider),
                                            ],
                                          ),
                                          SizedBox(height: 30),
                                          Row(
                                            children: [
                                              SizedBox(width: 40),
                                              ReturnButton(context),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
                  );
                });
          }),
    );
  }

  MaterialButton ConfirmButton(
      BuildContext context, QuerySnapshot data, Model modelpovider) {
    count = modelpovider.num1;
    count2 = modelpovider.num2;
    return MaterialButton(
      color: Color.fromARGB(255, 228, 63, 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Text(
        '  ยืนยันการสั่งซื้อ ',
        style:
            TextStyle(color: Color.fromARGB(255, 255, 252, 252), fontSize: 40),
      ),
      onPressed: () {
        count++;
        modelpovider.num1 = count;
        print('ยืนยันเสร็จเรียบร้อย');
        sendOrder(context, data, modelpovider);
        deleteBasket(context, data);
        Navigator.pushNamed(context, '/Order');
      },
    );
  }

  sendOrder(context, QuerySnapshot data, Model modelpovider) {
    for (int i = 0; i < data.size; i++) {
      var order = data.docs.elementAt(i);
      if (order['email'].toString() == _auth.email) {
        print(order['email']);
        Map<String, dynamic> dataSend = {
          'ordername': 'order' + count.toString(),
          'email': _auth.email,
          'image_url': order['image_url'],
          'item': order['item'],
          'title': order['title'],
          'subtitle': order['subtitle'],
        };
        count2++;
        modelpovider.num2 = count2;
        print('i = $i');
        print(dataSend);
        print('---------------------');
        FirebaseFirestore.instance
            .collection("Order")
            .doc(_auth.uid + count2.toString())
            .set(dataSend);
      }
    }
  }

  deleteBasket(context, QuerySnapshot data) {
    for (int i = 0; i < data.size; i++) {
      var order = data.docs.elementAt(i);

      if (order['email'].toString() == _auth.email) {
        FirebaseFirestore.instance.collection("Basket").doc(order.id).delete();
      }
    }
  }

  MaterialButton ReturnButton(BuildContext context) {
    return MaterialButton(
      color: Color.fromARGB(255, 25, 121, 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Text(
        '       ย้อนกลับ       ',
        style:
            TextStyle(color: Color.fromARGB(255, 255, 252, 252), fontSize: 40),
      ),
      onPressed: () {
        print('ย้อนกลับ');
        Navigator.pop(context);
      },
    );
  }
}
