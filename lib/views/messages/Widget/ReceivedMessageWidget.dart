import 'package:flutter/material.dart';
import 'package:ajialalsafaschool/Views/Messages//Global/Colors.dart'
    as MyColors;
import 'package:ajialalsafaschool/Views/Messages//Global/Settings.dart'
    as Settings;

class ReceivedMessageWidget extends StatelessWidget {
  final String content;

  final String time;

  const ReceivedMessageWidget({
    Key key,
    this.content,
    this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
      padding:
          const EdgeInsets.only(right: 20.0, left: 10.0, top: 4.0, bottom: 4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(0),
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15)),
        child: Container(
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(
                      right: 12.0, left: 23.0, top: 8.0, bottom: 15.0),
                  child: Column(
                    children: [
                      Text(
                        content,
                      ),
                    ],
                  )),
              Positioned(
                bottom: 1,
                right: 10,
                child: Text(
                  time.substring(0, 10),
                  style: TextStyle(
                      fontSize: 10, color: Colors.black.withOpacity(0.6)),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
