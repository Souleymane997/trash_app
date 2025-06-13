
// ignore_for_file: non_constant_identifier_names

class PhotoModel {
  late String id;
  late String user_id ;
  late String image_path;
  late String description;
  late String date_upload;
  late String lieu ;

  PhotoModel(
      { required this.id,
        required this.user_id,
        required this.image_path,
        required this.date_upload,
        required this.description,
        required this.lieu
      });

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      id: json['id'],
      user_id: json['user_id'],
      image_path: json['image_path'],
      date_upload: json['date_upload'],
      description: json['description'],
      lieu: json['lieu'],
    );

  }
}