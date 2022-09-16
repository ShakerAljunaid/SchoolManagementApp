import 'dart:convert';

import 'package:ajialalsafaschool/models/GeneralClasses/NetworkCheck.dart';
import 'package:ajialalsafaschool/models/GeneralClasses/dialogs_alerts.dart';
import 'package:ajialalsafaschool/models/GeneralClasses/userModel.dart';
import 'package:ajialalsafaschool/views/login/Screens/Login/login_screen.dart';
import 'package:ajialalsafaschool/views/login/Screens/Signup/components/background.dart';
import 'package:ajialalsafaschool/views/login/components/already_have_an_account_acheck.dart';
import 'package:ajialalsafaschool/views/login/components/rounded_button.dart';
import 'package:ajialalsafaschool/views/students/screens/students.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'or_divider.dart';

class Body extends StatefulWidget {
  @override
  _Body createState() => _Body();
}

class _Body extends State<Body> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController phoneNoEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController addressEditingController = TextEditingController();
  ProgressDialog pr;
  Future<SharedPreferences> _sPrefs = SharedPreferences.getInstance();
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

  String msg = '';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
    return Background(
      child: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "إنشاء حساب جديد",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: size.height * 0.06),
                Image.asset(
                  "assets/images/schoollogo.gif",
                  fit: BoxFit.contain,
                ),
                Padding(padding: EdgeInsets.only(top: size.height * 0.02)),
                SizedBox(
                  child: new TextFormField(
                    controller: nameEditingController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'الرجاء ملأ هذا الحقل';
                      }
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: "* الأسم الكامل",
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(1.0))),
                  ),
                  width: size.width * 0.7,
                ),
                Padding(padding: EdgeInsets.only(top: size.height * 0.02)),
                SizedBox(
                  child: new TextFormField(
                    controller: phoneNoEditingController,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'الرجاء ملأ هذا الحقل';
                      }
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        labelText: "* رقم الهاتف",
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(1.0))),
                  ),
                  width: size.width * 0.7,
                ),
                Padding(padding: EdgeInsets.only(top: size.height * 0.02)),
                SizedBox(
                  child: new TextFormField(
                    controller: passwordEditingController,
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'الرجاء ملأ هذا الحقل';
                      }
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        labelText: "* كلمة المرور",
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(1.0))),
                  ),
                  width: size.width * 0.7,
                ),
                Padding(padding: EdgeInsets.only(top: size.height * 0.02)),
                SizedBox(
                  child: new TextField(
                    controller: emailEditingController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: "البريد الإلكتروني (إان وجد)",
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(1.0))),
                  ),
                  width: size.width * 0.7,
                ),
                Padding(padding: EdgeInsets.only(top: size.height * 0.02)),
                SizedBox(
                  child: new TextFormField(
                    controller: addressEditingController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'الرجاء ملأ هذا الحقل';
                      }
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.home),
                        labelText: "* العنوان",
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(1.0))),
                  ),
                  width: size.width * 0.7,
                ),
                Padding(padding: EdgeInsets.only(top: size.height * 0.02)),
                RoundedButton(
                  text: "انشاء حساب",
                  press: () => saveData(),
                ),
                SizedBox(height: size.height * 0.03),
                AlreadyHaveAnAccountCheck(
                  login: false,
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return LoginScreen();
                        },
                      ),
                    );
                  },
                ),
                OrDivider(),
              ],
            )),
      ),
    );
  }

  saveData() async {
    if (!_formKey.currentState.validate()) {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('الرجاء تعبئة الحقول الإجبارية')));
    } else {
      if (await NetworkCheck().checkInternetConnection()) {
        User usr = new User(
            name: nameEditingController.text,
            phoneNo: phoneNoEditingController.text,
            password: passwordEditingController.text,
            email: emailEditingController.text ?? '',
            address: addressEditingController.text,
            accountTypeId: 18);
        var data = usr.toMap();
        try {
          pr.show();
          await Requests.post("http://192.168.1.33:51603/Accounts/Create",
                  timeoutSeconds: 120,
                  body: data,
                  bodyEncoding: RequestBodyEncoding.FormURLEncoded)
              .then((c) async {
            if (int.parse(c.content()) == -1) {
              if (pr.isShowing()) pr.hide();
              await DialogsAlerts.dialogsAlerts.wrongAlert(
                  context,
                  'الحساب موجود',
                  'بيانات هذا الحساب موجودة مسبقاً، الرجاء القيام بتسجيل الدخول!');
            } else if (int.parse(c.content()) > 1) {
              await Requests.post("http://192.168.1.33:51603/Accounts/Verify",
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
                        //  Navigator.pushReplacementNamed(context, '/std');
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Students()),
                          (Route<dynamic> route) => false,
                        );
                      }
                    }
                  } else {
                    if (pr.isShowing()) pr.hide();
                    await DialogsAlerts.dialogsAlerts.wrongAlert(context, 'خطأ',
                        'فشل تسجيل الدخول،الرجاء التأكد من البيانات!');

                    setState(() {
                      msg = "Login Fail";
                    });
                  }

                  print(msg);
                } else {
                  if (pr.isShowing()) pr.hide();
                  await DialogsAlerts.dialogsAlerts.wrongAlert(context, 'خطأ',
                      'فشل تسجيل الدخول،الرجاء التأكد من البيانات!');
                }
              });
            }
          });
        } catch (error) {
          if (pr.isShowing()) pr.hide();
          await DialogsAlerts.dialogsAlerts.wrongAlert(
              context, 'خطأ غير معروف', "الرجاء التأكد من البيانات");
        }
      } else {
        if (pr.isShowing()) pr.hide();
        _detailsDialog('خطأ', 'الرجاء التحقق من وجود انترنت!');
      }
    }
  }
}
