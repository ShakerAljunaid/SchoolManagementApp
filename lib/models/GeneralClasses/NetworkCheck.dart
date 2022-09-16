import 'dart:io';

import 'package:connectivity/connectivity.dart';

class NetworkCheck {
  Future<bool> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile && await checkDataReceiver()) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi && await checkDataReceiver()) {
      return true;
    }
    return false;
  }


  Future<bool> checkDataReceiver() async
  {
    try {
  final result = await InternetAddress.lookup('google.com');
  if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
   return true;
  }
} on SocketException catch (_) {
   return false;
}
  return false;
  }

  

 /* dynamic checkInternet(Function func) {
    check().then((intenet) {
      if (intenet != null && intenet) {
        func(true);
      }
      else{
    func(false);
  }
    });
  }

bool checkInternetConnection()
{
  check().then((intenet) {
      if (intenet != null && intenet) {
      return true;
      }
      else{
    return false;
  }
    });
    return false;
  }*/
}