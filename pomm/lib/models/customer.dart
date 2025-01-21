class Customer {
  String? customerid;
  String? customeremail;
  String? customername;
  String? customerphone;
  String? customerpassword;

  Customer(
      {this.customerid,
      this.customeremail,
      this.customername,
      this.customerphone,
      this.customerpassword});

  Customer.fromJson(Map<String, dynamic> json) {
    customerid = json['customerid'];
    customeremail = json['customeremail'];
    customername = json['customername'];
    customerphone = json['customerphone'];
    customerpassword = json['customerpassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerid'] = customerid;
    data['customeremail'] = customeremail;
    data['customername'] = customername;
    data['customerphone'] = customerphone;
    data['customerpassword'] = customerpassword;
    return data;
  }
}
