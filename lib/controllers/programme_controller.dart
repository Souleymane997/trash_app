// ignore_for_file: unused_local_variable

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trash_app/models/programme_model.dart';


class ProgrammeController with ChangeNotifier {
  final SupabaseClient supabase = Supabase.instance.client;

  List<ProgrammeModel> _list = [];
  List<ProgrammeModel> get lists => _list;
  bool loading = false;


  Future<List<ProgrammeModel?>> getProgrammeByStructure() async {
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
          .from('programme')
          .select().eq('structure_id', userId);

      _list =
          (response as List)
              .map((e) => ProgrammeModel.fromJson(e as Map<String, dynamic>))
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



  Future<bool> addProgramme(List<String> jour) async {

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
          .from('programme')
          .insert({
        'structure_id': userId,
        'jour1': jour[0],
        'jour2': jour[1]
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




  Future<bool> editProgramme(List<String> jour , int idProgramme) async {

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
          .from('programme')
          .update({
        'jour1': jour[0],
        'jour2': jour[1]
      }).eq('id', idProgramme); //

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Erreur  : $e");
    }
    loading = false;
    notifyListeners();

    return false;
  }



  Future<List<ProgrammeModel?>> getProgrammeByUser( String idStructure) async {
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
          .from('programme')
          .select().eq('structure_id', idStructure);

      _list =
          (response as List)
              .map((e) => ProgrammeModel.fromJson(e as Map<String, dynamic>))
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
