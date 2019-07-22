/// Station.dart A model class for API CALL

class Station {
  final String id;
  final String name;
  final String url;
  final String img;
  final String website;

  Station({this.id, this.name, this.url, this.img, this.website});

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: json['id'],
      name: json['name'],
      url: json['url'],
      img: json['img'],
      website: json['website'],
    );
  }
}