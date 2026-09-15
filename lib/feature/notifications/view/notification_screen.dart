import 'package:demandium_serviceman/common/widgets/no_data_screen.dart';
import 'package:get/get.dart';
import 'package:demandium_serviceman/utils/core_export.dart';


class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key}) ;
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  @override
  void initState() {
    super.initState();
    Get.find<NotificationController>().getNotifications(1,reload: true);
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopScopeWidget(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: CustomAppBar(title: "notifications".tr),
        body: RefreshIndicator(
          onRefresh: () async {
            Get.find<NotificationController>().getNotifications(1);
            },
          child: GetBuilder<NotificationController>(

            builder: (controller) {

            return controller.notificationModel == null ? const NotificationShimmer() : controller.dateList.isEmpty ?
            NoDataScreen(text: 'empty_notifications'.tr, type: NoDataType.notification,):
            CustomScrollView(
              controller: controller.scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: Column(children: [
                  ListView.builder(
                    itemBuilder: (context, index0) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeDefault,
                                vertical: Dimensions.paddingSizeDefault
                            ),
                            width: Get.width,
                            color:Theme.of(context).colorScheme.surface,
                            child: Text(Get.find<NotificationController>().dateList[index0],
                              textDirection: TextDirection.ltr,
                              style: robotoBold.copyWith(
                                  fontSize: Dimensions.fontSizeLarge,
                                  color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha:0.7)
                              )
                            )
                          ),
                          ListView.builder(
                            itemBuilder: (context, index1) {
                              return InkWell(
                                onTap:(){
                                  String? coverImage = controller.notificationList[index0][index1].coverImage;
                                  String? bookingId;
                                  String? bookingType;
                                  if (coverImage != null && coverImage.contains('|')) {
                                    List<String> parts = coverImage.split('|');
                                    bookingId = parts[0];
                                    bookingType = parts[1];
                                  }

                                  if (bookingId != null && bookingId.isNotEmpty) {
                                    Get.toNamed(RouteHelper.getBookingDetailsRoute(
                                      bookingId: bookingId,
                                      fromPage: 'fromNotification',
                                      isSubBooking: bookingType == "repeat",
                                    ));
                                  } else {
                                    showDialog(context: context, builder: (ctx)  => NotificationDialog(
                                      title: controller.notificationList[index0][index1].title.toString().trim(),
                                      subTitle: "${controller.notificationList[index0][index1].description}",
                                      imageUrl: '${controller.notificationList[index0][index1].coverImageFullPath}',
                                    ));
                                  }
                                },

                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: Dimensions.paddingSizeSmall,
                                      vertical: Dimensions.paddingSizeSmall,

                                    ),
                                    color: Theme.of(context).cardColor.withValues(alpha:Get.isDarkMode?0.5:1),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 2.0),
                                              child: InkWell(
                                                onTap: () {
                                                  String? notificationId = controller.notificationList[index0][index1].id;
                                                  if (notificationId != null) {
                                                    controller.markAsRead(notificationId);
                                                  }
                                                },
                                                child: Icon(
                                                  Icons.check_circle_outline,
                                                  color: Theme.of(context).primaryColor,
                                                  size: 24,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: Dimensions.paddingSizeDefault,),

                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(controller.notificationList[index0][index1].title.toString().trim(),
                                                    style: robotoMedium.copyWith(
                                                      color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha:0.7),
                                                      fontSize: Dimensions.fontSizeDefault
                                                    )
                                                  ),
                                                  const SizedBox(height: Dimensions.paddingSizeSmall),

                                                  Text("${controller.notificationList[index0][index1].description}",
                                                    style: robotoRegular.copyWith(
                                                      color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha:0.5),
                                                      fontSize: Dimensions.fontSizeDefault
                                                    ),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ]),
                                            ),

                                            SizedBox(
                                              height: 40, width: 60,
                                              child: Text(DateConverter.convertStringTimeToDate(DateConverter.isoUtcStringToLocalDate(
                                                  controller.notificationList[index0][index1].createdAt))
                                              )
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                ),
                              );
                            },
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.notificationList[index0].length,
                          )
                        ],
                      );
                    },
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.dateList.length,
                  ),
                  controller.isLoading? const CircularProgressIndicator():const SizedBox(),


                ],),
                ),
                const SliverToBoxAdapter(
                  child:   SizedBox(height: Dimensions.paddingSizeExtraLarge),
                )
              ]);
          },
        ))),
    );
  }
}




