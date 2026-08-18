// ignore_for_file: non_constant_identifier_names

import 'package:ahime/config/getx/updaterusulttext.dart';
import 'package:ahime/pages/transport/page_tranportresult.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ahime/config/utils/my_navbar.dart';
import 'package:ahime/config/my_config.dart';
import 'package:ahime/config/utils/dropdownlist.dart';
import 'package:ahime/config/utils/resizable.dart';
import 'package:ahime/config/utils/slide_img.dart';
import 'package:get/get.dart' hide FormData;

class PageTransport extends StatelessWidget {
  const PageTransport({super.key});

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
                const SlideImg(
                    imgPath: '$imageUri/SldTransport.jpg', title: 'Transport'),
                Padding(
                  padding: const EdgeInsets.only(left: 7, right: 7),
                  child: Column(
                    children: [
                      SizedBox(height: myHeight * 1),
                      tabCtnMenu(context: context),
                      const SizedBox(height: 1),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(left: 7),
                        child: const Text(
                          'Annonce publicitaire',
                          style: TextStyle(
                            color: myColorBlue,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      //myPub(myUrl: 'https://ahime-ci.com/pubhotel'),
                     const SlideImg(imgPath: '$imageUri/pubads.jpg', title: ''),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class tabCtnMenu extends StatefulWidget {
  const tabCtnMenu({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  State<tabCtnMenu> createState() => tabCtnMenuState();
}

// ignore: camel_case_types
class tabCtnMenuState extends State<tabCtnMenu> with TickerProviderStateMixin {
  final NbrController AfficherR = Get.put(NbrController());

  MyListf cmbVilleDepart = MyListf('');
  MyListf cmbVilleArrivee = MyListf('');
  MyListf cmbCompagnie = MyListf('');

  void changeVilleDepartValue(value) {
    cmbVilleDepart = value;
  }

  void changeVilleArriveeValue(value) {
    cmbVilleArrivee = value;
  }

  void changeCompagnieValue(value) {
    cmbCompagnie = value;
  }

  @override
  void initState() {
    super.initState();
    getdataAll('SELECT DISTINCT Nom FROM compagnie');
    getdataVille('SELECT NomVille FROM ville');
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var myWidth = SizeConfig.safeBlockHorizontal!;
    TabController tabController = TabController(length: 2, vsync: this);

    return Container(
      width: myWidth * 100,
      height: 194,
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(children: [
        Container(
          height: 30,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
            color: myColorGreen,
          ),
          child: TabBar(
            controller: tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            dividerColor: Colors.transparent,
            indicator: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
              color: myColorBlue,
            ),
            labelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 12,
            ),
            tabs: const [
              Tab(text: 'Ligne'),
              Tab(text: 'Compagnie'),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 4),
          height: 164,
          width: myWidth * 96,
          child: TabBarView(
            controller: tabController,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  mySearchtxt(
                      '', 'Ville de départ', listVille, changeVilleDepartValue),
                  SizedBox(height: 6),
                  mySearchtxt('', "Ville d'arrivée", listVille,
                      changeVilleArriveeValue),
                  SizedBox(height: 6),
                  myBtnMenu('Rechercher', () {
                    AfficherR.tTotal(0);
                    pushPage(
                        context,
                        PageTransportResult(
                          titre: 'Transport',
                          xVilleDepart: cmbVilleDepart.name,
                          xVilleArrivee: cmbVilleArrivee.name,
                        ));
                  }),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  mySearchtxt('', 'Destination par compagnie', listCompagnie,
                      changeCompagnieValue),
                  SizedBox(height: 14),
                  myBtnMenu('Rechercher', () {
                    AfficherR.tTotal(0);
                    pushPage(
                        context,
                        PageTransportResult(
                          titre: 'Transport',
                          xCompagnie: cmbCompagnie.name,
                        ));
                  }),
                ],
              ),
            ],
          ),
        )
      ]),
    );
  }

  mySearchtxt(String txLibelle, String myhintText, List<MyListf> myItems,
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
              fontSize: txLibelle.isEmpty ? 0 : 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          SearchDropdown(
            myItems: myItems,
            myhintText: myhintText,
            onChanged: onChanged,
            headerFontSize: 14,
          ),
        ],
      ),
    );
  }

  myBtnMenu(String titre, VoidCallback onClic) => GestureDetector(
        onTap: onClic,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(10),
          width: 150,
          height: 40,
          decoration: ShapeDecoration(
            color: myColorBlue,
            shape: StadiumBorder(),
          ),
          child: Text(
            titre,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );

  Future<void> getdataAll(String mReq1) async {
    Dio dio = Dio();
    List compagnie = [];

    FormData formData = FormData.fromMap(dataMulti(mReq1: mReq1));
    return dio.post(apiurl, data: formData).then((response) {
      var data1 = response.data['result1'];

      if (data1 != null && data1.isNotEmpty) {
        compagnie.addAll(data1.map((item) => item['Nom']));

        for (var name in compagnie) {
          listCompagnie.add(MyListf(name));
        }
      }
    });
  }

  Future<void> getdataVille(String mReq1) async {
    Dio dio = Dio();
    List ville = [];

    FormData formData = FormData.fromMap(dataMulti(mReq1: mReq1));
    return dio.post(apiurl, data: formData).then((response) {
      var data1 = response.data['result1'];

      if (data1 != null && data1.isNotEmpty) {
        ville.addAll(data1.map((item) => item['NomVille']));

        for (var name in ville) {
          listVille.add(MyListf(name));
        }
      }
    });
  }

}
