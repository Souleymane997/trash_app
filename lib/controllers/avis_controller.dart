// ignore_for_file: unused_local_variable

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trash_app/models/avis_model.dart';


class AvisController with ChangeNotifier {
  final SupabaseClient supabase = Supabase.instance.client;

  List<AvisModel> _list = [];
  List<AvisModel> get lists => _list;
  bool loading = false;


  Future<List<AvisModel?>> getAvisByStructure() async {
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
          .from('avis')
          .select().eq('structure_id', userId);

      _list =
          (response as List)
              .map((e) => AvisModel.fromJson(e as Map<String, dynamic>))
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



  Future<bool> addAvis(AvisModel avis) async {

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
          .from('avis')
          .insert({
        'user_id': userId,
        'structure_id': avis.structure_id,
        'comment': avis.comment,
        'notes': avis.notes
      }); //

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
