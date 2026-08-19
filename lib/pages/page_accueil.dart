import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:ahime/pages/artisan/page_artisan.dart';
import 'package:ahime/pages/hotel/page_hotel.dart';
import 'package:ahime/pages/transport/page_transport.dart';
import 'package:ahime/config/utils/resizable.dart';
import 'package:ahime/config/my_config.dart';
import 'package:url_launcher/url_launcher.dart';

class PageAccueil extends StatelessWidget {
  const PageAccueil({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var myHeight = SizeConfig.safeBlockVertical!;
    var myWidth = SizeConfig.safeBlockHorizontal!;

    return Scaffold(
      backgroundColor: myColorBlue,
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.75,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            _buildDrawerHeader(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildDrawerItem(
                    context,
                    title: 'Accueil',
                    icon: Icons.home_rounded,
                    onTap: () {
                      popPage(context);
                    },
                  ),
                  const SizedBox(height: 6),
                  _buildDrawerItem(
                    context,
                    title: 'Transport',
                    icon: Icons.directions_bus_rounded,
                    onTap: () {
                      popPage(context);
                      pushPage(context, const PageTransport());
                    },
                  ),
                  const SizedBox(height: 6),
                  _buildDrawerItem(
                    context,
                    title: 'Hôtel',
                    icon: Icons.hotel_rounded,
                    onTap: () {
                      popPage(context);
                      pushPage(context, PageHotel());
                    },
                  ),
                  const SizedBox(height: 6),
                  _buildDrawerItem(
                    context,
                    title: 'Artisan',
                    icon: Icons.handyman_rounded,
                    onTap: () {
                      popPage(context);
                      pushPage(context, const PageArtisan());
                    },
                  ),
                  const SizedBox(height: 6),
                  _buildDrawerItem(
                    context,
                    title: 'Immobilier',
                    icon: Icons.apartment_rounded,
                    onTap: () {
                      popPage(context);
                    },
                  ),
                ],
              ),
            ),
            _buildDrawerFooter(context),
          ],
        ),
      ),
      body: DoubleBackToCloseApp(
        //snackBar:fnSnackmsg(context, 'Appuyez à nouveau sur retour pour quitter'),
        snackBar: SnackBar(
            backgroundColor: Colors.black.withValues(alpha: 0.5),
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
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
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

Widget _buildDrawerHeader(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    decoration: const BoxDecoration(
      color: myColorBlue,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(20),
      ),
    ),
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Bienvenue',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Decouvrez nos services',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildDrawerItem(
  BuildContext context, {
  required String title,
  required IconData icon,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: myColorBlueLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: myColorBlue, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400, size: 20),
        ],
      ),
    ),
  );
}

Widget _buildDrawerFooter(BuildContext context) {
  return Container(
    padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
    decoration: BoxDecoration(
      color: myColorBlueLight,
      borderRadius: const BorderRadius.only(
        bottomRight: Radius.circular(20),
      ),
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _socialIcon(context, '$imageUri/Face.png', 'Facebook'),
            const SizedBox(width: 12),
            _socialIcon(context, '$imageUri/what.png', 'WhatsApp'),
            const SizedBox(width: 12),
            _socialIcon(context, '$imageUri/insta.png', 'Instagram'),
            const SizedBox(width: 12),
            _socialIcon(context, '$imageUri/x.png', 'X'),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'Copyright © 2023 Gek expertise',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}

Widget _socialIcon(BuildContext context, String assetPath, String label) {
  return InkWell(
    onTap: () async {
      final urls = {
        'Facebook': 'https://www.facebook.com/ahimeci',
        'WhatsApp': 'https://wa.me/22500000000',
        'Instagram': 'https://www.instagram.com/ahimeci',
        'X': 'https://x.com/ahimeci',
      };
      final url = Uri.parse(urls[label] ?? 'https://www.ahime-ci.com');
      if (await canLaunchUrl(url)) {
        launchURL(url);
      }
    },
    borderRadius: BorderRadius.circular(12),
    child: Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Image.asset(assetPath, width: 22, height: 22),
    ),
  );
}
