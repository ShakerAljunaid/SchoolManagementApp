import 'package:ajialalsafaschool/models/roundModel.dart';
import 'package:ajialalsafaschool/models/studentModel.dart';
import 'package:ajialalsafaschool/models/termModel.dart';
import 'package:ajialalsafaschool/services/rounds/rounds_db_operations.dart';
import 'package:ajialalsafaschool/views/examTable/examTable.dart';
import 'package:ajialalsafaschool/views/marks/marks.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeline_tile/timeline_tile.dart';

class RoundsTimeLine extends StatefulWidget {
  final StudentModel studentModel;
  final TermModel termModel;
  final int type;
  RoundsTimeLine(this.studentModel, this.termModel, this.type);
  @override
  _RoundsTimeLine createState() => _RoundsTimeLine();
}

class _RoundsTimeLine extends State<RoundsTimeLine> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        // drawer: Drawer(child: showDrawer(context, userName, userId)),
        body: SafeArea(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Colors.blue,
                    size: 52.0,
                  ),
                  tooltip: '',
                  onPressed: () {
                    _scaffoldKey.currentState.openDrawer();
                  },
                ),
                Text(
                  (widget.type == 1 ? 'درجات الطالب' : 'جدول الاختبارات') +
                      ' - ' +
                      widget.termModel.termTitle,
                  style: TextStyle(
                      color: Colors.blueAccent, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),

                // Image.asset(
                //   "assets/images/how-work3.png",
                //   width: 52.0,
                // )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2, right: 10),
            child: Text(
              widget.studentModel.name,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text("ID:" + widget.studentModel.code,
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.right),
          ),
          Center(
              child: FutureBuilder<List<RoundModel>>(
            //we call the method, which is in the folder db file database.dart

            future: RoundDatabaseOperation.roundDbOprPrv.getActiveYearrounds(
                widget.studentModel.schoolId,
                widget.termModel.yearId,
                widget.termModel.id),

            builder: (BuildContext context,
                AsyncSnapshot<List<RoundModel>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      var roundModel = snapshot.data[index];
                      if (roundModel == snapshot.data.first) {
                        return InkWell(
                            child: TimelineTile(
                              alignment: TimelineAlign.manual,
                              lineXY: 0.1,
                              isFirst: true,
                              indicatorStyle: IndicatorStyle(
                                width: 20,
                                color: roundModel.completeStatus == 2
                                    ? Color(0xFF2B619C)
                                    : roundModel.completeStatus == 0
                                        ? Color(0xFFDADADA)
                                        : Color(0xFF27AA69),
                                padding: EdgeInsets.all(6),
                              ),
                              endChild: RightChild(
                                disabled: roundModel.completeStatus == 0
                                    ? true
                                    : false,
                                asset: widget.type == 1
                                    ? "assets/images/Grades.png"
                                    : "assets/images/ExamTables.png",
                                title: roundModel.roundTitle,
                                message: roundModel.startsOn.replaceAll(
                                        new RegExp('00:00:00'), '') +
                                    ' - ' +
                                    roundModel.endsOn
                                        .replaceAll(new RegExp('00:00:00'), ''),
                              ),
                              beforeLineStyle: const LineStyle(
                                color: Color(0xFF27AA69),
                              ),
                              afterLineStyle: roundModel.completeStatus == 2
                                  ? LineStyle(
                                      color: Color(0xFFDADADA),
                                    )
                                  : null,
                            ),
                            onTap: () {
                              if (roundModel.completeStatus != 0) {
                                if (widget.type == 2)
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ExamTableView(
                                          widget.studentModel,
                                          widget.termModel,
                                          roundModel)));
                                else
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => MarksView(
                                          widget.studentModel,
                                          widget.termModel,
                                          roundModel)));
                              }
                            });
                      } else if (roundModel == snapshot.data.last) {
                        return InkWell(
                          child: TimelineTile(
                            isLast: true,
                            alignment: TimelineAlign.manual,
                            lineXY: 0.1,
                            isFirst: true,
                            indicatorStyle: IndicatorStyle(
                              width: 20,
                              color: roundModel.completeStatus == 2
                                  ? Color(0xFF2B619C)
                                  : roundModel.completeStatus == 0
                                      ? Color(0xFFDADADA)
                                      : Color(0xFF27AA69),
                              padding: EdgeInsets.all(6),
                            ),
                            endChild: RightChild(
                              disabled:
                                  roundModel.completeStatus == 0 ? true : false,
                              asset: widget.type == 1
                                  ? "assets/images/Grades.png"
                                  : "assets/images/ExamTables.png",
                              title: roundModel.roundTitle,
                              message: roundModel.startsOn
                                      .replaceAll(new RegExp('00:00:00'), '') +
                                  ' - ' +
                                  roundModel.endsOn
                                      .replaceAll(new RegExp('00:00:00'), ''),
                            ),
                            beforeLineStyle: const LineStyle(
                              color: Color(0xFF27AA69),
                            ),
                            afterLineStyle: roundModel.completeStatus == 2
                                ? LineStyle(
                                    color: Color(0xFFDADADA),
                                  )
                                : null,
                          ),
                          onTap: () {
                            if (roundModel.completeStatus != 0) {
                              if (widget.type == 2)
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ExamTableView(
                                        widget.studentModel,
                                        widget.termModel,
                                        roundModel)));
                              else
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MarksView(
                                        widget.studentModel,
                                        widget.termModel,
                                        roundModel)));
                            }
                          },
                        );
                      } else {
                        return InkWell(
                          child: TimelineTile(
                            alignment: TimelineAlign.manual,
                            lineXY: 0.1,
                            indicatorStyle: IndicatorStyle(
                              width: 20,
                              color: roundModel.completeStatus == 2
                                  ? Color(0xFF2B619C)
                                  : roundModel.completeStatus == 0
                                      ? Color(0xFFDADADA)
                                      : Color(0xFF27AA69),
                              padding: EdgeInsets.all(6),
                            ),
                            endChild: RightChild(
                              disabled:
                                  roundModel.completeStatus == 0 ? true : false,
                              asset: widget.type == 1
                                  ? "assets/images/Grades.png"
                                  : "assets/images/ExamTables.png",
                              title: roundModel.roundTitle,
                              message: roundModel.startsOn
                                      .replaceAll(new RegExp('00:00:00'), '') +
                                  ' - ' +
                                  roundModel.endsOn
                                      .replaceAll(new RegExp('00:00:00'), ''),
                            ),
                            beforeLineStyle: const LineStyle(
                              color: Color(0xFF27AA69),
                            ),
                            afterLineStyle: roundModel.completeStatus == 2
                                ? LineStyle(
                                    color: Color(0xFFDADADA),
                                  )
                                : null,
                          ),
                          onTap: () {
                            print(widget.type);
                            if (roundModel.completeStatus != 0) {
                              if (widget.type == 2)
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ExamTableView(
                                        widget.studentModel,
                                        widget.termModel,
                                        roundModel)));
                              else
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MarksView(
                                        widget.studentModel,
                                        widget.termModel,
                                        roundModel)));
                            }
                          },
                        );
                      }
                    });
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ))
        ])));
  }
}

class RightChild extends StatefulWidget {
  final String asset;
  final String title;
  final String message;
  final bool disabled;
  RightChild({
    Key key,
    this.asset,
    this.title,
    this.message,
    this.disabled = false,
  }) : super(key: key);

  @override
  _Rightchild createState() => _Rightchild();
}

class _Rightchild extends State<RightChild> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          Opacity(
            child: Image.asset(widget.asset, height: 50),
            opacity: widget.disabled ? 0.5 : 1,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.title,
                style: GoogleFonts.yantramanav(
                  color: widget.disabled
                      ? const Color(0xFFBABABA)
                      : const Color(0xFF636564),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.message,
                style: GoogleFonts.yantramanav(
                  color: widget.disabled
                      ? const Color(0xFFD5D5D5)
                      : const Color(0xFF636564),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF9F9F9),
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE9E9E9),
            width: 3,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'ESTIMATED TIME',
                    style: GoogleFonts.yantramanav(
                      color: const Color(0xFFA2A2A2),
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '30 minutes',
                    style: GoogleFonts.yantramanav(
                      color: const Color(0xFF636564),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'ORDER NUMBER',
                    style: GoogleFonts.yantramanav(
                      color: const Color(0xFFA2A2A2),
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '#2482011',
                    style: GoogleFonts.yantramanav(
                      color: const Color(0xFF636564),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF27AA69),
      leading: const Icon(Icons.menu),
      actions: <Widget>[
        Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              'CANCEL',
              style: GoogleFonts.neuton(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
      title: Text(
        'Track Order',
        style: GoogleFonts.neuton(
            color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
