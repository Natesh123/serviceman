import 'package:get/get.dart';
import 'package:demandium_serviceman/utils/core_export.dart';
import 'package:demandium_serviceman/feature/wallet/controller/wallet_controller.dart';
import 'package:demandium_serviceman/feature/profile/controller/user_controller.dart';
import 'package:intl/intl.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {

  @override
  void initState() {
    super.initState();
    Get.find<WalletController>().getWalletTransactions(1);
    Get.find<UserController>().getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: MainAppBar(
        title: "my_wallet".tr,
        color: Theme.of(context).primaryColor,
      ),
      body: GetBuilder<WalletController>(builder: (walletController) {
        return Column(
          children: [
            _buildTopCard(context),
            Expanded(
              child: walletController.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : walletController.transactionList.isNotEmpty
                  ? ListView.builder(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                itemCount: walletController.transactionList.length,
                itemBuilder: (context, index) {
                   return _buildTransactionCard(context, walletController.transactionList[index]);
                },
              )
                  : Center(child: Text("no_transaction_found".tr)),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildTopCard(BuildContext context) {
    return GetBuilder<UserController>(builder: (userController) {
      return Container(
        height: 150,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(Dimensions.radiusDefault),
            bottomRight: Radius.circular(Dimensions.radiusDefault),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "total_earnings".tr,
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
             Text(
                PriceConverter.convertPrice(Get.find<WalletController>().totalEarnings ?? 0),
                style: robotoBold.copyWith(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTransactionCard(BuildContext context, var transaction) {
    bool isCredit = transaction.credit != null && transaction.credit! > 0;
    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3), 
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                   transaction.trxType != null ? transaction.trxType.toString().replaceAll('_', ' ').capitalizeFirst! : "",
                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
              Text(
                DateConverter.isoStringToLocalDateAndTime(transaction.createdAt!),
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ],
          ),
          Text(
            "${isCredit ? '+' : '-'} ${PriceConverter.convertPrice(isCredit ? transaction.credit! : transaction.debit!)}",
            style: robotoBold.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: isCredit ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
