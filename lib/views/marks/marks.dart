import 'package:ajialalsafaschool/models/roundModel.dart';
import 'package:ajialalsafaschool/models/studentMarksModel.dart';
import 'package:ajialalsafaschool/models/studentModel.dart';
import 'package:ajialalsafaschool/models/termModel.dart';
import 'package:ajialalsafaschool/services/studentMarks/studentMarks_db_operations.dart';
import 'package:cupertino_listview/cupertino_listview.dart';
import 'package:flutter/material.dart';

class MarksView extends StatefulWidget {
  final StudentModel studentModel;
  final TermModel termModel;
  final RoundModel roundModel;
  MarksView(this.studentModel, this.termModel, this.roundModel);
  @override
  _MarksView createState() => _MarksView();
}

String screenTitle = "";

class _MarksView extends State<MarksView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<StudentMarksModel> _subjects = new List.empty();
  List<StudentMarksModel> _studentMarks = new List.empty();
  ScrollController _scrollController;
  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;
  @override
  void didUpdateWidget(MarksView oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _getStudentRoundMarks();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<List<StudentMarksModel>> _getStudentRoundMarks() async {
    StudentMarksDatabaseOperation.studentMarksDbOprPrv
        .getSubjectsNames(widget.studentModel.id, widget.studentModel.schoolId,
            widget.termModel.yearId, widget.termModel.id, widget.roundModel.id)
        .then((subjects) {
      setState(() {
        _subjects = subjects;
      });

      StudentMarksDatabaseOperation.studentMarksDbOprPrv
          .getActiveYearstudentMarkss(
              widget.studentModel.id,
              widget.studentModel.schoolId,
              widget.termModel.yearId,
              widget.termModel.id,
              widget.roundModel.id)
          .then((stdMrks) {
        setState(() {
          _studentMarks = stdMrks;
        });
      });
    });
    return _subjects;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        // appBar: AppBar(title: Text('widget.title')),
        // drawer: Drawer(child: showDrawer(context, userName, userId)),
        body: _studentMarks.length > 0
            ? SafeArea(
                child: Stack(
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
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
                                'درجات الطالب  ' +
                                    ' - ' +
                                    widget.roundModel.roundTitle +
                                    ' - ' +
                                    widget.termModel.termTitle,
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              )
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
                      ]),
                  CupertinoListView.builder(
                    padding:
                        EdgeInsets.only(top: (deviceHeight(context) * 0.2)),
                    sectionCount: _studentMarks.length,
                    itemInSectionCount: (section) => _subjects.length,
                    sectionBuilder: _buildSection,
                    childBuilder: _buildItem,
                    separatorBuilder: _buildSeparator,
                    controller: _scrollController,
                  )
                ],
              ))
            : null);
    //     child:
    // : null);
  }

  Widget _buildSeparator(BuildContext context, IndexPath index) {
    return Divider(indent: 20.0, endIndent: 20.0);
  }

  Widget _buildSection(
      BuildContext context, SectionPath index, bool isFloating) {
    final style = Theme.of(context).textTheme.headline6;
    return Container(
      height: 80.0,
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(left: 20.0),
      color: Theme.of(context).primaryColorDark,
      child: Text(_subjects[index.section].subjectName,
          style: style.copyWith(color: Colors.white)),
    );
  }

  Widget _buildItem(BuildContext context, IndexPath index) {
    final attribute = _studentMarks[index.child];
    return Container(
      padding: const EdgeInsets.all(20.0),
      constraints: BoxConstraints(minHeight: 50.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(child: Text(attribute.markTypeName), width: 120.0),
          Expanded(child: Text(attribute.markValue.toString())),
        ],
      ),
    );
  }
}
