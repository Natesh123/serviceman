import 'package:demandium_serviceman/utils/core_export.dart';
import 'package:get/get.dart';

void showCustomSnackBar(String? message, {
  ToasterMessageType type = ToasterMessageType.error,
  int duration =2, String? toasterTitle, String? icon}) {
  if(message != null && message.isNotEmpty) {
    Get.closeAllSnackbars();
    Get.showSnackbar(GetSnackBar(
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.transparent,
      duration: Duration(seconds: duration),
      overlayBlur: 0.0,
      messageText: Material(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF393f47),
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              icon !=null  ? Image.asset(icon, width: 25,) : Icon( type == ToasterMessageType.error ? Icons.cancel : type == ToasterMessageType.info ?  Icons.info  : Icons.check_circle,
                color: type == ToasterMessageType.info ? Colors.blueAccent : type == ToasterMessageType.error  ? const Color(0xffFF9090).withValues(alpha:0.5) : const Color(0xff039D55),
                size: 20,
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  if(toasterTitle !=null) Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(toasterTitle.tr, style: robotoMedium.copyWith(color : Colors.white, ), maxLines: 3, overflow: TextOverflow.ellipsis,),
                  ),
                  Text(message, style: robotoRegular.copyWith(color : Colors.white.withValues(alpha:0.8), height: toasterTitle !=null ?  1.0 : 1.2), maxLines: 3, overflow: TextOverflow.ellipsis),
                ]),
              ),
            ]),
          ),
        ),
      ),
      borderRadius: 10,
      padding: const EdgeInsets.all(0),
      snackStyle: SnackStyle.FLOATING,
      isDismissible: true,
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      reverseAnimationCurve: Curves.fastEaseInToSlowEaseOut,
      animationDuration: const Duration(milliseconds: 500),
    ));
  }
}