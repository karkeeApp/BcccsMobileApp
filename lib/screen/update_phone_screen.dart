import 'package:carkee/components/TextFieldPhungNoBorder.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:carkee/components/network_api.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:dio/dio.dart' as Dioo;
import 'package:carkee/controllers/controllers.dart';
import 'package:carkee/screen/screens.dart';

class UpdatePhoneScreen extends StatefulWidget {

  @override
  _UpdatePhoneScreenState createState() => _UpdatePhoneScreenState();
}

class _UpdatePhoneScreenState extends State<UpdatePhoneScreen> {
  final ProfileController profileController = Get.find();

  final mobileCodeController = TextEditingController();

  var mobileNo = TextEditingController();



  loadOldData() {

    mobileCodeController.text = profileController.userProfile.value.mobileCode;
    mobileNo.text = profileController.userProfile.value.mobile;
  }

  _showPickerCountry(BuildContext context) {
    showCountryPicker(
      //Có thể sau này dùng lại loic showCountryPicker xem trong source và chôm lại ý tưởng!
      context: context,
      showPhoneCode:
          true, // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        print('Select country: ${country.displayName}');
        print('Select Code: ${country.countryCode}');
        var codeSelected = country.phoneCode;
        mobileCodeController.text = '+$codeSelected';
        // controller.country = contrySelected;
        // print('codeMobile $codeMobile');
      },
    );
  }

  callAPIUpdateNumber() async {
    Dioo.FormData formData = new Dioo.FormData.fromMap({
      "mobile_code": mobileCodeController.text,
      "mobile": mobileNo.text,
    });
    Map<String, dynamic> jsonQuery = {"access-token": await Session.shared.getToken()};
    var network = NetworkAPI(
        endpoint: url_update_mobile, formData: formData, jsonQuery: jsonQuery);
    var jsonBody = await network.callAPIPOST();
    if (jsonBody["code"] == 100) {
      Session.shared.showAlertPopupOneButtonWithCallback(
          title: 'Success',
          content: jsonBody["message"],
          callback: () {
            print("success $url_update_mobile");
            profileController.callAPIGetProfile();//update data back!
            Get.back();
          });
    } else {
      Session.shared.showAlertPopupOneButtonNoCallBack(
          title: "Error", content: jsonBody["message"]);
    }
  }

  callAPIVerifyPassword(String pass) async {
    print("start callAPIVerifyPassword");
    Dioo.FormData formData = new Dioo.FormData.fromMap({
      'password' : pass
    });
    Map<String, dynamic> jsonQuery = {"access-token": await Session.shared.getToken()};
    var network = NetworkAPI(endpoint: url_member_verify_password, formData: formData, jsonQuery: jsonQuery);
    var jsonBody = await network.callAPIPOST();
    if (jsonBody["code"] == 100) {
      print("success $jsonBody continue call API update number");
      callAPIUpdateNumber();
    } else {
      Session.shared.showAlertPopupOneButtonNoCallBack(
          title: "Error", content: jsonBody["message"]);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadOldData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: PreferredSize(
        //     preferredSize: AppBarCustomRightIcon().preferredSize,
        //     child: AppBarCustomRightIcon(
        //       leftClicked: () {
        //         print("close clicked");
        //         Get.back();
        //       },
        //       title: 'Update New Password',
        //     )),
        // //SliderNewsDetails(modelNews: modelNews,),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text('Update Phone Number', style: Styles.mclub_Tilte),
          elevation: 1,
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          child: Padding(
            padding: const EdgeInsets.all(Config.kDefaultPadding * 2),
            child: Container(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Text(
                      'Secure your BCSS account by verifying your mobile phone number.',
                      style: Styles.mclub_normalText,
                    ),
                  ),

                  //PHONE CODE
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 140,
                          child: PickerMclub(
                            controller: mobileCodeController,
                            titleValue: 'Country Code',
                            onTap: () {
                              _showPickerCountry(context);
                            },
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          child: SizedBox(
                            child: TextFieldPhungNoBorder(
                              controller: mobileNo,
                              labelText: "Mobile No.",
                              hintText: "",
                              onChange: (value) {
                                print(value);
                                mobileNo.text = value;
                              },
                              keyboardType: TextInputType.number,
                              notAllowEmpty: true,
                            ),
                          ),
                        ),
                      ]),

                  SizedBox(height: 30,),
                  PrimaryButton(
                    callbackOnPress: () {
                      FocusScope.of(context).unfocus();//hide keyboard
                      Session.shared.showAlertPopupWithCallbackTextFieldInput(
                          title: "Please verify with your account password",
                          obscureText: true,
                          cancleText: "Cancle",
                          confirmText: "Confirm",
                          placeholder: "Password",
                          callback: (inputText) {
                            print("ok ok ok $inputText");
                            callAPIVerifyPassword(inputText);
                          });
                    },
                    title: "Verify Phone Number",
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
//
// class UpdatePhoneScreenController extends GetxController {
//   final ProfileController profileController = Get.find();
//   final mobileCodeController = TextEditingController();
//   var mobileNo = ''.obs;
//   @override
//   void onInit() {
//     super.onInit();
//     loadOldData();
//   }
//
//   callAPIUpdateNumber() async {
//     Dioo.FormData formData = new Dioo.FormData.fromMap({
//       "mobile_code": mobileCodeController.text,
//       "mobile": mobileNo,
//     });
//     Map<String, dynamic> jsonQuery = {"access-token": await Session.shared.getToken()};
//     var network = NetworkAPI(
//         endpoint: url_update_mobile, formData: formData, jsonQuery: jsonQuery);
//     var jsonBody = await network.callAPIPOST();
//     if (jsonBody["code"] == 100) {
//       Session.shared.showAlertPopupOneButtonWithCallback(
//           title: 'Success',
//           content: jsonBody["message"],
//           callback: () {
//             print("success $url_update_mobile");
//             profileController.callAPIGetProfile();//update data back!
//             Get.back();
//           });
//     } else {
//       Session.shared.showAlertPopupOneButtonNoCallBack(
//           title: "Error", content: jsonBody["message"]);
//     }
//   }
//
//   callAPIVerifyPassword(String pass) async {
//       print("start callAPIVerifyPassword");
//       Dioo.FormData formData = new Dioo.FormData.fromMap({
//         'password' : pass
//       });
//       Map<String, dynamic> jsonQuery = {"access-token": await Session.shared.getToken()};
//       var network = NetworkAPI(endpoint: url_member_verify_password, formData: formData, jsonQuery: jsonQuery);
//       var jsonBody = await network.callAPIPOST();
//       if (jsonBody["code"] == 100) {
//         print("success $jsonBody continue call API update number");
//         callAPIUpdateNumber();
//       } else {
//         Session.shared.showAlertPopupOneButtonNoCallBack(
//             title: "Error", content: jsonBody["message"]);
//       }
//   }
//
//   loadOldData() {
//     final ProfileController profileController = Get.find();
//     mobileCodeController.text = profileController.userProfile.value.mobileCode;
//     mobileNo.value = profileController.userProfile.value.mobile;
//   }
//
//   @override
//   void onClose() {
//     super.onClose();
//   }
// }
