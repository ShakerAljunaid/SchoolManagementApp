import 'package:ajialalsafaschool/models/GeneralClasses/shared_prf_data.dart';
import 'package:ajialalsafaschool/models/studentModel.dart';
import 'package:ajialalsafaschool/models/termModel.dart';
import 'package:ajialalsafaschool/views/RoundTimeLine/roundsTimeLine.dart';
import 'package:ajialalsafaschool/views/drawer/drawerview.dart';
import 'package:ajialalsafaschool/views/students/screens/calendar_page.dart';
import 'package:flutter/material.dart';

class NavigationPageScreen extends StatefulWidget {
  final StudentModel studentModel;
  final TermModel termModel;
  NavigationPageScreen(this.studentModel, this.termModel);
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPageScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final Color green = Color(0xFF1E8161);
  String userName = "";
  int userId;

  Future<void> getUserNameFromSharedPrf() async {
    await getSharedPref().then((r) {
      print(r.name);
      setState(() {
        userName = r.name;
        userId = r.id;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getUserNameFromSharedPrf();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        drawer: Drawer(child: showDrawer(context, userName, userId)),
        body: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: Colors.blue,
                      size: 52.0,
                    ),
                    tooltip: '',
                    onPressed: () {
                      _scaffoldKey.currentState.openDrawer();
                    },
                  ),
                  Text(
                    'قائمة العمليات',
                    style: TextStyle(
                        color: Colors.blueAccent, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )
                  // Image.asset(
                  //   "assets/images/how-work3.png",
                  //   width: 52.0,
                  // )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2, right: 10),
              child: Text(
                widget.studentModel.name,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("ID:" + widget.studentModel.code,
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.right),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20.0,
                  children: <Widget>[
                    SizedBox(
                      width: screenWidth(context, dividedBy: 2.7),
                      height: screenWidth(context, dividedBy: 2.8),
                      child: Card(
                        color: Colors.white,
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CalendarPage()),
                            );
                          },
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                Image.asset(
                                  "assets/images/Homework.png",
                                  width: 64.0,
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  "الواجبات اليومية",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                              ],
                            ),
                          )),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenWidth(context, dividedBy: 2.7),
                      height: screenWidth(context, dividedBy: 2.8),
                      child: Card(
                          color: Colors.white,
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          child: InkWell(
                            onTap: () {
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) => RoundsTimeLine(
                              //         widget.studentModel, widget.termModel)));
                            },
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/images/TimeTable.png",
                                    width: 64.0,
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    "جدول الحصص ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0),
                                  ),
                                ],
                              ),
                            )),
                          )),
                    ),
                    SizedBox(
                      width: screenWidth(context, dividedBy: 2.7),
                      height: screenWidth(context, dividedBy: 2.8),
                      child: Card(
                          color: Colors.white,
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => RoundsTimeLine(
                                      widget.studentModel,
                                      widget.termModel,
                                      1)));
                            },
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/images/Grades.png",
                                    width: 64.0,
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    "درجات الأختبارات",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0),
                                  ),
                                ],
                              ),
                            )),
                          )),
                    ),
                    SizedBox(
                      width: screenWidth(context, dividedBy: 2.7),
                      height: screenWidth(context, dividedBy: 2.8),
                      child: Card(
                          color: Colors.white,
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => RoundsTimeLine(
                                      widget.studentModel,
                                      widget.termModel,
                                      2)));
                            },
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/images/ExamTables.png",
                                    width: 64.0,
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    "جداول الاختبارات",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0),
                                  ),
                                ],
                              ),
                            )),
                          )),
                    ),
                    SizedBox(
                      width: screenWidth(context, dividedBy: 2.7),
                      height: screenWidth(context, dividedBy: 2.8),
                      child: Card(
                          color: Colors.white,
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          child: InkWell(
                            onTap: () {
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) => RoundsTimeLine(
                              //         widget.studentModel, widget.termModel)));
                            },
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/images/Reports.png",
                                    width: 64.0,
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    "تقارير الطالب ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0),
                                  ),
                                ],
                              ),
                            )),
                          )),
                    ),
                    SizedBox(
                      width: screenWidth(context, dividedBy: 2.7),
                      height: screenWidth(context, dividedBy: 2.8),
                      child: Card(
                          color: Colors.white,
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          child: InkWell(
                            onTap: () {
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) => MessagingWidget()));
                            },
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/images/Books.png",
                                    width: 64.0,
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    "المناهج الدراسية",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0),
                                  ),
                                ],
                              ),
                            )),
                          )),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            // SizedBox(height: 10),
            // Container(
            //   child: ListTile(
            //       dense: true,
            //       title: Text("SMEPS"),
            //       trailing: Text(
            //         "Version 6.1.1",
            //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            //       ),
            //       leading: Image.asset(
            //         "assets/images/smeps.png",
            //         fit: BoxFit.contain,
            //       )),
            // )
          ],
        )));
  }

  Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  double screenHeight(BuildContext context, {double dividedBy = 1}) {
    return screenSize(context).height / dividedBy;
  }

  double screenWidth(BuildContext context, {double dividedBy = 1}) {
    return screenSize(context).width / dividedBy;
  }
}
