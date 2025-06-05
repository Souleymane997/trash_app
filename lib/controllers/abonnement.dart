// ignore_for_file: unused_local_variable

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trash_app/models/abonn_model.dart';
import 'package:trash_app/models/service_model.dart';

import '../service/globals.dart';


class AbonnementController with ChangeNotifier {

  final SupabaseClient supabase = Supabase.instance.client;

  List<AbonnModel> _list = [];
  List<ServiceModel> _listService = [];
  List<AbonnModel> get lists => _list;
  bool loading = false;

  Future<ServiceModel?> getAbonnementService() async {
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
      final response = await supabase.from('abonnements').select().eq('user_id', userId).eq('actif', true);
      _list = (response as List)
          .map((e) => AbonnModel.fromJson(e as Map<String, dynamic>))
          .toList();

      if(_list.isNotEmpty){
        Globals.idAbonn = _list.first.abonnement_id ;

        final response = await supabase.from('services').select().eq('service_id',_list.first.service_id);
        _listService = (response as List)
            .map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
            .toList();
        if(_listService.isNotEmpty){
          return _listService.first ;
        }
      }
    } catch (e) {
      debugPrint("Erreur  : $e");
    }
    loading = false;
    notifyListeners();
    return _listService.first;
  }




  Future<bool> editAbonn({
    required int idService,
  }) async {

    int id = Globals.idAbonn ?? 0 ;
    try {
      final response = await supabase.from('abonnements').update(
          {'service_id':idService,
          }
      ).eq('abonnement_id', id);

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Erreur : $e");
      return false;
    }
  }



}




