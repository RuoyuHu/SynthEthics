import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:synthetics/components/carma_chart/carma_resolution_view.dart';
import 'package:synthetics/components/navbar/navbar.dart';
import 'package:synthetics/screens/achievements_page/achievements_page.dart';
import 'package:synthetics/services/current_user.dart';
import 'package:synthetics/theme/custom_colours.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';

import '../../routes.dart';

// Home page, currently standing in for the user home page
class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final double _iconSize = 30.0;
  bool _openAchievements = false;
  String uid;

  @override
  void initState() {
    // not sure if this widget will be rebuilt if uid changes
    uid = CurrentUser.getInstance().getUID();
    print("uid in home page: $uid");
    super.initState();
  }

  void _gotoEmptyPage() {
    Navigator.pushNamed(context, routeMapping[Screens.Empty]);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stackWidgets = [
      Scaffold(
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
              }
          ),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.exit_to_app,
                  size: _iconSize,
                  color: CustomColours.offWhite(),
                ),
                onPressed: () {
                  FirebaseAuth auth = FirebaseAuth.instance;
                  auth.signOut().then((res) => {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:routes[routeMapping[Screens.Login]]), (route) => false)
                  });
                }
            )
          ],
        ),
        body: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Stack(
                      children: [
                        Center(
                          child: Container(
                            color: CustomColours.offWhite(),
                            width: 400,
                            height: 180,
                            child: Container(
                              margin: EdgeInsets.only(bottom: 20, top: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                        decoration: new BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: new DecorationImage(
                                              fit: BoxFit.contain,
                                              image : NetworkImage("https://cdn.icon"
                                                  "scout.com/icon/free/png-512/avata"
                                                  "r-369-456321.png"),
                                            )
                                        )),
                                  ),
                                  Text(
                                    "Mrs Chanandler Bong",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: CustomColours.greenNavy()
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ]
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: DefaultTabController(
                      length: 3,
                      child: SizedBox(
                        height: 300,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                color: CustomColours.greenNavy(),
                                child: TabBar(
                                  labelColor: CustomColours.greenNavy(),
                                  unselectedLabelColor: CustomColours.offWhite(),
                                  indicator: UnderlineTabIndicator(
                                      borderSide: BorderSide(
                                          color: CustomColours.offWhite()
                                      )
                                  ),
                                  tabs: [
                                    CarmaResolutionTab(label : "WEEK"),
                                    CarmaResolutionTab(label : "MONTH"),
                                    CarmaResolutionTab(label : "YEAR"),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: TabBarView(
                                children: [
                                  CarmaResolutionView(resolution : CarmaViewResolution.WEEK),
                                  CarmaResolutionView(resolution : CarmaViewResolution.MONTH),
                                  CarmaResolutionView(resolution : CarmaViewResolution.YEAR),
                                ],
                              ),
                            )
                          ],
                        ),
                      )),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: NavBar(selected: 0),
      )
    ];

    if (_openAchievements) {
      stackWidgets.addAll([
        Container(
          color: CustomColours.baseBlack().withOpacity(0.9),
        ),
        AchievementsPage(onClose: () {
            setState(() {
              _openAchievements = false;
            });
          },
        )
      ]);
    }

    return Stack(
      children: stackWidgets
    );
  }
}

class CarmaResolutionTab extends StatefulWidget {
  final String label;

  const CarmaResolutionTab({Key key, this.label}) : super(key: key);

  @override
  _CarmaResolutionTabState createState() => _CarmaResolutionTabState();
}

class _CarmaResolutionTabState extends State<CarmaResolutionTab> {
  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        widget.label,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: CustomColours.offWhite()),
      ),
    );
  }
}
