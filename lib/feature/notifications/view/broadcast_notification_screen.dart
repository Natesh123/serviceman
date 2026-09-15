import 'package:demandium_serviceman/common/widgets/no_data_screen.dart';
import 'package:get/get.dart';
import 'package:demandium_serviceman/utils/core_export.dart';

class BroadcastNotificationScreen extends StatefulWidget {
  const BroadcastNotificationScreen({super.key});

  @override
  State<BroadcastNotificationScreen> createState() => _BroadcastNotificationScreenState();
}

class _BroadcastNotificationScreenState extends State<BroadcastNotificationScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<NotificationController>().getBroadcastNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: CustomAppBar(
        title: 'City Broadcasts',
        centerTitle: true,
      ),
      body: GetBuilder<NotificationController>(builder: (notificationController) {
        // if (notificationController.isLoadingBroadcast) {
        //   return const Center(child: Text('Loading Data...'));
        // }
        
        if (notificationController.broadcastNotificationList.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NoDataScreen(text: 'No broadcasts available in your city', type: NoDataType.notification,),
            ],
          );
        }

        return ListView.builder(
          itemCount: notificationController.broadcastNotificationList.length,
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          itemBuilder: (context, index) {
            var data = notificationController.broadcastNotificationList[index];
            return InkWell(
              onTap: () {
                if (data['booking_id'] != null) {
                  Get.toNamed(RouteHelper.getBookingDetailsRoute(
                    bookingId: data['booking_id'].toString(), 
                    fromPage: 'fromBroadcast',
                  ));
                }
              },
              child: Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            data['title'] ?? 'New Broadcast',
                            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          ),
                          child: Text(
                            'New',
                            style: robotoMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    Text(
                      data['body'] ?? 'No description provided.',
                      style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.6)),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        data['created_at'] != null ? DateConverter.dateMonthYearTime(DateConverter.isoUtcStringToLocalDate(data['created_at'])) : '',
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            );
          },
        );
      }),
    );
  }
}
