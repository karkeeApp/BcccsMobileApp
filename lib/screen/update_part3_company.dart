import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:carkee/components/slider_guestscreen.dart';
import 'package:carkee/models/ModelBannerResult.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:carkee/components/TextFieldPhungNoBorder.dart';
import 'package:carkee/components/bottom_next_back_register.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:carkee/components/network_api.dart';
import 'package:dio/dio.dart' as Dioo;
import 'package:carkee/controllers/controllers.dart';
import 'package:carkee/models/ModelMemberOptionsResult.dart';
import 'package:carkee/screen/update_part2_company.dart';
import 'package:carkee/screen/update_part2_personal.dart';

import 'get_app_screen.dart';

class UpdatePart3CompanyScreen extends StatefulWidget {
  @override
  _UpdatePart3CompanyScreenState createState() => _UpdatePart3CompanyScreenState();
}

class _UpdatePart3CompanyScreenState extends State<UpdatePart3CompanyScreen> {
  var modelBannerResult = ModelBannerResult();
  var isDone_callAPIGetBanner = false;//temp always true



  callAPIGetBanner() async {
    print("start callAPIGetListGuest");
    var network = NetworkAPI(
        endpoint: url_banner_list,
        jsonQuery: {"account_id": Session.shared.HASH_ID});
    var jsonRespondBody = await network.callAPIGET();
    if (jsonRespondBody["code"] == 100) {
      // print('jsonRespondBody $jsonRespondBody');
      var modelBannerResult = ModelBannerResult.fromJson(jsonRespondBody);
      setState(() {
        this.modelBannerResult = modelBannerResult;
        this.isDone_callAPIGetBanner = true;
      });

      return jsonRespondBody; //must return after get done asynx
    } else {
      Session.shared.showAlertPopupOneButtonWithCallback(
          content: jsonRespondBody["message"] ?? "");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callAPIGetBanner();
  }

  @override
  Widget build(BuildContext context) {
    print('Start build');
    return image_background(context);
  }



  Widget image_background(BuildContext context) {
    //return Center(child: CircularProgressIndicator());
    return Material(
      child: Container(
        // color: Colors.red,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/bg_2.png"), fit: BoxFit.cover),
          ),
          child : blur_background(context)
      ),
    );
  }

  Widget blur_background(BuildContext context) {
    //return Center(child: CircularProgressIndicator());
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
        ),
        child: body_view(context),
      ),
    );
  }

  Widget body_view(BuildContext context) {
    print('Start build');
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          child: Column(children: [
            // LineStepRegister(totalStep: 4, currentStep: 1),
            AppNavigationV2(
              closeClicked: () {
                print("close clicked");
                Session.shared.changeRootViewToGuest();
              },
              title: "An app of your own",
              subTitle:
              'Your club can have an app too, produced by Karkee.',
              totalStep: 4,
              currentStep: 3,
            ),
            Expanded(
              child: ListView(
                children: [
                  section1(context)
                ],
              ),
            ),
            // BottomNextBackRegister(
            //   titleNext: 'Next',
            //   isShowBack: true,
            //   nextClicked: () => callAPIUpdate(),
            //   backClicked: () => Get.offAll(() =>UpdatePart2CompanyScreen(),
            //       transition: Transition.leftToRight),
            // )
          ]),

          // children: [],
        ),
      ),
    );
  }

  Widget section1(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Config.kDefaultPadding * 2 ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Padding(
            //   padding: const EdgeInsets.only(top: Config.kDefaultPadding),
            //   child: Text(
            //     'What is this about?',
            //     style: Styles.mclub_Tilte,
            //   ),
            // ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What is this about?',
                  style: Styles.mclub_Tilte,
                ),
                Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ullamcorper morbi tincidunt ornare massa eget. Phasellus vestibulum lorem sed risus ultricies. Lorem ipsum dolor sit amet consectetur adipiscing elit. Scelerisque varius morbi enim nunc faucibus.',
                style: Styles.mclub_normalText,),
                Text(
                  'Make your experience smoother.',
                  style: Styles.mclub_Tilte,
                ),
                Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                  style: Styles.mclub_normalText,),

                //slider
                isDone_callAPIGetBanner ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: SliderAppScreen(modelGalleries: modelBannerResult.data),
                ) : SizedBox(),
                //text
                Text('Ullamcorper morbi tincidunt ornare massa eget. Phasellus vestibulum lorem sed risus ultricies.',
                  style: Styles.mclub_normalText,),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: BlackButton(callbackOnPress: (){
                    print("change to Get App Started");
                    Get.to(() => GetAppScreen());
                  }, title: "Get App Started"),
                ),

                Center(
                  child: GestureDetector(
                    onTap: (){
                      Session.shared.changeRootViewToDashBoard();
                    },
                    child: Text('No, thanks!',
                      style: Styles.mclub_normalText_underline,),
                  ),
                ),
                SizedBox(height: 30,)
              ],
            )
          ]),
    );
  }

}
