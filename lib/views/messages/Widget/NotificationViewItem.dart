import 'package:ajialalsafaschool/models/messageModel.dart';
import 'package:ajialalsafaschool/services/messages/messages_db_operations.dart';
import 'package:flutter/material.dart';

class NotificationViewItem extends StatelessWidget {
  final int senderId;
  final String senderName;

  const NotificationViewItem(
    this.senderId,
    this.senderName, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(this.senderName),
        ),
        body: FutureBuilder<List<MessageModel>>(
          //we call the method, which is in the folder db file database.dart

          future: MessagesDatabaseOperations.msgDb
              .getAllNotificationsOfSender(senderId, '114'),
          builder: (BuildContext context,
              AsyncSnapshot<List<MessageModel>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  var item = snapshot.data[index];
                  return Card(
                    elevation: 6.0,
                    margin: new EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 6.0),
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white24),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 10.0),
                        leading: Container(
                          padding: EdgeInsets.only(right: 4.0),
                          decoration: new BoxDecoration(
                              border: new Border(
                                  right: new BorderSide(
                                      width: 1.0, color: Colors.white24))),
                          child: Icon(Icons.notifications, color: Colors.black),
                        ),
                        title: Column(
                          children: [
                            Text(
                              // Read the name field value and set it in the Text widget
                              item.title,
                              // set some style to text
                              style: new TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.lightBlueAccent),
                            ),
                            Divider(),
                            Text(
                              // Read the name field value and set it in the Text widget
                              item.content,
                              // set some style to text
                            ),
                            Divider(),
                          ],
                        ),

                        subtitle: new Text(
                          // Read the name field value and set it in the Text widget
                          item.sendingDate.substring(0, 10),
                          // set some style to text
                          style: new TextStyle(color: Colors.amber),
                        ),

                        //   trailing:

                        //   IconButton(
                        //   icon: Icon(Icons.add_circle, color: Colors.black),
                        //  onPressed: () {
                        //     Navigator.of(context).push(
                        //    MaterialPageRoute(builder: (context) =>AddEditCheckListItem(trackerModel.id,widget.beneficiaryId,widget.activityId)));

                        //              setState(() {

                        //                }); },
                        // ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
