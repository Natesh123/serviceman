class WalletTransactionModel {
  String? responseCode;
  String? message;
  TransactionContent? content;

  WalletTransactionModel({this.responseCode, this.message, this.content});

  WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    content =
    json['content'] != null ? TransactionContent.fromJson(json['content']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['response_code'] = responseCode;
    data['message'] = message;
    if (content != null) {
      data['content'] = content!.toJson();
    }
    return data;
  }
}

class TransactionContent {
  int? currentPage;
  List<TransactionData>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  Null nextPageUrl;
  String? path;
  int? perPage;
  Null prevPageUrl;
  int? to;
  int? total;
  double? totalEarnings;

  TransactionContent(
      {this.currentPage,
        this.data,
        this.firstPageUrl,
        this.from,
        this.lastPage,
        this.lastPageUrl,
        this.nextPageUrl,
        this.path,
        this.perPage,
        this.prevPageUrl,
        this.to,
        this.total});

  TransactionContent.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <TransactionData>[];
      json['data'].forEach((v) {
        data!.add(TransactionData.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
    if(json['total_earnings'] != null){
      totalEarnings = double.tryParse(json['total_earnings'].toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = firstPageUrl;
    data['from'] = from;
    data['last_page'] = lastPage;
    data['last_page_url'] = lastPageUrl;
    data['next_page_url'] = nextPageUrl;
    data['path'] = path;
    data['per_page'] = perPage;
    data['prev_page_url'] = prevPageUrl;
    data['to'] = to;
    data['total'] = total;
    return data;
  }
}

class TransactionData {
  String? id;
  String? refTrxId;
  String? bookingId;
  String? trxType;
  double? debit;
  double? credit;
  double? balance;
  String? fromUserId;
  String? toUserId;
  String? createdAt;
  String? updatedAt;

  TransactionData(
      {this.id,
        this.refTrxId,
        this.bookingId,
        this.trxType,
        this.debit,
        this.credit,
        this.balance,
        this.fromUserId,
        this.toUserId,
        this.createdAt,
        this.updatedAt});

  TransactionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    refTrxId = json['ref_trx_id'];
    bookingId = json['booking_id'];
    trxType = json['trx_type'];
    debit = double.tryParse(json['debit'].toString());
    credit = double.tryParse(json['credit'].toString());
    balance = double.tryParse(json['balance'].toString());
    fromUserId = json['from_user_id'];
    toUserId = json['to_user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ref_trx_id'] = refTrxId;
    data['booking_id'] = bookingId;
    data['trx_type'] = trxType;
    data['debit'] = debit;
    data['credit'] = credit;
    data['balance'] = balance;
    data['from_user_id'] = fromUserId;
    data['to_user_id'] = toUserId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
