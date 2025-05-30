// ignore_for_file: unused_local_variable

import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trash_app/models/users_model.dart';


class UserController with ChangeNotifier {

  final SupabaseClient supabase = Supabase.instance.client;

  List<UserModel> _list = [];
  List<UserModel> get roles => _list;
  bool loading = false;

  Future<List<UserModel>> getListUser() async {
    loading = true;
    notifyListeners();

    try {
      final response = await supabase.from('structures').select();

      _list = (response as List)
          .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList();

      log("Premiere structure: ${_list.last.nom}");
    } catch (e) {
      debugPrint("Erreur lors du chargement des Users : $e");
    }

    loading = false;
    notifyListeners();
    return _list ;
  }




  Future<List<UserModel>> getUserWithArrondissement() async {
    final List<UserModel> users= [];
    try {
      final response = await Supabase.instance.client
          .from('users')
          .select('id, nom,tel,email,password,adresse,role(id,role),arrondissements(id, arrondissement)').eq('role_id', 1);

      for (var item in response) {
        users.add(UserModel.fromJson(item));
      }
    } catch (e) {
      debugPrint("Erreur chargement des users : $e");
    }
    return users;
  }



  Future<List<UserModel>> getAdminWithArrondissement() async {
    final List<UserModel> users= [];
    try {
      final response = await Supabase.instance.client
          .from('users')
          .select('id, nom,tel,email,password,adresse,role(id,role),arrondissements(id, arrondissement)').eq('role_id', 3);

      for (var item in response) {
        users.add(UserModel.fromJson(item));
      }
    } catch (e) {
      debugPrint("Erreur chargement des admins : $e");
    }
    return users;
  }



  Future<bool> signUpUser({
    String? email,
    String? tel,
    required UserModel item,
  }) async {
    final supabase = Supabase.instance.client;
    AuthResponse response;

    try {
      if (email != null) {
        response = await supabase.auth.signUp(email: email, password: item.password);
      } else if (tel != null) {
        response = await supabase.auth.signUp(phone: tel, password: item.password);
      } else {
        throw Exception("Email ou téléphone requis.");

      }

      final user = response.user;
      if (user == null) throw Exception("Échec de l'inscription");


    await supabase.from('users').insert({
        'id': user.id,
        'nom': item.nom,
        'tel': item.tel,
        'email': item.email,
        'password': item.password,
        'adresse': item.adresse,
        'role_id': item.role_id,
        'arrondissement_id': item.arrondissement_id,
      });

      if (kDebugMode) {
        print('Utilisateur créé avec succès');
      }
      return true ;
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de l’inscription : $e');
      }
      return false ;
    }
  }


  Future<bool> loginUser({
    String? email,
    String? phone,
    required String password,
  }) async {
    final supabase = Supabase.instance.client;

    try {
      final AuthResponse res;

      if (email != null) {
        res = await supabase.auth.signInWithPassword(
          email: email,
          password: password,
        );
      } else if (phone != null) {
        res = await supabase.auth.signInWithPassword(
          phone: phone,
          password: password,
        );
      } else {
        throw Exception('Email ou téléphone requis.');
      }

      final session = res.session;
      final user = res.user;

      if (session != null && user != null) {
        if (kDebugMode) {
          print("✅ Connexion réussie : ${user.email ?? user.phone}");
        }
        return true ;
      } else {
        if (kDebugMode) {
          print("❌ Échec de la connexion.");
        }
        return false ;
      }
    } catch (e) {
      if (kDebugMode) {
        print("❌ Erreur lors de la connexion : $e");
      }
      return false ;
    }
  }


  Future<UserModel> getUserDetails() async {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      if (kDebugMode) {
        print("❌ Aucun utilisateur connecté.");
      }
      return _list.first;
    }

    final data = await supabase
        .from('users')
        .select('id, nom,tel,email,password,adresse,role(id,role),arrondissements(id, arrondissement)')
        .eq('id', userId) ;

    _list = (data as List)
        .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
        .toList();

    notifyListeners();
    return _list.first ;
  }








  Future<bool> addUsers(UserModel item) async {
    try {
      final response = await supabase.from('users').insert({
        'nom': item.nom,
        'tel': item.tel,
        'email': item.email,
        'password': item.password,
        'adresse': item.adresse,
        'role_id': item.role_id,
        'arrondissement_id': item.arrondissement_id,
      });

      if (kDebugMode) {
        print('users crée : $response');
      }
      notifyListeners();
      return true;

    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la creation: $e');
      }
      return false;
    }
  }



  Future<bool> updateAdminRole({
    required String id,
    required int roleId
  }) async {
    try {
      final response = await supabase.from('users').update({
        'role_id': roleId,
      }).eq('id', id);

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Erreur lors de la modification des informations : $e");
      return false;
    }
  }


  Future<bool> logout() async {
    try {
      await Supabase.instance.client.auth.signOut();

      if (kDebugMode) {
        print('Déconnexion réussie');
      }
      return true ;
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la déconnexion : $e');
      }
      return false ;
    }
  }




  Future<bool> deleteUser(int id) async {
    try {
      final response = await supabase.from('users').delete().eq('id', id);

      return true;
    } catch (e) {
      debugPrint("Erreur lors de la suppression : $e");
      return false;
    }
  }

}




