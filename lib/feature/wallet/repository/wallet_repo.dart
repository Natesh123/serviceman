import 'package:get/get.dart';
import 'package:demandium_serviceman/api/api_client.dart';
import 'package:demandium_serviceman/utils/app_constants.dart';


class WalletRepo {
  final ApiClient apiClient;
  WalletRepo({required this.apiClient});

  Future<Response> getWalletTransactions(int offset) async {
    return await apiClient.getData('${AppConstants.walletTransactionUrl}?limit=10&offset=$offset');
  }
}
