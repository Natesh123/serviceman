import 'package:get/get.dart';
import 'package:demandium_serviceman/utils/core_export.dart';
import 'package:demandium_serviceman/feature/wallet/repository/wallet_repo.dart';
import 'package:demandium_serviceman/feature/wallet/model/wallet_transaction_model.dart';


class WalletController extends GetxController implements GetxService {
  final WalletRepo walletRepo;
  WalletController({required this.walletRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<TransactionData> _transactionList = [];
  List<TransactionData> get transactionList => _transactionList;

  double? _totalEarnings = 0.0;
  double? get totalEarnings => _totalEarnings;

  int? _pageSize;
  int _offset = 1;

  Future<void> getWalletTransactions(int offset, {bool reload = false}) async {
    if (offset == 1 || reload) {
      _offset = 1;
      _transactionList = [];
      _isLoading = true;
      if(reload) update();
    }
    
    Response response = await walletRepo.getWalletTransactions(offset);
    if (kDebugMode) {
      print("Wallet API Status: ${response.statusCode}, Body: ${response.body}");
    }
    
    if (response.statusCode == 200) {
      if(offset == 1) {
        _transactionList = [];
      }
      WalletTransactionModel walletTransactionModel = WalletTransactionModel.fromJson(response.body);
      if(walletTransactionModel.content != null && walletTransactionModel.content!.data != null){
           _transactionList.addAll(walletTransactionModel.content!.data!);
           _pageSize = walletTransactionModel.content!.lastPage;
           _totalEarnings = walletTransactionModel.content!.totalEarnings;
      }

    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }
}
