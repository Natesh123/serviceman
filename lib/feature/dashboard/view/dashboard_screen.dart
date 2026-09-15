import 'package:get/get.dart';
import 'package:demandium_serviceman/utils/core_export.dart';


class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key}) ;
  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}
class _DashBoardScreenState extends State<DashBoardScreen> {

  void _loadData(){
    Get.find<DashboardController>().getDashboardData(reload: false);
    Get.find<UserController>().getUserInfo();
    Get.find<DashboardController>().changeToYearlyEarnStatisticsChart(EarningType.monthly);
    Get.find<DashboardController>().getMonthlyBookingsDataForChart(
      DateConverter.stringYear(DateTime.now()),DateTime.now().month.toString(),
      isRefresh: true
    );
    Get.find<DashboardController>().getYearlyBookingsDataForChart(
      DateConverter.stringYear(DateTime.now()),
      isRefresh: true
    );
    Get.find<NotificationController>().getNotifications(1,saveNotificationCount: false);
    Get.find<NotificationController>().getBroadcastNotifications(saveNotificationCount: false, showLoading: false);
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  MainAppBar(
        color: Theme.of(context).primaryColor,
        title: AppConstants.appName,
        titleFontSize: Dimensions.fontSizeOverLarge,
      ),
      body: RefreshIndicator(
        backgroundColor: Theme.of(context).colorScheme.surface,
        color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha:0.6),
        onRefresh: () async {
          _loadData();
        },
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()
          ),
          child: GetBuilder<DashboardController>(
            builder: (dashboardController){
              return dashboardController.isLoading ?
              const DashboardTopCardShimmer() :

              const Column(
                children:[
                  BusinessSummerySection(),
                  BookingStatisticsSection(),
                  RecentActivitySection(),
                  SizedBox(height: Dimensions.paddingSizeDefault,)
                ],
              );
            },
          ),
        ),
      )
    );
  }
}
