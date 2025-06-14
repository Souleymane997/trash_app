
// ignore_for_file: non_constant_identifier_names

class ProgrammeModel {
  late int id;
  late String structure_id ;
  late String jour1;
  late String jour2;


  ProgrammeModel(
      { required this.id,
        required this.structure_id,
        required this.jour1,
        required this.jour2

      });

  factory ProgrammeModel.fromJson(Map<String, dynamic> json) {
    return ProgrammeModel(
      id: json['id'],
      structure_id: json['structure_id'],
      jour1: json['jour1'],
      jour2: json['jour2']
    );

  }
}