import 'package:get/get.dart';

class ImgController extends GetxController {
  var txtDescription = ''.obs;
  var  iMg64=''.obs;

  void fDescription(txt) {
      txtDescription.value = txt;
  }
  void fImg64(img) {
      iMg64.value = img;
  }
}
