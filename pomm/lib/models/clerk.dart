class Clerk {
  String? clerkid;
  String? clerkemail;
  String? clerkpassword;

  Clerk({this.clerkid, this.clerkemail, this.clerkpassword});

  Clerk.fromJson(Map<String, dynamic> json) {
    clerkid = json['clerkid'];
    clerkemail = json['clerkemail'];
    clerkpassword = json['clerkpassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['clerkid'] = clerkid;
    data['clerkemail'] = clerkemail;
    data['clerkpassword'] = clerkpassword;
    return data;
  }
}
