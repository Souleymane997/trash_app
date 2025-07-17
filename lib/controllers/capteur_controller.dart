// ignore_for_file: unused_local_variable

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/capteur_model.dart';


class CapteurController with ChangeNotifier {
  final SupabaseClient supabase = Supabase.instance.client;

  List<CapteurModel> _list = [];
  List<CapteurStringModel> _listString = [];
  List<CapteurModel> get lists => _list;
  bool loading = false;


  Future<List<CapteurModel?>> getList(String id) async {
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
          .from('sensordata')
          .select().eq('sensor_id', id)
          .order('timestamp', ascending: false);

      debugPrint(response.toString()) ;

      _list =
          (response as List)
              .map((e) => CapteurModel.fromJson(e as Map<String, dynamic>))
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


  Future<List<CapteurStringModel?>> getListCapteur() async {
    final supabase = Supabase.instance.client;

    try {
      final response = await supabase.from('capteur').select();

      debugPrint(response.toString()) ;
      _listString =
          (response as List)
              .map((e) => CapteurStringModel.fromJson(e as Map<String, dynamic>))
              .toList();

      if(_listString.isEmpty) {
        return [];
      }
      notifyListeners();
      return  _listString ;
    } catch (e) {
      debugPrint("Erreur  : $e");
    }
    loading = false;
    notifyListeners();
    return [];
  }

  Future<bool> addCapteur(String id) async {
    final supabase = Supabase.instance.client;

    try {
      final response = await supabase.from('capteur').insert({
        'sensor_id':id,
      });

      if (kDebugMode) {
        print('capteur ajouté : $response');
      }
      notifyListeners();
      return true;

    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de l’ajout du capteur : $e');
      }
      return false;
    }
  }


  Future<bool> editCapteur({
    required int id,
    required String newCapteur,
  }) async {
    try {
      final response = await supabase.from('capteur').update({'sensor_id': newCapteur}).eq('id', id);

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Erreur lors de la modification de l'id du Capteur : $e");
      return false;
    }
  }

  Future<bool> deleteCapteur(int id ) async {
    try {
      final response = await Supabase.instance.client
          .from('capteur')
          .delete()
          .eq('id', id);

      return true;
    } catch (e) {
      debugPrint("Erreur lors de la suppression : $e");
      return false;
    }
  }

  Future<bool> deleteCapteurData(String idSensor) async {
    try {
      final response = await Supabase.instance.client
          .from('sensordata')
          .delete()
          .eq('sensor_id', idSensor);

      return true;
    } catch (e) {
      debugPrint("Erreur lors de la suppression : $e");
      return false;
    }
  }

}
