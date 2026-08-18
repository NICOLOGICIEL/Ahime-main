import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart' hide FormData;
//import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:ahime/config/my_config.dart';
import 'package:ahime/config/utils/resizable.dart';
import 'package:ahime/pages/hotel/page_h.dart';
import 'package:ahime/pages/hotel/page_hotelimgdetail.dart';
import 'package:readmore/readmore.dart';
import 'package:ahime/config/getx/updateimg.dart';

class PageDetailH extends StatelessWidget {
  const PageDetailH({
    super.key,
    required this.idHotel,
    required this.nomEtab,
    required this.nomVille,
    required this.nomCommune,
    required this.nomQuartier,
    required this.nLongitude,
    required this.nLatitude,
    required this.prixMini,
    required this.img64,
    required this.contact,
    required this.numWhatApp,
    required this.situation,
    required this.description,
    required this.nbEtoile,
    required this.wifi,
    required this.piscine,
    required this.ventilateur,
    required this.climatiseur,
    required this.restoBar,
    required this.garage,
  });
  final int idHotel;
  final String nomEtab;
  final String nomVille;
  final String nomCommune;
  final String nomQuartier;
  final String nLongitude;
  final String nLatitude;
  final String prixMini;
  // ignore: prefer_typing_uninitialized_variables
  final img64;
  final String contact;
  final String numWhatApp;
  final String situation;
  final String description;
  final double nbEtoile;
  final int wifi;
  final int piscine;
  final int ventilateur;
  final int climatiseur;
  final int restoBar;
  final int garage;

  @override
  Widget build(BuildContext context) {
    return PageH(
      myTitle: 'Détails',
      myPage: Details(
        idhotel: idHotel,
        nomEtab: nomEtab,
        nomVille: nomVille,
        nomCommune: nomCommune,
        nomQuartier: nomQuartier,
        nLongitude: nLongitude,
        nLatitude: nLatitude,
        prixMini: prixMini,
        img64: img64,
        contact: contact,
        numWhatApp: numWhatApp,
        situation: situation,
        description: description,
        nbEtoile: nbEtoile,
        wifi: wifi,
        piscine: piscine,
        ventilateur: ventilateur,
        climatiseur: climatiseur,
        restoBar: restoBar,
        garage: garage,
      ),
    );
  }
}

class Details extends StatefulWidget {
  const Details({
    super.key,
    required this.idhotel,
    required this.nomEtab,
    required this.nomVille,
    required this.nomCommune,
    required this.nomQuartier,
    required this.nLongitude,
    required this.nLatitude,
    required this.prixMini,
    required this.img64,
    required this.contact,
    required this.numWhatApp,
    required this.situation,
    required this.description,
    required this.nbEtoile,
    required this.wifi,
    required this.piscine,
    required this.ventilateur,
    required this.climatiseur,
    required this.restoBar,
    required this.garage,
  });
  final int idhotel;
  final String nomEtab;
  final String nomVille;
  final String nomCommune;
  final String nomQuartier;
  final String nLongitude;
  final String nLatitude;
  final String prixMini;
  //final Uint8List img64;
  // ignore: prefer_typing_uninitialized_variables
  final img64;
  final String contact;
  final String numWhatApp;
  final String situation;
  final String description;
  final double nbEtoile;
  final int wifi;
  final int piscine;
  final int ventilateur;
  final int climatiseur;
  final int restoBar;
  final int garage;

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  List jsonData = []; // Tableau pour stocker les données JSON

  // Map pour stocker les données JSON

  Future<void> postdata(int iDhotel) async {
    Dio dio = Dio(); // Créer une instance de Dio
    dio.options.headers['content-Type'] = 'application/json';
    final url = '$APIServeur$endpoint';
    //final  url = Uri.https(apiBaseURL,endpoint);

    Map<String, dynamic> data = {
      'data_action': 'EnvoiRequete',
      'Requete': 'SELECT * FROM imagehotel WHERE IDHOTEL=$iDhotel'
    };

    FormData formData = FormData.fromMap(data);

    try {
      var response = await dio.post(
        url,
        data: formData,
      );

      if (response.statusCode == 200) {
        setState(() {
          jsonData = response.data;
        });
      } else {
        throw Exception('Échec de l\'envoi des données ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de réseau : $e');
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      postdata(widget.idhotel);
    });
  }

  final ImgController imgc = Get.put(ImgController());

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var myHeight = SizeConfig.safeBlockVertical!;
    var myWidth = SizeConfig.safeBlockHorizontal!;
    var myBtnHeight = 42.0;

    imgc.fImg64('');
    imgc.fDescription('');

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8, left: 3, right: 3),
          width: myWidth * 100,
          height: 430,
          decoration: const BoxDecoration(
            color: myColorWhite,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            border: Border(
              left: BorderSide(width: 1, color: myColorBlue),
              right: BorderSide(width: 1, color: myColorBlue),
              top: BorderSide(width: 1, color: myColorBlue),
            ),
          ),
          child: Column(
            children: [
              txtTitrehotel(widget.nomEtab),
              txtTitreVille(widget.nomVille),
              txtCommuneQuartier(widget.nomCommune, widget.nomQuartier),
              Hero(tag: 'img${widget.idhotel}',
                child: myImgDescription(context, myWidth, myHeight, widget.img64,
                    jsonData.length, jsonData),
              ),
              wgdPrixEtoile(widget.prixMini, widget.nbEtoile),
              wgdDescriptionCommodite(
                  context,
                  widget.contact,
                  widget.numWhatApp,
                  widget.situation,
                  widget.wifi,
                  widget.piscine,
                  widget.ventilateur,
                  widget.climatiseur,
                  widget.restoBar,
                  widget.garage,
                  widget.nLongitude,
                  widget.nLatitude),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 3, right: 3),
          width: myWidth * 100,
          height: myBtnHeight,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            border: Border(
              left: BorderSide(width: 1, color: myColorBlue),
              right: BorderSide(width: 1, color: myColorBlue),
              bottom: BorderSide(width: 1, color: myColorBlue),
            ),
          ),
          child: myBtnBox(myBtnHeight, myWidth, widget.contact),
        ),
        myLnDescription(myHeight, myWidth, widget.description),
        const SizedBox(height: 2)
      ],
    );
  }

  Container myImgDescription(
    BuildContext context,
    double myWidth,
    double myHeight,
    img,
    int nbPhoto,
    List<dynamic> dataPhoto,
  ) {
    return Container(
      margin: const EdgeInsets.only(left: 3, right: 3),
      child: GestureDetector(
        onTap: () {
          nbPhoto == 0
              ? null
              : pushPage(context, PageHotelimg(dataPhoto: dataPhoto));
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: myMemoryImage(
                img,
                BoxFit.fill,
                myWidth * 100,
                255,
              ),
            ),
            Positioned(
              top: -10,
              right: 0,
              child: Container(
                alignment: Alignment.center,
                width: 30,
                height: 25,
                decoration: BoxDecoration(
                  color: myColorGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: nbPhoto == 0
                    ? const SpinKitDoubleBounce(
                        color: myColorWhite,
                        size: 14,
                      )
                    : Text(
                        '+$nbPhoto',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Container wgdPrixEtoile(String prix, double nbEtoile) {
    return Container(
      margin: const EdgeInsets.only(left: 3, right: 3, top: 2),
      padding: const EdgeInsets.only(left: 4, right: 4),
      height: 20,
      width: double.infinity,
      decoration: BoxDecoration(
        color: myColorBlueLight,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        nbrEtoile(nbEtoile),
        spnPrixnuit(moneyFormat(prix)),
      ]),
    );
  }

  Row myBtnBox(double myButtonHeight, double myWidth, String myNumberPhone) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: myButtonHeight,
            decoration: const BoxDecoration(
              color: myColorBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(19),
              ),
              border: Border(
                left: BorderSide(width: 1, color: myColorBlue),
              ),
            ),
            child: GestureDetector(
                onTap: () {
                  launchCALL(myNumberPhone);
                },
                child: myBtn(Icons.call, 'Appelez-nous')),
          ),
        ),
        Container(
          width: myWidth * 50,
          height: myButtonHeight,
          decoration: const BoxDecoration(
            color: myColorGreen,
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(19),
            ),
          ),
          child: myBtn(Icons.edit_rounded, 'Notez-nous'),
        ),
      ],
    );
  }

  Row myBtn(IconData icon, String txtBtn) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(width: 3),
        Text(
          txtBtn,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }

  Row myLnDescription(double myHeight, double myWidth, String description) {
    double boxLarg = 114;
    double boxHaut = 17;

    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8, left: 3),
          width: boxLarg,
          height: myHeight * boxHaut,
          child: cardVote('0', boxLarg, () {}),
        ),
        SizedBox(width: myWidth * 1),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(top: 8, right: 3),
            height: myHeight * boxHaut,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListView(
              padding: const EdgeInsets.all(5),
              children: [
                ReadMoreText(
                  description.capitalized(),
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
          ),
        ),
      ],
    );
  }
}

GestureDetector cardVote(String numCard, double boxLarg, VoidCallback onClic) {
  var myHeight = SizeConfig.safeBlockVertical!;

  return GestureDetector(
    onTap: onClic,
    child: Column(
      children: [
        Container(
          width: boxLarg,
          height: myHeight * 13,
          decoration: const BoxDecoration(
            color: myColorBlue, // Background color
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Center(
            child: Text(
              numCard,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Container(
          width: boxLarg,
          height: myHeight * 4,
          decoration: const BoxDecoration(
            color: myColorBlue2, // Background color
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: const Center(
            child: Text(
              'VOTE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Text txtTitrehotel(String myTitle) {
  return (Text(
    myTitle.toUpperCase(),
    textAlign: TextAlign.center,
    style: const TextStyle(
      color: myColorBlue,
      fontSize: 17,
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
    ),
  ));
}

nbrEtoile(double rating) {
  return StarRating(
    rating: rating,
    size: 16,
    borderColor: const Color.fromARGB(255, 233, 233, 233),
  );
}

Row wgdDescriptionCommodite(
  BuildContext context,
  String contact,
  String numWhatApp,
  String situation,
  int wifi,
  int piscine,
  int ventilateur,
  int climatiseur,
  int restoBar,
  int garage,
  String nLongitude,
  String nLatitude,
) {
  return Row(children: [
    Expanded(
        child: wgdDescription(
            context, contact, numWhatApp, situation, nLongitude, nLatitude)),
    const SizedBox(width: 2),
    wgdCommodite(
      wifi: wifi,
      piscine: piscine,
      ventilateur: ventilateur,
      climatiseur: climatiseur,
      restoBar: restoBar,
      garage: garage,
    ),
  ]);
}

Container wgdDescription(context, String contact, String numWhatApp,
    String situation, String nLongitude, String nLatitude) {
  return Container(
    margin: const EdgeInsets.only(left: 3, top: 2),
    padding: const EdgeInsets.only(left: 4, right: 4, top: 5),
    height: 98,
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(5),
      border: Border.all(width: 1, color: myColorGreyBorber),
    ),
    child: Row(children: [
      Expanded(
        child: Column(
          children: [
            lngDescription('telwb.png', contact),
            lngDescription('whawb.png', numWhatApp),
            GestureDetector(
              onTap: () {
                copyClipBord(
                  context: context,
                  txtCopy: '$nLatitude,$nLongitude',
                  msgCopy: "Coordonnées GPS copiées dans le presse-papier",
                );
              },
              child: lngDescriptionGPS(
                  'positiongps.png', '$nLatitude ; $nLongitude'),
            ),
            lngDescriptionPosition(situation),
          ],
        ),
      ),
      GestureDetector(
        onTap: () {
          glMAPS(nLatitude, nLongitude);
        },
        onLongPress: () {
          defMAPS(nLatitude, nLongitude);
        },
        child: Container(
          alignment: Alignment.bottomCenter,
          child: Image.asset(
            '$imageUri/gps.png',
            width: 40,
            height: 40,
          ),
        ),
      ),
    ]),
  );
}

Row lngDescription(String logo, String txtDescription) {
  return Row(children: [
    logoIcon('$imageUri/$logo', 12, 12),
    const SizedBox(width: 1),
    Text(
      phoneFormat(txtDescription),
      style: const TextStyle(
        color: myColorBlue,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    )
  ]);
}

Row lngDescriptionGPS(String logo, String txtDescription) {
  return Row(children: [
    logoIcon('$imageUri/$logo', 12, 12),
    const SizedBox(width: 1),
    Text(
      txtDescription,
      style: const TextStyle(
        color: myColorBlue,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    )
  ]);
}

Expanded lngDescriptionPosition(String situation) {
  return Expanded(
    child: Container(
      margin: const EdgeInsets.only(top: 1),
      height: 10,
      child: ListView(
        padding: const EdgeInsets.all(2),
        children: [
          ReadMoreText(
            situation.capitalized(),
            trimMode: TrimMode.Line,
            trimLines: 6,
            colorClickableText: const Color.fromARGB(255, 30, 64, 233),
            trimCollapsedText: 'Voir plus',
            trimExpandedText: 'Voir moins',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: myColorBlue,
            ),
            moreStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}

Container wgdCommodite({
  wifi = 1,
  piscine = 1,
  ventilateur = 1,
  climatiseur = 1,
  restoBar = 1,
  garage = 1,
}) {
  double myhaut = 98;
  return Container(
    margin: const EdgeInsets.only(right: 3, top: 2),
    padding: const EdgeInsets.only(left: 2.5, right: 2.5),
    height: myhaut,
    width: 100,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(5),
      border: Border.all(width: 1, color: myColorGreyBorber),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        lngCommodite('wifi', wifi == 1 ? true : false),
        lngCommodite('ventilateur', ventilateur == 1 ? true : false),
        lngCommodite('climatiseur', climatiseur == 1 ? true : false),
        lngCommodite('piscine', piscine == 1 ? true : false),
        lngCommodite('resto-bar', restoBar == 1 ? true : false),
        lngCommodite('garage', garage == 1 ? true : false),
      ],
    ),
  );
}

Row lngCommodite(String txtCommodite, bool isvalid) {
  String txtValid = isvalid ? 'valid' : 'non-valid';

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(children: [
        logoIcon('$imageUri/$txtCommodite.png', 15, 15),
        const SizedBox(width: 1),
        Text(
          txtCommodite.capitalized(),
          style: const TextStyle(
            color: myColorBlue,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        )
      ]),
      logoIcon('$imageUri/$txtValid.png', 15, 15),
    ],
  );
}

SizedBox txtTitreVille(String txtVille) {
  return SizedBox(
    width: double.infinity,
    height: 11,
    child: Center(
      child: (Text(
        txtVille.toUpperCase(),
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      )),
    ),
  );
}

Text txtCommuneQuartier(String txtCommune, String txtQuartier) {
  return (Text(
    '${txtCommune.capitalized()}(${txtQuartier.toLowerCase()})',
    textAlign: TextAlign.center,
    style: const TextStyle(
      color: Colors.black54,
      fontSize: 10,
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
    ),
  ));
}

Text spnPrixnuit(String intPrix) {
  return Text.rich(
    TextSpan(
      text: '$intPrix Fcfa',
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: myColorRed,
      ),
      children: const [
        TextSpan(
          text: " / Nuit",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        )
      ],
    ),
  );
}
