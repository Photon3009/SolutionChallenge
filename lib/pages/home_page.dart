import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:heatlth1/pages/chat_screen.dart';
import 'package:heatlth1/pages/chatbot_page.dart';
import 'package:heatlth1/pages/webview_page.dart';
import 'package:heatlth1/theme/style.dart';
import 'package:provider/provider.dart';

import 'emergency_page.dart';
import 'locate_test_page.dart';
import 'my_home_page.dart';
import 'schemes_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int CurrentIndex = 0;
  List<String> _popupMenuList = [
    "Sign Out",
  ];

  void onTapChange(int index) {
    setState(() {
      CurrentIndex = index;
    });
  }

  static final List<Widget> _widgetOptions = <Widget>[
    MyHomePage(),
    EmergencyPage(),
    LocateTestPage(),
    ChatScreen(),
    WebViewApp(),
    // SchemesPage(),
  ];
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [Scaffold(
          appBar: AppBar(
            // title:
            // Center(child:Column(
            //   children: [
            //     SizedBox(height: 8,),
            //     Row(
            //       children: [
            //         SizedBox(width:w/4 ,),
            //         Image.asset('assets/mate4-removebg-preview.png', height:80,fit: BoxFit.cover),
            //       ],
            //     ),
            //   ],
            // ),),
            // const Center(child: Text('Heal+TheMate',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),)),
            backgroundColor: apnaColor,
            elevation: 0.0,
            actions: [
              PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                  itemBuilder: (_) => _popupMenuList.map((menuItem) {
                        return PopupMenuItem(
                          child: Text("$menuItem"),
                          onTap: () async {
                            FirebaseAuth.instance.signOut();
                          },
                        );
                      }).toList())
            ],
          ),
          extendBody: true,
          backgroundColor: apnaColor,
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
                color: Palette.kToDark, borderRadius: BorderRadius.circular(30)),
            margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: GNav(
                  onTabChange: onTapChange,
                  backgroundColor: Palette.kToDark,
                  color: Colors.white,
                  activeColor: const Color.fromARGB(255, 88, 172, 190),
                  tabBackgroundColor: Colors.white,
                  padding: const EdgeInsets.all(5),
                  tabs: const [
                    GButton(icon: Icons.home, text: 'Home'),
                    GButton(
                      icon: Icons.emergency,
                      text: 'Emergency',
                      iconSize: 25,
                    ),
                    GButton(
                      icon: Icons.location_on,
                      text: 'Locate test',
                    ),
                    GButton(
                      icon: Icons.chat_sharp,
                      text: 'ChatBot',
                    ),
                    GButton(
                      icon: Icons.account_circle,
                      text: 'Govt Schemes',
                    ),
                  ]),
            ),
          ),
          body: Center(
            child: _widgetOptions.elementAt(CurrentIndex),
          ),
        ),
        Positioned(
        top: 30,
        right: w/3.2,
        child: Image.asset('assets/mate4-removebg-preview.png',
            height: 80),
      ),]
      ),
    );
  }
}
