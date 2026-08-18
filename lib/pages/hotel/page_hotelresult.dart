import 'dart:typed_data';
import 'package:ahime/config/getx/updaterusulttext.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart' hide FormData;
import 'package:ahime/config/utils/my_titlerusult.dart';
import 'package:ahime/config/utils/my_navbar.dart';
import 'package:ahime/config/my_config.dart';
import 'package:ahime/config/utils/my_titlesub.dart';
import 'package:ahime/config/utils/resizable.dart';
import 'package:ahime/pages/hotel/page_hoteldetail.dart';
import 'package:readmore/readmore.dart';

double myHeight = 0;
double myWidth = 0;

int xEquat = 30;

final apiurl = '$APIServeur$endpoint';

class PageHotelResult extends StatefulWidget {
  const PageHotelResult({
    super.key,
    this.xNomEtab = '',
    this.xVille = '',
    this.xCommune = '',
    this.xQuartier = '',
    this.xPrix = 0,
    this.xNbrEtoile = false,
    this.xnoteEtoile = 0,
    this.xWifi = false,
    this.xPiscine = false,
    this.xSpa = false,
    this.xBar = false,
    this.xVentilateur = false,
    this.xClimatiseur = false,
    this.xEstResidence = false,
    this.xEstHotel = false,
    this.xL1 = 0,
    this.xL2 = 0,
    required this.titre,
  });
  final String xNomEtab;
  final String xVille;
  final String xCommune;
  final String xQuartier;
  final double xPrix;
  final bool xNbrEtoile;
  final double xnoteEtoile;
  final bool xWifi;
  final bool xPiscine;
  final bool xSpa;
  final bool xBar;
  final bool xVentilateur;
  final bool xClimatiseur;
  final bool xEstResidence;
  final bool xEstHotel;
  final int xL1;
  final int xL2;
  final String titre;

  @override
  State<PageHotelResult> createState() => _PageHotelResultState();
}

class _PageHotelResultState extends State<PageHotelResult> {
  final NbrController nbrC = Get.put(NbrController());

  final ScrollController scrollControl = ScrollController();
  final Dio dio = Dio(); // Créer une instance de Dio

  List jsonData = []; // Tableau pour stocker les données JSON

  int totalData = 0;
  bool isLoading = false;
  bool isInit = true;

  int xlim1 = 0;
  int xlim2 = xEquat;

  @override
  void dispose() {
    scrollControl.dispose(); // Nettoie le contrôleur
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    postdata(req1: fxReq(lim1: xlim1, lim2: xlim2), req2: fxReq());
    scrollControl.addListener(loadMoreData);
  }

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
                tltTitle(myTitle: 'Résultats de recherche ${widget.titre}'),
                myResultList(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container myResultList(BuildContext context) {
    return Container(
      width: myWidth * 100,
      height: myHeight * 88,
      decoration: const BoxDecoration(
        color: myColorWhite,
        image: DecorationImage(
          image: AssetImage('$imageUri/bg-Trasn.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          Obx(() => tltTotalresult(myResult: nbrC.txtresult.value)),
          SizedBox(height: 3),
          jsonData.isEmpty
              ? SizedBox(
                  width: myWidth * 100,
                  height: myHeight * 83,
                  child: const Center(
                      child: SpinKitPulsingGrid(
                    color: myColorBlue,
                    size: 100,
                  )),
                )
              : jsonData[0] == false && totalData == 0
                  ? SizedBox(
                      width: myWidth * 100,
                      height: myHeight * 83,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.warning_rounded,
                              color: myColorBlue, size: 40),
                          SizedBox(height: 10),
                          Text(
                            'Aucun résultat',
                            style: TextStyle(
                              color: myColorBlue,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ))
                  : myCnt(context),
          const SizedBox(height: 2),
        ],
      ),
    );
  }

  SizedBox myCnt(BuildContext context) {
    return SizedBox(
      width: myWidth * 100,
      height: myHeight * 83,
      child: ListView.builder(
        controller: scrollControl,
        itemCount: jsonData.length,
        itemBuilder: (context, index) {
          var result = jsonData[index];
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  pushPage(
                      context,
                      PageDetailH(
                        idHotel: int.parse(result['IDHOTEL']),
                        nomEtab: result['NomEtab'],
                        nomVille: result['Ville'],
                        nomCommune: result['Commune'],
                        nomQuartier: result['Quartier'],
                        nLongitude: result['Longitude'],
                        nLatitude: result['Latitude'],
                        prixMini: result['PrixMini'],
                        img64: imgBase64Dec(result['Image']),
                        contact: result['Contact'],
                        numWhatApp: result['NumWhatApp'],
                        situation: result['Situation'],
                        description: result['Description'],
                        nbEtoile: double.parse(result['NbrEtoile']),
                        wifi: int.parse(result['Wifi']),
                        piscine: int.parse(result['Piscine']),
                        ventilateur: int.parse(result['Ventilateur']),
                        climatiseur: int.parse(result['Climatiseur']),
                        restoBar: int.parse(result['Bar']),
                        garage: int.parse(result['Spa']),
                      ));
                },
                child: listHotel(
                  context,
                  result['IDHOTEL'],
                  result['NomEtab'],
                  result['Ville'],
                  result['Commune'],
                  result['Quartier'],
                  result['PrixMini'],
                  imgBase64Dec(result['Image']),
                  result['Contact'],
                  result['NumWhatApp'],
                  result['Situation'],
                  double.parse(result['NbrEtoile']),
                  int.parse(result['Wifi']),
                  int.parse(result['Piscine']),
                  int.parse(result['Ventilateur']),
                  int.parse(result['Climatiseur']),
                  int.parse(result['Bar']),
                  int.parse(result['Spa']),
                  result['Longitude'],
                  result['Latitude'],
                ),
              ),
              if (index == jsonData.length - 1 && isLoading)
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: SpinKitThreeInOut(
                    color: myColorBlue,
                    size: 30,
                  ),
                )
            ],
          );
        },
      ),
    );
  }

  Container listHotel(
    BuildContext context,
    String idHotel,
    String txtTitleH,
    String ville,
    String commune,
    String quartier,
    String prixMini,
    Uint8List img64,
    String contact,
    String numWhatApp,
    String situation,
    double nbEtoile,
    int wifi,
    int piscine,
    int ventilateur,
    int climatiseur,
    int restoBar,
    int garage,
    String nLongitude,
    String nLatitude,
  ) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 1, bottom: 10),
      padding: const EdgeInsets.only(left: 10, right: 10),
      height: 281,
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          txtTitrehotel(txtTitleH),
          nbrEtoile(nbEtoile),
          wgdCommodite(
            image: img64,
            wifi: wifi,
            piscine: piscine,
            ventilateur: ventilateur,
            climatiseur: climatiseur,
            restoBar: restoBar,
            garage: garage,
            index: idHotel,
          ),
          lnSeparateur(),
          txtTitreVille(ville),
          txtCommuneQuartier(commune, quartier),
          wgdDescription(contact, numWhatApp, situation, nLongitude, nLatitude),
          spnPrixnuit(moneyFormat(prixMini)),
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
        fontSize: 18,
        fontWeight: FontWeight.bold,
        overflow: TextOverflow.ellipsis,
      ),
    ));
  }

   nbrEtoile(double rating) {
    return StarRating(
      rating: rating,
      borderColor: const Color.fromARGB(255, 241, 241, 241),
      size: 22,
    );
  }

  Row wgdCommodite({
    image = '',
    wifi = 1,
    piscine = 1,
    ventilateur = 1,
    climatiseur = 1,
    restoBar = 1,
    garage = 1,
    index = '',
  }) {
    double myhaut = 98;
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Hero(
            tag: 'img$index',
            child: myMemoryImage(
              image,
              BoxFit.fill,
              110,
              myhaut,
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 8, right: 8),
            height: myhaut,
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
          ),
        ),
      ],
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

  Container lnSeparateur() {
    return Container(
      height: 2,
      margin: const EdgeInsets.only(top: 3, bottom: 1),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }

  SizedBox txtTitreVille(String txtVille) {
    return SizedBox(
      width: double.infinity,
      height: 20,
      child: Center(
        child: (Text(
          txtVille.toUpperCase(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black87,
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
        //backgroundColor: Colors.amber,
        fontSize: 10,
        fontWeight: FontWeight.bold,
        overflow: TextOverflow.ellipsis,
      ),
    ));
  }

  Container wgdDescription(
      contact, numWhatApp, situation, nLongitude, nLatitude) {
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5),
      padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
      height: 73,
      width: double.infinity,
      decoration: BoxDecoration(
        color: myColorBlueLight,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(children: [
        Expanded(
          child: Column(
            children: [
              lngDescription(
                'telwb.png',
                contact,
              ),
              lngDescription(
                'whawb.png',
                numWhatApp,
              ),
              lngDescriptionSV(
                'positiongps.png',
                situation,
              ),
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
          child: Image.asset(
            '$imageUri/gps.png',
            width: 40,
            height: 40,
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
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      )
    ]);
  }

  lngDescriptionSV(String logo, String txtDescription) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(top: 1),
        height: 10,
        child: ListView(
          padding: const EdgeInsets.all(2),
          children: [
            ReadMoreText(
              txtDescription.capitalized(),
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
              moreStyle:
                  const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
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

  void loadMoreData() {
    if (scrollControl.position.pixels ==
            scrollControl.position.maxScrollExtent &&
        jsonData.length < totalData) {
      postdata(req1: fxReq(lim1: xlim1, lim2: xlim2));
    }
  }

  Future<void> postdata({required String req1, String req2 = ''}) async {
    FormData formData = FormData.fromMap(mydata(mReq: req1, mReq2: req2));

    try {
      setState(() {
        isLoading = true;
      });

      var response = await dio.post(
        apiurl,
        data: formData,
      );

      if (response.statusCode == 200) {
        if (isInit) {
          isInit = false;
          totalData = response.data['total'];
          nbrC.tTotal(response.data['total']);
        }
        setState(() {
          isLoading = false;
          if (response.data['result'].isEmpty) {
            jsonData = [false];
          } else {
            jsonData.addAll(response.data['result']);
            xlim1 += xEquat;
            xlim2 += xEquat;
          }
        });
      } else {
        throw Exception('Échec de l\'envoi des données ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de réseau : $e');
    }
  }

  Future<void> getdataAll(String mReq) async {
    FormData formData = FormData.fromMap(mydata(mReq: mReq));
    return dio.post(apiurl, data: formData).then((response) {
      totalData = int.parse(response.data['total']);
      nbrC.tTotal(totalData);
    });
  }

  String fxReq({int lim1 = 0, int lim2 = 0}) {
    return myReq(
      xNomEtab: widget.xNomEtab,
      xVille: widget.xVille,
      xCommune: widget.xCommune,
      xQuartier: widget.xQuartier,
      xPrix: widget.xPrix,
      xNbrEtoile: widget.xNbrEtoile,
      xnoteEtoile: widget.xnoteEtoile,
      xWifi: widget.xWifi,
      xPiscine: widget.xPiscine,
      xSpa: widget.xSpa,
      xBar: widget.xBar,
      xVentilateur: widget.xVentilateur,
      xClimatiseur: widget.xClimatiseur,
      xEstResidence: widget.xEstResidence,
      xEstHotel: widget.xEstHotel,
      xL1: lim1,
      xL2: lim2,
    );
  }
}
