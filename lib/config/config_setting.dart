//change this file for clone app!
//alright... yeah checked all apis on production.. for mclub its api.carkee.sg, for carkee its carkeeapi.carkee.sg

// import 'package:flavor/flavor.dart';
/*
flutter build apk --split-per-abi --no-shrink
mv build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk /Users/phung/Desktop/20.6_carkee.apk
//may M1
mv build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk /Users/phungdu/Desktop/20.6_carkee.apk
open /Users/phung/Desktop
open /Users/phungdu/Desktop //may M1


 */
class ConfigSetting {
  //KARKEE
// var appVersion = "1.0.0";//always QA!
//1.0.3 start phase 2
  static const buildVersion = '20.7';//for bannerfinalArrayImage
  // static const env = Environment.dev;//for banner
  // static const env = Environment.production;
  static const appVersion = "1.0.12";
  static const clubName = "bccs";//"karkee";
  // static const baseURLFirstload = "https://carkee.solveware.co/";//"https://api.karkee.sg/"; // "https://api.karkee.sg/";
  // static const baseURLFirstload = "https://carkeeapi.carkee.sg/";//"https://api.karkee.sg/"; // "https://api.karkee.sg/";
  static const baseURLFirstload = "http://bccs.karkee.biz/";//"https://api.karkee.sg/"; // "https://api.karkee.sg/";
  static const username = 'bccs';
  static const password = 'bccs_server_pwd';

  //change set iconbottombar // clone must have icon app !

///change icon logo at choose register
  //Android Package name : sg.carkee.app
///Notification
///https://firebase.flutter.dev/docs/messaging/overview/
///
//get key google-services and put in ../android/app
//SHA certificate fingerprints setup from https://developers.google.com/android/guides/client-auth
//2 key Sh1 , 1 for QA debug key, 1 for key release
///  keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore
///  keytool -list -v -alias mclubforsingapore -keystore android/keystore
///
///
//SHA-1 : 12:8f:b0:0b:a1:75:9f:4c:21:24:b1:b8:ce:7d:03:9e:e9:e7:27:a7
//SHA-1:  8a:bf:d9:9f:b0:84:48:0d:d4:14:7a:e8:1d:77:6d:76:59:7a:4b:da
///Apple
//get P8 key from apple : // Dùng chung cho all account unravels
// Key ID : 68X6FRLF95
// Team ID : 93K7CUUG7Z
///Serverside
//need gen json key from Service Account -> download new private key
//Android side : google-service.json put in android/app
//Adroid copy file Application.kt ! remember change header~
///IOS side : phai mo Xcode keo vao!!! google-service.plist put in ios/Runner/...same level with info.plist,

//Khi báo trong main va start_loading notification.
//lam theo huong dan trong firebase console
//check all file Appdelegate, manifest , buldgarde
//change icon notificatin!
//add firebasetoken to login /







  //MCLUB
  // static const baseURLFirstload = "https://api.carkee.sg/";//mlub
  // static const appVersion = "9.9.9";
  // static const username = 'sasuke';
  // static const password = 'ZhNnvB79BNc5PzAS';
  // static const clubName = "mclub";
}
//old domain for test clone
//mclub var _baseURL = "https://api.carkee.sg/";//"http://api.carkee.sg/";
/*
testmember01@gmail.com - expired
testmember02@gmail.com - near expiry
testmember03@gmail.com - expired

password: test12345
* */