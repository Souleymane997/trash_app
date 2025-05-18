class RoleModel {
  int? id;
  late String role;

  RoleModel(
      {this.id,
        required this.role
      });

  RoleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['role'] = role;
    return data;
  }
}
