import 'package:demandium_serviceman/utils/core_export.dart';
import 'package:get/get.dart';

class ApiChecker {
  static void checkApi(Response response) {
    if(response.statusCode == 401) {
      Get.find<AuthController>().clearSharedData();
      if(Get.currentRoute!=RouteHelper.getSignInRoute('splash')){
        Get.offAllNamed(RouteHelper.getSignInRoute('splash'));
      }
    }if(response.statusCode == 500){
      showCustomSnackBar(response.statusText);
    }else {
      showCustomSnackBar(response.statusText);
    }
  }
}