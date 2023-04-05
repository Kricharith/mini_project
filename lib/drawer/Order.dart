import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../povider/model.dart';

class Order extends StatefulWidget {
  const Order({Key? key}) : super(key: key);

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  @override
  final store = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance.currentUser!;
  dynamic _order;
  int price = 0;
  int p = 0;
  final _usersStream = FirebaseFirestore.instance
      .collection('Profile')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
  dynamic _profile;
  @override
  Widget build(BuildContext context) {
    return Consumer<Model>(
      builder: (context, modelpovider, child) => StreamBuilder(
          stream: store.collection('Order').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: _usersStream,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot2) {
                  if (snapshot2.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot2.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  Map<String, dynamic> data =
                      snapshot2.data!.data() as Map<String, dynamic>;
                  _profile = data;
                  return Scaffold(
                    appBar: PreferredSize(
                      preferredSize: Size.fromHeight(120),
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Container(
                            color: Color.fromARGB(255, 60, 112, 255),
                          ),
                          SizedBox(),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_back,
                                  size: 30,
                                ),
                                onPressed: () {
                                  Navigator.popAndPushNamed(
                                      context, '/homepage');
                                },
                              ),
                            ],
                          ),
                          Center(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 100,
                                ),
                                Text("รายการสั่งซื้อ",
                                    style: TextStyle(fontSize: 40)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    body: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                            Color.fromARGB(255, 215, 225, 253),
                            Color.fromARGB(255, 137, 161, 246),
                            Color.fromARGB(255, 212, 224, 255)
                          ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter)),
                      child: snapshot.hasData
                          ? buildOrderList(snapshot.data!, modelpovider)
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                  );
                });
          }),
    );
  }

  ListView buildOrderList(QuerySnapshot data, Model modelpovider) {
    price = 0;
    int stast = 0;
    String save = '';
    String save2 = '';
    return ListView.builder(
      itemCount: data.size,
      itemBuilder: (BuildContext context, int index) {
        var order = data.docs.elementAt(index);
        _order = order;

        for (int i = 0; i <= 20; i++)
          if (order['email'].toString() != _auth.email.toString()) {
            print("errrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
          } else if (order['ordername'] == 'order' + i.toString()) {
            save = order['ordername'];
            //print('in=' + order['ordername']);
            if (order['ordername'] == save && save != save2) {
              stast = 1;
              save2 = order['ordername'];
              //print('ddd = ' + order['ordername']);
              return show(data, order, modelpovider);
            } else {
              stast = 0;
              //print('out=' + order['ordername']);
            }
          }
        return SizedBox(
          height: 0,
        );
      },
    );
  }

  Center show(QuerySnapshot data, dynamic order, Model modelpovider) {
    String save = '';
    String save2 = '';
    int state = 0;
    return Center(
      child: Card(
        clipBehavior: Clip.hardEdge,
        color: Color.fromARGB(255, 113, 191, 255),
        child: InkWell(
          splashColor: Color.fromARGB(255, 0, 138, 252).withAlpha(30),
          onTap: () {
            print(order['ordername'].toString());
            modelpovider.indexOrder = order['ordername'].toString();
            Navigator.pushNamed(context, '/Orderlist');
            debugPrint('Card tapped.');
          },
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromARGB(255, 254, 194, 162),
              Color.fromARGB(255, 255, 168, 68),
              Color.fromARGB(255, 255, 191, 143)
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: SizedBox(
                width: 350,
                height: 120,
                child: Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Container(
                        width: 250,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'รายการการสั่งซื้อของคุณ ${_profile['username']}',
                              style: TextStyle(fontSize: 15),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ที่จัดส่ง'),
                                Text(_profile['address'].toString()),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Stack(
                          children: <Widget>[
                            Positioned.fill(
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: <Color>[
                                      Color(0xFF0D47A1),
                                      Color.fromARGB(255, 58, 140, 221),
                                      Color(0xFF0D47A1),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.all(10.0),
                                textStyle: const TextStyle(fontSize: 20),
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: StatefulBuilder(builder:
                                        (BuildContext context,
                                            StateSetter setState) {
                                      return Container(
                                        height: 110,
                                        child: Column(
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  " คุณได้รับสินค้าแล้ว",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                                Text(
                                                  "ใช่หรือไม่",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary:
                                                              Color.fromARGB(
                                                                  255,
                                                                  255,
                                                                  34,
                                                                  14)),
                                                  child: Text(
                                                    'ไม่',
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary:
                                                              Color.fromARGB(
                                                                  255,
                                                                  66,
                                                                  255,
                                                                  14)),
                                                  child: Text(
                                                    'ใช่',
                                                  ),
                                                  onPressed: () {
                                                    print(order['ordername']);
                                                    String del =
                                                        order['ordername'];
                                                    setState(() {
                                                      for (int n = 0;
                                                          n <= 10;
                                                          n++) {
                                                        for (int m = 0;
                                                            m < data.size;
                                                            m++) {
                                                          var _order = data.docs
                                                              .elementAt(m);
                                                          if (_order['ordername']
                                                                  .toString() ==
                                                              del) {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "Order")
                                                                .doc(_order.id)
                                                                .delete();
                                                          }
                                                        }
                                                      }
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                    }),
                                  ),
                                );
                              },
                              child: const Text('ได้รับ'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
