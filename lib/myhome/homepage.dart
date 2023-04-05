import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:mini_project/index.dart';
import 'package:mini_project/index.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Homepage extends StatefulWidget {
  //const Homepage({Key? key}) : super(key: key);
  @override
  State createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Map image_url = {
    0: {
      "image_url":
          "https://images.rawpixel.com/image_1000/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIyLTA1L3JtMzA5LWFkai0wMS5qcGc.jpg",
    },
    1: {
      "image_url":
          "https://images.rawpixel.com/image_1000/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIyLTA1L3JtMzA5LWFkai0wMS5qcGc.jpg",
    },
    2: {
      "image_url":
          "https://images.rawpixel.com/image_1000/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIyLTA1L3JtMzA5LWFkai0wMS5qcGc.jpg",
    },
    3: {
      "image_url":
          "https://images.rawpixel.com/image_1000/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIyLTA1L3JtMzA5LWFkai0wMS5qcGc.jpg",
    },
    4: {
      "image_url":
          "https://images.rawpixel.com/image_1000/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIyLTA1L3JtMzA5LWFkai0wMS5qcGc.jpg",
    },
    5: {
      "image_url":
          "https://images.rawpixel.com/image_1000/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIyLTA1L3JtMzA5LWFkai0wMS5qcGc.jpg",
    }
  };
  void initState() {
    getdata();
    super.initState();
  }

  var listimage = [];
  final _auth = FirebaseAuth.instance.currentUser!;
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  dynamic save;
  final _usersStream = FirebaseFirestore.instance
      .collection('Profile')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('Profile');
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: _usersStream,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.data() == null) {}

          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          save = data;

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 254, 194, 162),
              elevation: 0,
              centerTitle: true,
              title: Text(
                'Home Page',
                style: TextStyle(fontSize: 35),
              ),
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(
                      Icons.person,
                      size: 40,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    tooltip:
                        MaterialLocalizations.of(context).openAppDrawerTooltip,
                  );
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.shopping_cart,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, "/Basket");
                  },
                ),
              ],
            ),
            body: Container(
              constraints: BoxConstraints.expand(),
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/Homepage3.png"),
                    fit: BoxFit.cover),
              ),
              child: Column(
                children: [
                  //getjson(context),
                  Image_list(),
                  SizedBox(height: 65),
                  Row(
                    children: [
                      SizedBox(width: 50),
                      Column(
                        children: [
                          IconButton(
                            splashRadius: 100,
                            iconSize: 90,
                            icon: Image.asset('assets/images/burger_icon.png'),
                            onPressed: () {
                              debugPrint('Burger');
                              Navigator.pushNamed(context, '/Burger');
                            },
                          ),
                          Text('Burger', style: TextStyle(fontSize: 30)),
                        ],
                      ),
                      SizedBox(width: 80),
                      Column(
                        children: [
                          IconButton(
                            splashRadius: 100,
                            iconSize: 90,
                            icon: Image.asset('assets/images/snack_icon.png'),
                            onPressed: () {
                              debugPrint('Snack');
                              Navigator.pushNamed(context, '/Snacks');
                            },
                          ),
                          Text('Snack', style: TextStyle(fontSize: 30)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 35),
                  Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 50),
                          Column(
                            children: [
                              IconButton(
                                splashRadius: 100,
                                iconSize: 90,
                                icon:
                                    Image.asset('assets/images/drink_icon.png'),
                                onPressed: () {
                                  debugPrint('Drink');
                                  Navigator.pushNamed(context, '/Drink');
                                },
                              ),
                              Text('Drink', style: TextStyle(fontSize: 30)),
                            ],
                          ),
                          SizedBox(width: 65),
                          Column(
                            children: [
                              IconButton(
                                splashRadius: 100,
                                iconSize: 90,
                                icon: Image.asset(
                                    'assets/images/burgerset_icon.png'),
                                onPressed: () {
                                  debugPrint('Set burger');
                                  Navigator.pushNamed(context, '/Burgerset');
                                },
                              ),
                              SizedBox(
                                height: 0.1,
                              ),
                              Text('Set burger',
                                  style: TextStyle(fontSize: 30)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 60),
                ],
              ),
            ),
            drawer: Drawer(
              child: Drawer(
                backgroundColor: Color.fromARGB(255, 255, 252, 239),
                elevation: 0,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    UserAccountsDrawerHeader(
                      decoration: new BoxDecoration(
                        image: new DecorationImage(
                          image: new AssetImage('assets/images/backDrawer.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),

                      accountName: Text(
                        save['username'.toString()],
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0), fontSize: 25),
                      ),
                      // accountName: Text(save['username'].toString()),
                      accountEmail: Text(
                        _auth.email.toString(),
                        style: TextStyle(
                            color: Color.fromARGB(255, 7, 7, 7), fontSize: 15),
                      ),
                      currentAccountPicture: CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 32, 31, 31),
                        backgroundImage: NetworkImage(
                          save['urlprofile'].toString(),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.account_circle_sharp),
                      title: Text('ข้อมูลของฉัน'),
                      onTap: () {
                        Navigator.pushNamed(context, "/Profile");
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.library_books_sharp),
                      title: Text('คำสั่งซื้อสินค้า'),
                      onTap: () {
                        Navigator.pushNamed(context, "/Order");
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.contact_phone_rounded),
                      title: Text('ติดต่อเรา'),
                      onTap: () {
                        Navigator.pushNamed(context, "/Contact");
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('ออกจากระบบ'),
                      onTap: () {
                        auth.signOut().then((value) {
                          Navigator.popAndPushNamed(context, "/index");
                        });
                        const SnackBar(content: Text("LogOut Pass"));
                        //Navigator.pop(context, "/index");
                        //Navigator.of(context).pushReplacement(
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget Image_list() {
    return ImageSlideshow(
      width: double.infinity,
      initialPage: 0,
      indicatorColor: Colors.blue,
      indicatorBackgroundColor: Colors.grey,
      children: [
        Image.network(
          image_url[0]['image_url'],
          fit: BoxFit.fill,
        ),
        Image.network(
          image_url![1]['image_url'],
          fit: BoxFit.fill,
        ),
        Image.network(
          image_url![2]['image_url'],
          fit: BoxFit.fill,
        ),
        Image.network(
          image_url![3]['image_url'],
          fit: BoxFit.fill,
        ),
        Image.network(
          image_url![4]['image_url'],
          fit: BoxFit.fill,
        ),
      ],
      onPageChanged: (value) {},
      autoPlayInterval: 5000,
      isLoop: true,
    );
  }

  Future getdata() async {
    //https://raw.githubusercontent.com/Kricharith/BurgerAPI/main/pomotion.json
    var url = Uri.https('raw.githubusercontent.com',
        '/Kricharith/BurgerAPI/main/pomotion.json');
    var response = await http.get(url);
    var result = json.decode(response.body);
    setState(() {
      image_url[0] = result[0];
      image_url[1] = result[1];
      image_url[2] = result[2];
      image_url[3] = result[3];
      image_url[4] = result[4];
    });

    print(image_url);
    return result;
  }
}
