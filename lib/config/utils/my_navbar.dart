import 'package:ahime/config/utils/resizable.dart';
import 'package:flutter/material.dart';
import 'package:ahime/config/my_config.dart';


// ignore: non_constant_identifier_names
MyNavbar({required BuildContext context}) {
  SizeConfig().init(context);
  var myWidth = SizeConfig.safeBlockHorizontal!;
  var myHeight = SizeConfig.safeBlockVertical!;

  return Container(
    width: myWidth * 100,
    height: myHeight * 10,
    color: Colors.white,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          iconSize: 20,
          color: Colors.grey[600],
          onPressed: () {
            popPage(context);
          },
        ),
        SizedBox(
          child: Image.asset('$imageUri/logo3.png', width: 70),
        ),
        const SizedBox(width: 40)
      ],
    ),
  );
}
