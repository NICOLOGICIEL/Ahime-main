// ignore_for_file: non_constant_identifier_names

import 'package:ahime/config/utils/resizable.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:platform_detector/platform_detector.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:geolocator/geolocator.dart';

//css
const Color myColorBlue = Color(0xFF023a6b);
const Color myColorBlue2 = Color(0xFF0050a0);
const Color myColorGreen = Color(0xFF02893c);
const Color myColorWhite = Color(0xFFF6F7F9);
const Color myColorRed = Color(0xFFcb182b);
const Color myColorBlueLight = Color(0xFFeaf1f9);
const Color myColorBgGrey = Color(0xFFf1f1f2);
var myColorGreyBorber = Colors.grey.withOpacity(0.5);
const Color myColorGreenLight = Color(0xFFe9fdfe);
const Color myColorGreenn = Color(0xFF35d852);

//adresse API
// ignore: constant_identifier_names
const String APIServeur = "https://ahime-ci.com/casa2babyAPI";
const String apiBaseURL = "ahime-ci.com/casa2babyAPI";
var endpoint = '/api/action';
var endpointINI = '/api';
final apiurl = '$APIServeur$endpoint';
final apiurlINI = '$APIServeur$endpointINI';

//assets uri
const imageUri = 'assets/image';
const fontsUri = 'assets/fonts';

//pushPage
Future pushPage(BuildContext context, Widget page) {
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => page,
    ),
  );
}

//popPage
void popPage(BuildContext context) {
  return Navigator.pop(
    context,
  );
}

class MyListf with CustomDropdownListFilter {
  final String name;
  const MyListf(this.name);

  @override
  String toString() {
    return name;
  }

  @override
  bool filter(String query) {
    return name.toLowerCase().contains(query.toLowerCase());
  }
}

extension StringExtension on String {
  String capitalized() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

String moneyFormat(String price) {
  if (price.length > 2) {
    var value = price;
    value = value.replaceAll(RegExp(r'\D'), '');
    value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ' ');
    return value;
  } else {
    return price;
  }
}

String phoneFormat(String number) {
  if (number.length > 8) {
    var value = number;
    value = value.replaceAll(RegExp(r'\D'), '');
    value = value.replaceAll(RegExp(r'\B(?=(\d{2})+(?!\d))'), ' ');
    return value;
  } else {
    return number;
  }
}

Image myNetImage(String imgUrl, BoxFit mBox, double mywidth, double myheight) {
  return Image.network(
    imgUrl,
    height: myheight,
    width: mywidth,
    loadingBuilder:
        (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
      final totalBytes = loadingProgress?.expectedTotalBytes;
      final bytesLoaded = loadingProgress?.cumulativeBytesLoaded;
      if (totalBytes != null && bytesLoaded != null) {
        return CircularProgressIndicator(
          backgroundColor: Colors.white70,
          value: bytesLoaded / totalBytes,
          color: Colors.blue[900],
          strokeWidth: 5.0,
        );
      } else {
        return child;
      }
    },
    frameBuilder: (BuildContext context, Widget child, int? frame,
        bool wasSynchronouslyLoaded) {
      if (wasSynchronouslyLoaded) {
        return child;
      }
      return AnimatedOpacity(
        opacity: frame == null ? 0 : 1,
        duration: const Duration(seconds: 1),
        curve: Curves.easeOut,
        child: child,
      );
    },
    fit: mBox,
    errorBuilder:
        (BuildContext context, Object exception, StackTrace? stackTrace) {
      return const Text('😢');
    },
  );
}

Image myMemoryImage(imgByte, BoxFit mBox, double mywidth, double myheight) {
  return Image.memory(
    imgByte,
    height: myheight,
    width: mywidth,
    frameBuilder: (BuildContext context, Widget child, int? frame,
        bool wasSynchronouslyLoaded) {
      if (wasSynchronouslyLoaded) {
        return child;
      }
      return AnimatedOpacity(
        opacity: frame == null ? 0 : 1,
        duration: const Duration(seconds: 1),
        curve: Curves.easeOut,
        child: child,
      );
    },
    fit: mBox,
    errorBuilder:
        (BuildContext context, Object exception, StackTrace? stackTrace) {
      return const Text('😢');
    },
  );
}

Image myAssetImage(String imgUrl) {
  return Image.asset(
    imgUrl,
    fit: BoxFit.cover,
  );
}

Widget logoIcon(String imagePath, double width, double height) {
  return SizedBox(
    child: Image.asset(imagePath, width: width, height: height),
  );
}

Widget logoIconD(String logo, double mySizeW, double mySizeH) {
  return Container(
    width: mySizeW,
    height: mySizeH,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
    ),
    child: Image.asset(
      logo,
      fit: BoxFit.cover,
    ),
  );
}

ntEtoile(
    {double note = 0,
    double taille = 22,
    Color myColor = myColorBlue,
    Color myBorderColor = myColorWhite,
    required void Function(double) onChanged}) {
  return StarRating(
    rating: note,
    size: taille,
    color: myColor,
    borderColor: myBorderColor,
    allowHalfRating: true,
    onRatingChanged:onChanged,
  );
}

// ignore: camel_case_types
class myButton extends StatelessWidget {
  final String label;
  final Color color;
  final double borderRadius;
  final TextStyle? textStyle;
  final VoidCallback onPressed;

  const myButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = Colors.blue,
    this.borderRadius = 8.0,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Text(
        label,
        style: textStyle ?? const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}

Widget myBtn({
  String txtBtn = 'Text Boutton',
  String? myfontFamily = '',
  Color txtColor = Colors.white,
  double myfontSize = 16,
  FontWeight myfontWeight = FontWeight.normal,
  double myheight = 50,
  double mywidth = 20,
  double myBorderRadius = 80,
  Color myColor = myColorBlue,
  required void Function()? onPressed,
}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: mywidth),
    width: double.infinity,
    height: myheight,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: myColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(myBorderRadius),
        ),
      ),
      child: Text(
        txtBtn,
        style: TextStyle(
          color: txtColor,
          fontSize: myfontSize,
          fontWeight: myfontWeight,
          fontFamily: myfontFamily,
        ),
      ),
    ),
  );
}

Widget myBtnIcon() {
  return ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        minimumSize: const Size(double.infinity, 50),
        side: const BorderSide(
          color: Colors.black,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        )),
    onPressed: () {
      //signIn();
    },
    icon: const Icon(Icons.login),
    label: const Text('Sign In'),
  );
}

var client = http.Client();

//envoyer une requête GET
Future<List> getData(String enpoint) async {
  //final url = Uri.https(APIServeur, enpoint);
  final url = Uri.parse('$APIServeur$enpoint');
  //final response = await client.get(url);
  var headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Access-Control-Allow-Origin': '*',
  };
  final response = await client.get(
    url,
    headers: headers,
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Échec de l\'envoi des données');
  }
}

//envoyer une requête POST
Future<List> postData(String data, String enpoint) async {
  final url = Uri.https(apiBaseURL, enpoint);
  var headers = {'Content-Type': 'application/json; charset=UTF-8'};

  final response = await client.post(
    url,
    headers: headers,
    body: data,
  );

  if (response.statusCode == 201) {
    return json.decode(response.body);
  } else {
    throw Exception('Échec de l\'envoi des données');
  }
}

Future<List> getdata(String enpoint) async {
  Dio dio = Dio(); // Créer une instance de Dio
  final url = '$APIServeur$enpoint';

  try {
    var response = await dio.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.data); // Affiche les données de la réponse
    } else {
      throw Exception('Échec de l\'envoi des données ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Erreur de réseau : $e');
  }
}

Future<List> postdata(data, String enpoint) async {
  Dio dio = Dio();
  final url = '$APIServeur$enpoint';

  try {
    // Envoyer une requête POST
    var response = await dio.post(
      url,
      data: data,
    );

    if (response.statusCode == 201) {
      return json.decode(response.data);
    } else {
      throw Exception('Échec de l\'envoi des données');
    }
  } catch (e) {
    throw Exception('Erreur de réseau : $e');
  }
}

Future<List> sendReq({required String action, required String requete}) {
  var dataPost = json.encode({
    'data_action': action,
    'Requete': requete,
  });
  return postdata(dataPost, endpoint);
}

String tTotal(int nbrTot) {
  if (nbrTot <= 1) {
    return '$nbrTot résultat trouvé';
  } else {
    return '$nbrTot résultats trouvés';
  }
}

Map<String, String> mydata({required String mReq, String mReq2 = ''}) {
  return {
    'data_action': 'ReqExec',
    'Requete': mReq,
    'Requete2': mReq2,
  };
}

Map<String, String> dataMulti(
    {required String mReq1, String mReq2 = '', String mReq3 = ''}) {
  return {
    'data_action': 'ReqMultiExec',
    'Requete1': mReq1,
    'Requete2': mReq2,
    'Requete3': mReq3,
  };
}

Map<String, String> dataR(String mReq) {
  return {
    'data_action': 'EnvoiRequete',
    'Requete': mReq,
  };
}

String myReq({
  String xNomEtab = '',
  String xVille = '',
  String xCommune = '',
  String xQuartier = '',
  double xPrix = 0,
  xNbrEtoile = false,
  xnoteEtoile = 0,
  bool xWifi = false,
  bool xPiscine = false,
  bool xSpa = false,
  bool xBar = false,
  bool xVentilateur = false,
  bool xClimatiseur = false,
  bool xEstResidence = false,
  bool xEstHotel = false,
  int xL1 = 0,
  int xL2 = 0,
}) {
  String x1 = "AND hotel.NomEtab LIKE '%$xNomEtab%'";
  String x2 = "AND hotel.Ville ='$xVille'";
  String x3 = "AND hotel.Commune ='$xCommune'";
  String x4 = "AND hotel.Quartier LIKE '%$xQuartier%'";
  String x5 = "AND hotel.PrixMini <=$xPrix";
  String x6 = "AND commoditehotel.NbrEtoile =$xnoteEtoile";
  String x7 = "AND commoditehotel.Wifi =$xWifi";
  String x8 = "AND commoditehotel.Piscine =$xPiscine";
  String x9 = "AND commoditehotel.Spa =$xSpa";
  String x10 = "AND commoditehotel.Bar =$xBar";
  String x11 = "AND commoditehotel.Ventilateur =$xVentilateur";
  String x12 = "AND commoditehotel.Climatiseur =$xClimatiseur";
  String x13 = "AND commoditehotel.EstResidence =$xEstResidence";
  String x14 = "LIMIT $xL1,$xL2";

  if (xNomEtab == "") {
    x1 = "";
  }
  if (xVille == "") {
    x2 = "";
  }
  if (xCommune == "") {
    x3 = "";
  }
  if (xQuartier == "") {
    x4 = "";
  }
  if (xPrix == 0) {
    x5 = "";
  }
  if (xNbrEtoile == false) {
    x6 = "";
  }
  if (xWifi == false) {
    x7 = "";
  }
  if (xPiscine == false) {
    x8 = "";
  }
  if (xSpa == false) {
    x9 = "";
  }
  if (xBar == false) {
    x10 = "";
  }
  if (xVentilateur == false) {
    x11 = "";
  }
  if (xClimatiseur == false) {
    x12 = "";
  }
  if ((xEstResidence == false && xEstHotel == false) ||
      (xEstResidence == true && xEstHotel == true)) {
    x13 = "";
  }
  if (xL1 == 0 && xL2 == 0) {
    x14 = "";
  }

  var sXMaReqSQL =
      "SELECT * FROM hotel,commoditehotel WHERE hotel.IDHOTEL = commoditehotel.IDHOTEL $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9 $x10 $x11 $x12 $x13 ORDER BY RAND() $x14 ";

  return sXMaReqSQL;
}

String myReqArtisant({
  String xMetier = '',
  String xCategorie = '',
  String xVille = '',
  String xCommune = '',
  String xQuartier = '',
  double xnoteEtoile = 0,
  int xIDart = 0,
  int xL1 = 0,
  int xL2 = 0,
}) {
  String x1 = "";
  String x2 = "AND metier.Libelle LIKE '%$xMetier%'";
  String x3 = "AND categoriemetier.Categorie ='$xCategorie'";
  String x4 = "AND artisant.Ville ='$xVille'";
  String x5 = "AND artisant.Commune LIKE '%$xCommune%'";
  String x6 = "AND artisant.Quartier LIKE '%$xQuartier%'";
  String x7 = "AND artisant.IDARTISANT = $xIDart";
  String x8 = "AND artisant.Tnote >=$xnoteEtoile";
  String x9 = "LIMIT $xL1,$xL2";

  if (xMetier == "") {
    x2 = "";
  }
  if (xCategorie == "") {
    x3 = "";
  }
  if (xVille == "") {
    x4 = "";
  }
  if (xCommune == "") {
    x5 = "";
  }
  if (xQuartier == "") {
    x6 = "";
  }
  if (xIDart == 0) {
    x7 = "";
  }
  if (xnoteEtoile == 0) {
    x8 = "";
  }

  if (xL1 == 0 && xL2 == 0) {
    x9 = "";
  }

  var sXMaReqSQL =
      'SELECT metier.*,artisant.*,categoriemetier.* FROM categoriemetier INNER JOIN(metier INNER JOIN artisant ON metier.IDmetier = artisant.IDmetier) ON categoriemetier.IDcategoriemetier = artisant.IDcategoriemetier WHERE artisant.IDARTISANT > 0 $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 ORDER BY RAND() $x9';

  return sXMaReqSQL;
}

String myReqTransport({
  String xVille_depart = '',
  String xVille_d_arrivee = '',
  String xNom_Compagnie = '',
  int xL1 = 0,
  int xL2 = 0,
}) {
  String x1 = "AND VilleDepart ='$xVille_depart'";
  String x2 = "AND VilleArrivee ='$xVille_d_arrivee'";
  String x3 = "AND Nom LIKE '%$xNom_Compagnie%'";
  String x4 = "LIMIT $xL1,$xL2";

  if (xVille_depart == "") {
    x1 = "";
  }
  if (xVille_d_arrivee == "") {
    x2 = "";
  }
  if (xNom_Compagnie == "") {
    x3 = "";
  }
  if (xL1 == 0 && xL2 == 0) {
    x4 = "";
  }

  var sXMaReqSQL =
      'SELECT * FROM lignetransport,compagnie WHERE compagnie.IDCOMPAGNIE = lignetransport.IDCOMPAGNIE $x1 $x2 $x3 $x4';

  return sXMaReqSQL;
}

String myReqHoraire({int x1 = 0}) {
  var sXMaReqSQL =
      'SELECT * FROM depart,commoditetransport WHERE depart.IDDEPART = commoditetransport.IDDEPART AND IDLIGNETRANSPORT=$x1';

  return sXMaReqSQL;
}

String myReqEscale({int IdDepart = 0}) {
  var sXMaReqSQL = 'SELECT * FROM escale WHERE IDDEPART=$IdDepart';

  return sXMaReqSQL;
}

imgBase64Dec(img) {
  return base64.decode(img.replaceAll(RegExp(r'\s+'), ''));
}

Future<void> launchURL(Uri url) async {
  try {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalNonBrowserApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  } catch (e) {
    throw Exception(e.toString());
  }
}

void launchCALL(myNumberPhone) {
  launchURL(Uri.parse('tel:$myNumberPhone'));
}

void launchSMS(myNumberPhone) {
  launchURL(Uri.parse('sms:$myNumberPhone'));
}

void launchURI(myTxt) {
  launchURL(Uri.parse('$myTxt'));
}

void defMAPS(myLatitude, myLongitude) {
  launchURL(Uri.parse('geo:$myLatitude,$myLongitude'));
}

void glMAPS(myLatitude, myLongitude) {
  launchURL(Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$myLatitude,$myLongitude'));
}

copyClipBord(
    {required context, required String txtCopy, String msgCopy = ''}) async {
  await Clipboard.setData(ClipboardData(text: txtCopy)).then((_) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.black.withOpacity(0.5),
        margin: const EdgeInsets.all(5),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        content:
            Text(msgCopy == '' ? 'Copiée dans le presse-papier' : msgCopy)));
  });
}

fnSnackmsg(context, txtmsg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.black.withOpacity(0.5),
      margin: const EdgeInsets.all(5),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      content: Text(txtmsg)));
}

class MyBrowser extends StatefulWidget {
  const MyBrowser({
    super.key,
    required this.myUrl,
  });
  final String myUrl;

  @override
  MyBrowserState createState() => MyBrowserState();
}

class MyBrowserState extends State<MyBrowser> {
  late InAppWebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var myWidth = SizeConfig.safeBlockHorizontal!;

    return Container(
      width: myWidth * 95,
      height: 262.5,
      color: myColorBlue,
      child: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(widget.myUrl)),
        onWebViewCreated: (InAppWebViewController controller) {
          _webViewController = controller;
        },
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<InAppWebViewController>(
        '_webViewController', _webViewController));
  }
}

class MyBrowserView extends StatefulWidget {
  const MyBrowserView({
    super.key,
    required this.myUrl,
  });
  final String myUrl;

  @override
  MyBrowserViewState createState() => MyBrowserViewState();
}

class MyBrowserViewState extends State<MyBrowserView> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var myWidth = SizeConfig.safeBlockHorizontal!;

    var controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.myUrl));

    return Container(
      width: myWidth * 95,
      height: 262.5,
      color: myColorBlue,
      child: WebViewWidget(controller: controller),
    );
  }
}

myPub({required String myUrl}) {
  return isMobile() ? MyBrowserView(myUrl: myUrl) : MyBrowser(myUrl: myUrl);
}

List<MyListf> listPays = [
  MyListf('France'),
  MyListf('Allemagne'),
  MyListf('Espagne'),
  MyListf('Italie'),
  MyListf('Angleterre'),
  MyListf('Pays-Bas'),
  MyListf('Belgique'),
  MyListf('Suisse'),
  MyListf('Portugal'),
  MyListf('Pays-Bas'),
  MyListf('Congo'),
  MyListf('Niger'),
  MyListf('Mali'),
  MyListf('Senegal'),
  MyListf('Ghana'),
  MyListf('Nigeria'),
  MyListf('Togo'),
  MyListf('Benin'),
  MyListf('Burkina Faso'),
  MyListf('Côte d\'Ivoire'),
];

List<MyListf> listVille = [
  MyListf(''),
];

List<MyListf> listCat = [
  MyListf(''),
];

List<MyListf> listMetier = [
  MyListf(''),
];

List<MyListf> listCompagnie = [
  MyListf(''),
];

//------------------------Géolocalisation GPS------------------------

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    //await Geolocator.openAppSettings();
    //await Geolocator.openLocationSettings();
    return Future.error('Les services de localisation sont désactivés');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Les autorisations de localisation sont refusées');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Les autorisations de localisation sont définitivement refusées');
  }

  return await Geolocator.getCurrentPosition(
      locationSettings: locationSettings);
}

final LocationSettings locationSettings = LocationSettings(
  accuracy: LocationAccuracy.high,
  distanceFilter: 100,
);


//dio.options.headers['content-Type'] = 'application/json';
//dio.options.headers['content-Type'] = "multipart/form-data";
// return dio.post(api, data: data).then((response) {
//   print(response.data.runtimeType);
//   print(response.data);
//   print(response.data['token']);
// })