
// ignore_for_file: non_constant_identifier_names

class CapteurModel {
  late int id;
 // late double distance ;
  late String sensor_id ;
  late double pourcent ;
  late String fill_state ;
  late double latitude ;
  late double longitude;
  late DateTime time ;


  CapteurModel(
      { required this.id,
       // required this.distance,
        required this.sensor_id,
        required this.fill_state,
        required this.pourcent,
        required this.latitude,
        required this.longitude,
        required this.time

      });

  factory CapteurModel.fromJson(Map<String, dynamic> json) {
    return CapteurModel(
        id: json['id'],
       // distance: json['distance'],
      sensor_id: json['sensor_id'],
      pourcent: json['pourcent'],
        fill_state: json['fill_state'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        time: DateTime.parse(json['timestamp']),
    );

  }
}

class CapteurStringModel {
  int? id;
  late String sensor_id;

  CapteurStringModel(
      {this.id,
        required this.sensor_id
      });

  CapteurStringModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sensor_id = json['sensor_id'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sensor_id'] = sensor_id;
    return data;
  }

  @override
  String toString() {
    return sensor_id;
  }
}