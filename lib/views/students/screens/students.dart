import 'dart:convert';

import 'package:ajialalsafaschool/models/GeneralClasses/dialogs_alerts.dart';
import 'package:ajialalsafaschool/models/GeneralClasses/shared_prf_data.dart';
import 'package:ajialalsafaschool/models/GeneralClasses/userModel.dart';
import 'package:ajialalsafaschool/models/messageModel.dart';
import 'package:ajialalsafaschool/models/studentModel.dart';
import 'package:ajialalsafaschool/services/datamanagement/fetchData.dart';
import 'package:ajialalsafaschool/services/messages/messages_db_operations.dart';
import 'package:ajialalsafaschool/services/students/studentMethods.dart';
import 'package:ajialalsafaschool/services/students/students_db_operations.dart';
import 'package:ajialalsafaschool/views/drawer/drawerview.dart';
import 'package:ajialalsafaschool/views/students/theme/colors/light_colors.dart';
import 'package:ajialalsafaschool/views/students/widgets/top_container.dart';
import 'package:ajialalsafaschool/views/terms/termsscreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:percent_indicator/percent_indicator.dart';

class Students extends StatefulWidget {
  @override
  _Students createState() => _Students();
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  print('on background $message');
  String msgTitle, msgContent;
  if (message['data']['title'] == 'msg') {
    var content = message['data']['content'];
    var messages = json.decode(content);
    List<MessageModel> msgs = new List();

    for (var m in messages) {
      var msg = MessageModel.fromMap(m);
      msgs.add(msg);
      msgTitle = (m['type'] == 115 ? 'لديك اشعار من ' : 'لديك رسالة من ') +
          m['senderName'];
      msgContent = m['content'];
    }
    MessagesDatabaseOperations.msgDb.syncMsgsData(msgs).then((value) {
      _Students()._showNotification(msgTitle, msgContent);
    });
  }
}

class _Students extends State<Students> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future _showNotification(String title, String content) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'channel id',
      'channel name',
      'channel desc',
      importance: Importance.max,
      priority: Priority.high,
    );

    var platformChannelSpecifics =
        new NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      content,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

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
    getUserNameFromSharedPrf();
    try {
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('app_icon');

      final InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
      );

      Future selectNotification(String payload) async {
        await flutterLocalNotificationsPlugin.cancelAll();
      }

      flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: selectNotification);

      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
          // final notification = message['notification'];
          myBackgroundMessageHandler(message);
          // print(message);
          // var notificationData = message['data'];

          // if (notificationData['view'] == 'show_notifications_screen') {
          //   SyncData().fetchRegularData();
          //   Navigator.of(context).push(
          //       MaterialPageRoute(builder: (context) => MessagingWidget()));
          // }
        },
        onLaunch: (Map<String, dynamic> message) async {
          // SyncData().fetchRegularData();
          // print("onLaunch: $message");

          print(message);
          // var notificationData = message['data'];

          // if (notificationData['view'] == 'show_notifications_screen') {
          //   SyncData().fetchRegularData();
          //   Navigator.of(context).push(
          //       MaterialPageRoute(builder: (context) => MessagingWidget()));
          // }
          myBackgroundMessageHandler(message);
        },
        onBackgroundMessage: myBackgroundMessageHandler,
        onResume: (Map<String, dynamic> message) async {
          myBackgroundMessageHandler(message);
          // var notificationData = message['data'];

          // if (notificationData['view'] == 'show_notifications_screen') {
          //   SyncData().fetchRegularData();
          //   Navigator.of(context).push(
          //       MaterialPageRoute(builder: (context) => MessagingWidget()));
          // }

          //  print("onResume: $message");
        },
      );
      // _firebaseMessaging.requestNotificationPermissions(
      //     const IosNotificationSettings(sound: true, badge: true, alert: true));
      // });
    } catch (e) {}

    super.initState();
    // this.getUserNameFromSharedPrf().then((value) {
    // _firebaseMessaging.subscribeToTopic('userId$userId');
    // _firebaseMessaging.subscribeToTopic('projectId$projectId');
  }

  Future<String> inputNewStudents({String studentCode}) async {
    String studentCode = '';
    TextEditingController editTextTitle = new TextEditingController();
    studentCode != null ? editTextTitle.text = studentCode : null;
    return showDialog<String>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ادخل كود الطالب'),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                controller: editTextTitle,
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'كود الطالب', hintText: 'كود الطالب.'),
                onChanged: (value) {
                  studentCode = value;
                },
              ))
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('حفظ'),
              onPressed: () async {
                await StudentMethods.studentMtd
                    .addStudent(context, studentCode)
                    .then((student) {
                  _firebaseMessaging
                      .subscribeToTopic('schoolId${student.schoolId}');
                  _firebaseMessaging
                      .subscribeToTopic('gradeId${student.gradeId}');
                  _firebaseMessaging
                      .subscribeToTopic('classId${student.classId}');
                  _firebaseMessaging
                      .subscribeToTopic('branchId${student.branchId}');
                  _firebaseMessaging
                      .subscribeToTopic('termId${student.termId}');
                  _firebaseMessaging.subscribeToTopic('studentId${student.id}');
                  // print(value);
                });
                Navigator.of(context).pop();
                // if (catId != null) {
                //   await DirectoryCategoryOperation.directoryCatDbOprPrv
                //       .updateFileCategory(
                //           new FileCategoryModel(id: catId, title: catName),
                //           title);
                // } else {
                //   await DirectoryCategoryOperation.directoryCatDbOprPrv
                //       .addFileCategoryToDatabase(
                //           new FileCategoryModel(title: catName));
                // }
                // Navigator.of(context).pop(catName);
              },
            ),
          ],
        );
      },
    );
  }

  Text subheading(String title) {
    return Text(
      title,
      style: TextStyle(
          color: LightColors.kDarkBlue,
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2),
    );
  }

  static CircleAvatar addStudentIcon() {
    return CircleAvatar(
      radius: 25.0,
      backgroundColor: LightColors.kGreen,
      child: Icon(
        Icons.person_add,
        size: 20.0,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: LightColors.kLightYellow,
      drawer: Drawer(child: showDrawer(context, userName, userId)),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TopContainer(
              height: 200,
              width: width,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.menu,
                              color: LightColors.kDarkBlue, size: 30.0),
                          tooltip: '',
                          onPressed: () {
                            _scaffoldKey.currentState.openDrawer();
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.download_rounded,
                              color: LightColors.kDarkBlue, size: 30.0),
                          tooltip: '',
                          onPressed: () {
                            StudentDatabaseOperation.studentDbOprPrv
                                .getAllStudents()
                                .then((students) {
                              for (var s in students) {
                                FetchData()
                                    .fetchExamTableData(
                                        context,
                                        s.schoolId,
                                        s.branchId,
                                        s.gradeId,
                                        s.classId,
                                        s.id,
                                        s.yearId,
                                        s.termId)
                                    .then((result) {
                                  DialogsAlerts.dialogsAlerts.wrongAlert(
                                      context,
                                      'حالة العملية',
                                      result ? 'نجحت العملية' : 'فشلت العملية');
                                });
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          CircularPercentIndicator(
                            radius: 90.0,
                            lineWidth: 5.0,
                            animation: true,
                            percent: 0.75,
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: LightColors.kRed,
                            backgroundColor: LightColors.kDarkYellow,
                            center: CircleAvatar(
                              backgroundColor: LightColors.kBlue,
                              radius: 35.0,
                              backgroundImage: AssetImage(
                                'assets/images/avatar.png',
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  userName,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    color: LightColors.kDarkBlue,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  'ولي أمر',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ]),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              subheading('الطلاب'),
                              GestureDetector(
                                onTap: () async {
                                  inputNewStudents().then((val) {
                                    print(val);
                                    setState(() {});
                                  });
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => CalendarPage()),
                                  // );
                                },
                                child: addStudentIcon(),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.0),

                          //we call the method, which is in the folder db file database.dart

                          FutureBuilder<List<StudentModel>>(
                            future: StudentDatabaseOperation.studentDbOprPrv
                                .getAllStudents(),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<StudentModel>> snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var student = snapshot.data[index];
                                    return ListTile(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 10.0),
                                      leading: Container(
                                        padding: EdgeInsets.only(right: 4.0),
                                        decoration: new BoxDecoration(
                                            border: new Border(
                                                right: new BorderSide(
                                                    width: 1.0,
                                                    color: Colors.white24))),
                                        child: CircleAvatar(
                                          radius: 20.0,
                                          backgroundColor: LightColors.kRed,
                                          child: Icon(
                                            Icons.person,
                                            size: 15.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        snapshot.data[index].name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                          snapshot.data[index].gradeName +
                                              ' - ' +
                                              snapshot.data[index].className),
                                      onTap: () async {
                                        var userModel =
                                            User(name: userName, id: userId);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SchoolTermsView(
                                                      student, userModel)),
                                        );
                                      },
                                    );
                                  },
                                );
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          ),

                          // SizedBox(
                          //   height: 15.0,
                          // ),
                          // TaskColumn(
                          //   icon: Icons.blur_circular,
                          //   iconBackgroundColor: LightColors.kDarkYellow,
                          //   title: 'In Progress',
                          //   subtitle: '1 tasks now. 1 started',
                          // ),
                          // SizedBox(height: 15.0),
                          // TaskColumn(
                          //   icon: Icons.check_circle_outline,
                          //   iconBackgroundColor: LightColors.kBlue,
                          //   title: 'Done',
                          //   subtitle: '18 tasks now. 13 started',
                          // ),
                        ],
                      ),
                    ),
                    // Container(
                    //   color: Colors.transparent,
                    //   padding: EdgeInsets.symmetric(
                    //       horizontal: 20.0, vertical: 10.0),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: <Widget>[
                    //       subheading('Active Projects'),
                    //       SizedBox(height: 5.0),
                    //       Row(
                    //         children: <Widget>[
                    //           ActiveProjectsCard(
                    //             cardColor: LightColors.kGreen,
                    //             loadingPercent: 0.25,
                    //             title: 'Medical App',
                    //             subtitle: '9 hours progress',
                    //           ),
                    //           SizedBox(width: 20.0),
                    //           ActiveProjectsCard(
                    //             cardColor: LightColors.kRed,
                    //             loadingPercent: 0.6,
                    //             title: 'Making History Notes',
                    //             subtitle: '20 hours progress',
                    //           ),
                    //         ],
                    //       ),
                    //       Row(
                    //         children: <Widget>[
                    //           ActiveProjectsCard(
                    //             cardColor: LightColors.kDarkYellow,
                    //             loadingPercent: 0.45,
                    //             title: 'Sports App',
                    //             subtitle: '5 hours progress',
                    //           ),
                    //           SizedBox(width: 20.0),
                    //           ActiveProjectsCard(
                    //             cardColor: LightColors.kBlue,
                    //             loadingPercent: 0.9,
                    //             title: 'Online Flutter Course',
                    //             subtitle: '23 hours progress',
                    //           ),
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
