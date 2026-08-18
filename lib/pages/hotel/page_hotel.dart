import 'package:ahime/pages/hotel/page_hotelrecherche.dart';
import 'package:flutter/material.dart';
import 'package:ahime/pages/hotel/page_hotelresult.dart';
import 'package:ahime/config/utils/my_navbar.dart';
import 'package:ahime/config/my_config.dart';
import 'package:ahime/config/utils/resizable.dart';
import 'package:ahime/config/utils/slide_img.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ahime/config/getx/updaterusulttext.dart';

double myHeight = 0;
double myWidth = 0;
String dataP = '';

class PageHotel extends StatelessWidget {
  PageHotel({super.key});

  final NbrController nbrC = Get.put(NbrController());
  final txtRechercheController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    myHeight = SizeConfig.safeBlockVertical!;
    myWidth = SizeConfig.safeBlockHorizontal!;

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
                MyNavbar(context: context),
                const SlideImg(imgPath: '$imageUri/HotelS.jpg', title: 'Hôtel'),
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 7, right: 7),
                  child: Column(
                    children: [
                      txtRecherche(context),
                      SizedBox(height: myHeight * 1),
                      ctnMenu(context),
                      SizedBox(height: myHeight * 1),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(left: 9),
                        child: const Text(
                          'Annonce publicitaire',
                          style: TextStyle(
                            color: myColorBlue,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      SizedBox(height: myHeight * 1),
                      myPub(myUrl: 'https://ahime-ci.com/pubhotel'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container ctnMenu(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5),
      width: myWidth * 100,
      height: 95,
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: myColorGreyBorber,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          myBtnMenu('Résidence \n  meublée', '$imageUri/ResidenceA.png', () {
            nbrC.onClose();
            pushPage(context,
                PageHotelResult(xEstResidence: true, titre: 'Résidence'));
          }),
          myBtnMenu('Hôtels', '$imageUri/hotels.png', () {
            nbrC.onClose();
            pushPage(context, PageHotelResult(xEstHotel: true, titre: 'Hôtel'));
          }),
          myBtnMenu('Recherche \n     filtrée', '$imageUri/filtre.png', () {
            nbrC.onClose();
            pushPage(context, PageHotelRecherche());
          }),
        ],
      ),
    );
  }

  Column myBtnMenu(String titre, String imgPath, VoidCallback onClic) => Column(
        children: [
          GestureDetector(
            onTap: onClic,
            child: Container(
              padding: const EdgeInsets.all(10),
              width: 70,
              height: 50,
              decoration: const ShapeDecoration(
                color: myColorBlue,
                shape: StadiumBorder(),
              ),
              child: Image.asset(imgPath),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            titre,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );

  TextField txtRecherche(context) {
    return TextField(
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9\s]+$'))
      ],
      controller: txtRechercheController,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintText: 'Rechercher par mot clé',
        suffixIcon: btnSearch(
          onClic: () {
            nbrC.onClose();
            pushPage(
                context,
                PageHotelResult(
                  xNomEtab: txtRechercheController.text,
                  titre: '',
                ));
          },
        ),
        border: myTextFormBorder(),
        enabledBorder: myTextFormBorder(),
      ),
    );
  }

  OutlineInputBorder myTextFormBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.0),
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.5),
        width: 1.0,
      ),
    );
  }

  Container btnSearch({void Function()? onClic}) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: myColorBlue,
        borderRadius: BorderRadius.circular(5),
      ),
      child: IconButton(
        icon: const Icon(
          Icons.search,
          color: Colors.white,
        ),
        onPressed: onClic,
      ),
    );
  }
}
