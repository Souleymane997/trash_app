// ignore_for_file: unused_local_variable

import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trash_app/models/role.dart';


class RoleController with ChangeNotifier {

  final SupabaseClient supabase = Supabase.instance.client;

  List<RoleModel> _roles = [];
  List<RoleModel> get roles => _roles;

  bool loading = false;

  Future<List<RoleModel>> getListRoles() async {
    loading = true;
    notifyListeners();

    try {
      final response = await supabase.from('role').select();

      _roles = (response as List)
          .map((e) => RoleModel.fromJson(e as Map<String, dynamic>))
          .toList();

      log("Première rôle : ${_roles.last.role}");
    } catch (e) {
      debugPrint("Erreur lors du chargement des rôles : $e");
    }

    loading = false;
    notifyListeners();
    return _roles;
  }


  Future<bool> addRole(String roleName) async {
    final supabase = Supabase.instance.client;

    try {
      final response = await supabase.from('role').insert({
        'role': roleName,
      });

      if (kDebugMode) {
        print('Rôle ajouté : $response');
      }
      notifyListeners();
      return true;

    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de l’ajout du rôle : $e');
      }
      return false;
    }
  }



  Future<bool> editRole({
    required int id,
    required String newRoleName,
  }) async {
    try {
      final response = await supabase.from('role').update({'role': newRoleName}).eq('id', id);

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Erreur lors de la modification du rôle : $e");
      return false;
    }
  }




  Future<bool> deleteRole(int roleId) async {
    try {
      final response = await Supabase.instance.client
          .from('role')
          .delete()
          .eq('id', roleId);

      return true;
    } catch (e) {
      debugPrint("Erreur lors de la suppression : $e");
      return false;
    }
  }




}




