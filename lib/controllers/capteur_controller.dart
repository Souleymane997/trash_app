// ignore_for_file: unused_local_variable

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/capteur_model.dart';


class CapteurController with ChangeNotifier {
  final SupabaseClient supabase = Supabase.instance.client;

  List<CapteurModel> _list = [];
  List<CapteurModel> get lists => _list;
  bool loading = false;


  Future<List<CapteurModel?>> getList() async {
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
          .select()
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

}
