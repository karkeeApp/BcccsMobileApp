import 'dart:io';

import 'package:carkee/screen/profile_member_view_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import '../components/infoItemHorizal.dart';
import '../components/network_api.dart';
import '../config/app_configs.dart';
import '../config/strings.dart';
import '../controllers/controllers.dart';
import 'package:dio/dio.dart' as Dioo;

import 'get_app_screen.dart';
import 'start_loading.dart';

//0,1,2,3
enum NotificationType { none, news, events, all }

class ProfileMemberTabScreen extends StatefulWidget {
  @override
  _ProfileMemberTabScreenState createState() => _ProfileMemberTabScreenState();
}

class _ProfileMemberTabScreenState extends State<ProfileMemberTabScreen> {
  final ProfileController profileController = Get.find();

  File _file;
  final picker = ImagePicker();

  // This is the type used by the popup menu below.

  NotificationType selection = NotificationType.all;

  var checkedNoti = '✔️';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //load old state notification
    var oldSelected = Session.shared.getTopicInt();

    switch (oldSelected) {
      case 0:
        {
          setState(() {
            selection = NotificationType.none;
          });
          print('none');
        }
        break;

      case 1:
        {
          setState(() {
            selection = NotificationType.events;
          });
          print('events');
        }
        break;

      case 2:
        {
          setState(() {
            selection = NotificationType.news;
          });
          print('events');
        }
        break;

      case 3:
        {
          setState(() {
            selection = NotificationType.all;
          });
          print('all');
        }
        break;

      default:
        {}
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          // iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.white,
          title: Text("My Profile", style: Styles.mclub_Tilte),
          elevation: 1,
          leading: IconButton(
            padding: EdgeInsets.only(left: 10),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(Icons.menu),
            iconSize: 30,
            color: Colors.black,
          ),
          actions: [
            // This menu button widget updates a _selection field (of type WhyFarther,
// not shown here).
            PopupMenuButton<NotificationType>(
              icon:
                  getIconNotiTopRight(), //Icon(Icons.notifications_active_outlined),
              onSelected: (NotificationType result) {
                setState(() {
                  print("you selected $result");
                  selection = result;
                  Session.shared.box.write('notiType', selection.index);

                  switch (selection) {
                    case NotificationType.none:
                      {
                        unsubAll();
                        print('none');
                      }
                      break;
                    case NotificationType.events:
                      {
                        firebaseMessaging.unsubscribeFromTopic('1');
                        firebaseMessaging.unsubscribeFromTopic('3');
                        firebaseMessaging.subscribeToTopic('2');
                        profileController.callAPIUpdateTopic();

                        print('events');
                      }
                      break;
                    case NotificationType.news:
                      {
                        firebaseMessaging.unsubscribeFromTopic('2');
                        firebaseMessaging.unsubscribeFromTopic('3');
                        firebaseMessaging.subscribeToTopic('1');
                        profileController.callAPIUpdateTopic();
                        print('news');
                      }
                      break;
                    default:
                      {
                        firebaseMessaging.unsubscribeFromTopic('1');
                        firebaseMessaging.unsubscribeFromTopic('2');
                        firebaseMessaging.subscribeToTopic('3');
                        profileController.callAPIUpdateTopic();
                        print('all');
                      }
                      break;
                  }
                });
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<NotificationType>>[
                //none
                PopupMenuItem<NotificationType>(
                  value: NotificationType.none,
                  child: Container(
                    child: Row(
                      children: [
                        Icon(Icons.notifications_off_outlined),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Off Notifications')
                      ],
                    ),
                    color: selection == NotificationType.none
                        ? Colors.grey.shade200
                        : Colors.white,
                  ),
                ),

                PopupMenuItem<NotificationType>(
                  value: NotificationType.events,
                  child: Container(
                    child: Row(
                      children: [
                        Icon(Icons.notifications_active_outlined),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Events Notifications')
                      ],
                    ),
                    color: selection == NotificationType.events
                        ? Colors.grey.shade200
                        : Colors.white,
                  ),
                ),

                PopupMenuItem<NotificationType>(
                  value: NotificationType.news,
                  child: Container(
                    child: Row(
                      children: [
                        Icon(Icons.notifications_active_outlined),
                        SizedBox(
                          width: 10,
                        ),
                        Text('News Notifications')
                      ],
                    ),
                    color: selection == NotificationType.news
                        ? Colors.grey.shade200
                        : Colors.white,
                  ),
                ),

                PopupMenuItem<NotificationType>(
                  value: NotificationType.all,
                  child: Container(
                    child: Row(
                      children: [
                        Icon(Icons.notifications_active),
                        SizedBox(
                          width: 10,
                        ),
                        Text('All Notifications')
                      ],
                    ),
                    color: selection == NotificationType.all
                        ? Colors.grey.shade200
                        : Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
        body: buildBody(context));
  }

  unsubAll() {
    firebaseMessaging.unsubscribeFromTopic('1');
    firebaseMessaging.unsubscribeFromTopic('2');
    firebaseMessaging.unsubscribeFromTopic('3');
  }

  getIconNotiTopRight() {
    switch (selection) {
      case NotificationType.none:
        {
          return Icon(Icons.notifications_off_outlined);
        }
        break;

      case NotificationType.events:
        {
          return Icon(Icons.notifications_active_outlined);
        }
        break;

      case NotificationType.news:
        {
          return Icon(Icons.notifications_active_outlined);
        }
        break;

      case NotificationType.all:
        {
          return Icon(Icons.notifications_active);
        }
        break;

      default:
        {}
        break;
    }
  }

  Widget buildBody(BuildContext context) {
    print('buildBody ProfileMemberTabScreen ${profileController.modelMemberOptionsResult.value.toJson()}');

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Container(
        // color: Colors.red,
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _refreshData,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(children: [
                SizedBox(
                  height: 20,
                ),
                getHeader(),
                SizedBox(
                  height: 40,
                ),
                fakeTopRadius(),
                Obx(() => getInfo()),
              ]),
            ),
          ),
        ),
        // children: [],
      ),
    );
  }

  Future _refreshData() async {
    // await Future.delayed(Duration(seconds: 1));
    profileController.callAPIGetProfile();
  }

  Container fakeTopRadius() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          boxShadow: Config.kShadow),
    );
  }

  boxProfile() {
    return Container(
      // height: 200,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
                offset: Offset(0,
                    -6), //(0,-12) Bóng lên,(0,12) bóng xuống,, tuong tự cho trái phải
                blurRadius: 15, //do bóng phủ xa
                spreadRadius:
                    -6.0, ////giảm độ mờ của bóng lên -4 để bottom ko có bóng!
                color: Colors.black26)
          ]),

      child: getInfo(),
    );
  }

  getInfo() {
    return Column(
      children: [
        infoItemHorizal(
            title: 'Email', value: profileController.userProfile.value.email),
        infoItemHorizal(
            title: 'Contact No', value: profileController.getFullMobile()),
        infoItemHorizal(
            title: 'Date of Birth', value: profileController.getBirthday()),
        infoItemHorizal(
            title: 'Gender', value: profileController.getGenderString()),
        SizedBox(
          height: Config.kDefaultPadding * 2,
        ),
        ProfileButton(
            title: "View Full Profile",
            onClick: () {
              print("View Full Profile clicked");
              Get.to(() => ProfileMemberViewScreen());
            }),
        // ProfileButton(
        //     title: "Show Firebasetoken for test",
        //     onClick: () {
        //       Clipboard.setData(new ClipboardData(
        //           text: Session.shared.box.read('firebaseToken')));
        //       Get.snackbar('Your firebaseToken Code', 'Copied');
        //     }),
        // profileButton(
        //     title: "View Service",
        //     onClick: () {
        //       print("View Serviceclicked");
        //     }),
        // profileButton(title : "Create a Club", onClick: (){
        //   print("Create a Club clicked");
        //   Get.to(() => GetAppScreen());
        // }),
      ],
    );
  }

  getHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Config.kDefaultPadding * 2),
          child: GestureDetector(
            onTap: () {
              print('change avatar show picker');
              // showImagePicker(context, false);
              Session.shared.showImagePicker(context, isHavePDFOption: false,
                  callback: (file) {
                print("callback ddddddd");
                setState(() {
                  _file = file;
                });
                _callAPIUploadImage();
              }); //try call from Session
            },
            child: Obx(() {
              return CircleAvatar(
                radius: 40.0,
                backgroundImage:
                    NetworkImage(profileController.getProfileImage()),
                backgroundColor: Colors.transparent,
              );
            }),
          ),
        ),
        Obx(() {
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profileController.getFullName(),
                  style: Styles.mclub_Tilte,
                ),
                Text(
                  profileController.userProfile.value.memberSince,
                  style: Styles.mclub_smallText,
                ),
                Text(
                  profileController.userProfile.value.memberExpire,
                  style: Styles.mclub_smallText,
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // showImagePicker(context, @required bool isHavePDFOption) {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (BuildContext bc) {
  //         return SafeArea(
  //           child: Container(
  //             child: Wrap(
  //               children: <Widget>[
  //                 ListTile(
  //                     leading: new Icon(Icons.photo_library),
  //                     title: new Text('Photo Library'),
  //                     onTap: () {
  //                       _imgFromGallery();
  //                       Navigator.of(context).pop();
  //                     }),
  //                 ListTile(
  //                   leading: new Icon(Icons.photo_camera),
  //                   title: new Text('Camera'),
  //                   onTap: () {
  //                     _imgFromCamera();
  //                     Navigator.of(context).pop();
  //                   },
  //                 ),
  //                 isHavePDFOption
  //                     ? ListTile(
  //                         leading: new Icon(Icons.picture_as_pdf),
  //                         title: new Text('PDF'),
  //                         onTap: () {
  //                           _chooseFile();
  //                           Navigator.of(context).pop();
  //                         },
  //                       )
  //                     : SizedBox(),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }

  //HANDLE PICTURE UPLOAD
  // _chooseFile() async {
  //   FilePickerResult result = await FilePicker.platform.pickFiles(
  //       allowMultiple: false,
  //       type: FileType.custom,
  //       allowedExtensions: ['pdf']);
  //   if (result != null) {
  //     // _file = File(result.files.single.path);
  //     // _callAPIUploadImage();
  //     _file = File(result.files.single.path);
  //     var fileType = lookupMimeType(result.files.single.path);
  //     print(fileType);
  //     if (fileType == 'application/pdf') {
  //       _callAPIUploadImage();
  //     } else {
  //       Session.shared
  //           .showAlertPopupOneButtonNoCallBack(content: "File not support");
  //     }
  //   } else {
  //     // User canceled the picker
  //     print('No file selected.');
  //   }
  // }

  // _imgFromCamera() async {
  //   final pickedFile =
  //       await picker.getImage(source: ImageSource.camera, imageQuality: 50,);
  //   if (pickedFile != null) {
  //     print('upload now');
  //     setState(() {
  //       _file = File(pickedFile.path);
  //     });
  //     _cropImage();
  //     // _callAPIUploadImage();//no more call APi here, put after crop!
  //   } else {
  //     // Session.shared.hideLoading();
  //     print('No image selected.');
  //   }
  // }
  //crop
  // Future<Null> _cropImage() async {
  //   File croppedFile = await ImageCropper.cropImage(
  //       sourcePath: _file.path,
  //       aspectRatioPresets: Platform.isAndroid
  //           ? [
  //         CropAspectRatioPreset.square,
  //         CropAspectRatioPreset.ratio3x2,
  //         CropAspectRatioPreset.original,
  //         CropAspectRatioPreset.ratio4x3,
  //         CropAspectRatioPreset.ratio16x9
  //       ]
  //           : [
  //         CropAspectRatioPreset.original,
  //         CropAspectRatioPreset.square,
  //         CropAspectRatioPreset.ratio3x2,
  //         CropAspectRatioPreset.ratio4x3,
  //         CropAspectRatioPreset.ratio5x3,
  //         CropAspectRatioPreset.ratio5x4,
  //         CropAspectRatioPreset.ratio7x5,
  //         CropAspectRatioPreset.ratio16x9
  //       ],
  //       androidUiSettings: AndroidUiSettings(
  //           toolbarTitle: 'Cropper',
  //           toolbarColor: Colors.deepOrange,
  //           toolbarWidgetColor: Colors.white,
  //           initAspectRatio: CropAspectRatioPreset.original,
  //           lockAspectRatio: false),
  //       iosUiSettings: IOSUiSettings(
  //         title: 'Cropper',
  //       ));
  //   if (croppedFile != null) {
  //     setState(() {
  //       _file = croppedFile;//update UI!
  //     });
  //     _callAPIUploadImage();//call API after crop!
  //   } else {
  //     _clearImage();
  //   }
  // }
  // void _clearImage() {
  //   _file = null;
  // }

/*
  _imgFromGallery() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      _file = File(pickedFile.path);
      print('upload now');
      //upload now
      _callAPIUploadImage();
    } else {
      Session.shared.hideLoading();
      print('No image selected.');
    }
  }
*/
  // _imgFromGallery() async {
  //   FilePickerResult result = await FilePicker.platform.pickFiles(
  //     allowMultiple: false,
  //     type: FileType.image,
  //   );
  //   if (result != null) {
  //     _file = File(result.files.single.path);
  //     if (Session.shared.isFileSizeUnder5MB(_file)) {
  //       // _callAPIUploadImage();
  //       _cropImage();
  //     } else {
  //       _file = null;
  //       Session.shared.showAlertPopupOneButtonNoCallBack(title: "Error", content: "File not allow > 5MB");
  //     }
  //   } else {
  //     print('No file selected.');
  //   }
  // }
  _callAPIUploadImage() async {
    // Session.shared.showLoading();
    // EasyLoading.showProgress(0.5);
    print("start _callAPIUploadImage");
    //get Type
    Dioo.FormData formData = new Dioo.FormData.fromMap({
      "file":
          await Dioo.MultipartFile.fromFile(_file.path, filename: _file.name),
      'field': Strings.img_profile,
    });
    Map<String, dynamic> jsonQuery = {"access-token": await Session.shared.getToken()};
    var network = NetworkAPI(
        endpoint: url_member_upload_doc,
        formData: formData,
        jsonQuery: jsonQuery);

    var jsonBody = await network.callAPI(
        method: "POST",
        percent: (percent) {
          print(percent);
          if (percent != 1) {
            EasyLoading.showProgress(percent, status: 'Uploading..');
          } else {
            EasyLoading.dismiss(animation: true);
          }
        });
    // EasyLoading.dismiss(animation: true);
    // Session.shared.hideLoading();
    if (jsonBody["code"] == 100) {
      print("success $jsonBody");
      profileController.callAPIGetProfile(); //refresh
    } else {
      Session.shared.showAlertPopupOneButtonNoCallBack(
          title: "Error", content: jsonBody["message"]);
    }
  }

  void iconNotiClicked() {
    print("clicked");
  }
}
