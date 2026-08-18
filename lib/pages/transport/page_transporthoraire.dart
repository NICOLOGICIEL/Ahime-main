import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ahime/config/my_config.dart';
import 'package:ahime/config/utils/resizable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ahime/config/getx/updatescreen.dart';
import "package:get/get.dart" hide FormData;
import 'package:timeline_tile_plus/timeline_tile_plus.dart';

class PageTransportHoraire extends StatefulWidget {
  const PageTransportHoraire({
    super.key,
    required this.dataP,
    this.distanceKM,
  });
  final Map<String, dynamic> dataP;
  final double? distanceKM;

  @override
  State<PageTransportHoraire> createState() => _PageTransportHoraireState();
}

class _PageTransportHoraireState extends State<PageTransportHoraire> {
  List jsonData = []; // Tableau pour stocker les données JSON
  List jsonDataEscale = []; // Tableau pour stocker les données JSON
  final Dio dio = Dio(); // Créer une instance de Dio
  int totalData = 0;
  int totalDataEscale = 0;

  final EscaleController escaleControl = Get.put(EscaleController());

  @override
  void initState() {
    super.initState();
    postdata(req1: fxReq(), req2: fxReq());
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
                myDescription(context, myWidth, myHeight, widget.dataP),
                SizedBox(height: 10),
                myResultList(context, myWidth, myHeight),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Stack myDescription(
      BuildContext context, double myWidth, double myHeight, result) {
    return Stack(
      children: [
        Container(
          height: 280,
          width: myWidth * 100,
          decoration: BoxDecoration(
            color: myColorBlue, // Background color
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 12),
              txtTitreCompagine(result['Nom']),
              txtDistance(widget.distanceKM),
              txtNbrDepart((jsonData.length <= 1)
                  ? '${jsonData.length} Départ'
                  : '${jsonData.length} Départs'),
              SizedBox(height: myHeight * 1),
              desriptionGpsPhone(myWidth, result),
              txtTitreVille(result['Ville']),
              txtCommuneQuartier(result['Commune'], result['Quartier']),
              lngDescription('telw.png', result['Contact']),
              txtVilleDepartArrivee(
                  result['VilleDepart'], result['VilleArrivee']),
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
            color: myColorWhite,
            onPressed: () {
              popPage(context);
            },
          ),
        )
      ],
    );
  }

  Container myResultList(BuildContext context, myWidth, myHeight) {
    return Container(
      width: myWidth * 100,
      height: myHeight * 60,
      decoration: const BoxDecoration(
        color: myColorWhite,
      ),
      child: jsonData.isEmpty
          ? SizedBox(
              width: myWidth * 100,
              height: myHeight * 60,
              child: const Center(
                  child: SpinKitPulsingGrid(
                color: myColorBlue,
                size: 100,
              )),
            )
          : jsonData[0] == false && totalData == 0
              ? SizedBox(
                  width: myWidth * 100,
                  height: myHeight * 60,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.warning_rounded, color: myColorBlue, size: 40),
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
    );
  }

  SizedBox myCnt(BuildContext context) {
    SizeConfig().init(context);
    var myHeight = SizeConfig.safeBlockVertical!;
    var myWidth = SizeConfig.safeBlockHorizontal!;

    return SizedBox(
      width: myWidth * 90,
      height: myHeight * 60,
      child: ListView.builder(
        itemCount: jsonData.length,
        itemBuilder: (context, index) {
          var result = jsonData[index];
          return GestureDetector(
            onTap: () {},
            child: listHotel(result, index),
          );
        },
      ),
    );
  }

  Container listHotel(Map<String, dynamic> result, int index) {
    SizeConfig().init(context);
    //var myWidth = SizeConfig.safeBlockHorizontal!;

    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 10),
      padding: EdgeInsets.only(left: 10, right: 10),
      height: 150,
      //width: myWidth * 50,
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          heurePrix(result, index),
          SizedBox(height: 5),
          Text('Commodité',
              style: TextStyle(
                color: myColorBlue,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )),
          wcommodite(result),
          SizedBox(height: 5),
          myBtnTransport('Afficher les escales', () {
            displayBottomSheet(context, index, result);
          }),
        ],
      ),
    );
  }

  Container wcommodite(Map<String, dynamic> result) {
    return Container(
      height: 50,
      width: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: myColorBgGrey, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              lngCommodite(
                  'wifi', int.parse(result['Wifi']) == 1 ? true : false),
              lngCommodite('climatiseur',
                  int.parse(result['Climatiseur']) == 1 ? true : false),
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              lngCommodite('Pt Déjeuné',
                  int.parse(result['petitDej']) == 1 ? true : false),
              lngCommodite('toilette',
                  int.parse(result['Toilette']) == 1 ? true : false),
            ],
          ),
        ],
      ),
    );
  }

  Row lngDescription(String logo, String txtDescription) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      logoIcon('$imageUri/$logo', 12, 12),
      SizedBox(width: 3),
      Text(
        phoneFormat(txtDescription),
        style: const TextStyle(
          color: myColorWhite,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      )
    ]);
  }

  Row lngCommodite(String txtCommodite, bool isvalid) {
    String txtValid = isvalid ? 'valid' : 'non-valid';
    String txtComName = txtCommodite;
    txtCommodite = (txtCommodite == 'Pt Déjeuné') ? 'ptdej' : txtCommodite;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          logoIcon('$imageUri/$txtCommodite.png', 15, 15),
          const SizedBox(width: 4),
          SizedBox(
            width: 60,
            child: Text(
              txtComName.capitalized(),
              style: const TextStyle(
                color: myColorBlue,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ]),
        SizedBox(width: 8),
        logoIcon('$imageUri/$txtValid.png', 15, 15),
      ],
    );
  }

  Row heurePrix(result, index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(result['HeureDepart'],
            style: TextStyle(
              color: myColorBlue,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            )),
        Text('DÉPART ${index + 1}',
            style: TextStyle(
              color: myColorBlue,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            )),
        Container(
            alignment: Alignment.center,
            width: 70,
            padding: EdgeInsets.only(left: 3, right: 3),
            decoration: BoxDecoration(
              //color: myColorGreen,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: myColorGreen, width: 1),
            ),
            child: Text(moneyFormat(result['Prix']),
                style: TextStyle(
                  color: myColorGreen,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                )))
      ],
    );
  }

  Text txtDistance(double? distanceKM) {
    return Text(
      'À environ ${distanceKM!.round()} Km de vous',
      style: TextStyle(
        color: const Color.fromARGB(255, 239, 242, 206),
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Container desriptionGpsPhone(double myWidth, result) {
    return Container(
      margin: EdgeInsets.only(left: 3, right: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
              onTap: () {
                launchCALL(result['Contact']);
              },
              child: Icon(Icons.phone, color: myColorGreenn, size: 40)),
          SizedBox(width: myWidth * 1),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: myMemoryImage(
              imgBase64Dec(result['Photo']),
              BoxFit.fill,
              110,
              100,
            ),
          ),
          SizedBox(width: myWidth * 1),
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
              width: 50,
              height: 50,
            ),
          ),
        ],
      ),
    );
  }

  Text txtNbrDepart(String txtDepart) {
    return Text(
      txtDepart,
      style: TextStyle(
        color: myColorGreenn,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Text txtTitreCompagine(String txtTitre) {
    return Text(
      txtTitre.toUpperCase(),
      style: TextStyle(
        color: myColorWhite,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        overflow: TextOverflow.ellipsis,
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
            color: myColorWhite,
            fontWeight: FontWeight.bold,
            fontSize: 16,
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
        color: myColorWhite,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        overflow: TextOverflow.ellipsis,
      ),
    ));
  }

  Text txtVilleDepartArrivee(String txtVilleDepart, String txtVilleArrivee,
      {double myfontSize = 18}) {
    return (Text(
      '${txtVilleDepart.toUpperCase()} <--> ${txtVilleArrivee.toUpperCase()}',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: myfontSize,
        fontWeight: FontWeight.bold,
        overflow: TextOverflow.ellipsis,
        fontFamily: 'Noteworthy-Lt',
      ),
    ));
  }

  myBtnTransport(String titre, VoidCallback onClic) => GestureDetector(
        onTap: onClic,
        child: Container(
          alignment: Alignment.center,
          width: 240,
          height: 32,
          decoration: ShapeDecoration(
            color: myColorBlue,
            shape: StadiumBorder(),
          ),
          child: Text(
            titre,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      );

  Future<void> postdata({required String req1, String req2 = ''}) async {
    FormData formData = FormData.fromMap(mydata(mReq: req1, mReq2: req2));

    try {
      var response = await dio.post(
        apiurl,
        data: formData,
      );

      if (response.statusCode == 200) {
        totalData = response.data['total'];

        setState(() {
          if (response.data['result'].isEmpty) {
            jsonData = [false];
          } else {
            jsonData.addAll(response.data['result']);
          }
        });
      } else {
        throw Exception('Échec de l\'envoi des données ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de réseau : $e');
    }
  }

  String fxReq() {
    return myReqHoraire(x1: int.parse(widget.dataP['IDLIGNETRANSPORT']));
  }

  Future<void> postdataEscale({required String req1, String req2 = ''}) async {
    FormData formData = FormData.fromMap(mydata(mReq: req1, mReq2: req2));

    try {
      var response = await dio.post(
        apiurl,
        data: formData,
      );

      if (response.statusCode == 200) {
        totalDataEscale = response.data['total'];

        if (response.data['result'].isEmpty) {
          jsonDataEscale = [false];
        } else {
          jsonDataEscale = response.data['result'];
        }
        escaleControl.tEscale(jsonDataEscale);
      } else {
        throw Exception('Échec de l\'envoi des données ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de réseau : $e');
    }
  }

  String fxReqEscale(int idDep) {
    return myReqEscale(IdDepart: idDep);
  }

  void displayBottomSheet(
      BuildContext context, int index, Map<String, dynamic> result) {
    SizeConfig().init(context);
    var myHeight = SizeConfig.safeBlockVertical!;
    var myWidth = SizeConfig.safeBlockHorizontal!;
    var idDep = int.parse(result['IDDEPART']);

    escaleControl.onClose();

    postdataEscale(req1: fxReqEscale(idDep), req2: fxReqEscale(idDep));

    showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: myHeight * 65,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              myHead(context, index, widget.dataP),
              SizedBox(height: 10),
              myHours(result['HeureDepart']),
              SizedBox(height: 10),
              myBoby(context, myWidth, myHeight),
            ],
          ),
        );
      },
    );
  }

  Container myHours(String txtHeure) {
    return Container(
        alignment: Alignment.center,
        width: 87,
        padding: EdgeInsets.only(left: 3, right: 3),
        decoration: BoxDecoration(
          color: myColorGreen,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: myColorGreen, width: 2),
        ),
        child: Text(
          txtHeure,
          style: TextStyle(
            color: myColorWhite,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ));
  }

  myBoby(BuildContext context, myWidth, myHeight) {
    return Obx(
      () => escaleControl.dataEscale.isEmpty
          ? SizedBox(
              width: myWidth * 100,
              height: myHeight * 40,
              child: Center(
                  child: SpinKitWave(
                color: myColorBlue,
                size: 20,
              )),
            )
          : escaleControl.dataEscale[0] == false && totalDataEscale == 0
              ? SizedBox(
                  width: myWidth * 100,
                  height: myHeight * 40,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.warning_rounded, color: myColorBlue, size: 40),
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
              : Flexible(
                  child: ListView.builder(
                    itemCount: escaleControl.dataEscale.length,
                    itemBuilder: (context, index) {
                      var resultescale = escaleControl.dataEscale[index];
                      return myTimeline(
                          resultescale,
                          index == 0 ? true : false,
                          index == escaleControl.dataEscale.length - 1
                              ? true
                              : false);
                    },
                  ),
                ),
    );
  }

  Container textColl(Map<String, dynamic> result) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(left: 15, right: 10),
      height: 30,
      width: double.infinity,
      decoration: BoxDecoration(
        color: myColorBlue, //Colors.blueGrey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        result['Localite'],
        style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontFamily: 'Noteworthy-Lt',
            overflow: TextOverflow.ellipsis),
        textAlign: TextAlign.center,
      ),
    );
  }

  myHead(BuildContext context, int index, result) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: myColorBlue,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 50,
            height: 1,
          ),
          Column(
            children: [
              SizedBox(height: 2),
              Text(
                'DÉPART ${index + 1}',
                style: TextStyle(
                  color: myColorWhite,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              txtVilleDepartArrivee(
                  result['VilleDepart'], result['VilleArrivee'],
                  myfontSize: 14),
              SizedBox(height: 2)
            ],
          ),
          IconButton(
            onPressed: () {
              popPage(context);
            },
            icon: Icon(Icons.close),
            color: myColorWhite,
            iconSize: 20,
          )
        ],
      ),
    );
  }

  myTimeline(result, isFirst, isLast) {
    return Container(
      margin: EdgeInsets.only(left: 40, right: 40),
      width: double.infinity,
      height: 60.0,
      child: TimelineTile(
        isFirst: isFirst,
        isLast: isLast,
        beforeLineStyle: LineStyle(
          color: myColorBlue,
        ),
        indicatorStyle: IndicatorStyle(
          color: myColorBlue,
          width: 30,
          iconStyle: IconStyle(
            iconData: Icons.location_on,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        endChild: textColl(result),
      ),
    );
  }
}
