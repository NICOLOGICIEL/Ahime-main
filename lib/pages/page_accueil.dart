import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:ahime/pages/artisan/page_artisan.dart';
import 'package:ahime/pages/hotel/page_hotel.dart';
import 'package:ahime/pages/transport/page_transport.dart';
import 'package:ahime/config/utils/resizable.dart';
import 'package:ahime/config/my_config.dart';

class PageAccueil extends StatelessWidget {
  const PageAccueil({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var myHeight = SizeConfig.safeBlockVertical!;
    var myWidth = SizeConfig.safeBlockHorizontal!;

    return Scaffold(
      backgroundColor: myColorBlue,
      body: DoubleBackToCloseApp(
        //snackBar:fnSnackmsg(context, 'Appuyez à nouveau sur retour pour quitter'),
        snackBar: SnackBar(
            backgroundColor: Colors.black.withOpacity(0.5),
            margin: const EdgeInsets.all(5),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            content: Text('Appuyez à nouveau sur retour pour quitter')),
        child: SafeArea(
          child: Container(
            width: myWidth * 100,
            height: myHeight * 100,
            color: myColorWhite,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: myHeight * 1),
                  headBar(),
                  SizedBox(height: myHeight * 1),
                  myPub(myUrl: 'https://ahime-ci.com/slideshow'),
                  SizedBox(height: myHeight * 1),
                  textCategorie(),
                  SizedBox(height: myHeight * 1),
                  listCategorie(),
                  textNosPartenaire(myHeight),
                  logoSociete(),
                  SizedBox(height: myHeight * 3),
                  MyFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class listCategorie extends StatelessWidget {
  const listCategorie({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var myHeight = SizeConfig.safeBlockVertical!;
    var myWidth = SizeConfig.safeBlockHorizontal!;

    return Container(
      width: myWidth * 100,
      height: myHeight * 14.2,
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            sizeSpace(),
            cardCategorie('TRANSPORT', '$imageUri/transport.png', 60, 50, () {
              pushPage(context, const PageTransport());
            }),
            sizeSpace(),
            cardCategorie('HÔTEL', '$imageUri/hotels.png', 45, 45, () {
              pushPage(context, PageHotel());
            }),
            sizeSpace(),
            cardCategorie('ARTISAN', '$imageUri/artisan.png', 70, 70, () {
              pushPage(context, PageArtisan());
            }),
            sizeSpace(),
            cardCategorie(
                'IMMOBILIER', '$imageUri/immobilier.png', 50, 60, () {}),
            sizeSpace(),
          ],
        ),
      ),
    );
  }

  SizedBox sizeSpace() => const SizedBox(width: 6.5);

  GestureDetector cardCategorie(String titreCard, String imagePath,
      double largeur, double hauteur, VoidCallback onClic) {
    //SizeConfig().init(context);
    var myHeight = SizeConfig.safeBlockVertical!;
    var myWidth = SizeConfig.safeBlockHorizontal!;

    return GestureDetector(
      onTap: onClic,
      child: Container(
        width: myWidth * 31,
        height: myHeight * 15,
        decoration: BoxDecoration(
          color: Colors.white, // Background color
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Container(
              width: myWidth * 31,
              height: myHeight * 10,
              decoration: const BoxDecoration(
                color: myColorBlue, // Background color
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Center(
                child: Image.asset(imagePath, width: largeur, height: hauteur),
              ),
            ),
            Container(
              width: myWidth * 31,
              height: myHeight * 4,
              decoration: const BoxDecoration(
                color: myColorGreen, // Background color
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Center(
                child: Text(
                  titreCard,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyFooter extends StatelessWidget {
  const MyFooter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var myWidth = SizeConfig.safeBlockHorizontal!;

    return Container(
      width: myWidth * 100,
      height: 62,
      color: Colors.white,
      child: (Column(
        children: [
          const Text(
            'Retrouvez-nous sur',
            style: TextStyle(
              color: myColorBlue,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              logoIcon('$imageUri/Face.png', 30, 30),
              SizedBox(width: myWidth * 2),
              logoIcon('$imageUri/what.png', 30, 30),
              SizedBox(width: myWidth * 2),
              logoIcon('$imageUri/insta.png', 30, 30),
              SizedBox(width: myWidth * 2),
              logoIcon('$imageUri/x.png', 30, 30),
            ],
          ),
          const Text(
            'Copyright © 2023 Gek expertise',
            style: TextStyle(
              color: myColorBlue,
              fontSize: 9,
            ),
          ),
        ],
      )),
    );
  }
}

Container textNosPartenaire(myheight) => Container(
      alignment: Alignment.center,
      width: 150,
      height: myheight * 5,
      child: const Text(
        'Nos partenaires',
        style: TextStyle(
          color: Colors.black,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

Container textCategorie() => Container(
      alignment: Alignment.center,
      width: 135,
      height: 24,
      decoration: BoxDecoration(
        color: myColorGreen, // Background color
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'Catégories',
        style: TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

// ignore: camel_case_types
class headBar extends StatelessWidget {
  const headBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var myWidth = SizeConfig.safeBlockHorizontal!;

    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      width: myWidth * 95,
      height: 100,
      decoration: BoxDecoration(
        color: myColorBlue, // Background color
        borderRadius: BorderRadius.circular(20),
      ),
      child: (Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              width: 70,
              height: 70,
              color: Colors.grey[300],
              child: Image.asset('$imageUri/ahime.jpg', fit: BoxFit.fill)),
          const Text(
            "Bienvenue",
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: () {},
            child: SizedBox(
              child: Image.asset('$imageUri/IcMenu.png', width: 30, height: 30),
            ),
          ),
        ],
      )),
    );
  }
}

// ignore: camel_case_types
class logoSociete extends StatelessWidget {
  const logoSociete({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          logoS("$imageUri/gek.jpg"),
          logoS("$imageUri/logoahime.jpg"),
          logoS("$imageUri/aim.jpg"),
        ],
      ),
    );
  }

  Container logoS(String imagePath) {
    var myHeight = SizeConfig.safeBlockVertical!;
    var myWidth = SizeConfig.safeBlockHorizontal!;
    return Container(
      width: myWidth * 27,
      height: myHeight * 13,
      color: Colors.grey[300],
      child: Image.asset(imagePath, fit: BoxFit.fill),
    );
  }
}
