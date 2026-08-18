import 'package:ahime/pages/hotel/page_hotelimgfull.dart';
import 'package:flutter/material.dart';
import 'package:ahime/config/my_config.dart';
import 'package:ahime/config/utils/resizable.dart';
import 'package:get/get.dart';
import 'package:ahime/config/getx/updateimg.dart';
import 'package:readmore/readmore.dart';

class PageHotelimg extends StatelessWidget {
  PageHotelimg({
    super.key,
    required this.dataPhoto,
  });
  final List<dynamic> dataPhoto;

  final ImgController imgc = Get.put(ImgController());

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
                myImgDescription(
                    context, myWidth, myHeight, dataPhoto[0]['Photo']),
                txtDescriptionImage(dataPhoto[0]['Description']),
                const SizedBox(height: 2),
                txtTitreCataloge('Cataloge image (${dataPhoto.length})'),
                const SizedBox(height: 2),
                grdCataloge(myHeight),
                const SizedBox(height: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Stack myImgDescription(
      BuildContext context, double myWidth, double myHeight, ig64) {
    return Stack(
      //clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: () {
            pushPage(context,PageHotelimgFull(mphoto: imgc.iMg64.value == '' ? ig64 : imgc.iMg64.value));
          },
          child: ClipRRect(
              child: Obx(() => myMemoryImage(
                    imgBase64Dec(
                        imgc.iMg64.value == '' ? ig64 : imgc.iMg64.value),
                    BoxFit.fill,
                    myWidth * 100,
                    300,
                  ))),
        ),
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
    );
  }

  Container txtDescriptionImage(String tDescriptionImg) {
    return Container(
      //margin: const EdgeInsets.only(left: 3, right: 3, top: 1),
      padding: const EdgeInsets.all(5),
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
        color: myColorBlueLight,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Obx(
        () => ListView(
          children: [
            ReadMoreText(
              imgc.txtDescription.value==''?tDescriptionImg:imgc.txtDescription.value.capitalized(),
              trimMode: TrimMode.Line,
              trimLines: 8,
              colorClickableText: const Color.fromARGB(255, 30, 64, 233),
              trimCollapsedText: 'Voir plus',
              trimExpandedText: 'Voir moins',
              moreStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Container txtTitreCataloge(String txtCataloge) {
    return Container(
      margin: const EdgeInsets.only(left: 3),
      height: 25,
      width: double.infinity,
      child: Text(
        txtCataloge,
        style: const TextStyle(
          color: myColorBlue,
          fontSize: 17,
          fontFamily: 'Noteworthy-Lt',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Container grdCataloge(double myHeight) {
    return Container(
      margin: const EdgeInsets.only(left: 3, right: 3),
      height: myHeight * 46,
      width: double.infinity,
      child: GridView.builder(
        itemCount: dataPhoto.length,
        itemBuilder: (context, int index) {
          var result = dataPhoto[index];
          var image64 = imgBase64Dec(result['Photo']);

          return ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: GestureDetector(
              onTap: () {
                imgc.fImg64(result['Photo']);
                imgc.fDescription(result['Description']);
              },
              child: myMemoryImage(
                image64,
                BoxFit.fill,
                100,
                300,
              ),
            ),
          );
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 5,
          mainAxisSpacing: 4,
        ),
      ),
    );
  }
}
