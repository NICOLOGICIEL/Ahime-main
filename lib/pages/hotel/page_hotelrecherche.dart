import 'package:ahime/config/utils/dropdownlist.dart';
import 'package:ahime/config/utils/my_navbar.dart';
import 'package:ahime/config/utils/my_titlerusult.dart';
import 'package:ahime/config/utils/resizable.dart';
import 'package:ahime/pages/hotel/page_hotelresult.dart';
import 'package:flutter/material.dart';
import 'package:ahime/config/my_config.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';
import 'package:ahime/config/getx/updaterusulttext.dart';


class PageHotelRecherche extends StatefulWidget {
  const PageHotelRecherche({super.key});

  @override
  State<PageHotelRecherche> createState() => _PageHotelRechercheState();
}

class _PageHotelRechercheState extends State<PageHotelRecherche> {
  final NbrController nbrC = Get.put(NbrController());
  final txtPrixcontroller = MoneyMaskedTextController(
      initialValue: 0,
      decimalSeparator: '',
      thousandSeparator: ' ',
      precision: 0);
  TextEditingController txtCommunecontroller = TextEditingController();
  TextEditingController txtQuartiercontroller = TextEditingController();

  bool chkHotel = false;
  bool chkResidence = false;
  bool chkNote = false;
  bool chkWifi = false;
  bool chkPiscine = false;
  bool chkBar = false;
  bool chkGarage = false;
  bool chkVentilateur = false;
  bool chkClimatiseur = false;
  double notNote = 0;

  MyListf cmbVille = MyListf('');

  void changeSelectedValue(value) {
    cmbVille = value;
  }

  void changechkClimatiseur(bool? value) {
    setState(() {
      chkClimatiseur = value!;
    });
  }

  void changechkWifi(bool? value) {
    setState(() {
      chkWifi = value!;
    });
  }

  void changechkPiscine(bool? value) {
    setState(() {
      chkPiscine = value!;
    });
  }

  void changechkBar(bool? value) {
    setState(() {
      chkBar = value!;
    });
  }

  void changechkGarage(bool? value) {
    setState(() {
      chkGarage = value!;
    });
  }

  void changechkVentilateur(bool? value) {
    setState(() {
      chkVentilateur = value!;
    });
  }

  void changechkNote(bool? value) {
    setState(() {
      if (value == false) {
        notNote = 0;
      }
      chkNote = value!;
    });
  }

  void changechkResidence(bool? value) {
    setState(() {
      chkResidence = value!;
    });
  }

  void changechkHotel(bool? value) {
    setState(() {
      chkHotel = value!;
    });
  }

  void changeNote(double? value) {
    setState(() {
      if (chkNote == true) {
        notNote = value!;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    txtPrixcontroller.clear();
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
                tltTitle(myTitle: 'Recherche filtrée'),
                SizedBox(height: 8),
                mySaisie('Prix maximum', false, txtPrixcontroller),
                SizedBox(height: 1),
                mySearchtxt('Ville', listVille, changeSelectedValue),
                SizedBox(height: 1),
                mySaisie('Commune', true, txtCommunecontroller),
                SizedBox(height: 1),
                mySaisie('Quartier', true, txtQuartiercontroller),
                SizedBox(height: 1),
                textTypeCom('Type'),
                SizedBox(height: 1),
                typeCont(myWidth),
                SizedBox(height: 1),
                textTypeCom('Commodité'),
                SizedBox(height: 1),
                commoditeCont(myWidth),
                SizedBox(height: 12),
                myBtn(context),
                SizedBox(height: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container commoditeCont(double myWidth) {
    return Container(
      width: myWidth * 89,
      height: 144,
      decoration: BoxDecoration(
          color: myColorBgGrey, borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              chkBoxIcon('Ventilateur', chkVentilateur, 'ventilateur.png',
                  changechkVentilateur),
              chkBoxIcon('Climatiseur', chkClimatiseur, 'climatiseur.png',
                  changechkClimatiseur),
            ],
          ),
          Row(
            children: [
              chkBoxIcon('Wifi', chkWifi, 'wifi.png', changechkWifi),
              chkBoxIcon(
                  'Piscine', chkPiscine, 'piscine.png', changechkPiscine),
            ],
          ),
          Row(
            children: [
              chkBoxIcon('Resto-Bar', chkBar, 'resto-bar.png', changechkBar),
              chkBoxIcon('Garage', chkGarage, 'garage.png', changechkGarage),
            ],
          ),
        ],
      ),
    );
  }

  Container typeCont(double myWidth) {
    return Container(
      width: myWidth * 89,
      height: 96,
      decoration: BoxDecoration(
          color: myColorBgGrey, borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              chkBox('Hotel', chkHotel, changechkHotel),
              SizedBox(width: 10),
              chkBox('Résidence meublée', chkResidence, changechkResidence),
            ],
          ),
          Row(
            children: [
              Checkbox(value: chkNote, onChanged: changechkNote),
              SizedBox(width: 10),
              myRating(notNote, changeNote),
            ],
          ),
        ],
      ),
    );
  }

  myRating(double note, void Function(double) onChanged) {
    return Row(
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
    );
  }

  Row chkBox(String txtChkBox, bool chkHotel,
      void Function(bool? value) changechkHotel) {
    return Row(
      children: [
        Checkbox(value: chkHotel, onChanged: changechkHotel),
        Text(
          txtChkBox,
          style: TextStyle(
            color: myColorBlue,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Row chkBoxIcon(String txtChkBox, bool chkHotel, String chkImg,
      void Function(bool? value) changechkHotel) {
    return Row(
      children: [
        Checkbox(value: chkHotel, onChanged: changechkHotel),
        SizedBox(
          width: 82,
          child: Text(
            txtChkBox,
            style: TextStyle(
              color: myColorBlue,
              fontSize: 15,
            ),
          ),
        ),
        SizedBox(width: 3),
        Image.asset(
          '$imageUri/$chkImg',
          width: 20,
          height: 20,
        ),
      ],
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

  Container textTypeCom(String txttext) => Container(
        alignment: Alignment.center,
        width: 150,
        height: 22,
        child: Text(
          txttext,
          style: TextStyle(
            color: myColorBlue,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  myBtn(BuildContext context, {String txtBtn = 'Rechercher'}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          nbrC.onClose();
          pushPage(
              context,
              PageHotelResult(
                titre: '',
                xPrix: txtPrixcontroller.text.isEmpty
                    ? 0
                    : txtPrixcontroller
                        .numberValue, //double.parse(txtPrixcontroller.text),
                xVille: cmbVille.name,
                xCommune: txtCommunecontroller.text,
                xQuartier: txtQuartiercontroller.text,
                xEstHotel: chkHotel,
                xEstResidence: chkResidence,
                xNbrEtoile: chkNote,
                xnoteEtoile: notNote,
                xVentilateur: chkVentilateur,
                xClimatiseur: chkClimatiseur,
                xWifi: chkWifi,
                xPiscine: chkPiscine,
                xBar: chkBar,
                xSpa: chkGarage,
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
}
