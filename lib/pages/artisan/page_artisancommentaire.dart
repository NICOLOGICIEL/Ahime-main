import 'package:ahime/config/getx/updatescreen.dart';
import 'package:flutter/material.dart';
import 'package:ahime/config/my_config.dart';
import 'package:ahime/config/utils/my_titlesub.dart';
import 'package:ahime/config/utils/resizable.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:ahime/config/utils/dropdownlist.dart';


class PageArtisantCommentaire extends StatefulWidget {
  const PageArtisantCommentaire({super.key});

  @override
  State<PageArtisantCommentaire> createState() =>
      _PageArtisantCommentaireState();
}

class _PageArtisantCommentaireState extends State<PageArtisantCommentaire> {
   //
  final ChkController rateNote = Get.put(ChkController());
  final TextEditingController txtNomcontroller = TextEditingController();
  final TextEditingController txtTitrecontroller = TextEditingController();
  final TextEditingController txtCommentairecontroller =TextEditingController();

  MyListf cmbMetier = MyListf('');

  void changeMetierValue(value) {
    cmbMetier = value;
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
                myTlt(context, 'Commentaire', myWidth),
                myResultList(context, myWidth, myHeight)
              ],
            ),
          ),
        ),
      ),
    );
  }

  myTlt(BuildContext context, String myTitle, double myWidth) {
    return Container(
      alignment: Alignment.center,
      width: myWidth * 100,
      height: 35,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            iconSize: 20,
            color: Colors.grey[600],
            onPressed: () {
              popPage(context);
            },
          ),
          Text(
            myTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: myColorBlue,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            // Pour créer un espace identiquie entre les deux
            width: 50,
            height: 1,
          ),
        ],
      ),
    );
  }

  Container myResultList(
      BuildContext context, double myWidth, double myHeight) {
    return Container(
      width: myWidth * 100,
      height: myHeight * 100,
      decoration: const BoxDecoration(
        color: myColorWhite,
        image: DecorationImage(
          image: AssetImage('$imageUri/bg-Trasn.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          const tltTotalresult(myResult: '0 résultat trouvé'),
          const SizedBox(height: 2),
          myCnt(context, myWidth, myHeight),
          const SizedBox(height: 2),
          btnAjout(context),
        ],
      ),
    );
  }

  SizedBox myCnt(BuildContext context, double myWidth, double myHeight) {
    return SizedBox(
      width: myWidth * 100,
      height: myHeight * 83,
      child: ListView.builder(
        itemCount: 20,
        itemBuilder: (BuildContext context, int index) {
          return listCommentaire(context, index);
        },
      ),
    );
  }

  Column listCommentaire(BuildContext context, int index) {
    return Column(
      children: [
        Container(
          margin:
              const EdgeInsets.only(left: 10, right: 10, top: 1, bottom: 15),
          padding: const EdgeInsets.only(left: 10, right: 10),
          height: 185,
          decoration: const BoxDecoration(
            color: Colors.white, // Background color
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            children: [
              myHeadT(),
              myDescription(context, SizeConfig.safeBlockHorizontal!,
                  SizeConfig.safeBlockVertical!)
            ],
          ),
        ),
      ],
    );
  }

  myDescription(BuildContext context, double myWidth, double myHeight) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(top: 7),
        height: 125,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            txtText(txtVille: 'Titre du commentaire'.toUpperCase()),
            const SizedBox(height: 4),
            txtCommentaire(
                'Lorem ipsum dolor sit amet, consectefhfdhhghgh ffhfh ghgh tur dfsdf dsfsdgsdgd. adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex'),
            txtText(txtVille: 'Ville', mytextAlign: TextAlign.start),
          ],
        ),
      ),
    );
  }

  Row myHeadT() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ntEtoile(note: 2, onChanged: (value) {}),
        const Icon(
          Icons.more_vert,
          color: Colors.grey,
        )
      ],
    );
  }

  Widget txtText({
    required String txtVille,
    double myfontSize = 16,
    TextAlign? mytextAlign = TextAlign.center,
    FontWeight? myfontWeight = FontWeight.bold,
    Color? mycolor = myColorBlue,
  }) {
    return SizedBox(
      width: double.infinity,
      height: myfontSize + 4,
      child: Text(
        txtVille,
        textAlign: mytextAlign,
        style: TextStyle(
          color: mycolor,
          fontSize: myfontSize,
          fontWeight: myfontWeight,
        ),
      ),
    );
  }

  Widget btnAjout(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
      width: double.infinity,
      height: 45,
      child: myBtn(
        txtBtn: 'Ajouter un commentaire',
        myfontSize: 18,
        myheight: 50,
        onPressed: () {
          displayBottomSheet(context, SizeConfig.safeBlockVertical!);
        },
      ),
    );
  }

  void displayBottomSheet(BuildContext context, double myHeight) {
    showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: myHeight * 55,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                myHead(context),
                const SizedBox(height: 15),
                myBody(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Row myHead(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(
          width: 50,
          height: 1,
        ),
        const Text(
          'Ajouter un commentaire',
          style: TextStyle(
              color: myColorBlue,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Noteworthy-Lt'),
        ),
        IconButton(
          onPressed: () {
            popPage(context);
          },
          icon: const Icon(Icons.close),
          color: myColorBlue,
        )
      ],
    );
  }

  myBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 5),
        Obx(() => myRating(rateNote.notNote.value, rateNote.changeNote)),
        const SizedBox(height: 5),
        mySaisie('Votre nom',true,txtNomcontroller,1),
        const SizedBox(height: 3),
        mySaisie('Titre du commentaire',true,txtTitrecontroller,1),
        const SizedBox(height: 3),
        mySaisie('Tapez votre commentaire',true,txtCommentairecontroller,5),
        const SizedBox(height: 10),
        myBoutton(context),
        const SizedBox(height: 3),
        mySearchtxt('Métier', listMetier, changeMetierValue),
      ],
    );
  }

  Widget myBoutton(BuildContext context) {
    return myBtn(
      txtBtn: 'Enregister',
      myfontSize: 18,
      myheight: 50,
      onPressed: () {
         //txtNomcontroller
         //txtTitrecontroller
         //txtCommentairecontroller
        popPage(context);
      },
    );
  }

  myRating(double note, void Function(double) onChanged) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ntEtoile(
              note: note,
              taille: 24,
              myBorderColor: myColorGreyBorber,
              onChanged: onChanged),
          Text(
            '(Nombre d\'étoiles)',
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 13,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  mySaisie(String txLibelle, bool isText, TextEditingController controller,int mymaxLines) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '        $txLibelle',
          textAlign: TextAlign.start,
          style: const TextStyle(
            color: myColorBlue,
            fontSize: 14,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 25),
          child: TextField(
            maxLines:mymaxLines,
            controller: controller,
            decoration: const InputDecoration(
              filled: true,
              fillColor: myColorBgGrey,
              contentPadding: EdgeInsets.symmetric(horizontal: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide.none,
              ),
            ),
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
            textAlign: TextAlign.start,
            keyboardType: isText ? TextInputType.text : TextInputType.number,
            inputFormatters: isText
                ? [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^[a-zA-Z0-9\s]+$'))
                  ]
                : [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
            cursorColor: myColorBlue,
          ),
        )
      ],
    );
  }

    mySearchtxt(String txLibelle, List<MyListf> myItems,
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
              fontSize: 14,
            ),
          ),
          SearchDropdown(
            myItems: myItems,
            myhintText: "",
            onChanged: onChanged,
            headerFontSize: 14,
          ),
        ],
      ),
    );
  }

  Widget txtCommentaire(String myTitle) {
    return Container(
      width: double.infinity,
      height: 100,
      margin: const EdgeInsets.only(left: 3, right: 3),
      padding: const EdgeInsets.only(left: 3, right: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView(
        padding: const EdgeInsets.all(5),
        children: [
          ReadMoreText(
            myTitle,
            trimMode: TrimMode.Line,
            trimLines: 4,
            textAlign: TextAlign.justify,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
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
}
