import 'package:ahime/config/getx/updaterusulttext.dart';
import 'package:ahime/pages/artisan/page_artisanimgdetail.dart';
import 'package:flutter/material.dart';
import 'package:ahime/config/utils/my_titlerusult.dart';
import 'package:ahime/config/utils/my_navbar.dart';
import 'package:ahime/config/my_config.dart';
import 'package:ahime/config/utils/my_titlesub.dart';
import 'package:ahime/config/utils/resizable.dart';
import 'package:dio/dio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart' hide FormData;

int xEquat = 30;

class PageArtisantResult extends StatefulWidget {
  const PageArtisantResult({
    super.key,
    this.xMetier = '',
    this.xCategorie = '',
    this.xVille = '',
    this.xCommune = '',
    this.xQuartier = '',
    this.xnoteEtoile = 0,
  });

  final String xMetier;
  final String xCategorie;
  final String xVille;
  final String xCommune;
  final String xQuartier;
  final double xnoteEtoile;

  @override
  State<PageArtisantResult> createState() => _PageArtisantResultState();
}

class _PageArtisantResultState extends State<PageArtisantResult> {
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
                const tltTitle(myTitle: 'Résultats artisan'),
                myTlt(widget.xCategorie.isEmpty
                    ? widget.xMetier
                    : widget.xCategorie, myWidth),
                myResultList(context, myWidth, myHeight)
              ],
            ),
          ),
        ),
      ),
    );
  }

  myTlt(String myTitle, double myWidth) {
    return Container(
      alignment: Alignment.center,
      width: myWidth * 100,
      height: 27,
      color: myColorGreenLight,
      child: Text(
        myTitle,
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: myColorBlue,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic),
      ),
    );
  }

  Container myResultList(
      BuildContext context, double myWidth, double myHeight) {
    return Container(
      width: myWidth * 100,
      height: myHeight * 87,
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
                  : myCnt(context, myWidth, myHeight),
          const SizedBox(height: 2),
        ],
      ),
    );
  }

  SizedBox myCnt(BuildContext context, double myWidth, double myHeight) {
    return SizedBox(
      width: myWidth * 100,
      height: myHeight * 80,
      child: ListView.builder(
        controller: scrollControl,
        itemCount: jsonData.length,
        itemBuilder: (BuildContext context, int index) {
          var result = jsonData[index];
          return Column(
            children: [
              listArtisan(context, result),
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

  Column listArtisan(BuildContext context, Map<String, dynamic> result) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 10, right: 10, top: 1),
          padding: const EdgeInsets.only(left: 10, right: 10),
          height: 160,
          decoration: const BoxDecoration(
            color: Colors.white, // Background color
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Column(
            children: [
              txtTitrehotel('${result['Nom']} ${result['prenom']}'),
              myDescription(context, SizeConfig.safeBlockHorizontal!,
                  SizeConfig.safeBlockVertical!, result)
            ],
          ),
        ),
        footerDescription(context, result),
      ],
    );
  }

  myDescription(BuildContext context, double myWidth, double myHeight,
      Map<String, dynamic> result) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          height: 120,
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
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(top: 7),
            height: 125,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                txtTitreVille(result['Ville']),
                txtCommuneQuartier(result['Commune'], result['Quartier']),
                ntEtoile(
                    note: double.parse(result['Tnote']),
                    taille: 18,
                    myBorderColor: myColorBgGrey,
                    onChanged: (value) {}),
                const SizedBox(height: 4),
                lngDescription('telwb.png', result['Contact']),
                const SizedBox(height: 4),
                lngDescription('whawb.png', result['NumWhatApp']),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Text txtTitrehotel(String myTitle) {
    return (Text(
      myTitle.toUpperCase(),
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: myColorBlue,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        overflow: TextOverflow.ellipsis,
      ),
    ));
  }

  Text txtTitreVille(String txtVille) {
    return Text(
      txtVille.toUpperCase(),
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: myColorBlue,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Text txtCommuneQuartier(String txtCommune, String txtQuartier) {
    return (Text(
      '${txtCommune.capitalized()}(${txtQuartier.toLowerCase()})',
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: myColorBlue,
        fontSize: 12,
        overflow: TextOverflow.ellipsis,
      ),
    ));
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
        ),
      )
    ]);
  }

  Container footerDescription(BuildContext context, Map<String, dynamic> result) {
    String myTitle = result['Categorie'];
    myTitle = myTitle == 'Batiment' ? 'Bâtiment' : myTitle;
    myTitle = myTitle == 'Securite' ? 'Sécurité' : myTitle;
    String myTitlesub = result['Libelle'];
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      width: double.infinity,
      height: 50,
      decoration: const BoxDecoration(
        color: myColorBlue, // Background color
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(
            child: Column(children: [
          Text(
            myTitle.toUpperCase(),
            style: const TextStyle(
                color: myColorGreenn,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Noteworthy-Lt'),
          ),
          Text(
            myTitlesub.capitalized(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              //fontFamily: 'palr45w'
            ),
          ),
        ])),
        SizedBox(
          width: 35,
          height: 50,
          //color: myColorWhite,
          child: IconButton(
            icon: const Icon(
              Icons.arrow_forward_ios,
            ),
            iconSize: 25,
            color: Colors.white,
            onPressed: () {
              pushPage(context, PageArtisanimg(result: result));
            },
          ),
        ),
      ]),
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

  String fxReq({int lim1 = 0, int lim2 = 0}) {
    return myReqArtisant(
      xMetier: widget.xMetier,
      xCategorie: widget.xCategorie,
      xVille: widget.xVille,
      xCommune: widget.xCommune,
      xQuartier: widget.xQuartier,
      xnoteEtoile: widget.xnoteEtoile,
      xL1: lim1,
      xL2: lim2,
    );
  }
}
