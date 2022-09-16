import 'package:ajialalsafaschool/models/GeneralClasses/shared_prf_data.dart';
import 'package:ajialalsafaschool/models/messageModel.dart';
import 'package:ajialalsafaschool/services/database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sql.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:uuid/uuid.dart';

class MessagesDatabaseOperations {
  MessagesDatabaseOperations._();
  DatabaseProvider dbPrv = new DatabaseProvider();
  static final MessagesDatabaseOperations msgDb =
      MessagesDatabaseOperations._();

  //Query
  //muestra todos los Beneficiaryes de la base de datos
  Future<List<MessageModel>> getAllMessageModel() async {
    final db = await dbPrv.database;
    var response = await db.query("messages");
    List<MessageModel> list =
        response.map((c) => MessageModel.fromMap(c)).toList();
    return list;
  }

  Future<List<MessageModel>> getUnSyncedMessages() async {
    final db = await dbPrv.database;
    var userData = await getSharedPref();
    var response = await db.rawQuery(
        "select * from messages where senderId=${userData.id} and isSynched!=1;");
    List<MessageModel> list =
        response.map((c) => MessageModel.fromMap(c)).toList();
    return list;
  }

  Future<List<MessageModel>> syncMsgsData(List<MessageModel> msg) async {
    final db = await dbPrv.database;
    var response = await db.query("messages");
    List<MessageModel> list =
        response.map((c) => MessageModel.fromMap(c)).toList();
    for (int i = 0; i < msg.length; i++) {
      var rowState = list.firstWhere((dropdown) => dropdown.guid == msg[i].guid,
          orElse: () => null);
      if (rowState == null)
        addMessageModelToDatabase(msg[i]);
      else {
        msg[i].guid = rowState.guid;
        msg[i].readOrNot = rowState.readOrNot;
        updateMessageModel(msg[i]);
      }
    }
    return list;
  }

  Future<List<MessageModel>> getAllMessageModelGroups(String typeId) async {
    final db = await dbPrv.database;
    var userData = await getSharedPref();
    var response = await db.rawQuery(
        'select senderName,senderId ,max(sendingDate ) sendingDate from messages where senderId!=${userData.id} and typeId in($typeId) group by senderName,senderId   order by id desc');
    List<MessageModel> list =
        response.map((c) => MessageModel.fromMap(c)).toList();
    var q;
    for (var m in list) {
      q = await db.rawQuery(
          "select count(guid) as noOfUnRead  from messages where senderName='${m.senderName}' and readOrNot!=1 and typeId in($typeId) order by id desc");
      m.noOfUnRead = q.first["noOfUnRead"];
      q = await db.rawQuery(
          "select content from messages where id=(select max(ID) from messages where (senderName='${m.senderName}' or receiverId=${m.senderId}) and typeId in($typeId))  ");
      m.lastContent = q.first["content"];
    }
    // var noOf = await db.rawQuery("select * from messages");

    // List<MessageModel> l = noOf.map((c) => MessageModel.fromMap(c)).toList();
    // print(l);
    return list;
  }

  Future<List<MessageModel>> getMessageModelViewWithBnf(
      int senderId, String typeId) async {
    final db = await dbPrv.database;
    //db.rawQuery("delete from  messages");
    var response = await db.rawQuery(
        "select * from messages where  typeId in ($typeId) and (senderId=$senderId or receiverId=$senderId) order by id asc ");
    db.rawQuery(
        "update messages set readOrNot=1 where typeId in ($typeId) and (senderId=$senderId or receiverId=$senderId)");
    List<MessageModel> list =
        response.map((c) => MessageModel.fromMap(c)).toList();
    return list;
  }

  Future<List<MessageModel>> getAllNotificationsOfSender(
      int senderId, String typeId) async {
    final db = await dbPrv.database;
    //db.rawQuery("delete from  messages");
    var response = await db.rawQuery(
        "select * from messages where  typeId in ($typeId) and (senderId=$senderId or receiverId=$senderId) order by id desc ");
    db.rawQuery(
        "update messages set readOrNot=1 where typeId in ($typeId) and (senderId=$senderId or receiverId=$senderId)");
    List<MessageModel> list =
        response.map((c) => MessageModel.fromMap(c)).toList();
    return list;
  }

  Future<int> addMessageModelToDatabase(MessageModel msg) async {
    final db = await dbPrv.database;
    msg.guid = msg.guid ?? Uuid().v4();

    msg.readOrNot = 0;
    msg.isSynched = 1;

    var raw = await db.insert(
      "messages",
      msg.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  //Inserts
  Future<int> addReplyToDatabase(MessageModel msg) async {
    final db = await dbPrv.database;
    msg.guid = msg.guid ?? Uuid().v4();
    var userData = await getSharedPref();
    msg.title = 'reply';
    msg.typeId = 3;
    msg.senderId = userData.id;
    msg.senderName = userData.name;
    msg.schoolId = userData.schoolId;
    msg.readOrNot = 1;
    msg.isSynched = 0;
    msg.sendingDate =
        '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}/${DateTime.now().hour}/${DateTime.now().minute}/${DateTime.now().second}';
    var raw = await db.insert(
      "messages",
      msg.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  //Delete
  //Delete messages with id
  deleteMessageModelWithId(int id) async {
    final db = await dbPrv.database;
    return db.delete("messages", where: "id = ?", whereArgs: [id]);
  }

  //Delete all messages
  deleteAllMessageModel() async {
    final db = await dbPrv.database;
    db.delete("messages");
  }

  //Update
  updateMessageModel(MessageModel msg) async {
    final db = await dbPrv.database;
    var response = await db.update("messages", msg.toMap(),
        where: "guid = ?", whereArgs: [msg.guid]);
    return response;
  }

  updateMessagesSyncState() async {
    final db = await dbPrv.database;
    var response = await db.rawUpdate("update messages set isSynched=1");
    return response;
  }
}
