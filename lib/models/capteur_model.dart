
// ignore_for_file: non_constant_identifier_names

class CapteurModel {
  late int id;
  late double distance ;
  late String fill_state ;
  late double latitude ;
  late double longitude;
  late DateTime time ;


  CapteurModel(
      { required this.id,
        required this.distance,
        required this.fill_state,
        required this.latitude,
        required this.longitude,
        required this.time

      });

  factory CapteurModel.fromJson(Map<String, dynamic> json) {
    return CapteurModel(
        id: json['id'],
        distance: json['distance'],
        fill_state: json['fill_state'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        time: DateTime.parse(json['timestamp']),
    );

  }
}