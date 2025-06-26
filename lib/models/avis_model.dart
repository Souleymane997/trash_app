
// ignore_for_file: non_constant_identifier_names

class AvisModel {
  late int id;
  late String user_id ;
  late String structure_id ;
  late String comment;
  late String nom ;
  late String tel ;
  late int notes;
  late String date ;


  AvisModel(
      { required this.id,
        required this.user_id,
        required this.structure_id,
        required this.comment,
        required this.nom,
        required this.tel,
        required this.date,
        required this.notes

      });

  factory AvisModel.fromJson(Map<String, dynamic> json) {
    return AvisModel(
        id: json['id'],
        user_id: json['user_id'],
        structure_id: json['structure_id'],
        comment: json['comment'],
        nom: json['nom'],
        tel: json['tel'],
        date: json['date'],
        notes: json['notes']
    );

  }
}