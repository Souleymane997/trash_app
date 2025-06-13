// ignore_for_file: unused_local_variable

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trash_app/models/photo_model.dart';


class PhotoController with ChangeNotifier {
  final SupabaseClient supabase = Supabase.instance.client;

  List<PhotoModel> _list = [];
  List<PhotoModel> get lists => _list;
  bool loading = false;


  Future<List<PhotoModel?>> getListPhotos() async {
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
          .from('photos')
          .select();

      _list =
          (response as List)
              .map((e) => PhotoModel.fromJson(e as Map<String, dynamic>))
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



  Future<bool> addPhotoViolation(PhotoModel photo) async {

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
          .from('photos')
          .insert({
        'user_id': userId,
        'image_path': photo.image_path,
        'date_upload': photo.date_upload,
        'description': photo.description,
        'lieu': photo.lieu
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


  Future<PhotoModel?> getPhotoViolation(String id) async {

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
          .from('photos').select().eq('id', id);

      _list =
          (response as List)
              .map((e) => PhotoModel.fromJson(e as Map<String, dynamic>))
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



}
