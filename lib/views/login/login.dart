import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:ajialalsafaschool/models/GeneralClasses/NetworkCheck.dart';
import 'package:ajialalsafaschool/models/GeneralClasses/dialogs_alerts.dart';
import 'package:ajialalsafaschool/models/GeneralClasses/userModel.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:requests/requests.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uuid/uuid.dart';

class LoginScreen extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, widget) => ResponsiveWrapper.builder(
        BouncingScrollWrapper.builder(context, widget),
        maxWidth: 1200,
        minWidth: 450,
        defaultScale: true,
        breakpoints: [
          ResponsiveBreakpoint.resize(450, name: MOBILE),
          ResponsiveBreakpoint.autoScale(800, name: TABLET),
          ResponsiveBreakpoint.autoScale(1000, name: TABLET),
          ResponsiveBreakpoint.resize(1200, name: DESKTOP),
          ResponsiveBreakpoint.autoScale(2460, name: "4K"),
        ],
      ),
      title: 'Ajial Alsafa',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [Locale('ar', 'AE')],
      locale: Locale('ar', 'AE'),
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: _MyLoginScreen(title: 'Ajial Alsafa School'),
      // routes: {
      //   '/benf': (context) => NavigationPageScreen(),
      // },
    );
  }
}

class _MyLoginScreen extends StatefulWidget {
  final String title;
  _MyLoginScreen({Key key, this.title}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return new LoginScreenItems();
  }
}

class LoginScreenItems extends State<_MyLoginScreen> {
  ProgressDialog pr;

  _detailsDialog(String msgTitle, String msgContent) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(msgTitle),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(msgContent),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('تم'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  TextEditingController txtuserName = new TextEditingController();
  TextEditingController txtuserPwd = new TextEditingController();

  Future<SharedPreferences> _sPrefs = SharedPreferences.getInstance();
  String msg = '';

  Future<void> _login() async {
    User usr = new User(phoneNo: txtuserName.text, password: txtuserPwd.text);

    var data = usr.toMap();
    try {
      pr.show();
      await Requests.post("http://192.168.1.35:51603/Accounts/Verify",
              timeoutSeconds: 120,
              body: data,
              bodyEncoding: RequestBodyEncoding.FormURLEncoded)
          .then((v) async {
        if (v.json() != null) {
          var datauser = v.json();
          var strReturnedData = v.content();

          if (datauser["id"] > 0) {
            var uuid = Uuid();
            String userGuid = uuid.v4();
            strReturnedData = strReturnedData.replaceAll(
                '}', ',"userGuid":"' + userGuid + '"}');

            final SharedPreferences prefs = await _sPrefs;
            prefs.setString('UseCredentials', strReturnedData);
            msg = "Login Success";
            SnackBar(content: Text("تم تسجيل الدخول بنجاح!"));
            Center(child: CircularProgressIndicator());
            if (prefs.get("UseCredentials") != null) {
              Map<String, dynamic> userStr =
                  jsonDecode(prefs.get("UseCredentials"));
              if (userStr["id"] > 0) {
                print('Stored Name is :' + prefs.get("UseCredentials"));
              }
            }
          } else {
            if (pr.isShowing()) pr.hide();
            await DialogsAlerts.dialogsAlerts.wrongAlert(
                context, 'خطأ', 'فشل تسجيل الدخول،الرجاء التأكد من البيانات!');

            setState(() {
              msg = "Login Fail";
            });
          }

          print(msg);
        } else {
          if (pr.isShowing()) pr.hide();
          await DialogsAlerts.dialogsAlerts.wrongAlert(
              context, 'خطأ', 'فشل تسجيل الدخول،الرجاء التأكد من البيانات!');
        }
      });
    } catch (error) {
      if (pr.isShowing()) pr.hide();
      await DialogsAlerts.dialogsAlerts
          .wrongAlert(context, 'خطأ غير معروف', "الرجاء التأكد من البيانات");
    }
  }

  Future<Null> checkLogin() async {
    final SharedPreferences prefs = await _sPrefs;
    _login();
  }

  Future<Null> clearItems() async {
    final SharedPreferences prefs = await _sPrefs;
    prefs.clear();
  }

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.update(
      progress: 50.0,
      message: "...جاري فحص البيانات",
      progressWidget: Container(
          padding: EdgeInsets.all(9.0), child: CircularProgressIndicator()),
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
    // TODO: implement build
    return Scaffold(
        body: SingleChildScrollView(
            child: new Center(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(36.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 40)),
              SizedBox(
                height: 155.0,
                child: Image.asset(
                  "assets/smeps.png",
                  fit: BoxFit.contain,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 40)),
              SizedBox(
                child: new TextField(
                  controller: txtuserName,
                  style: style,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      labelText: "البريد الإلكتروني",
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1.0))),
                ),
                width: 300,
              ),
              Padding(padding: EdgeInsets.only(top: 40)),
              SizedBox(
                child: new TextField(
                  controller: txtuserPwd,
                  obscureText: true,
                  style: style,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: "كلمة المرور",
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1.0))),
                ),
                width: 300,
              ),
              Padding(padding: EdgeInsets.only(top: 40)),
              new RaisedButton(
                elevation: 5.0,
                padding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 5.0),
                color: Colors.green,
                onPressed: () async {
                  if (await NetworkCheck().checkInternetConnection()) {
                    clearItems();

                    await checkLogin();
                  } else {
                    if (pr.isShowing()) pr.hide();

                    _detailsDialog('خطأ', 'الرجاء التحقق من وجود انترنت!');
                  }
                },
                child: Text("تسجيل الدخول ",
                    textAlign: TextAlign.center,
                    style: style.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                shape:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(1)),
              ),
              new Text(
                "",
              )
            ],
          ),
        ),
      ),
    )));
  }
}
