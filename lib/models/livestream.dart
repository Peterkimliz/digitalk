class Livestream {
  final String image;
  final String title;
  final String channelId;
  final startedtAt;
  final String username;
  final String uid;
  final int viewers;

  Livestream(
      {required this.uid,
      required this.image,
      required this.username,
      required this.title,
      required this.channelId,
      required this.startedtAt,
      required this.viewers});

  factory Livestream.fromJson(Map<String, dynamic> json) => Livestream(
      uid: json["uid"],
      image: json["image"],
      username: json["username"],
      title: json["title"],
      channelId: json["channelId"],
      startedtAt: json["startedtAt"],
      viewers: json["viewers"]);

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "username": username,
        "title": title,
        "image": image,
        "channelId": channelId,
        "viewers": viewers,
        "startedtAt": startedtAt
      };
}
