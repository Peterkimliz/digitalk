class User {
  String? email;
  String? uid;
  String? username;

  User({this.email, this.uid, this.username});

  factory User.fromJson(Map<String, dynamic> json) => User(
        uid: json["uid"],
        email: json["email"],
        username: json["username"],
      );
  Map<String,dynamic>toJson()=>{
    "uid": uid,
    "email": email,
    "username": username,
  };
}
