import 'package:flutter/material.dart';
import 'package:ahime/config/utils/resizable.dart';

class SlideImg extends StatelessWidget {
  const SlideImg({
    super.key,
    this.imgPath,
    this.title,
  });

  final String? imgPath;
  final String? title;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var myHeight = SizeConfig.safeBlockVertical!;
    var myWidth = SizeConfig.safeBlockHorizontal!;

    return Container(
      height: myHeight * 25,
      width: myWidth * 100,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(imgPath!), fit: BoxFit.fill),
      ),
      child: Center(
        child: Text(title!,
            style: const TextStyle(
                fontSize: 40,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}
