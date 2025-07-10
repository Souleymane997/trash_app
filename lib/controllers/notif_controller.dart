// ignore_for_file: unused_local_variable

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trash_app/models/notif_model.dart';


class NotifController with ChangeNotifier {

  final SupabaseClient supabase = Supabase.instance.client;

  List<NotifModel> _list = [];
  List<NotifModel> get notifs => _list;
  bool loading = false;

  Future<List<NotifModel>> getList() async {
    loading = true;
    notifyListeners();

    try {
      final response = await supabase.from('notifications').select();
      _list = (response as List)
          .map((e) => NotifModel.fromJson(e as Map<String, dynamic>))
          .toList();

    } catch (e) {
      debugPrint("Erreur lors du chargement des Notifs: $e");
    }

    loading = false;
    notifyListeners();
    return _list;
  }



  Future<bool> getNewNotifStructure() async {

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
      final response = await supabase.from('notifications').select().eq('structure_id',userId).eq('lecture', false).order('notification_id', ascending: false);

      _list = (response as List)
          .map((e) => NotifModel.fromJson(e as Map<String, dynamic>))
          .toList();

      if(_list.isNotEmpty){
        return true ;
      }
      else{
        return false ;
      }

    } catch (e) {
      debugPrint("Erreur lors du chargement des Notifs: $e");
    }

    loading = false;
    notifyListeners();
    return false;
  }



  Future<List<NotifModel>> getListNotifStructure() async {

    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      if (kDebugMode) {
        print("❌ Aucun utilisateur connecté.");
      }
      return _list;
    }


    loading = true;
    notifyListeners();

    try {
      final response = await supabase.from('notifications').select().eq('structure_id',userId).order('notification_id', ascending: false);
      _list = (response as List)
          .map((e) => NotifModel.fromJson(e as Map<String, dynamic>))
          .toList();

    } catch (e) {
      debugPrint("Erreur lors du chargement des Notifs: $e");
    }

    loading = false;
    notifyListeners();
    return _list;
  }


  Future<bool> addNotif(NotifModel item) async {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;

    try {
      final response = await supabase.from('notifications').insert({
      'user_id' : userId,
      'structure_id' : item.structure_id ,
      'requete_id' : item.requete_id,
      'description' : item.description ,
      'date_envoi' : '${DateTime.now().day}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().year.toString().padLeft(2, '0')}',
      'type_notification' : item.type_notification,
      'lecture' : false
      });

      if (kDebugMode) {
        print('Notification envoyé : $response');
      }
      notifyListeners();
      return true;

    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de l envoi : $e');
      }
      return false;
    }
  }



  Future<bool> lecture({
    required int id,
    required bool lu,
  }) async {
    try {
      final response = await supabase.from('notifications').update({
        'lecture' : lu
      }).eq('notification_id', id);

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Erreur : $e");
      return false;
    }
  }




  Future<bool> delete(int id) async {
    try {

      final response = await supabase.from('notifications').select().eq('notification_id',id).limit(1);

      if(response.isNotEmpty){
        _list = (response as List)
            .map((e) => NotifModel.fromJson(e as Map<String, dynamic>))
            .toList();

        int idRequete = _list.first.requete_id ;

        final delete1 = await supabase.from('requetes').delete().eq('requete_id', idRequete);

        final delete = await supabase.from('notifications').delete().eq('notification_id', id);

        return true;

      }
      else{
        return false ;
      }






    } catch (e) {
      debugPrint("Erreur lors de la suppression : $e");
      return false;
    }
  }


}




