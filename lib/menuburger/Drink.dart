import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Drink extends StatefulWidget {
  //const Drink({Key? key}) : super(key: key);

  @override
  State<Drink> createState() => _DrinkState();
}

class _DrinkState extends State<Drink> {
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
              color: Color.fromARGB(255, 29, 151, 251),
            ),
            Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 70,
                  ),
                  Text(
                    "MENU",
                    style: TextStyle(fontSize: 45),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text("Drink", style: TextStyle(fontSize: 40)),
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
          Color.fromARGB(255, 98, 200, 255),
          Color.fromARGB(255, 205, 229, 255),
          Color.fromARGB(255, 123, 170, 220)
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = json.decode(snapshot.data.toString());
                print(data.length);
                return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return MyBox(data[index]['title'], data[index]['subtitle'],
                        data[index]['image_url'], index, data[index]);
                  },
                  itemCount: data.length,
                );
              } else {
                return Container();
              }
            },
            future:
                DefaultAssetBundle.of(context).loadString('assets/drink.json'),
          ),
        ),
      ),
    );
  }

  Widget MyBox(String title, String subtitle, String image_uil, int index,
      dynamic data) {
    return Container(
      /*  margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.only(left: 20, right: 20),
      height: 150,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: NetworkImage(image_uil),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.45), BlendMode.darken),
          )),*/
      child: Column(
        children: [
          Image.asset(
            image_uil,
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
            //mainAxisAlignment: MainAxisAlignment.start,
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
                    onPressed: () {
                      // do something when the button is pressed
                      setState(() {
                        count_item = 1;
                        print(count_item);
                      });
                      print('Clickkkkkkkk $index');
                      print('Clickkkkkkkk ${data}');
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
                                  Image.asset(
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
                                                'drink' +
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
}