import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

enum Departments { Production, Research, Purchasing, Marketing, Accounting }
enum ConfirmAction { CANCEL, ACCEPT }

class DialogsAlerts {
  DialogsAlerts._();
  static final DialogsAlerts dialogsAlerts = DialogsAlerts._();

  Future<void> waitingAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  CircularProgressIndicator(),
                  Text(".....جاري رفع البيانات")
                ],
              )),
          actions: <Widget>[],
        );
      },
    );
  }

  Future<void> wrongAlert(BuildContext context, String header, String msg) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(header),
          content: Text(msg),
          actions: <Widget>[
            FlatButton(
              child: Text('موافق'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> saveErrorAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('خطأ '),
          content: const Text('الرجاء تحديد الملف'),
          actions: <Widget>[
            FlatButton(
              child: Text('موافق'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> ackAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تم الحفظ '),
          content: const Text('تم الحفظ بنجاح'),
          actions: <Widget>[
            FlatButton(
              child: Text('موافق'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<int> b4TempSaveWarnig(BuildContext context, header, message) async {
    return showDialog<int>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(header),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: const Text('حفظ'),
              onPressed: () {
                Navigator.of(context).pop(1);
              },
            ),
            FlatButton(
              child: const Text('حفظ مؤقت'),
              onPressed: () {
                Navigator.of(context).pop(2);
              },
            ),
            FlatButton(
              child: const Text('عدم الحفظ'),
              onPressed: () {
                Navigator.of(context).pop(3);
              },
            )
          ],
        );
      },
    );
  }

  Future<ConfirmAction> b4SaveWarnig(
      BuildContext context, header, message) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(header),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: const Text('الغاء'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            FlatButton(
              child: const Text('متأكد'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
              },
            )
          ],
        );
      },
    );
  }

  Future<ConfirmAction> syncFiles2ServerWarning(BuildContext context) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تحذير'),
          content: const Text(
              'لرفع الملفات إلى السرفر،يجب توفر انترنت عبر الواي في،ويمكن ان تحتاج عملية الرفع إلى وقت طويل،هل تريد تأكيد العملية؟ '),
          actions: <Widget>[
            FlatButton(
              child: const Text('الغاء'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            FlatButton(
              child: const Text('متأكد'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
              },
            )
          ],
        );
      },
    );
  }

  Future<ConfirmAction> logoutConfirmDialog(BuildContext context) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تأكيد'),
          content: const Text('هل انت متأكد من تسجيل الخروج؟'),
          actions: <Widget>[
            FlatButton(
              child: const Text('الغاء'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            FlatButton(
              child: const Text('متأكد'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
              },
            )
          ],
        );
      },
    );
  }

  Future<ConfirmAction> asyncConfirmDialog(BuildContext context) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تأكيد'),
          content: const Text('سيتم الخروج من دون حفظ البيانات،هل انت متأكد'),
          actions: <Widget>[
            FlatButton(
              child: const Text('الغاء'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            FlatButton(
              child: const Text('متأكد'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
              },
            )
          ],
        );
      },
    );
  }

  Future<ConfirmAction> confirmBringData(BuildContext context) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تأكيد'),
          content: const Text(
              'جلب جميع البيانات ،يحتاج الي وقت لمقارنة البيانات الموجودة مع بيانات السيرفر،هل انت متأكد من وجود انترنت كافي؟'),
          actions: <Widget>[
            FlatButton(
              child: const Text('الغاء'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            FlatButton(
              child: const Text('متأكد'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
              },
            )
          ],
        );
      },
    );
  }

  Future<ConfirmAction> confirmDeleteDialog(BuildContext context) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تأكيد'),
          content: const Text('هل انت متأكد من حذف هذا العنصر؟'),
          actions: <Widget>[
            FlatButton(
              child: const Text('الغاء'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            FlatButton(
              child: const Text('متأكد'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
              },
            )
          ],
        );
      },
    );
  }

  Future<String> asyncInputDialog(BuildContext context) async {
    String teamName = '';
    return showDialog<String>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter current team'),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Team Name', hintText: 'eg. Juventus F.C.'),
                onChanged: (value) {
                  teamName = value;
                },
              ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop(teamName);
              },
            ),
          ],
        );
      },
    );
  }

  Future<Departments> asyncSimpleDialog(BuildContext context) async {
    return await showDialog<Departments>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select Departments '),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Departments.Production);
                },
                child: const Text('Production'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Departments.Research);
                },
                child: const Text('Research'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Departments.Purchasing);
                },
                child: const Text('Purchasing'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Departments.Marketing);
                },
                child: const Text('Marketing'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Departments.Accounting);
                },
                child: const Text('Accounting'),
              )
            ],
          );
        });
  }

  Future<Departments> addFileCat(BuildContext context) async {
    return await showDialog<Departments>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select Departments '),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Departments.Production);
                },
                child: const Text('Production'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Departments.Research);
                },
                child: const Text('Research'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Departments.Purchasing);
                },
                child: const Text('Purchasing'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Departments.Marketing);
                },
                child: const Text('Marketing'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Departments.Accounting);
                },
                child: const Text('Accounting'),
              )
            ],
          );
        });
  }
}
