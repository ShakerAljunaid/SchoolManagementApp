import 'package:ajialalsafaschool/models/messageModel.dart';
import 'package:ajialalsafaschool/services/messages/messages_db_operations.dart';
import 'package:ajialalsafaschool/views/Messages/Widget/ChatListViewItem.dart';
import 'package:flutter/material.dart';
import 'package:ajialalsafaschool/Views/Messages//Global/Colors.dart'
    as MyColors;

import 'package:ajialalsafaschool/Views/Messages//Global/Settings.dart'
    as Settings;

class ChatListPageView extends StatefulWidget {
  @override
  _ChatListPageViewState createState() => _ChatListPageViewState();
}

class _ChatListPageViewState extends State<ChatListPageView> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Settings.isDarkMode ? Colors.grey[900] : MyColors.blue,
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          centerTitle: true,
          title: Text(
            'الرسائل',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          leading: IconButton(
            icon: Icon(
                Settings.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: () {
              Settings.changeTheme();
            },
          ),
        ),
        body: FutureBuilder<List<MessageModel>>(
          //we call the method, which is in the folder db file database.dart

          future:
              MessagesDatabaseOperations.msgDb.getAllMessageModelGroups('1,3'),
          builder: (BuildContext context,
              AsyncSnapshot<List<MessageModel>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                //Count all records
                itemCount: snapshot.data.length,
                //all the records that are in the client table are passed to an item Client item = snapshot.data [index];
                itemBuilder: (BuildContext context, int index) {
                  MessageModel item = snapshot.data[index];
                  //delete one register for id
                  return Dismissible(
                    key: UniqueKey(),
                    background: Container(color: Colors.red),

                    //Now we paint the list with all the records, which will have a number, name, phone
                    child: ChatListViewItem(
                      hasUnreadMessage: true,
                      icon: Icon(Icons.person),
                      lastMessage: item.senderName,
                      name: item.senderName,
                      newMesssageCount: item.noOfUnRead,
                      //time: "19:27 PM",
                    ),
                  );
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
