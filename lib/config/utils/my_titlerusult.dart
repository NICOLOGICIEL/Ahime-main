import 'package:flutter/material.dart';
import 'package:ahime/config/my_config.dart';
import 'package:ahime/config/utils/resizable.dart';

// ignore: camel_case_types
class tltTitle extends StatelessWidget {
  const tltTitle({
    super.key,
    required this.myTitle,
  });

  final String myTitle;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    //var myHeight = SizeConfig.safeBlockVertical!;
    var myWidth = SizeConfig.safeBlockHorizontal!;
    return Container(
      alignment: Alignment.center,
      width: myWidth * 100,
      height: 32,
      color: myColorBlue,
      child: Text(
        myTitle,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: myColorWhite,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
