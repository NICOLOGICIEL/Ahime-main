// ignore_for_file: non_constant_identifier_names

import 'package:ahime/config/getx/updaterusulttext.dart';
import 'package:ahime/pages/artisan/page_artisanresult.dart';
import 'package:ahime/config/getx/updatescreen.dart';
import 'package:ahime/pages/artisan/page_artisantrecherche.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ahime/config/utils/dropdownlist.dart';
import 'package:ahime/config/utils/my_navbar.dart';
import 'package:ahime/config/utils/resizable.dart';
import 'package:ahime/config/my_config.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide FormData;
import 'package:platform_detector/platform_detector.dart';
import 'package:text_scroll/text_scroll.dart';

// ignore: must_be_immutable
class PageArtisan extends StatefulWidget {
  const PageArtisan({super.key});

  @override
  State<PageArtisan> createState() => _PageArtisanState();
}

class _PageArtisanState extends State<PageArtisan> {
  //
  final ChkController rateNote = Get.put(ChkController());
  final NbrController AfficheR = Get.put(NbrController());
  final TextEditingController txtCommunecontroller = TextEditingController();
  final TextEditingController txtQuartiercontroller = TextEditingController();

  MyListf cmbMetier = MyListf('');
  MyListf cmbCategorie = MyListf('');
  MyListf cmbVille = MyListf('');

  void changeMetierValue(value) {
    cmbMetier = value;
  }

  void changeCategorieValue(value) {
    cmbCategorie = value;
  }

  void changeVilleValue(value) {
    cmbVille = value;
  }

  @override
  void initState() {
    super.initState();
    getdataAll('SELECT * FROM categoriemetier', 'SELECT * FROM metier');
  }

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
                MyNavbar(context: context),
                SlideImgA(
                    context: context,
                    imgPath: '$imageUri/ArtisanS.jpg',
                    title: 'Artisan'),
                scrollWarning(myWidth, myHeight),
                ctnMenu(context),
                SizedBox(height: 2),
                Padding(
                  padding: const EdgeInsets.only(left: 3, right: 3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      myPubText('Annonce publicitaire'),
                      SizedBox(height: myHeight * 0.5),
                      myPub(myUrl: 'https://ahime-ci.com/pubhotel'),
                    ],
                  ),
                ),
                const SizedBox(height: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Text myPubText(String txLibelle) {
    return Text(
      txLibelle,
      style: const TextStyle(
        color: myColorBlue,
        fontSize: 13,
      ),
    );
  }

  Container scrollWarning(double myWidth, double myHeight) {
    return Container(
      width: myWidth * 100,
      height: 25,
      color: Colors.white,
      child: Row(
        children: [
          imgWarning(),
          Expanded(
            child: lblWarning(),
          ),
          imgWarning(),
        ],
      ),
    );
  }

  Container lblWarning() {
    return Container(
      width: 80,
      height: 30,
      color: Colors.white,
      child: const TextScroll(
        " La confiance n'exclut pas le contrôle nous vous invitons a adopter la bonne attitude, régler après la prestation et à voir notre condition générale d'utilisation article 4.",
        velocity: Velocity(pixelsPerSecond: Offset(30, 0)),
        mode: TextScrollMode.endless,
        style: TextStyle(
          color: Color.fromARGB(255, 236, 13, 13),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Container imgWarning() {
    return Container(
      padding: const EdgeInsets.all(2),
      width: 30,
      height: 30,
      child: Image.asset(
        '$imageUri/warning.png',
        fit: BoxFit.fill,
      ),
    );
  }

  SlideImgA({
    required BuildContext context,
    required String imgPath,
    required String title,
  }) {
    SizeConfig().init(context);
    var myWidth = SizeConfig.safeBlockHorizontal!;
    return Container(
      height: 235,
      width: myWidth * 100,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(imgPath), fit: BoxFit.fill),
      ),
      child: Column(
        children: [
          SizedBox(height: 30),
          Text(
            title,
            style: TextStyle(
                fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 72),
          btnRechercher(context, () {
            if (isMobile()) {
              displayBottomSheet(context, SizeConfig.safeBlockVertical!);
            }
            if (isWeb()) {
              pushPage(context, PageArtisantRecherche());
            }
          })
        ],
      ),
    );
  }

  GestureDetector btnRechercher(context, onClic) {
    SizeConfig().init(context);
    var myWidth = SizeConfig.safeBlockHorizontal!;

    return GestureDetector(
      onTap: onClic,
      child: Container(
        width: myWidth * 80,
        height: 60,
        decoration: BoxDecoration(
          color: myColorBlue, // Background color
          borderRadius: BorderRadius.circular(40),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              color: Colors.white,
              size: 30.0,
            ),
            Text('Rechercher un métier',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ))
          ],
        ),
      ),
    );
  }

//}
  Container ctnMenu(BuildContext context) {
    SizeConfig().init(context);
    var myWidth = SizeConfig.safeBlockHorizontal!;

    return Container(
      padding: const EdgeInsets.only(top: 5),
      width: myWidth * 100,
      height: 80,
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            sizeSpace(),
            myBtnMenu('Environnement', '$imageUri/environnement.png', () {
              AfficheR.tTotal(0);
              pushPage(
                  context, PageArtisantResult(xCategorie: 'Environnement'));
            }),
            sizeSpace(),
            myBtnMenu('Automobile', '$imageUri/auto.png', () {
              AfficheR.tTotal(0);
              pushPage(context, PageArtisantResult(xCategorie: 'Automobile'));
            }),
            sizeSpace(),
            myBtnMenu('Technologie', '$imageUri/technologie.png', () {
              AfficheR.tTotal(0);
              pushPage(context, PageArtisantResult(xCategorie: 'Technologie'));
            }),
            sizeSpace(),
            myBtnMenu('Bâtiment', '$imageUri/batiment.png', () {
              AfficheR.tTotal(0);
              pushPage(context, PageArtisantResult(xCategorie: 'Bâtiment'));
            }),
            sizeSpace(),
            myBtnMenu('Sécurité', '$imageUri/securite.png', () {
              AfficheR.tTotal(0);
              pushPage(context, PageArtisantResult(xCategorie: 'Sécurité'));
            }),
            sizeSpace(),
            myBtnMenu('Transport', '$imageUri/transport.png', () {
              AfficheR.tTotal(0);
              pushPage(context, PageArtisantResult(xCategorie: 'Transport'));
            }),
            sizeSpace(),
            myBtnMenu('Autres', '$imageUri/autre.png', () {
              AfficheR.tTotal(0);
              pushPage(context, PageArtisantResult(xCategorie: 'Autres'));
            }),
            sizeSpace(),
          ],
        ),
      ),
    );
  }

  SizedBox sizeSpace() => const SizedBox(width: 16);

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

  void displayBottomSheet(BuildContext context, double myHeight) {
    showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: myHeight * 75,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: [
              myHeader(),
              SizedBox(height: 20),
              myBody(context),
            ],
          ),
        );
      },
    );
  }

  myHeader() {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: const BoxDecoration(
        color: myColorBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Recherche',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Noteworthy-Lt'),
          ),
          Image.asset('$imageUri/search.png', width: 60, height: 60),
        ],
      ),
    );
  }

  myBody(BuildContext context) {
    return Flexible(
      child: ListView(
        children: [
          mySearchtxt('Métier', listMetier, changeMetierValue),
          SizedBox(height: 3),
          mySearchtxt('Catégorie', listCat, changeCategorieValue),
          SizedBox(height: 3),
          mySearchtxt('Ville', listVille, changeVilleValue),
          SizedBox(height: 3),
          mySaisie('Commune', true, txtCommunecontroller),
          SizedBox(height: 3),
          mySaisie('Quartier', true, txtQuartiercontroller),
          SizedBox(height: 10),
          Obx(() => myRating(rateNote.notNote.value, rateNote.changeNote)),
          SizedBox(height: 14),
          myBtn(context, txtBtn: 'Rechercher'),
          SizedBox(height: 6),
        ],
      ),
    );
  }

  myRating(double note, void Function(double) onChanged) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ntEtoile(
              note: note,
              taille: 24,
              myBorderColor: myColorGreyBorber,
              onChanged: onChanged),
          Text(
            '(Nombre d\'étoiles)',
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 13,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  myBtn(BuildContext context, {String txtBtn = 'Rechercher'}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          pushPage(
              context,
              PageArtisantResult(
                xMetier: cmbMetier.name,
                xCategorie: cmbCategorie.name,
                xVille: cmbVille.name,
                xCommune: txtCommunecontroller.text,
                xQuartier: txtQuartiercontroller.text,
                xnoteEtoile: rateNote.notNote.value,
              ));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: myColorBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(80),
          ),
        ),
        child: Text(
          txtBtn,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  mySearchtxt(String txLibelle, List<MyListf> myItems,
      dynamic Function(MyListf?)? onChanged) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '    $txLibelle',
            textAlign: TextAlign.start,
            style: TextStyle(
              color: myColorBlue,
              fontSize: 14,
            ),
          ),
          SearchDropdown(
            myItems: myItems,
            myhintText: "",
            onChanged: onChanged,
            headerFontSize: 14,
          ),
        ],
      ),
    );
  }

  mySaisie(String txLibelle, bool isText, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '        $txLibelle',
          textAlign: TextAlign.start,
          style: const TextStyle(
            color: myColorBlue,
            fontSize: 14,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 25),
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              filled: true,
              fillColor: myColorBgGrey,
              contentPadding: EdgeInsets.symmetric(horizontal: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide.none,
              ),
            ),
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
            textAlign: TextAlign.start,
            keyboardType: isText ? TextInputType.text : TextInputType.number,
            inputFormatters: isText
                ? [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^[a-zA-Z0-9\s]+$'))
                  ]
                : [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
            cursorColor: myColorBlue,
          ),
        )
      ],
    );
  }

  Future<void> getdataAll(String mReq1, String mReq2) async {
    Dio dio = Dio();
    List category = [];
    List job = [];

    FormData formData = FormData.fromMap(dataMulti(mReq1: mReq1, mReq2: mReq2));
    return dio.post(apiurl, data: formData).then((response) {
      var data1 = response.data['result1'];
      var data2 = response.data['result2'];
      if ((data1 != null && data1.isNotEmpty) ||
          (data2 != null && data2.isNotEmpty)) {
        category.addAll(data1.map((item) => item['Categorie']));
        job.addAll(data2.map((item) => item['Libelle']));

        for (var name in category) {
          listCat.add(MyListf(name));
        }
        for (var name in job) {
          listMetier.add(MyListf(name));
        }
      }
    });
  }
}
