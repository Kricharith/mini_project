import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import '../povider/model.dart';

class OrderList extends StatefulWidget {
  const OrderList({Key? key}) : super(key: key);

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  @override
  final store = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance.currentUser!;
  dynamic _order;
  final _usersStream = FirebaseFirestore.instance
      .collection('Profile')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Consumer<Model>(
      builder: (context, modelpovider, child) => StreamBuilder(
          stream: store.collection('Order').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(120),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Container(
                      color: Color.fromARGB(255, 51, 99, 255),
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
                            Navigator.pop(context);
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
                          Text("รายการสั่งซื้อของคุณ",
                              style: TextStyle(fontSize: 40)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              body: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Color.fromARGB(255, 215, 225, 253),
                  Color.fromARGB(255, 137, 161, 246),
                  Color.fromARGB(255, 212, 224, 255)
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                child: snapshot.hasData
                    ? buildOrderList(snapshot.data!, modelpovider)
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            );
          }),
    );
  }

  ListView buildOrderList(QuerySnapshot data, Model modelpovider) {
    return ListView.builder(
      itemCount: data.size,
      itemBuilder: (BuildContext context, int index) {
        var order = data.docs.elementAt(index);
        _order = order;
        for (int i = 0; i <= data.size; i++)
          if (order['email'].toString() != _auth.email.toString()) {
            print("errrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
          } else if (order['ordername'] == modelpovider.indexOrder) {
            _order = order;
            return Column(
              children: [
                Container(
                  child: Row(
                    children: [
                      Divider(
                        color: Color.fromARGB(255, 6, 6, 6),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Image.network(
                            _order!['image_url'].toString(),
                            height: 100,
                            width: 100,
                          ),
                          Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 240,
                                        child: Text(
                                          _order!['title'].toString(),
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("X ${_order['item']}"),
                                      SizedBox(
                                        width: 180,
                                      ),
                                      Text(_order['subtitle'],
                                          style: TextStyle(fontSize: 20)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      //Text(order['image_url']),
                      Divider(
                        color: Color.fromARGB(255, 6, 6, 6),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        return SizedBox(
          height: 0,
        );
      },
    );
  }
}
