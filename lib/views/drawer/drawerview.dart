import 'package:ajialalsafaschool/models/GeneralClasses/dialogs_alerts.dart';
import 'package:ajialalsafaschool/views/login/Screens/Welcome/welcome_screen.dart';
import 'package:ajialalsafaschool/views/messages/messaging_widget.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

void _onLoading(BuildContext context) {
  pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
  pr.update(
    progress: 50.0,
    message: "جاري جلب البيانات ...",
    progressWidget: Container(
        padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()),
    maxProgress: 100.0,
    progressTextStyle: TextStyle(
        color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
    messageTextStyle: TextStyle(
        color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
  );
  pr.show();
}

_detailsDialog(BuildContext cntx, String msgTitle, String msgContent) async {
  return showDialog<void>(
    context: cntx,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(msgTitle),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              new CircularProgressIndicator(),
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

ProgressDialog pr;

Widget showDrawer(BuildContext cntx, String userName, int userId) {
  return Column(
    mainAxisAlignment: MainAxisAlignment
        .spaceBetween, // place the logout at the end of the drawer
    children: <Widget>[
      Flexible(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Row(
                children: <Widget>[
                  FlatButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      Icons.person,
                      size: 40,
                    ),
                    label: Text(userName + "\n\n الرقم:" + userId.toString()),
                  )
                ],
              ),
            ),
            Divider(),
            ListTile(
              dense: true,
              title: Text('إشعارات مهمة', style: TextStyle(color: Colors.grey)),
              leading: Icon(Icons.notification_important),
              onTap: () {
                Navigator.push(
                    cntx,
                    new MaterialPageRoute(
                        builder: (ctxt) => new MessagingWidget()));
              },
            ),
            ListTile(
              dense: true,
              title: Text(
                'معلومات الإستشاري',
                style: TextStyle(color: Colors.grey),
              ),
              leading: Icon(Icons.info),
              onTap: () {
                // Navigator.pushAndRemoveUntil(cntx,  MaterialPageRoute(builder: (context) => TryBnfWithProvider()),  (Route<dynamic> route) => false,);
              },
            ),
            ListTile(
              dense: true,
              title: Text('قائمة المستفيدين'),
              leading: Icon(Icons.list),
              onTap: () {
                // Navigator.pushAndRemoveUntil(
                //   cntx,
                //   MaterialPageRoute(
                //       builder: (context) => BnfListWithProvider()),
                //   (Route<dynamic> route) => false,
                // );
              },
            ),
            ListTile(
              dense: true,
              title: Text(
                'الدروس المستفادة',
              ),
              leading: Icon(Icons.book),
              onTap: () {
                // Navigator.pushAndRemoveUntil(
                //   cntx,
                //   MaterialPageRoute(builder: (context) => LessonLearnedList()),
                //   (Route<dynamic> route) => false,
                // );
              },
            ),
            ListTile(
              dense: true,
              title: Text('تقارير الاستشاري'),
              leading: Icon(Icons.report),
              onTap: () {
                // Navigator.push(
                //     cntx,
                //     new MaterialPageRoute(
                //         builder: (ctxt) => new MonthlyReport()));
              },
            ),
            ListTile(
              dense: true,
              title: Text('الاستبيانات العامة'),
              leading: Icon(Icons.question_answer),
              onTap: () {
                // Navigator.push(cntx,
                //     new MaterialPageRoute(builder: (ctxt) => new SurveyList()));
                //Navigator.push(cntx,new MaterialPageRoute(builder: (ctxt) => new TrackerList(0,0,2)));
              },
            ),
            Divider(),

            // ListTile(

            //   dense: true,
            //    title: Text('الاستبيانات المستتجدة'),
            //   leading: Icon(Icons.list),
            //     onTap: () {Navigator.push(cntx,new MaterialPageRoute(builder: (ctxt) => new GeneralSurveyList ())); },
            // ),
            //  ListTile(

            //   dense: true,
            //    title: Text('قصص النجاح'),
            //   leading: Icon(Icons.list),
            //     onTap: () {Navigator.push(cntx,new MaterialPageRoute(builder: (ctxt) => new SuccessStoryList())); },
            // ),

            //        ListTile(
            //   onTap: () {

            //   },
            //   dense: true,
            //   title: Text("ال"),
            //   leading: new Image.asset(
            //     "assets/images/icon_consulta_margem.png",
            //     width: 20.0,
            //   ),
            // ),
            /* ListTile(
              dense: true,
              title: Text("Informe de Rendimentos"),
              leading: new Image.asset(
                "assets/images/icon_rendimento.png",
                width: 20.0,
              ),
            ), */

            // ListTile(
            //   dense: true,
            //   title: Text("التقرير الشهري"),
            //   leading: Icon(Icons.list),
            //    onTap: () { Navigator.push(cntx, new MaterialPageRoute(builder: (ctxt) => new MonthlyReport())); },
            // ),

            // Divider(),
            ListTile(
                dense: true,
                title: Text('جلب وتحديث السجلات '),
                leading: Icon(Icons.get_app),
                onTap: () async {
                  //   if(await NetworkCheck().checkInternetConnection())
                  // {_onLoading(cntx); SyncData().fetchDataFromSrv().whenComplete((){pr.dismiss(); });}
                  // else
                  //  _detailsDialog(cntx,'خطأ','الرجاء التأكد من الإتصال بالانترنت');
                  // Navigator.push(
                  //     cntx,
                  //     new MaterialPageRoute(
                  //         builder: (ctxt) => new FetechDataCheckList()));
                }),
            ListTile(
              dense: true,
              title: Text('مزامنة البيانات'),
              leading: Icon(Icons.sync),
              onTap: () {
                // Navigator.push(
                //     cntx,
                //     new MaterialPageRoute(
                //         builder: (ctxt) => new SyncDataPresenter()));
              },
            ),

            //   ListTile(

            //   dense: true,
            //   title: Text("جلب جميع البيانات"),
            //   leading: Icon(Icons.list),
            //     onTap: ()
            //     async{
            //           if(await NetworkCheck().checkInternetConnection())
            //         {
            //           DialogsAlerts.dialogsAlerts.confirmBringData(cntx).then((r)
            //           {
            //             if(r.index==1)
            //               _onLoading(cntx);
            //               SyncData().fetchFirstTimeDataFromSrv().then((r) async{
            //                await SyncData().fetchDataFromSrv().whenComplete((){pr.dismiss(); });
            //                });

            //           });

            //           }
            //         else
            //          _detailsDialog(cntx,'خطأ','الرجاء التأكد من الإتصال بالانترنت');
            //          }
            // ),

            Divider(),
            ListTile(
              dense: true,
              title: Text("تعليمات", style: TextStyle(color: Colors.grey)),
              leading: Icon(Icons.perm_device_information),
              onTap: () {
                // Navigator.push(
                //     cntx,
                //     new MaterialPageRoute(
                //         builder: (ctxt) => new BnfListWithProvider()));
              },
            ),
            ListTile(
              dense: true,
              title: Text("تسجيل الخروج"),
              leading: Icon(Icons.lock_open),
              onTap: () async {
                await DialogsAlerts.dialogsAlerts
                    .logoutConfirmDialog(cntx)
                    .then((res) {
                  if (res.index == 1)
                    Navigator.pushAndRemoveUntil(
                      cntx,
                      MaterialPageRoute(builder: (context) => WelcomeScreen()),
                      (Route<dynamic> route) => false,
                    );
                });
              },
            ),
          ],
        ),
      ),
      ListTile(
        dense: true,
        title: Text("SMEPS"),
        trailing: Text(
          "Version 6.1.1",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        leading: Image.asset(
          "assets/images/schoollogo.gif",
          fit: BoxFit.contain,
        ),
      ),
    ],
  );
}
