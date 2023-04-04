import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:mini_project/index.dart';
import 'package:mini_project/index.dart';

class Homepage extends StatefulWidget {
  //const Homepage({Key? key}) : super(key: key);
  @override
  State createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
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
      /// Width of the [ImageSlideshow].
      width: double.infinity,

      /// Height of the [ImageSlideshow].
      height: 210,

      /// The page to show when first creating the [ImageSlideshow].
      initialPage: 0,

      /// The color to paint the indicator.
      indicatorColor: Colors.blue,

      /// The color to paint behind th indicator.
      indicatorBackgroundColor: Colors.grey,

      /// The widgets to display in the [ImageSlideshow].
      /// Add the sample image file into the images folder
      children: [
        Image.asset(
          'assets/images/promotion/1.png',
          fit: BoxFit.fill,
        ),
        Image.asset(
          'assets/images/promotion/2.png',
          fit: BoxFit.fill,
        ),
        Image.asset(
          'assets/images/promotion/3.png',
          fit: BoxFit.fill,
        ),
        Image.asset(
          'assets/images/promotion/4.png',
          fit: BoxFit.fill,
        ),
        Image.asset(
          'assets/images/promotion/5.png',
          fit: BoxFit.fill,
        ),
      ],

      /// Called whenever the page in the center of the viewport changes.
      onPageChanged: (value) {
        //print('Page changed: $value');
      },

      /// Auto scroll interval.
      /// Do not auto scroll with null or 0.
      autoPlayInterval: 3000,

      /// Loops back to first slide.
      isLoop: true,
    );
  }
}
