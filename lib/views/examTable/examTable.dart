import 'package:ajialalsafaschool/models/examTableModel.dart';
import 'package:ajialalsafaschool/models/roundModel.dart';
import 'package:ajialalsafaschool/models/studentModel.dart';
import 'package:ajialalsafaschool/models/termModel.dart';
import 'package:ajialalsafaschool/services/examTable/examTable_db_operations.dart';
import 'package:flutter/material.dart';

class ExamTableView extends StatefulWidget {
  final StudentModel studentModel;
  final TermModel termModel;
  final RoundModel roundModel;
  ExamTableView(this.studentModel, this.termModel, this.roundModel);
  @override
  _ExamTableView createState() => _ExamTableView();
}

class _ExamTableView extends State<ExamTableView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<ExamTableModel> _examTable = new List();
  _getTable() async {
    ExamTableDatabaseOperation.examTableDbOprPrv
        .getActiveYearexamTables(widget.studentModel.schoolId,
            widget.termModel.yearId, widget.termModel.id, widget.roundModel.id)
        .then((examTbls) {
      setState(() {
        _examTable = examTbls;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _examTable = [];
    _getTable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        // drawer: Drawer(child: showDrawer(context, userName, userId)),
        body: SafeArea(
            child: Column(
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
                      'جدول االإختبارات ' +
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
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("ID:" + widget.studentModel.code,
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.right),
              ),
              Center(
                  child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: [
                              DataColumn(
                                label: Text('المادة',
                                    style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.bold)),
                              ),
                              DataColumn(
                                label: Text('التاريخ',
                                    style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.bold)),
                              ),
                              DataColumn(
                                label: Text('المقرر',
                                    style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.bold)),
                              ),
                              // Lets add one more column to show a delete button
                            ],
                            rows: _examTable
                                .map(
                                  (et) => DataRow(cells: [
                                    DataCell(
                                      Text(et.subjectName),
                                      // Add tap in the row and populate the
                                      // textfields with the corresponding values to update
                                      onTap: () {
                                        // _showValues(employee);
                                        // Set the Selected employee to Update
                                        // _selectedEmployee = employee;
                                        // setState(() {
                                        //   _isUpdating = true;
                                        // });
                                      },
                                    ),
                                    DataCell(
                                      Text(
                                        et.dueDate.replaceAll(
                                            new RegExp('00:00:00'), ''),
                                      ),
                                      onTap: () {
                                        // _showValues(employee);
                                        // // Set the Selected employee to Update
                                        // _selectedEmployee = employee;
                                        // // Set flag updating to true to indicate in Update Mode
                                        // setState(() {
                                        //   _isUpdating = true;
                                        // });
                                      },
                                    ),
                                    DataCell(
                                      Text(
                                        '',
                                      ),
                                      onTap: () {
                                        // _showValues(employee);
                                        // // Set the Selected employee to Update
                                        // _selectedEmployee = employee;
                                        // setState(() {
                                        //   _isUpdating = true;
                                        // });
                                      },
                                    ),
                                  ]),
                                )
                                .toList(),
                          ))))
            ])));
  }
}
