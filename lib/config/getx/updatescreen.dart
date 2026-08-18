import 'package:get/get.dart';

class ChkController extends GetxController {
  var txtresult = ''.obs;
  var notNote = 0.0.obs;

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

  void changeNote(rate) {
    notNote.value = rate;
  }
}

class EscaleController extends GetxController {
  var dataEscale = [].obs;

    @override
  void onClose() {
    dataEscale.value = [];
  }

  void tEscale(data) {
    dataEscale.value = data;
  }
}
