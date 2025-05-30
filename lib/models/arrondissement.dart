class ArrondissementModel {
  int? id;
  late String arrondissement;

  ArrondissementModel(
      { this.id,
        required this.arrondissement
      });

  ArrondissementModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    arrondissement = json['arrondissement'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['arrondissement'] = arrondissement;
    return data;
  }


  @override
  String toString() {
    return arrondissement;
  }
}
