//import 'package:ahime/pages/artisan/page_artisancommentaire.dart';
import 'package:flutter/material.dart';
import 'package:ahime/config/my_config.dart';
import 'package:ahime/config/utils/resizable.dart';
import 'package:flutter_rating/flutter_rating.dart';
//import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:readmore/readmore.dart';

class PageArtisanimg extends StatelessWidget {
  const PageArtisanimg({
    super.key,
    required this.result,
  });
  final Map<String, dynamic> result;

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
                myImgDescription(context, myWidth, myHeight),
                myDescription(context, myWidth),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget myImgDescription(
      BuildContext context, double myWidth, double myHeight) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: myWidth * 100,
          height: 340,
          decoration: const BoxDecoration(
            color: myColorBlue,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 170,
                height: 168,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(90),
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Hero(
                    tag: 'img${result['IDARTISANT']}',
                    child: myMemoryImage(
                      imgBase64Dec(result['Photo']),
                      BoxFit.fill,
                      90,
                      90,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${result['Nom']} ${result['Prenom']}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              StarRating(
                rating: double.parse(result['Tnote']),
                color: Colors.white,
                size: 25,
              ),
              const SizedBox(height: 2),
              lngDescription('telw.png', result['Contact'], 15),
              const SizedBox(height: 2),
              lngDescription('whaw.png', result['NumWhatApp'], 15),
              const SizedBox(height: 4),
              myNotecall(context),
            ],
          ),
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
        ),
        Positioned(
          top: 15,
          right: 5,
          child: result['Recommende'] == '1'
              ? Container(
                  margin: const EdgeInsets.only(left: 3, right: 3, top: 1),
                  padding: const EdgeInsets.all(5),
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: myColorBlueLight,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                      child: Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 20,
                  )),
                )
              : SizedBox(),
        )
      ],
    );
  }

  Widget myLocalisation() {
    return Container(
      width: 180,
      height: 40,
      decoration: BoxDecoration(
        color: myColorGreen,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(
        children: [
          txtTitreVille(result['Ville']),
          txtCommuneQuartier(result['Commune'], result['Quartier']),
        ],
      ),
    );
  }

  Widget txtTitreVille(String txtVille) {
    return Text(
      txtVille.toUpperCase(),
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.bold,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget txtCommuneQuartier(String txtCommune, String txtQuartier) {
    return Text(
      '${txtCommune.capitalized()}(${txtQuartier.toLowerCase()})',
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 10,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget myDescription(BuildContext context, double myWidth) {
    return Container(
      width: myWidth * 100,
      height: 430,
      color: myColorWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 100,
            width: myWidth * 100,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                txtMetier(result['Categorie']),
                txtCategorie(result['Libelle']),
                myLocalisation(),
              ],
            ),
          ),
          const SizedBox(height: 6),
          txtDescription(result['Description']),
        ],
      ),
    );
  }

  Widget txtCategorie(String myTitlesub) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        myTitlesub.capitalized(),
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: myColorBlue,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget txtMetier(String myTitle) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        myTitle.toUpperCase(),
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: myColorBlue,
          fontSize: 19,
          fontFamily: 'Noteworthy-Lt',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget txtDescriptionlbl(String myTitle) {
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5),
      child: Text(
        myTitle.capitalized(),
        style: const TextStyle(
          color: myColorBlue,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget txtDescription(String myTitle) {
    return Container(
      width: double.infinity,
      height: 300,
      margin: const EdgeInsets.only(top: 10, left: 5, right: 5),
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView(
        children: [
          ReadMoreText(
            myTitle,
            trimMode: TrimMode.Line,
            trimLines: 6,
            colorClickableText: const Color.fromARGB(255, 30, 64, 233),
            trimCollapsedText: 'Voir plus',
            trimExpandedText: 'Voir moins',
            moreStyle:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget lngDescription(String logo, String txtDescription, double mySize) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      logoIcon('$imageUri/$logo', mySize, mySize),
      const SizedBox(width: 6),
      Text(
        phoneFormat(txtDescription),
        style: TextStyle(
          color: Colors.white,
          fontSize: mySize,
        ),
      )
    ]);
  }

  Row myNotecall(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            launchCALL(result['Contact']);
          },
          child: CircleAvatar(
            radius: 23,
            backgroundColor: Colors.white.withValues(alpha: 0.3),
            child: const Icon(
              Icons.phone_in_talk_sharp,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 30),
        GestureDetector(
          onTap: () {
            //pushPage(context, const PageArtisantCommentaire());
          },
          child: CircleAvatar(
            radius: 23,
            backgroundColor: Colors.white.withValues(alpha: 0.3),
            child: const Icon(
              Icons.chat_bubble_rounded,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
