import 'package:flutter/material.dart';
import 'package:ahime/config/my_config.dart';
import 'package:ahime/config/utils/resizable.dart';

class PageHotelimgFull extends StatelessWidget {
  const PageHotelimgFull({
    super.key,
    required this.mphoto,
  });
  final String mphoto;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var myHeight = SizeConfig.safeBlockVertical!;
    var myWidth = SizeConfig.safeBlockHorizontal!;

    return Scaffold(
      backgroundColor: myColorBlue,
      body: SafeArea(
        child: Stack(
          children: [
            ClipRRect(
                child: myMemoryImage(
              imgBase64Dec(mphoto),
              BoxFit.fill,
              myWidth * 100,
              myHeight * 100,
            )),
            Positioned(
              top: 3,
              left: 3,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                ),
                iconSize: 20,
                color: Colors.white,
                onPressed: () {
                  popPage(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
