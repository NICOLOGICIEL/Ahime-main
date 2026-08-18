import 'package:flutter/material.dart';
import 'package:ahime/config/utils/my_titlerusult.dart';
import 'package:ahime/config/utils/my_navbar.dart';
import 'package:ahime/config/my_config.dart';
import 'package:ahime/config/utils/resizable.dart';

class PageH extends StatelessWidget {
  const PageH({
    super.key,
    required this.myTitle,
    required this.myPage,
  });
  final String myTitle;
  final Widget myPage;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var myHeight = SizeConfig.safeBlockVertical!;
    var myWidth = SizeConfig.safeBlockHorizontal!;

    return Scaffold(
      backgroundColor: myColorBlue,
      body: SafeArea(
        child: Container(
          width: myWidth * 100,
          height: myHeight * 100,
          color: myColorWhite,
          child: SingleChildScrollView(
            child: Column(
              children: [
                MyNavbar(context:context),
                tltTitle(myTitle: myTitle),
                myPage,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
