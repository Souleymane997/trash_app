// ignore_for_file: unused_local_variable

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trash_app/models/requete.dart';
import '../models/notif_model.dart';
import '../models/users_model.dart';
import 'notif_controller.dart';


class RequeteController with ChangeNotifier {
  final SupabaseClient supabase = Supabase.instance.client;

  List<RequeteModel> _list = [];
  List<RequeteModel> get lists => _list;
  bool loading = false;


  Future<List<RequeteModel?>> getListRequetebyUser(String idStructure) async {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      if (kDebugMode) {
        print("❌ Aucun utilisateur connecté.");
      }
      return [];
    }
    loading = true;
    notifyListeners();

    try {
      final response = await supabase
          .from('requetes')
          .select()
          .eq('structure_id', idStructure)
          .eq('user_id', userId)
          .inFilter('statut', ['En attente', 'Acceptee']);

      _list =
          (response as List)
              .map((e) => RequeteModel.fromJson(e as Map<String, dynamic>))
              .toList();
      
      if(_list.isEmpty) {
        return [];
      }

      return  _list ;
      
    } catch (e) {
      debugPrint("Erreur  : $e");
    }
    loading = false;
    notifyListeners();

    return [];
  }

  Future<List<RequeteModel?>> getListRequetebyStructure(String idStructure) async {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      if (kDebugMode) {
        print("❌ Aucun utilisateur connecté.");
      }
      return [];
    }
    loading = true;
    notifyListeners();

    try {
      final response = await supabase
          .from('requetes')
          .select()
          .eq('structure_id', idStructure);


      _list =
          (response as List)
              .map((e) => RequeteModel.fromJson(e as Map<String, dynamic>))
              .toList();

      if(_list.isEmpty) {
        return [];
      }

      return _list ;

    } catch (e) {
      debugPrint("Erreur  : $e");
    }
    loading = false;
    notifyListeners();

    return [];
  }

  Future<bool> askRequete(String idStructure , String date) async {

    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;


    if (userId == null) {
      if (kDebugMode) {
        print("❌ Aucun utilisateur connecté.");
      }
      return false;
    }
    loading = true;
    notifyListeners();

    final data = await supabase
        .from('users')
        .select('id, nom,tel,email,password,adresse,role(id,role),secteurs(id,secteur),arrondissements(id, arrondissement)')
        .eq('id', userId) ;

    List<UserModel> list = (data as List)
        .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
        .toList();


    final existing = await Supabase.instance.client
        .from('requetes')
        .select()
        .eq('user_id', userId)
        .eq('statut', 'En attente')
        .maybeSingle(); // ou .limit(1)

    if (existing != null) {
      // Déjà une requête en attente
      debugPrint('Vous avez déjà une requête en attente.');
      return false ;
    }

    notifyListeners();

    try {
      final response = await supabase
          .from('requetes')
          .insert({
            'structure_id': idStructure,
            'user_id': userId,
            'statut': 'En attente',
            'date_requete': date,
          }).select(); //

    if (response.isEmpty) {
      debugPrint('Erreur ou insertion échouée');
      return false;
    }

    final inserted = response.first;
    final idRequete = inserted['requete_id'];
    final nomUser = list.first.nom;
    final adresse = list.first.adresse ;
    final secteur = list.first.secteur ;

    NotifModel item = NotifModel(notification_id: 1, user_id: userId, structure_id: idStructure, requete_id: idRequete, description: " M/Mme $nomUser demande un ramassage urgent d'ordure au $secteur precisement á $adresse le $date. ", date_envoi:'' , type_notification: 'requete', lecture: false) ;

    bool ress =  await NotifController().addNotif(item) ;
      if(ress){
        notifyListeners();
        return true;
      }else{
        return false ;
      }

    } catch (e) {
      debugPrint("Erreur  : $e");
    }
    loading = false;
    notifyListeners();

    return false;
  }


  Future<RequeteModel?> getRequete(int idRequete) async {

    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      if (kDebugMode) {
        print("❌ Aucun utilisateur connecté.");
      }
      return null;
    }
    loading = true;
    notifyListeners();

    try {
      final response = await supabase
          .from('requetes').select().eq('requete_id', idRequete);

      _list =
          (response as List)
              .map((e) => RequeteModel.fromJson(e as Map<String, dynamic>))
              .toList();


      notifyListeners();
      return _list.first ;

    } catch (e) {
      debugPrint("Erreur  : $e");
    }
    loading = false;
    notifyListeners();

    return null;
  }




  Future<bool> agreeRequete(int idRequete) async {

    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      if (kDebugMode) {
        print("❌ Aucun utilisateur connecté.");
      }
      return false;
    }
    loading = true;
    notifyListeners();

    try {
      final response = await supabase
          .from('requetes')
          .update({
            'statut': 'Acceptee',
          }).eq('requete_id', idRequete);


      notifyListeners();
      return true;

    } catch (e) {
      debugPrint("Erreur  : $e");
    }
    loading = false;
    notifyListeners();

    return false;
  }

  Future<bool> refuserRequete(int idRequete) async {

    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      if (kDebugMode) {
        print("❌ Aucun utilisateur connecté.");
      }
      return false;
    }
    loading = true;
    notifyListeners();

    try {
      final response = await supabase
          .from('requetes')
          .update({
        'statut': 'Refuser',
      }).eq('requete_id', idRequete);


      notifyListeners();
      return true;

    } catch (e) {
      debugPrint("Erreur  : $e");
    }
    loading = false;
    notifyListeners();

    return false;
  }

  Future<bool> cloturerRequete(int idRequete) async {

    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      if (kDebugMode) {
        print("❌ Aucun utilisateur connecté.");
      }
      return false;
    }
    loading = true;
    notifyListeners();

    try {
      final response = await supabase
          .from('requetes')
          .update({
        'statut': 'Cloturer',
      }).eq('requete_id', idRequete);


      notifyListeners();
      return true;

    } catch (e) {
      debugPrint("Erreur  : $e");
    }
    loading = false;
    notifyListeners();

    return false;
  }

}
