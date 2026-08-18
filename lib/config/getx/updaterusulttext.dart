import 'package:get/get.dart';

class NbrController extends GetxController {
  var txtresult = ''.obs;


  @override
  void onClose() {
    txtresult.value = '0 résultat trouvé';
  }

  void tTotal(nbrTot) {
    if (nbrTot <= 1) {
      txtresult.value = '$nbrTot résultat trouvé';
    } else {
      txtresult.value = '$nbrTot résultats trouvés';
    }
  }
}
