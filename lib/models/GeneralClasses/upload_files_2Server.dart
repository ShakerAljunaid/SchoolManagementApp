// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:http/http.dart' as http;
// import 'package:mime/mime.dart';

// import 'package:synchronized/synchronized.dart' as sync;
// import 'package:projecttracker/model/successStories/success_story_model.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:path/path.dart' as path;

// Future<String> uploadVideoNew(String fpath) async {
//   String mimeStr = lookupMimeType(fpath);
//   var fileType = mimeStr.split('/');
//   if (fileType.contains('image')) {
//     File compressed = await testCompressAndGetFile(fpath);
//     fpath = compressed.path;
//   }

//   var uri = Uri.parse('https://mis.smeps.org.ye:90//SyncAppData/uploadFileNew');
//   var request = new http.MultipartRequest("POST", uri);
//   String srvPath = '';
//   var multipartFile = await http.MultipartFile.fromPath("file", fpath);
//   request.files.add(multipartFile);

//   try {
//     await request.send().then((r) async {
//       await http.Response.fromStream(r).then((onValue) {
//         srvPath = onValue.body;
//       });
//     });

//     return srvPath;
//   } catch (e) {
//     print("Exception Caught: $e");
//   }
// }

// Future<File> testCompressAndGetFile(String targetPath) async {
//   File file = File(targetPath);
//   var result = await FlutterImageCompress.compressAndGetFile(
//     file.absolute.path,
//     '/storage/emulated/0/DCIM/Camera/Compressed/' + path.basename(file.path),
//     quality: 60,
//     rotate: 180,
//   );

//   print(file.lengthSync());
//   print(result.lengthSync());

//   return result;
// }

// Future uploadViaDio(String filePath) async {
//   var postUri =
//       Uri.parse('https://mis.smeps.org.ye:90//SyncAppData/uploadFileNew');
//   var request = new http.MultipartRequest("POST", postUri);
//   request.files.add(await http.MultipartFile.fromPath("file", filePath));

//   request.send().then((response) {
//     if (response.statusCode == 200) print("Uploaded!");
//   });

// //   var uri = Uri.parse('http://192.168.1.236:51971/Home/uploadFileNew');
// //     var request = new http.MultipartRequest("POST", uri);
// //   var multipartFile = await http.MultipartFile.fromPath("file", filePath);
// //     request.files.add(multipartFile);
// //  var response = await request.send();
// //     response.stream.transform(utf8.decoder).listen((value) {
// //       print(value);
// //     });
// //     if(response.statusCode==200){
// //       print("Video uploaded");
// //     }else{
// //       print("Video upload failed");
// //     }
//   /*String srvPath='';

//  try {
//    final postUri = Uri.parse("http://192.168.1.236:51971/Home/uploadFileNew");
// http.MultipartRequest request = http.MultipartRequest('POST', postUri);

// http.MultipartFile multipartFile =
// await http.MultipartFile.fromPath('file', filePath); //returns a Future<MultipartFile>

// request.files.add(multipartFile);

//       await request.send().then((r) async{
//           await http.Response.fromStream(r).then((onValue){
//                    srvPath=onValue.body;
//              });
//        });

//         return srvPath;
//   }catch (e) {
//       print("Exception Caught: $e");
//     }
//  */

//   // try {

//   //   FormData formData =
//   //       new FormData.from({"file": new UploadFileInfo(File(filePath) , filePath)});

//   //   Response response =
//   //       await Dio().post('http://192.168.1.236:51971/Home/uploadFileNew', data: formData);
//   //   print("File upload response: $response");

//   //   // Show the incoming message in snakbar
//   //   print(response.data['message']);
//   // } catch (e) {
//   //   print("Exception Caught: $e");
//   // }
// }
// // Future<String> uploadVideoNew(String fpath) async {

// //  var uri = Uri.parse('http://192.168.1.236:51971/Home/uploadFileNew');
// //     var request = new http.MultipartRequest("POST", uri);
// //     String srvPath='';
// //   var multipartFile = await http.MultipartFile.fromPath("file", fpath);
// //     request.files.add(multipartFile);
// //     try {

// //       await request.send().then((r) async{
// //           await http.Response.fromStream(r).then((onValue){
// //                    srvPath=onValue.body;
// //              });
// //        });

// //         return srvPath;
// //   }catch (e) {
// //       print("Exception Caught: $e");
// //     }

// // }

// Future<String> async1(String path1) async {
//   String imgSrvPath = '';
//   if (path1 != '')
//     await Future<String>.delayed(const Duration(seconds: 1), () async {
//       await uploadViaDio(path1).then((v) {
//         imgSrvPath = v;
//       });
//     });

//   return imgSrvPath;
// }

// Future<String> async2(String path2) async {
//   String vidSrvPath = '';
//   if (path2 != '')
//     await Future<String>.delayed(const Duration(seconds: 2), () async {
//       uploadViaDio(path2).then((v) {
//         vidSrvPath = v;
//       });
//     });

//   return vidSrvPath;
// }

// Future<String> async3(String path3) async {
//   String docSrvPath = '';
//   if (path3 != '')
//     await Future<String>.delayed(const Duration(seconds: 3), () async {
//       await uploadViaDio(path3).then((v) {
//         docSrvPath = v;
//       });
//     });

//   return docSrvPath;
// }

// final _lock = new sync.Lock();
// Future<SuccessStoryModel> callAllAysncs(SuccessStoryModel scStry) async {
//   //<- 'async' is not necessary here
//   await _lock.synchronized(() async {
//     var v = await async1(scStry.imageLink);
//     if (v != null) scStry.imageLink = v;
//     await async2(scStry.videoLink).then((v2) {
//       print('v=' + v2);
//       if (v2 != null && v2 != '') scStry.videoLink = v2;
//     });
//     await async3(scStry.documentLink).then((v3) {
//       if (v3 != null && v3 != '') scStry.documentLink = v3;
//     });
//   });

//   return scStry;
// }

// Future<List<String>> uploadAllAttachment(List<String> attachments) async {
//   List<String> returnedAttachmentArray = new List<String>();
//   await _lock.synchronized(() async {
//     for (int i = 0; i < attachments.length; i++) {
//       if (attachments[i] != '') {
//         await Future<String>.delayed(Duration(seconds: i), () async {
//           await uploadVideoNew(attachments[i]).then((v) {
//             returnedAttachmentArray.add(v);
//           });
//         });
//       } else
//         returnedAttachmentArray.add('');
//     }
//   });
//   return returnedAttachmentArray;
// }
