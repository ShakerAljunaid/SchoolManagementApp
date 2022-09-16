import 'package:ajialalsafaschool/models/GeneralClasses/shared_prf_data.dart';
import 'package:ajialalsafaschool/models/GeneralClasses/userModel.dart';
import 'package:ajialalsafaschool/models/studentModel.dart';
import 'package:ajialalsafaschool/models/termModel.dart';
import 'package:ajialalsafaschool/services/terms/terms_db_operations.dart';
import 'package:ajialalsafaschool/views/StudentNavigationScreen/navigationMenu.dart';
import 'package:ajialalsafaschool/views/drawer/drawerview.dart';
import 'package:flutter/material.dart';

class SchoolTermsView extends StatefulWidget {
  final StudentModel studentModel;
  final User user;
  SchoolTermsView(this.studentModel, this.user);
  @override
  _SchoolTermsViewState createState() => _SchoolTermsViewState();
}

class _SchoolTermsViewState extends State<SchoolTermsView> {
  @override
  void didUpdateWidget(SchoolTermsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        drawer: Drawer(
            child: showDrawer(context, widget.user.name, widget.user.id)),
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
                  'الفصول الدراسية',
                  style: TextStyle(
                      color: Colors.blueAccent, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                )
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
          Divider(),
          FutureBuilder<List<TermModel>>(
            //we call the method, which is in the folder db file database.dart

            future: TermDatabaseOperation.termDbOprPrv.getActiveYearterms(
                widget.studentModel.schoolId, widget.studentModel.yearId),

            builder: (BuildContext context,
                AsyncSnapshot<List<TermModel>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    var termModel = snapshot.data[index];
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
                            child:
                                Icon(Icons.local_activity, color: Colors.black),
                          ),
                          title: Text(
                            termModel.termTitle,
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) => NavigationPageScreen(
                                        widget.studentModel, termModel)))
                                .then((value) {
                              setState(() {});
                            });
                          },
                          subtitle: Row(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width / 10,
                                height: MediaQuery.of(context).size.width / 6,
                                child: CircleAvatar(
                                  backgroundColor: Colors.lightBlueAccent,
                                  child: Text(
                                      termModel.noOfRounds
                                          .toString(), //rma.noOToDoid.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                      )),
                                ),
                              ),
                              Expanded(
                                // add this
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8, bottom: 8), // g give some padding
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize:
                                        MainAxisSize.min, // set it to min
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                            child: Padding(
                                                padding:
                                                    EdgeInsets.only(right: 5.0),
                                                child: Text(
                                                    termModel.startsOn
                                                            .replaceAll(
                                                                new RegExp(
                                                                    '00:00:00'),
                                                                '') +
                                                        ' - ' +
                                                        termModel.endsOn
                                                            .replaceAll(
                                                                new RegExp(
                                                                    '00:00:00'),
                                                                ''),
                                                    style: TextStyle(
                                                        color: Colors.black))),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        // tag: 'hero',
                                        child: LinearProgressIndicator(
                                          backgroundColor: Color.fromRGBO(
                                              200, 180, 204, 0.2),
                                          value: termModel.noOfCompletedRounds >
                                                  0
                                              ? termModel.noOfCompletedRounds <
                                                      termModel.noOfRounds
                                                  ? (termModel.noOfRounds -
                                                          (termModel
                                                                  .noOfRounds -
                                                              termModel
                                                                  .noOfCompletedRounds)) /
                                                      termModel.noOfRounds
                                                  : 1
                                              : 0,
                                          // value: rma.noOfAchievedToDos > 0
                                          //     ? rma.noOfAchievedToDos < rma.noOToDoid
                                          //         ? (rma.noOToDoid -
                                          //                 (rma.noOToDoid -
                                          //                     rma.noOfAchievedToDos)) /
                                          //             rma.noOToDoid
                                          //         : 1
                                          //     : 0,
                                          valueColor: AlwaysStoppedAnimation(
                                              Colors.green),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // trailing: IconButton(
                          //   icon: Icon(Icons.lock),
                          //   tooltip: bnfIcons.length.toString(),
                          //   onPressed: () {
                          //     RoundMapActivityWIthBnfDatabaseOperation.rndMp2BnfDbOprPrv
                          //         .updateRoundMapActivityStateWIthBnf(new RoundMapActivityWIthBnf(
                          //       roundMapState: 1,
                          //       roundMapActivityId: rma.id,
                          //       beneficiaryId: widget.beneficiaryNew.beneficiaryId,
                          //     ));
                          //     setState(() {});
                          //   },
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
          )
        ])));
  }
}
