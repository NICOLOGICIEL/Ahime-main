import 'package:flutter/material.dart';
import 'package:ahime/config/my_config.dart';
//import 'package:ahime/config/my_config.dart';
import 'package:ahime/config/utils/resizable.dart';

// ignore: camel_case_types
class tltTotalresult extends StatelessWidget {
  const tltTotalresult({
    super.key,
    required this.myResult,
  });

  final String myResult;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    //var myHeight = SizeConfig.safeBlockVertical!;
    var myWidth = SizeConfig.safeBlockHorizontal!;
    return Container(
      alignment: Alignment.center,
      width: myWidth * 100,
      height: 12,
      //color: myColorBlue,
      child: Text(
        myResult,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: myColorRed,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
