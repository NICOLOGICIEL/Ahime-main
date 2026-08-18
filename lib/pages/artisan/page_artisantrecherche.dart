import 'package:ahime/config/utils/dropdownlist.dart';
import 'package:ahime/config/utils/my_navbar.dart';
import 'package:ahime/config/utils/my_titlerusult.dart';
import 'package:ahime/config/utils/resizable.dart';
import 'package:ahime/pages/artisan/page_artisanresult.dart';
import 'package:flutter/material.dart';
import 'package:ahime/config/my_config.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ahime/config/getx/updaterusulttext.dart';

class PageArtisantRecherche extends StatefulWidget {
  const PageArtisantRecherche({super.key});

  @override
  State<PageArtisantRecherche> createState() => _PageArtisantRechercheState();
}

class _PageArtisantRechercheState extends State<PageArtisantRecherche> {
  final NbrController nbrC = Get.put(NbrController());

  TextEditingController txtCommunecontroller = TextEditingController();
  TextEditingController txtQuartiercontroller = TextEditingController();

  double notNote = 0;

  MyListf cmbVille = MyListf('');
  MyListf cmbMetier = MyListf('');
  MyListf cmbCategorie = MyListf('');

  void changeMetierValue(value) {
    cmbMetier = value;
  }

  void changeCategorieValue(value) {
    cmbCategorie = value;
  }

  void changeVilleValue(value) {
    cmbVille = value;
  }

  void changeNote(double? value) {
    setState(() {
      notNote = value!;
    });
  }

  @override
  void initState() {
    super.initState();
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
                tltTitle(myTitle: 'Recherche artisan'),
                SizedBox(height: 22),
                mySearchtxt('Metier', listMetier, changeMetierValue),
                SizedBox(height: 4),
                mySearchtxt('Catégorie', listCat, changeCategorieValue),
                SizedBox(height: 4),
                mySearchtxt('Ville', listVille, changeVilleValue),
                SizedBox(height: 4),
                mySaisie('Commune', true, txtCommunecontroller),
                SizedBox(height: 4),
                mySaisie('Quartier', true, txtQuartiercontroller),
                SizedBox(height: 10),
                myRating(notNote, changeNote),
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

  myRating(double note, void Function(double) onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 22),
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
              PageArtisantResult(
                xMetier: cmbMetier.name,
                xCategorie: cmbCategorie.name,
                xVille: cmbVille.name,
                xCommune: txtCommunecontroller.text,
                xQuartier: txtQuartiercontroller.text,
                xnoteEtoile: notNote,
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
