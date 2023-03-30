class User {
  String? id;
  String? email;
  String? username;
  String? contactno;
  String? regdate;
  String? otp;

  User(
      {this.id,
      this.email,
      this.username,
      this.contactno,
      this.regdate,
      this.otp});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    username = json['username'];
    contactno = json['contactno'];
    regdate = json['regdate'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['username'] = this.username;
    data['contactno'] = this.contactno;
    data['regdate'] = this.regdate;
    data['otp'] = this.otp;
    return data;
  }
}