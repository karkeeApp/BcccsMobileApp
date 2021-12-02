import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:store_redirect/store_redirect.dart';

class AlertPopupOneButton extends StatelessWidget {
  final Function() callbackAfterPressOK;
  final String title;
  final String content;
  const AlertPopupOneButton(
      {Key key, this.callbackAfterPressOK, this.title, this.content})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text("OK"),
          onPressed: () {
            // print("OK pressed");
            if (content.contains(
                "A new release has been published, Please download the new version")) {
              print("go store");
              StoreRedirect.redirect(
                  androidAppId: "sg.bccs.app", iOSAppId: "1525180667");
            } else {
              Get.back();
              if (callbackAfterPressOK != null) {
                callbackAfterPressOK();
              }
            }
          },
        ),
      ],
    );
  }
}

class AlertPopup2Button extends StatelessWidget {
  final Function() callbackAfterPressOK;
  final Function() callbackAfterLeftClick;
  final String titleButtonRight;
  final String titleButtonLeft;
  final String title;
  final String content;
  const AlertPopup2Button(
      {Key key,
      this.callbackAfterPressOK,
      this.title,
      this.content,
      this.titleButtonRight,
      this.titleButtonLeft = 'Cancel',
      this.callbackAfterLeftClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text(titleButtonLeft),
          onPressed: () {
            if (callbackAfterLeftClick != null) {
              callbackAfterLeftClick();
            } else {
              Get.back();
            }
          },
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          isDefaultAction: false,
          child: Text(titleButtonRight),
          onPressed: () {
            Get.back();
            callbackAfterPressOK();
          },
        ),
      ],
    );
  }
}

class AlertPopup2ButtonCallback extends StatelessWidget {
  final Function() callbackButtonRight;
  final Function() callbackButtonLeft;
  final String titleButtonRight;
  final String titleButtonLeft;
  final String title;
  final String content;

  const AlertPopup2ButtonCallback(
      {Key key,
      this.title,
      this.content,
      this.titleButtonRight = 'OK',
      this.titleButtonLeft = 'Cancel',
      this.callbackButtonRight,
      this.callbackButtonLeft})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text(titleButtonLeft),
          onPressed: () {
            Get.back();
            if (callbackButtonLeft != null) callbackButtonLeft();
          },
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          isDefaultAction: false,
          child: Text(titleButtonRight),
          onPressed: () {
            Get.back();
            if (callbackButtonRight != null) callbackButtonRight();
          },
        ),
      ],
    );
  }
}

class AlertPopupWithTextField extends StatelessWidget {
  var texfieldController = TextEditingController();
  final Function(String) callbackAfterPressOK;
  final String confirmText;
  final String cancleText;
  final String title;
  final String placeholder;
  final bool obscureText;
  AlertPopupWithTextField(
      {Key key,
      this.callbackAfterPressOK,
      this.confirmText,
      this.cancleText,
      this.title,
      this.placeholder,
      this.obscureText})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(
          title,
          style: Styles.mclub_normalText,
        ),
      ),
      content: CupertinoTextField(
        placeholder: placeholder,
        obscureText: obscureText,
        controller: texfieldController,
      ),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text(cancleText),
          onPressed: () {
            Get.back();
          },
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text(confirmText),
          onPressed: () {
            Get.back();
            callbackAfterPressOK(texfieldController.text);
          },
        ),
      ],
    );
  }
}
