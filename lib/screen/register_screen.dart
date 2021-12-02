// import 'package:circular_check_box/circular_check_box.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:carkee/components/TextFieldPhungNoBorder.dart';

import 'package:carkee/components/network_api.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as Dioo;
import 'package:carkee/screen/screens.dart';
import 'package:carkee/screen/update_part1_personal.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var isChecked = false.obs;

  final key = GlobalKey<FormState>();
  var fullname = TextEditingController();

  var password = TextEditingController();

  var password_confirm = TextEditingController();

  var email = TextEditingController();

  var registration_code = TextEditingController();

  var mobile_code = TextEditingController();

  var mobile = TextEditingController();

  // final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAutoFill();
  }

  loadAutoFill() {
    mobile_code.text = "+65";
    //load data from session for social new account
    email.text = Session.shared.social_email;
    fullname.text = Session.shared.social_name;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            reverse: false,//day bottom len!
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0,
                            -12), //(0,-12) Bóng lên,(0,12) bóng xuống,, tuong tự cho trái phải
                        blurRadius: 15, //do bóng phủ xa
                        color: Colors.black.withOpacity(0.5))
                  ]),
              // color: Colors.red.shade200,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // AppBarRightX(
                  //   closeClicked: (){},
                  //   title: "Welcome Back!",
                  //   subTitle: 'Log in now and check out the latest deals available!',
                  // ),
                  getHeader(),
                  buildForm(context),
                ],
              ),
            ),
          ),
        ));

    return Scaffold(
        appBar: PreferredSize(
            preferredSize: AppBarRightX().preferredSize,
            child: AppBarRightX(
              closeClicked: () {
                print("close clicked");
                Session.shared.changeRootViewToGuest();
              },
              title: 'Create an account',
              subTitle: 'Sign up to get started!',
            )),
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LineStepRegister(totalStep: 6, currentStep: 0),
            buildForm(context),
            // Expanded(
            //   child: ListView(
            //     children: [
            //       buildForm(context),
            //     ],
            //   ),
            // ),
          ],
        ));
  }

  Widget getHeader() {
    return AppNavigationV2(
        totalStep: 4,
        currentStep: 0,
        closeClicked: () {
          Get.back();
        },
        title: "Create an account",
        subTitle: "Sign up to get started!");
  }

  validAgree() {
    var errorString =
        'Please read and agree to the Terms of Use and Privacy Policy.';
    if (isChecked.value == false) {
      Session.shared.showAlertPopupOneButtonWithCallback(
          content: errorString,
          callback: () {
            Session.shared.hideLoading();
          });
      return false;
    }
    return true;
  }

  _showPickerTelephoneCode(BuildContext context) {
    showCountryPicker(
      //Có thể sau này dùng lại loic showCountryPicker xem trong source và chôm lại ý tưởng!
      context: context,
      showPhoneCode:
          true, // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        print('Select country: ${country.displayName}');
        print('Select Code: ${country.countryCode}');
        var codeSelected = country.phoneCode;
        mobile_code.text = '+$codeSelected';
      },
    );
  }

  callAPI() async {
    Session.shared.showLoading();
    print("start callAPI");
    if (validAgree() == false) return;
    var uiid = await Session.shared.getUIID();
    //hide keyboard!
    Dioo.FormData formData = new Dioo.FormData.fromMap({
      "fullname": fullname.text,
      'email': email.text,
      'registration_code': registration_code.text,
      'mobile_code': mobile_code.text,
      'mobile': mobile.text,
      "password": password.text,
      "password_confirm": password_confirm.text,
      "account_id": Session.shared.ACCOUNTID,
      "device_type": GetPlatform.isIOS ? "ios" : "android",
      'uiid': uiid,
      //for social , optional social_media_type, social_media_id
      'social_media_type': Session
          .shared.social_media_type, //login_type (1 = fb, 2 = google, 3 = apple
      'social_media_id': Session.shared.social_id,
    });
    var network = NetworkAPI(endpoint: url_register, formData: formData);
    var jsonBody = await network.callAPIPOST();
    Session.shared.hideLoading();
    if (jsonBody["code"] == 100) {
      var token = jsonBody["accesstoken"];
      print("save token if login success $token");
      //save token if register success
      Session.shared.saveToken(token);
      print('go Onboard for personal');
      Session.shared.resetSocialLoginInfo();
      Get.off(AfterLoginScreen());
    } else {
      Session.shared.showAlertPopupOneButtonNoCallBack(
          title: "Error", content: jsonBody["message"]);
    }
  }

  Padding buildForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: Config.kDefaultPadding * 2,
          right: Config.kDefaultPadding * 2,
          bottom: Config.kDefaultPadding),
      child: Column(
        children: [
          Form(
            key: key,
            // initialValue: {'email': email, 'password': password},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextFieldPhungNoBorder(
                  controller: fullname,
                  labelText: "Full Name",
                  hintText: "",
                  onChange: (value) {
                    print(value);
                    fullname.text = value;
                  },
                  keyboardType: TextInputType.text,
                  notAllowEmpty: true,
                ),

                TextFieldPhungNoBorder(
                  controller: password,
                  labelText: "Password",
                  hintText: "",
                  onChange: (value) {
                    print(value);
                    password.text = value;
                  },
                  isPassword: true,
                  notAllowEmpty: true,
                ),

                TextFieldPhungNoBorder(
                  controller: password_confirm,
                  labelText: "Confirm Password",
                  hintText: "",
                  onChange: (value) {
                    print(value);
                    password_confirm.text = value;
                  },
                  isPassword: true,
                  notAllowEmpty: true,
                ),

                TextFieldPhungNoBorder(
                  controller: email,
                  labelText: "Email Address",
                  hintText: "",
                  onChange: (value) {
                    print(value);
                    email.text = value;
                  },
                  notAllowEmpty: true,
                  requiredEmail: true,
                  keyboardType: TextInputType.emailAddress,
                ),
                TextFieldPhungNoBorder(
                  controller: registration_code,
                  labelText: "Registration Code",
                  hintText: "",
                  onChange: (value) {
                    print(value);
                    registration_code.text = value;
                  },
                  notAllowEmpty: false,
                ),
                //PHONE CODE
                Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  SizedBox(
                    width: 140,
                    child: PickerMclub(
                      controller: mobile_code,
                      titleValue: 'Country Code',
                      onTap: () {
                        _showPickerTelephoneCode(context);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Flexible(
                    child: SizedBox(
                      child: TextFieldPhungNoBorder(
                        controller: mobile,
                        labelText: "Mobile No.",
                        hintText: "",
                        onChange: (value) {
                          print(value);
                          mobile.text = value;
                        },
                        keyboardType: TextInputType.number,
                        notAllowEmpty: true,
                      ),
                    ),
                  ),
                ]),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Obx(() => Checkbox(
                            value: isChecked.value,
                            checkColor: Colors.white,
                            activeColor: Config.secondColor,
                        shape: CircleBorder(),
                        onChanged: (value) {
                              isChecked.value = !isChecked.value;
                              print(value);
                            },
                          )
                      ),
                    ),

                    SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: Column(children: [
                        RichText(
                          maxLines: 2,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: "I have read and understood BCCS's ",
                                  style: TextStyle(color: Colors.black)),
                              TextSpan(
                                text: 'Data Protection Terms',
                                style: TextStyle(
                                    color: Config.secondColor,
                                    fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    var _urlTerm = Session.shared.getBaseURL() +
                                        url_URL_TERM_OF_USE;
                                    print('launch url: $_urlTerm');
                                    Session.shared.openWebView(
                                        title: 'Data Protection Term',
                                        url: _urlTerm);
                                  },
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ]),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          BlackButton(
            callbackOnPress: () {
              // if (_fbKey.currentState.saveAndValidate()) {
              //   print(_fbKey.currentState.value);
              //   print("call API here ");
              //   FocusScope.of(context).unfocus();
              //   callAPI();
              // } else {
              //   print(_fbKey.currentState.value);
              //   print('validation failed');
              // }
              if (key.currentState.validate()) {
                print("call API here ");
                FocusScope.of(context).unfocus();
                callAPI();
              } else {
                print('validation failed');
              }
            },
            title: "Create an account",
          ),
          // sectionGoLogin()
        ],
      ),
    );
  }

  Padding sectionGoLogin() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: Config.kDefaultPadding),
        child: GestureDetector(
          onTap: () {
            print("go register now");
            Session.shared.changeRootViewToLogin();
          },
          child: Column(
            children: [
              Text("Already a member?"),
              Text.rich(TextSpan(
                text: 'Log In',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Config.secondColor),
                children: <InlineSpan>[
                  TextSpan(
                    text: ' now',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.black),
                  )
                ],
              ))
            ],
          ),
        ));
  }
}

//
// class RegisterScreen extends StatefulWidget {
//   @override
//   _RegisterScreenState createState() => _RegisterScreenState();
// }
//
// class _RegisterScreenState extends State<RegisterScreen> {
//   var isChecked = false.obs;
//
//   String fullname = "";
//
//   String password = "";
//
//   String password_confirm = "";
//
//   String email = "";
//
//   var mobile_code = TextEditingController();
//
//   var mobile = '';
//
//   final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     mobile_code.text = "+65";
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//         appBar: PreferredSize(
//             preferredSize: AppBarRightX().preferredSize,
//             child: AppBarRightX(
//               closeClicked: () {
//                 print("close clicked");
//                 Session.shared.changeRootViewToGuest();
//               },
//               title: 'Create an account',
//               subTitle: 'Sign up to get started!',
//             )),
//         body: Column(
//           // mainAxisAlignment: MainAxisAlignment.center,
//           // crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             LineStepRegister(totalStep: 6, currentStep: 0),
//             Expanded(
//               child: ListView(
//                 children: [
//                   buildForm(context),
//                 ],
//               ),
//             ),
//           ],
//         ));
//   }
//
//   validAgree() {
//     var errorString =
//         'Please read and agree to the Terms of Use and Privacy Policy.';
//     if (isChecked.value == false) {
//       Session.shared.showAlertPopupOneButtonNoCallBack(content: errorString);
//       return false;
//     }
//     return true;
//   }
//
//   _showPickerTelephoneCode(BuildContext context) {
//     showCountryPicker(
//       //Có thể sau này dùng lại loic showCountryPicker xem trong source và chôm lại ý tưởng!
//       context: context,
//       showPhoneCode:
//       true, // optional. Shows phone code before the country name.
//       onSelect: (Country country) {
//         print('Select country: ${country.displayName}');
//         print('Select Code: ${country.countryCode}');
//         var codeSelected = country.phoneCode;
//         mobile_code.text = '+$codeSelected';
//       },
//     );
//   }
//
//   callAPI() async {
//     Session.shared.showLoading();
//     print("start callAPI");
//     if (validAgree() == false) return;
//     var uiid = await Session.shared.getUIID();
//     //hide keyboard!
//     Dioo.FormData formData = new Dioo.FormData.fromMap({
//       "fullname": fullname,
//       'email': email,
//       'mobile_code' : mobile_code.text,
//       'mobile': mobile,
//       "password": password,
//       "password_confirm": password_confirm,
//       "account_id": Session.shared.ACCOUNTID,
//       "device_type": GetPlatform.isIOS ? "ios" : "android",
//       'uiid': uiid,
//     });
//     var network = NetworkAPI(endpoint: url_register, formData: formData);
//     var jsonBody = await network.callAPIPOST();
//     Session.shared.hideLoading();
//     if (jsonBody["code"] == 100) {
//       var token = jsonBody["accesstoken"];
//       print("save token if login success $token");
//       //save token if register success
//       Session.shared.saveToken(token);
//       print('go Onboard for personal');
//       Get.off(AfterLoginScreen());
//     } else {
//       Session.shared.showAlertPopupOneButtonNoCallBack(
//           title: "Error", content: jsonBody["message"]);
//     }
//   }
//
//   Padding buildForm(BuildContext context) {
//
//     return Padding(
//       padding: const EdgeInsets.all(Config.kDefaultPadding * 2),
//       child: Column(
//         children: [
//           FormBuilder(
//             key: _fbKey,
//             // initialValue: {'email': email, 'password': password},
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 FormBuilderTextField(
//                   autocorrect: false,
//                   name: 'fullname',
//                   decoration: InputDecoration(
//                       labelText: "Full Name",
//                       labelStyle: Styles.mclub_inputTextStyle),
//                   onChanged: (value) {
//                     print(value);
//                     fullname = value;
//                   },
//                   // valueTransformer: (text) => num.tryParse(text),
//                   validator: FormBuilderValidators.compose([
//                     FormBuilderValidators.required(context),
//                   ]),
//                 ),
//
//                 FormBuilderTextField(
//                   obscureText: true,
//                   autocorrect: false,
//                   name: 'password',
//                   decoration: InputDecoration(
//                       labelText: "Password",
//                       labelStyle: Styles.mclub_inputTextStyle),
//                   onChanged: (value) {
//                     print(value);
//                     password = value;
//                   },
//                   validator: FormBuilderValidators.compose([
//                     FormBuilderValidators.required(context),
//                     // FormBuilderValidators.email(context)
//                     // FormBuilderValidators.numeric(context),
//                     // FormBuilderValidators.max(context, 70),
//                   ]),
//                 ),
//                 FormBuilderTextField(
//                   obscureText: true,
//                   autocorrect: false,
//                   name: 'password_confirm',
//                   // controller: _emailController,//this case no need
//                   decoration: InputDecoration(
//                       labelText: "Confirm Password",
//                       labelStyle: Styles.mclub_inputTextStyle),
//                   onChanged: (value) {
//                     print(value);
//                     password_confirm = value;
//                   },
//                   // valueTransformer: (text) => num.tryParse(text),
//                   validator: FormBuilderValidators.compose([
//                     FormBuilderValidators.required(context),
//                   ]),
//                 ),
//                 FormBuilderTextField(
//                   autocorrect: false,
//                   name: 'email',
//                   // controller: _emailController,//this case no need
//                   decoration: InputDecoration(
//                       labelText: "Email Address",
//                       labelStyle: Styles.mclub_inputTextStyle),
//                   onChanged: (value) {
//                     print(value);
//                     email = value;
//                   },
//                   validator: FormBuilderValidators.compose([
//                     FormBuilderValidators.required(context),
//                     FormBuilderValidators.email(context)
//                   ]),
//                   keyboardType: TextInputType.emailAddress,
//                 ),
//
//
//                 //PHONE CODE
//                 Row(children: [
//                   SizedBox(
//                     width: 140,
//                     child: PickerMclub(
//                       controller: mobile_code,
//                       titleValue: 'Country Code',
//                       onTap: () {
//                         _showPickerTelephoneCode(context);
//                       },
//                     ),
//                   ),
//                   SizedBox(width: 5,),
//                   Flexible(
//                     child: SizedBox(
//                       child: FormBuilderTextField(
//                         initialValue: mobile,
//                         keyboardType: TextInputType.number,
//                         autocorrect: false,
//                         name: 'emergency_no',
//                         decoration: InputDecoration(
//                             contentPadding: EdgeInsets.zero,
//                             labelText: "Mobile No.",
//                             labelStyle: Styles.mclub_inputTextStyle),
//                         onChanged: (value) {
//                           mobile = value;
//                           print(value);
//                         },
//                       ),
//                     ),
//                   ),
//
//                 ]),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 10),
//                   child: Row(children: [
//                     SizedBox(
//                       width: 24,
//                       height: 24,
//                       child: Obx(() =>
//                           CircularCheckBox(
//                             value: isChecked.value,
//                             checkColor: Colors.white  ,
//                             activeColor: Config.secondColor,
//                             inactiveColor: Config.primaryColor,
//                             disabledColor: Colors.grey ,
//                             onChanged: (value) {
//                               isChecked.value = !isChecked.value;
//                               print(value);
//                             },
//                           )
//                       ),
//                     ),
//
//                     SizedBox(
//                       width: 20,
//                     ),
//                     Flexible(
//                       child: Column(children: [
//                         RichText(
//                           maxLines: 2,
//                           text: TextSpan(
//                             children: [
//                               TextSpan(
//                                   text: "I have read and understood Carkee's ",
//                                   style: TextStyle(color: Colors.black)),
//                               TextSpan(
//                                 text: 'Data Protection Terms',
//                                 style: TextStyle(
//                                     color: Config.secondColor,
//                                     fontWeight: FontWeight.bold),
//                                 recognizer: TapGestureRecognizer()
//                                   ..onTap = () {
//                                     var _urlTerm = Session.shared.getBaseURL() +
//                                         url_URL_TERM_OF_USE;
//                                     print('launch url: $_urlTerm');
//                                     Session.shared.openWebView(
//                                         title: 'Data Protection Term',
//                                         url: _urlTerm);
//                                   },
//                               ),
//                             ],
//                           ),
//                         ),
//                       ]),
//                     ),
//                   ]),
//                 ),
//               ],
//             ),
//           ),
//           PrimaryButton(
//             callbackOnPress: () {
//               if (_fbKey.currentState.saveAndValidate()) {
//                 print(_fbKey.currentState.value);
//                 print("call API here ");
//                 FocusScope.of(context).unfocus();
//                 callAPI();
//               } else {
//                 print(_fbKey.currentState.value);
//                 print('validation failed');
//               }
//             },
//             title: "Create an Account",
//           ),
//           sectionGoLogin()
//         ],
//       ),
//     );
//   }
//
//   Padding sectionGoLogin() {
//     return Padding(
//         padding: const EdgeInsets.symmetric(vertical: Config.kDefaultPadding),
//         child: GestureDetector(
//           onTap: () {
//             print("go register now");
//             Session.shared.changeRootViewToLogin();
//           },
//           child: Column(
//             children: [
//               Text("Already a member?"),
//               Text.rich(TextSpan(
//                 text: 'Log In',
//                 style: TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.bold,
//                     color: Config.secondColor),
//                 children: <InlineSpan>[
//                   TextSpan(
//                     text: ' now',
//                     style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.normal,
//                         color: Colors.black),
//                   )
//                 ],
//               ))
//             ],
//           ),
//         ));
//   }
// }
