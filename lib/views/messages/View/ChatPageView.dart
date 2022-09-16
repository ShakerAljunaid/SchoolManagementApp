import 'package:ajialalsafaschool/models/messageModel.dart';
import 'package:ajialalsafaschool/services/messages/messages_db_operations.dart';
import 'package:flutter/material.dart';
import 'package:ajialalsafaschool/Views/Messages/Global/Colors.dart'
    as MyColors;
import 'package:ajialalsafaschool/Views/Messages/Global/Settings.dart'
    as Settings;
import 'package:ajialalsafaschool/Views/Messages/Widget/ReceivedMessageWidget.dart';
import 'package:ajialalsafaschool/Views/Messages/Widget/SendedMessageWidget.dart';

class ChatPageView extends StatefulWidget {
  final String username;
  final int senderId;

  const ChatPageView(
    this.senderId, {
    Key key,
    this.username,
  }) : super(key: key);

  @override
  _ChatPageViewState createState() => _ChatPageViewState();
}

class _ChatPageViewState extends State<ChatPageView> {
  TextEditingController _text = new TextEditingController();
  ScrollController _scrollController = ScrollController();
  var childList = <Widget>[];
  messagesOfSender() async {
    var _childList = <Widget>[];
    await MessagesDatabaseOperations.msgDb
        .getMessageModelViewWithBnf(widget.senderId, '1,3')
        .then((messages) {
      for (var m in messages) {
        print(m.sendingDate);
        if (m.typeId == 1) {
          _childList.add(Align(
            alignment: Alignment(-0.9, 0),
            child: ReceivedMessageWidget(
              content: m.content,
              time: m.sendingDate,
            ),
          ));
        } else if (m.typeId == 3) {
          _childList.add(Align(
            alignment: Alignment(1, 0),
            child: SendedMessageWidget(
              messageId: m.id,
              content: m.content,
              time: m.sendingDate,
              isSynced: m.isSynched,
            ),
          ));
        }
      }
      setState(() {
        childList = _childList;
      });
    });
  }

  @override
  void didUpdateWidget(ChatPageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    this.messagesOfSender();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            fit: StackFit.loose,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.start,
                // mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(
                    height: 65,
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                widget.username ?? "Jimi Cooke",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15),
                              ),
                            ],
                          ),
                          Spacer(),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                            child: Container(
                              child: ClipRRect(
                                child: Container(
                                  child: SizedBox(
                                    child: Icon(Icons.person),
                                  ),
                                ),
                                borderRadius: new BorderRadius.circular(50),
                              ),
                              height: 55,
                              width: 55,
                              padding: const EdgeInsets.all(0.0),
                              decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 5.0,
                                        spreadRadius: -1,
                                        offset: Offset(0.0, 5.0))
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 0,
                    color: Colors.black54,
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Container(
                      color: Colors.grey[300],
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                          controller: _scrollController,

                          // reverse: true,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: childList,
                          )),
                    ),
                  ),
                  Divider(height: 0, color: Colors.black26),
                  Container(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextField(
                        maxLines: 20,
                        controller: _text,
                        decoration: InputDecoration(
                          suffixIcon: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: Icon(Icons.send),
                                onPressed: () async {
                                  MessagesDatabaseOperations.msgDb
                                      .addReplyToDatabase(MessageModel(
                                          content: _text.text,
                                          receiverId: widget.senderId))
                                      .then((value) {
                                    setState(() {
                                      childList.add(Align(
                                        alignment: Alignment(1, 0),
                                        child: SendedMessageWidget(
                                          content: _text.text,
                                          time:
                                              '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}/${DateTime.now().hour}/${DateTime.now().minute}/${DateTime.now().second}',
                                          isSynced: 0,
                                        ),
                                      ));
                                      _text.text = '';
                                    });
                                  });
                                },
                              ),
                            ],
                          ),
                          border: InputBorder.none,
                          hintText: "اكتب رسالة لـ${widget.username}",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
