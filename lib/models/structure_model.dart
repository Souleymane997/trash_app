class StructureModel {
  int? id;
  late String nom;
  late String tel;
  late int idArrondissement;

  StructureModel (
      {this.id,
        required this.nom,
        required this.tel,
        required this.idArrondissement
      });

  StructureModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom = json['nom'];
    tel = json['tel'];
    idArrondissement = json['idArrondissement'];

  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nom'] = nom;
    data['tel'] = tel;
    data['idArrondissement'] = idArrondissement;

    return data;
  }
}
