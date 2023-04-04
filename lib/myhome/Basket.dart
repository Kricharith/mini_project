import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../povider/model.dart';

class Basket extends StatefulWidget {
  const Basket({Key? key}) : super(key: key);

  @override
  State<Basket> createState() => _BasketState();
}

class _BasketState extends State<Basket> {
  @override
  void initState() {
    Consumer<Model>(
      builder: (context, modelpovider, child) {
        fillInitialData(modelpovider);
        super.initState();
        return Center();
      },
    );
  }

  Widget fillInitialData(Model modelpovider) {
    int p;
    if (modelpovider.costtotal != 0) {
      p = modelpovider.costtotal;
      modelpovider.costtotal = p;
    }
    return Center();
  }

  @override
  final store = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance.currentUser!;
  dynamic _order;
  int price = 0;
  int p = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<Model>(
      builder: (context, modelpovider, child) => StreamBuilder(
          stream: store.collection('Basket').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(120),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Container(
                      color: Colors.red.shade600,
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
                            Navigator.pushNamed(context, "/homepage");
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
                          Text("สินค้าในตะกร้า",
                              style: TextStyle(fontSize: 40)),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.restore,
                            size: 30,
                          ),
                          onPressed: () {
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              body:
                  //Container(
                  // decoration: BoxDecoration(
                  //     gradient: LinearGradient(colors: [
                  //   Colors.red.shade200,
                  //   Colors.red.shade100,
                  //   Colors.red.shade300,
                  // ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                  snapshot.hasData
                      ? buildOrderList(snapshot.data!, modelpovider)
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
              // ),

              bottomNavigationBar: BottomAppBar(
                  color: Color.fromARGB(255, 188, 188, 188),
                  child: Container(
                      height: 150,
                      child: Column(
                        children: [
                          StatefulBuilder(builder: (context, MyStateFunc) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("ราคารวม", style: TextStyle(fontSize: 35)),
                                SizedBox(
                                  width: 100,
                                ),
                                fillInitialData(modelpovider),
                                Text('${modelpovider.costtotal.toString()} บาท',
                                    style: TextStyle(fontSize: 35)),
                              ],
                            );
                          }),
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
            TextStyle(color: Color.fromARGB(255, 255, 252, 252), fontSize: 35),
      ),
      onPressed: () {
        print('Goto  Address');
        Navigator.pushNamed(context, '/Address');
      },
    );
  }

  ListView buildOrderList(QuerySnapshot data, Model modelpovider) {
    price = 0;
    if (data.docs.length == 0) {
      modelpovider.costtotal = 0;
    }
    return ListView.builder(
      itemCount: data.size,
      itemBuilder: (BuildContext context, int index) {
        var order = data.docs.elementAt(index);
        //var model = data.docs.elementAt(index);
        _order = order;
        if (order['email'].toString() != _auth.email.toString()) {
          p = 0;
          price = 0;
          print("errrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
        } else {
          //print("yessssssssssssssssssssssssssss");
          String st = order['subtitle'];
          int num_item = order['item'];
          //print(num_item);
          st = st.replaceAll("บาท", "");
          price += int.parse(st) * num_item;
          p = price;
          print("priceeeeeeeeeeeee === ");
          print(p);
          modelpovider.costtotal = p;
          _order = order;
          return Container(
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
                    Image.asset(
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 240,
                                  child: Text(
                                    _order!['title'].toString(),
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                IconButton(
                                  //splashRadius: 100,
                                  iconSize: 36,
                                  icon: Icon(Icons.delete_forever),
                                  color: Color.fromARGB(255, 246, 16, 0),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        content: StatefulBuilder(builder:
                                            (BuildContext context,
                                                StateSetter setState) {
                                          return Container(
                                            height: 220,
                                            child: Column(
                                              children: [
                                                Text(
                                                  _order['title'],
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                                Image.asset(
                                                  _order['image_url'],
                                                  height: 100,
                                                  width: 100,
                                                  fit: BoxFit.fill,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      " คุณต้องการลบสิ้นค้าใช่หรือไม่",
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary: Color
                                                                  .fromARGB(
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
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      66,
                                                                      255,
                                                                      14)),
                                                      child: Text(
                                                        'ใช่',
                                                      ),
                                                      onPressed: () {
                                                        print("del");
                                                        print(data.docs
                                                            .elementAt(index)
                                                            .id);
                                                        try {
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "Basket")
                                                              .doc(data.docs
                                                                  .elementAt(
                                                                      index)
                                                                  .id)
                                                              .delete();
                                                        } catch (e) {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                  'Error $e'),
                                                            ),
                                                          );
                                                        }
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
          );
        }
        return SizedBox(
          height: 0,
        );
      },
    );
  }
}
