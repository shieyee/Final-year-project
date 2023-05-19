class Tender {
  String? productId;
  String? userId;
  String? productName;
  String? productDesc;
  String? productPrice;
  String? productQty;
  String? productType;
  String? productDate;
  String? tenderId;
  String? tenderStatus;
  String? tenderPending;

  Tender(
      {this.productId,
      this.userId,
      this.productName,
      this.productDesc,
      this.productPrice,
      this.productQty,
      this.productType,
      this.productDate,
      this.tenderId,
      this.tenderStatus,
      this.tenderPending,});

  Tender.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    userId = json['user_id'];
    productName = json['product_name'];
    productDesc = json['product_desc'];
    productPrice = json['product_price'];
    productQty = json['product_qty'];
    productType = json['product_type'];
    productDate = json['product_date'];
    tenderId = json['tender_id'];
    tenderStatus = json['tender_status'];
    tenderPending = json['tender_pending'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['user_id'] = this.userId;
    data['product_name'] = this.productName;
    data['product_desc'] = this.productDesc;
    data['product_price'] = this.productPrice;
    data['product_qty'] = this.productQty;
    data['product_type'] = this.productType;
    data['product_date'] = this.productDate;
    data['tender_id'] = this.tenderId;
    data['tender_status'] = this.tenderStatus;
    data['tender_pending'] = this.tenderPending;
    return data;
  }
}