import 'package:demandium_serviceman/utils/core_export.dart';
import 'package:demandium_serviceman/feature/profile/widget/custom_checkbox.dart';
import 'package:demandium_serviceman/feature/profile/widget/time_picker_widget.dart';
import 'package:get/get.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class ServiceAvailabilitySetup extends StatelessWidget {
  const ServiceAvailabilitySetup({super.key});

  @override
  Widget build(BuildContext context) {
    JustTheController tooltipController = JustTheController();

    return GetBuilder<UserController>(builder: (userController){
      return Scaffold(
        appBar: CustomAppBar(title: "service_availability".tr),
        body: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          boxShadow: Get.find<ThemeController>().darkTheme ? null : [BoxShadow(color: Colors.grey[200]!, blurRadius: 5, spreadRadius: 1)],
                        ),
                        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        margin: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("service_availability".tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                              FlutterSwitch(
                                width: 50.0,
                                height: 25.0,
                                valueFontSize: 12.0,
                                toggleSize: 18.0,
                                value: userController.serviceAvailabilitySettings,
                                borderRadius: 30.0,
                                padding: 2.0,
                                activeColor: Theme.of(context).primaryColor,
                                inactiveColor: Colors.grey,
                                onToggle: (val) {
                                  userController.toggleServiceAvailabilitySettings();
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
                          Text("service_availability_hint".tr,
                            style: robotoRegular.copyWith(
                                color: Theme.of(context).textTheme.bodySmall?.color,
                                fontSize: Dimensions.fontSizeSmall + 1
                            ),
                            textAlign: TextAlign.justify,
                          )
                        ],),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
                      Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            boxShadow: Get.find<ThemeController>().darkTheme ? null : [BoxShadow(color: Colors.grey[200]!, blurRadius: 5, spreadRadius: 1)]
                        ),
                        margin: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start ,children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeLarge, Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall),
                            child: Row(children: [
                              Image.asset(Images.iconCalendar, height: 20, width: 20,),
                              const SizedBox(width: Dimensions.paddingSizeExtraSmall,),
                              Text("availability_schedule".tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),),
                              const SizedBox(width: Dimensions.paddingSizeExtraSmall,),
                              JustTheTooltip( backgroundColor: Colors.black87, controller: tooltipController,
                                preferredDirection: AxisDirection.down, tailLength: 14, tailBaseWidth: 20,
                                content: Padding( padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                                  child:  Text("service_availability_hint_text".tr, style: robotoRegular.copyWith(color: Colors.white,)),
                                ),
                                child:  InkWell( onTap: ()=> tooltipController.showTooltip(),
                                  child: Icon(Icons.info_outline_rounded, color: Theme.of(context).colorScheme.primary, size: 18,),
                                ),
                              )
                            ],),
                          ),
                          Divider(color: Theme.of(context).hintColor,),
                          Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                            child: Text("service_providing_time".tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha:0.8)),),
                          ),
                          Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                            child: Row(
                              children: [
                                Text("from".tr, style: robotoRegular.copyWith(),),
                                const SizedBox(width: Dimensions.paddingSizeSmall,),
                                Expanded(child: TimePickerWidget(
                                  title: 'open_time'.tr,
                                  time: userController.serviceStartTime,
                                  onTimeChanged: (time){
                                    userController.setServiceStartTime = time;
                                  },
                                )),
                                const SizedBox(width: Dimensions.paddingSizeDefault,),
                                Text("till".tr, style: robotoRegular.copyWith(),),
                                const SizedBox(width: Dimensions.paddingSizeSmall,),
                                Expanded(child: TimePickerWidget(
                                  title: 'close_time'.tr, time: userController.serviceEndTime,
                                  onTimeChanged: (time) =>userController.setServiceEndTime = time,
                                )),
                              ],
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall,),
                          Divider(color: Theme.of(context).hintColor,),
                          Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                            child: Text("weekend".tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha:0.8)),),
                          ),
                          GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisExtent: 40,
                            ),
                            itemBuilder: (context,index){
                            return InkWell(
                              onTap: ()=>userController.toggleDaysCheckedValue(index),
                              child: CustomCheckBox(title: userController.daysList[index],
                                value: userController.daysCheckList[index],
                                onTap: ()=>userController.toggleDaysCheckedValue(index),
                              ),
                            );
                          },itemCount: userController.daysList.length,
                            shrinkWrap: true,
                            physics : const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeDefault * 1.5,),
                        ],),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall,),
              CustomButton(btnTxt: "save_information".tr,
                onPressed: ()=> userController.updateServiceAvailabilitySettingsIntoServer(),
                isLoading: userController.isLoading,
              )
            ],
          ),
        ),
      );
    });
  }
}
