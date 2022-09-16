import 'package:ajialalsafaschool/models/GeneralClasses/dialogs_alerts.dart';
import 'package:ajialalsafaschool/services/messages/messages_db_operations.dart';
import 'package:flutter/material.dart';

class SendedMessageWidget extends StatefulWidget {
  final int messageId;
  final String content;

  final String time;

  final int isSynced;
  const SendedMessageWidget({
    Key key,
    this.content,
    this.messageId,
    this.time,
    this.isSynced,
  }) : super(key: key);

  @override
  _SendedMessageWidget createState() => _SendedMessageWidget();
}

class _SendedMessageWidget extends State<SendedMessageWidget> {
  @override
  void didUpdateWidget(SendedMessageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  void initState() {
    super.initState();
  }

  var messageColor = Colors.green[100];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(
              right: 20.0, left: 10.0, top: 4.0, bottom: 4.0),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(0),
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15)),
            child: Container(
              color: messageColor,

              // margin: const EdgeInsets.only(left: 10.0),
              child: Stack(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      right: 12.0, left: 23.0, top: 8.0, bottom: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          widget.isSynced == 1
                              ? Icon(Icons.check_box_rounded,
                                  size: 15, color: Colors.green)
                              : Icon(Icons.schedule_rounded,
                                  size: 15, color: Colors.black),
                          Text(
                            " " + widget.content,
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Positioned(
                  bottom: 1,
                  right: 10,
                  child: Text(
                    widget.time,
                    style: TextStyle(
                        fontSize: 10, color: Colors.black.withOpacity(0.6)),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
      onLongPress: () async {
        if (widget.isSynced == 0)
          await DialogsAlerts.dialogsAlerts
              .confirmDeleteDialog(context)
              .then((res) {
            if (res.index == 1) {
              MessagesDatabaseOperations.msgDb
                  .deleteMessageModelWithId(widget.messageId);
              setState(() {
                messageColor = Colors.red;
              });
              // Navigator.pop(context);
            }
          });
        else
          DialogsAlerts.dialogsAlerts
              .wrongAlert(context, "تنبيه", "لايمكن حذف العناصر المزامنة");
      },
    );
  }
}
