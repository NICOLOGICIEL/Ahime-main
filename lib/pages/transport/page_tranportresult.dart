// ignore_for_file: non_constant_identifier_names

import 'package:ahime/config/getx/updaterusulttext.dart';
import 'package:ahime/pages/transport/page_transporthoraire.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart' hide FormData;
import 'package:flutter_rating/flutter_rating.dart';
import 'package:ahime/config/utils/my_titlerusult.dart';
import 'package:ahime/config/utils/my_navbar.dart';
import 'package:ahime/config/my_config.dart';
import 'package:ahime/config/utils/my_titlesub.dart';
import 'package:ahime/config/utils/resizable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:motion_toast/motion_toast.dart';

double myHeight = 0;
double myWidth = 0;

bool gpsPermission = false;

int xEquat = 30;

class PageTransportResult extends StatefulWidget {
  const PageTransportResult({
    super.key,
    this.xVilleArrivee = '',
    this.xVilleDepart = '',
    this.xCompagnie = '',
    this.xL1 = 0,
    this.xL2 = 0,
    required this.titre,
  });
  final String xVilleArrivee;
  final String xVilleDepart;
  final String xCompagnie;
  final int xL1;
  final int xL2;
  final String titre;

  @override
  State<PageTransportResult> createState() => _PageTransportResultState();
}

class _PageTransportResultState extends State<PageTransportResult> {
  final NbrController nbrC = Get.put(NbrController());
  double xLat = 0;
  double xLong = 0;

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
    getPosition();
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
                onTap: () {},
                child: listHotel(result),
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

  Container listHotel(Map<String, dynamic> result) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 1, bottom: 10),
      padding: const EdgeInsets.only(left: 10, right: 10),
      height: 172,
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          txtTitrehotel(result['Nom']),
          wgdCommodite(result),
          myNotecall(context, result),
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
        //fontFamily: 'Noteworthy-Lt',
      ),
    ));
  }

//   GFRating nbrEtoile(double rating) {
//     return GFRating(
//       value: rating,
//       borderColor: const Color.fromARGB(255, 228, 223, 223),
//       size: 15,
//       onChanged: (double rating) {},
//     );
//   }

  nbrEtoile(double rating) {
    return StarRating(
      rating: rating,
      size: 15,
      borderColor: const Color.fromARGB(255, 228, 223, 223),
    );
  }

  wgdCommodite(Map<String, dynamic> result) {
    double myhaut = 100;
    return GestureDetector(
      onTap: () {
        pushPage(
            context,
            PageTransportHoraire(
                dataP: result,
                distanceKM: getDistanceKM(double.parse(result['LatitudeComp']),
                    double.parse(result['LongitudeComp']))));
      },
      child: Container(
        height: myhaut,
        width: double.infinity,
        decoration: BoxDecoration(
          color: myColorBlueLight, // Background color
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 5),
              height: 80,
              width: 90,
              decoration: BoxDecoration(
                color: myColorBlueLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: myMemoryImage(
                  imgBase64Dec(result['Photo']),
                  BoxFit.fill,
                  90,
                  90,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 8, right: 8),
                height: myhaut,
                child: Column(
                  children: [
                    txtTitreVille(result['Ville']),
                    txtCommuneQuartier(result['Commune'], result['Quartier']),
                    nbrEtoile(0),
                    txtVilleDepartArrivee(
                        result['VilleDepart'], result['VilleArrivee']),
                    SizedBox(height: 14),
                    lngDescription('tel.png', result['Contact']),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 5, right: 5),
              height: myhaut,
              width: 36,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      glMAPS(double.parse(result['LatitudeComp']),
                          double.parse(result['LongitudeComp']));
                    },
                    onLongPress: () {
                      defMAPS(double.parse(result['LatitudeComp']),
                          double.parse(result['LongitudeComp']));
                    },
                    child: Image.asset(
                      '$imageUri/gps.png',
                      width: 40,
                      height: 40,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    gpsPermission
                        ? '${getDistanceKM(double.parse(result['LatitudeComp']), double.parse(result['LongitudeComp'])).round()} km'
                        : '',
                    style: TextStyle(
                      color: myColorBlue,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
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
        fontSize: 10,
        fontWeight: FontWeight.bold,
        overflow: TextOverflow.ellipsis,
      ),
    ));
  }

  Text txtVilleDepartArrivee(String txtVilleDepart, String txtVilleArrivee) {
    return (Text(
      '${txtVilleDepart.toUpperCase()} <--> ${txtVilleArrivee.toUpperCase()}',
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.black54,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        overflow: TextOverflow.ellipsis,
        fontFamily: 'Noteworthy-Lt',
      ),
    ));
  }

  Row lngDescription(String logo, String txtDescription) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      logoIcon('$imageUri/$logo', 12, 12),
      SizedBox(width: 3),
      Text(
        phoneFormat(txtDescription),
        style: const TextStyle(
          color: myColorBlue,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      )
    ]);
  }

  Row myNotecall(BuildContext context, Map<String, dynamic> result) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            launchCALL(result['Contact']);
          },
          child: CircleAvatar(
            radius: 23,
            backgroundColor: myColorBlue.withValues(alpha: 0.0),
            child: const Icon(
              Icons.phone_in_talk_sharp,
              color: myColorBlue,
            ),
          ),
        ),
        SizedBox(width: 30),
        GestureDetector(
          onTap: () {
            pushPage(
                context,
                PageTransportHoraire(
                    dataP: result,
                    distanceKM: getDistanceKM(
                        double.parse(result['LatitudeComp']),
                        double.parse(result['LongitudeComp']))));
          },
          child: CircleAvatar(
            radius: 23,
            backgroundColor: myColorBlue.withValues(alpha: 0.0),
            child: const Icon(
              Icons.access_time_outlined,
              color: myColorBlue,
            ),
          ),
        ),
        SizedBox(width: 30),
        GestureDetector(
          onTap: () {
            //pushPage(context, PageTransportHoraire(dataPhoto: jsonData));
          },
          child: CircleAvatar(
            radius: 23,
            backgroundColor: myColorBlue.withValues(alpha: 0.0),
            child: Icon(
              Icons.edit_note_rounded,
              color: myColorBlue,
            ),
          ),
        ),
      ],
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
    return myReqTransport(
      xVille_depart: widget.xVilleDepart,
      xVille_d_arrivee: widget.xVilleArrivee,
      xNom_Compagnie: widget.xCompagnie,
      xL1: lim1,
      xL2: lim2,
    );
  }

  getPosition() async {
    try {
      Position position = await determinePosition();
      xLat = position.latitude;
      xLong = position.longitude;
      gpsPermission = true;
    } catch (e) {
      gpsPermission = false;

      // ignore: use_build_context_synchronously
      //fnSnackmsg(context, e.toString());

      MotionToast.info(
              title: Text("Erreur de localisation"),
              displaySideBar: false,
              toastDuration: Duration(seconds: 4),
              animationType: AnimationType.fromTop,
              animationCurve: Curves.decelerate,
              description: Text(e.toString()))
          // ignore: use_build_context_synchronously
          .show(context);
    }
  }

  double getDistanceInKm(double mlat, double mlon) {
    double distanceInMeters =
        Geolocator.distanceBetween(xLat, xLong, mlat, mlon);
    var distanceInKm = distanceInMeters / 1000;
    return distanceInKm;
  }

  double getDistanceInM(double mlat, double mlon) {
    double distanceInMeters =
        Geolocator.distanceBetween(xLat, xLong, mlat, mlon);
    return distanceInMeters;
  }

  double getDistanceKM(double mlat, double mlon) {
    var distance = Distance();
    double distanceInKm = distance.as(
        LengthUnit.Kilometer, LatLng(xLat, xLong), LatLng(mlat, mlon));
    return distanceInKm;
  }

  double getDistanceM(double mlat, double mlon) {
    var distance = Distance();
    double distanceInM = distance(LatLng(xLat, xLong), LatLng(mlat, mlon));
    return distanceInM;
  }
}
