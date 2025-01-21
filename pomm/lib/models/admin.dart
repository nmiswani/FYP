class Admin {
  String? adminid;
  String? adminemail;
  String? adminpassword;

  Admin({this.adminid, this.adminemail, this.adminpassword});

  Admin.fromJson(Map<String, dynamic> json) {
    adminid = json['adminid'];
    adminemail = json['adminemail'];
    adminpassword = json['adminpassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['adminid'] = adminid;
    data['adminemail'] = adminemail;
    data['adminpassword'] = adminpassword;
    return data;
  }
}
