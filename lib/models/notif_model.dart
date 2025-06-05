// ignore_for_file: non_constant_identifier_names


class NotifModel {
  late int notification_id;
  late String user_id ;
  late String structure_id;
  late int requete_id ;
  late String date_envoi ;
  late String description;
  late String type_notification;
  late bool lecture;

  NotifModel(
      { required this.notification_id,
        required this.user_id,
        required this.structure_id,
        required this.requete_id,
        required this.description,
        required this.date_envoi,
        required this.type_notification,
        required this.lecture
      });

  NotifModel.fromJson(Map<String, dynamic> json) {
    notification_id = json['notification_id'];
    user_id = json['user_id'];
    structure_id = json['structure_id'];
    requete_id = json['requete_id'];
    description = json['description'];
    date_envoi = json['date_envoi']??"";
    type_notification = json['type_notification'];
    lecture = json['lecture'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['notification_id'] =notification_id;
    data['user_id'] =user_id;
    data['structure_id'] =structure_id ;
    data['requete_id'] = requete_id;
    data['description'] = description;
    data['date_envoi'] = date_envoi;
    data['type_notification'] = type_notification;
    data['lecture'] = lecture;

    return data;
  }

}
