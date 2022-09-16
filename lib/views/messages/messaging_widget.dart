import 'package:ajialalsafaschool/models/messageModel.dart';
import 'package:ajialalsafaschool/services/messages/messages_db_operations.dart';
import 'package:flutter/material.dart';
import 'Widget/ChatListViewItem.dart';

class MessagingWidget extends StatefulWidget {
  @override
  _MessagingWidgetState createState() => _MessagingWidgetState();
}

class _MessagingWidgetState extends State<MessagingWidget>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  @override
  void didUpdateWidget(MessagingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  ScrollController _scrollViewController;
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    // Future.delayed(const Duration(seconds: 2), () {
    //   setState(() {
    //     isLoading = false;
    //   });
    // });
    _scrollViewController = new ScrollController();
    _tabController = new TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    try {
      _scrollViewController.dispose();
      _tabController.dispose();
      super.dispose();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _submitDetails(bool state) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(state ? 'نجحت العملية' : 'فشلت العملية'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(state
                      ? 'تم مزامنة بيانات هذه الشاشة بنجاح.'
                      : 'لم تتم المزامنة،الرجاء المحاولة لاحقاً.'),
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("الرسائل والاشعارات"),
        actions: <Widget>[
          // RaisedButton.icon(
          //   onPressed: () {
          //     SyncData()
          //         .syncConsultantMessagesReplies(context)
          //         .then((result) async {
          //           if (result) {
          //             MessagesDatabaseOperations.msgDb
          //                 .updateMessagesSyncState();
          //             setState(() {});
          //           }
          //           result ? _submitDetails(true) : _submitDetails(false);
          //         })
          //         .catchError((err) => print('Query error: $err'))
          //         .whenComplete(() {});
          //   },
          //   icon: Icon(Icons.sync),
          //   color: Colors.white,
          //   label: const Text('مزامنة'),
          // ),
        ],
      ),
      body: new NestedScrollView(
        controller: _scrollViewController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          //<-- headerSliverBuilder
          return <Widget>[
            new SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              expandedHeight: 1.5 * kToolbarHeight,
              //<-- forceElevated to innerBoxIsScrolled
              flexibleSpace: new TabBar(
                tabs: <Tab>[
                  new Tab(
                    text: "الرسائل",
                    icon: new Stack(
                      children: <Widget>[
                        new Icon(Icons.message),
                        new Positioned(
                          top: 1.0,
                          right: 0.0,
                          child: new Stack(
                            children: <Widget>[
                              new Icon(Icons.message,
                                  size: 18.0, color: Colors.green[800]),
                              new Positioned(
                                top: 1.0,
                                right: 4.0,
                                child: new Text("4",
                                    style: new TextStyle(
                                        color: Colors.black,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w500)),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  new Tab(
                    text: "الإشعارات",
                    icon: new Icon(Icons.notification_important,
                        size: 18.0, color: Colors.green[800]),
                  ),
                ],
                controller: _tabController,
              ),
            ),
          ];
        },
        body: new TabBarView(
          children: <Widget>[
            _buildFirstPage(),
            _buildSecondPage()
            //new HistoryPage(),
          ],
          controller: _tabController,
        ),
      ),
    );
  }

  Widget _buildFirstPage() => FutureBuilder<List<MessageModel>>(
        //we call the method, which is in the folder db file database.dart

        future:
            MessagesDatabaseOperations.msgDb.getAllMessageModelGroups('1,3'),
        builder:
            (BuildContext context, AsyncSnapshot<List<MessageModel>> snapshot) {
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
                    hasUnreadMessage: item.noOfUnRead > 0 ? true : false,
                    icon: Icon(Icons.person),
                    lastMessage: item.lastContent,
                    name: item.senderName,
                    newMesssageCount: item.noOfUnRead,
                    time: item.sendingDate.substring(0, 10),
                    senderId: item.senderId,
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      );

  Widget _buildSecondPage() => FutureBuilder<List<MessageModel>>(
        //we call the method, which is in the folder db file database.dart

        future:
            MessagesDatabaseOperations.msgDb.getAllMessageModelGroups('114'),
        builder:
            (BuildContext context, AsyncSnapshot<List<MessageModel>> snapshot) {
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
                    type: 114,
                    title: item.title ?? "Yahia",
                    lastMessage: item.lastContent,
                    hasUnreadMessage: item.noOfUnRead > 0 ? true : false,
                    icon: Icon(Icons.person),
                    name: item.senderName,
                    newMesssageCount: item.noOfUnRead,
                    time: item.sendingDate.substring(0, 10),
                    senderId: item.senderId,
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      );
}
