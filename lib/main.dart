import 'package:flutter/material.dart';
import 'package:mini_project/drawer/EditProfile.dart';
import 'package:mini_project/drawer/Order.dart';
import 'package:mini_project/drawer/Orderlist.dart';
import 'package:mini_project/drawer/map.dart';
import 'package:mini_project/myhome/Address.dart';
import 'package:mini_project/drawer/Contact.dart';
import 'package:mini_project/drawer/Profile.dart';
import 'package:mini_project/index.dart';
import 'package:mini_project/index.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mini_project/login/login.dart';
import 'package:mini_project/login/register.dart';
import 'package:mini_project/menuburger/Burger.dart';
import 'package:mini_project/menuburger/Burgerset.dart';
import 'package:mini_project/menuburger/Drink.dart';
import 'package:mini_project/menuburger/Snacks.dart';
import 'package:mini_project/myhome/Basket.dart';
import 'package:mini_project/myhome/Confirm.dart';
import 'package:mini_project/myhome/homepage.dart';
import 'package:mini_project/povider/model.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Model(),
      child: buildMaterialApp(),
    );
    // MultiProvider(
    //   providers: [
    //     Provider(create: (_) => Model()),
    //     Provider(create: (_) => Model()),
    //   ],
    //   child: buildMaterialApp(),5
    // ); ถ้ามี provider หลายตัว
    buildMaterialApp();
  }

  MaterialApp buildMaterialApp() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      /*theme: ThemeData(
        primarySwatch: Colors.amber,
      ),*/

      initialRoute: '/index',
      routes: {
        '/index': (context) => Index(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/homepage': (context) => Homepage(),
        '/Drink': (context) => Drink(),
        '/Burger': (context) => Burger(),
        '/Burgerset': (context) => Burgerset(),
        '/Snacks': (context) => Snacks(),
        '/Basket': (context) => Basket(),
        '/Address': (context) => Address(),
        '/Contact': (context) => Contact(),
        '/Confirm': (context) => Confirm(),
        '/Order': (context) => Order(),
        '/Profile': (context) => Profile(),
        '/EditProfile': (context) => EditProfile(),
        '/Orderlist': (context) => OrderList(),
        '/map': (context) => MapsPage(),
      },
    );
  }
}
