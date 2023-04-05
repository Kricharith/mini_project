import 'dart:convert';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class Burger extends StatefulWidget {
  const Burger({Key? key}) : super(key: key);

  @override
  State<Burger> createState() => _BurgerState();
}

class _BurgerState extends State<Burger> {
  final store = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance.currentUser!;
  int count_item = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              color: Color.fromARGB(255, 255, 255, 14),
            ),
            Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 35,
                  ),
                  Text(
                    "MENU",
                    style: TextStyle(fontSize: 45),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text("Burger", style: TextStyle(fontSize: 40)),
                ],
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pushNamed(context, "/homepage");
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromARGB(255, 254, 194, 162),
          Color.fromARGB(255, 255, 164, 60),
          Color.fromARGB(255, 255, 191, 143)
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: FutureBuilder(
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    //print(data[index]);
                    return MyBox(
                        snapshot.data[index]['title'],
                        snapshot.data[index]['subtitle'],
                        snapshot.data[index]['image_url'],
                        index,
                        snapshot.data[index]);
                  },
                  itemCount: snapshot.data.length,
                );
              } else {
                return Container();
              }
            },
            future: getdata(),
            // future:
            //     DefaultAssetBundle.of(context).loadString('assets/burger.json'),
          ),
        ),
      ),
    );
  }

  Widget MyBox(String title, String subtitle, String image_url, int index,
      dynamic data) {
    return Container(
      child: Column(
        children: [
          Image.network(
            image_url,
            width: 200,
            height: 200,
            fit: BoxFit.fill,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            title,
            style:
                TextStyle(fontSize: 25, color: Color.fromARGB(255, 13, 0, 0)),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 305,
                child: Row(
                  children: [
                    SizedBox(
                        //width: 130,
                        ),
                    Text(
                      subtitle,
                      style: TextStyle(
                          fontSize: 25, color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    //splashRadius: 100,
                    iconSize: 50,
                    icon: Image.asset('assets/images/basket.png'),
                    color: Color.fromARGB(255, 255, 17, 0),
                    onPressed: () {
                      // do something when the button is pressed
                      setState(() {
                        count_item = 1;
                        print(count_item);
                      });
                      //print('Clickkkkkkkk $index');
                      //print('Clickkkkkkkk ${data}');
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                            return Container(
                              height: 230,
                              child: Column(
                                children: [
                                  Text(
                                    data['title'],
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Image.network(
                                    data['image_url'],
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.fill,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "จำนวน",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            count_item--;
                                          });
                                        },
                                        icon: Icon(Icons.remove_circle_outline),
                                      ),
                                      Text(count_item.toString()),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            count_item++;
                                            print(count_item);
                                          });
                                        },
                                        icon: Icon(Icons.add_circle_outline),
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary:
                                            Color.fromARGB(255, 177, 255, 82)),
                                    child: Text(
                                      'ยืนยัน',
                                    ),
                                    onPressed: () {
                                      data['item'] = count_item;
                                      data['email'] = _auth.email;
                                      try {
                                        FirebaseFirestore.instance
                                            .collection("Basket")
                                            .doc(_auth.uid +
                                                'burger' +
                                                index.toString())
                                            .set(data);
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text('Error $e'),
                                          ),
                                        );
                                      }
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      );
                      setState(() {});
                    },
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Future getdata() async {
    //https://raw.githubusercontent.com/Kricharith/BurgerAPI/main/burger.json
    var url = Uri.https(
        'raw.githubusercontent.com', '/Kricharith/BurgerAPI/main/burger.json');
    var response = await http.get(url);
    var result = json.decode(response.body);
    print(result);
    return result;
  }
}
