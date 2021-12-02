import 'package:flutter/material.dart';

class Config {
  static const Color primaryColor = Color(0xFF464646);//0xFF304983 darkgray
  static const Color secondColor = Color(0xFF01579B);// 0xFF464646 red
  static const Color kTextLightColor = Color(0xFFACACAC);
  static const Color kTextColor = Color(0xFF535353);
  //F2F2F7 grab background
  static const Color kLightGreyBackgroundColor = Color(0xFFF2F2F7);
  static const kDefaultPadding = 10.0;
  static const kLineHeight = 2.0;
  static const kShadow = [
    BoxShadow(
        offset: Offset(0,
            -6), //(0,-12) Bóng lên,(0,12) bóng xuống,, tuong tự cho trái phải
        blurRadius: 6 ,//do bóng phủ xa
        spreadRadius: -4.0,////giảm độ mờ của bóng lên -4 để bottom ko có bóng!
        color: Colors.black26)
  ];
  static const kShadowSponsor = [
    BoxShadow(
        offset: Offset(0,
            0), //(0,-12) Bóng lên,(0,12) bóng xuống,, tuong tự cho trái phải
        blurRadius: 5 ,//do bóng phủ xa
        // spreadRadius: -4.0,////giảm độ mờ của bóng lên -4 để bottom ko có bóng!
        color: Colors.black38)
  ];
}
