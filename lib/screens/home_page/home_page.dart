import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:synthetics/components/carma_chart/carma_resolution_view.dart';
import 'package:synthetics/components/navbar/navbar.dart';
import 'package:synthetics/screens/achievements_page/achievements_page.dart';
import 'package:synthetics/screens/home_page/carma_record_viewer.dart';
import 'package:synthetics/screens/home_page/widget/right_side_drawer.dart';
import 'package:synthetics/screens/login/sign_in_method_enum.dart';
import 'package:synthetics/services/api_client.dart';
import 'package:synthetics/services/current_user.dart';
import 'package:synthetics/services/initialiser/initialiser.dart';
import 'package:synthetics/theme/custom_colours.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';

import '../../routes.dart';
import 'info_page.dart';

// Home page, currently standing in for the user home page
class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final double _iconSize = 30.0;
  CurrentUser user;

  bool _openAchievements = false;

  int carmaPoints = 0;
  String uid;

  @override
  void initState() {
    print("STARTING PAGE");
    setState(() {
      user = CurrentUser.getInstance();
    });
    getUserRecords();
    super.initState();
  }

  void getUserRecords() async {
    String uid = user.getUID();
    final resp = await api_client.get("/getUserRecords/" + uid);

    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      setState(() {
        carmaPoints = body["carmaPoints"];
      });
      user.setUsername(body["firstName"], body["lastName"]);
    } else {
      print("Failed to fetch user records");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stackWidgets = [
      Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: CustomColours.greenNavy(),
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: Icon(
                Icons.emoji_events,
                size: _iconSize,
                color: CustomColours.offWhite(),
              ),
              onPressed: () {
                setState(() {
                  _openAchievements = true;
                });
              }),
          actions: [
            IconButton(
                icon: Icon(Icons.info,
                    size: _iconSize, color: CustomColours.offWhite()),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InformationPage()),
                  );
                }),
            IconButton(
              icon: Icon(Icons.settings,
                  size: _iconSize, color: CustomColours.offWhite()),
              onPressed: () {
                _scaffoldKey.currentState.openEndDrawer();
              },
            )
            // HomeDropdownMenu()
          ],
        ),
        endDrawer: HomeRightDrawer(),
        body: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              flex: 4,
                              child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: CircleAvatar(
                                      backgroundColor:
                                          CustomColours.greenNavy(),
                                      child: user.signInMethod ==
                                              SignInMethod.EmailPassword || user.bgImage == null || user.bgImage == ""
                                          ? Center(
                                              child: Text(user.initials == null ? "" : user.initials,
                                                  style: TextStyle(
                                                      color: Colors.white)))
                                          : Container()))),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "${carmaPoints.toString()} Carma Points",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: CustomColours.greenNavy()),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(flex: 3, child: CarmaRecordViewer()),
              ],
            ),
          ),
        ),
        bottomNavigationBar: NavBar(selected: 0),
      )
    ];

    stackWidgets.addAll([
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: (_openAchievements)
            ? Container(
                color: CustomColours.baseBlack().withOpacity(0.9),
              )
            : Container(),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(child: child, scale: animation);
        },
      ),
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 150),
        child: (_openAchievements)
            ? AchievementsPage(
                onClose: () {
                  setState(() {
                    _openAchievements = false;
                  });
                },
              )
            : Container(),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(child: child, scale: animation);
        },
      )
    ]);

    return Stack(children: stackWidgets);
  }
}
