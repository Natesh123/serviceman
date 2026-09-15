import 'package:get/get.dart';
import 'package:demandium_serviceman/utils/core_export.dart';
import 'package:demandium_serviceman/feature/notifications/model/notofication_model.dart';
import 'package:demandium_serviceman/feature/notifications/repository/notification_repo.dart';



class NotificationController extends GetxController implements GetxService{
  final NotificationRepo notificationRepo;
  NotificationController({required this.notificationRepo});

  NotificationModel? _notificationModel;
  NotificationModel? get notificationModel => _notificationModel;
  List<String> dateList = [];
  List allNotificationList=[];
  List<dynamic> notificationList=[];
  
  List<dynamic> broadcastNotificationList = [];
  bool isLoadingBroadcast = false;
  String debugMessage = "Init";

  final bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _paginationLoading = false;
  bool get paginationLoading => _paginationLoading;

  int _notificationCount = 0;
  int get unseenNotificationCount => _notificationCount;

  int _unseenBroadcastNotificationCount = 0;
  int get unseenBroadcastNotificationCount => _unseenBroadcastNotificationCount;

  int _totalNumberOfNotification=0;
  int get totalNumberOfNotification => _totalNumberOfNotification;

  int? _pageSize = 1;
  int _offset = 1;

  int get offset => _offset;
  int? get pageSize => _pageSize;

  ScrollController scrollController = ScrollController();

  @override
  void onInit(){
    super.onInit();
    scrollController.addListener(() {
      if(scrollController.position.maxScrollExtent/2 < scrollController.position.pixels) {
        if(_offset < _pageSize! ) {
          getNotifications(offset+1, reload: false);
        }
      }
    });
  }

  Future<void> getNotifications(int offset, {bool reload = true,bool saveNotificationCount=true})async{
    _offset = offset;


    Response response = await notificationRepo.getNotification(offset);
    if(reload){
      dateList =[];
      notificationList =[];
    }
    else {
      _paginationLoading = true;
    }
    if(response.statusCode == 200){

      allNotificationList =[];
      _totalNumberOfNotification = 0;
      _notificationModel =  NotificationModel.fromJson(response.body);

      _pageSize = response.body['content']['last_page'];

      _totalNumberOfNotification  = notificationModel!.content!.total??0;

      getNotificationCount();
      int unseenBookingAcceptedCount = 0;
      if (notificationModel != null && notificationModel!.content != null && notificationModel!.content!.data != null) {
        int checkCount = _notificationCount;
        if (checkCount > notificationModel!.content!.data!.length) {
          checkCount = notificationModel!.content!.data!.length;
        }
        for (int i = 0; i < checkCount; i++) {
          String title = notificationModel!.content!.data![i].title ?? "";
          if (title.toLowerCase().contains("accept")) {
            unseenBookingAcceptedCount++;
          }
        }
      }
      _notificationCount = _notificationCount - unseenBookingAcceptedCount;
      if (_notificationCount < 0) {
        _notificationCount = 0;
      }

      if(saveNotificationCount){
        setNotificationCount(_totalNumberOfNotification);
      }

      List<String> readNotifications = notificationRepo.getReadNotifications();

      for (var data in notificationModel!.content!.data!) {
        String title = data.title ?? "";
        if (title.toLowerCase().contains("accept")) {
          continue;
        }
        if (!readNotifications.contains(data.id)) {
          allNotificationList.add(data);
        }
      }

      for (var data in notificationModel!.content!.data!) {
        String title = data.title ?? "";
        if (title.toLowerCase().contains("accept")) {
          continue;
        }
        if (!readNotifications.contains(data.id)) {
          if(!dateList.contains(DateConverter.dateStringMonthYear(DateTime.tryParse(data.createdAt!)))) {
            dateList.add(DateConverter.dateStringMonthYear(DateTime.tryParse(data.createdAt!)));
          }
        }
      }

      for(int i=0;i< dateList.length;i++){
        notificationList.add([]);
        for (var element in allNotificationList) {
          if(dateList[i]== DateConverter.dateStringMonthYear(DateTime.tryParse(element.createdAt!))){
            notificationList[i].add(element);
          }
        }
      }

    } else{
      ApiChecker.checkApi(response);
    }
    _paginationLoading = false;
    update();
  }

  Future<void> getBroadcastNotifications({bool saveNotificationCount = true, bool showLoading = true}) async {
    // Prevent "setState() called during build" by waiting for the current frame to finish
    await Future.delayed(const Duration(milliseconds: 10));
    
    if (showLoading) {
      isLoadingBroadcast = true;
      update();
    }
    try {
      Response response = await Get.find<ApiClient>().getData('/api/v1/serviceman/booking/broadcast-notifications');
      if(response.statusCode == 200){
        broadcastNotificationList = response.body['content'] ?? [];
        
        int? savedCount = await notificationRepo.getBroadcastNotificationCount();
        if (savedCount != null) {
          _unseenBroadcastNotificationCount = broadcastNotificationList.length - savedCount;
          if (_unseenBroadcastNotificationCount < 0) _unseenBroadcastNotificationCount = 0;
        } else {
          _unseenBroadcastNotificationCount = broadcastNotificationList.length;
        }

        if (saveNotificationCount) {
          notificationRepo.setBroadcastNotificationCount(broadcastNotificationList.length);
          _unseenBroadcastNotificationCount = 0;
        }
      }
    } catch (e) {
      debugMessage = "Exception: $e";
    } finally {
      if (showLoading) {
        isLoadingBroadcast = false;
      }
      update();
    }
  }

  void resetBroadcastNotificationCount() {
    _unseenBroadcastNotificationCount = 0;
    notificationRepo.setBroadcastNotificationCount(broadcastNotificationList.length);
    update();
  }

  Future<void> markAsRead(String notificationId) async {
    await notificationRepo.markAsRead(notificationId);
    getNotifications(_offset, reload: true, saveNotificationCount: false);
  }

  void getNotificationCount() async {
    _notificationCount = (await notificationRepo.getNotificationCount())!;
    if(_totalNumberOfNotification>_notificationCount){
      _notificationCount = _totalNumberOfNotification - _notificationCount;
    }else{
      _notificationCount =0;
    }

    update();
  }

  void resetNotificationCount(){
    _notificationCount = 0;
    update();
  }
  void setNotificationCount(int count){
    notificationRepo.setNotificationCount(count);
  }
}