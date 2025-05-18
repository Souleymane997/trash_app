// ignore_for_file: unused_local_variable

import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trash_app/models/arrondissement.dart';


class ArrondController with ChangeNotifier {

  final SupabaseClient supabase = Supabase.instance.client;

  List<ArrondissementModel> _listArrondissement = [];
  List<ArrondissementModel> get roles => _listArrondissement;
  bool loading = false;

  Future<List<ArrondissementModel>> getListArrondissement() async {
    loading = true;
    notifyListeners();

    try {
      final response = await supabase.from('arrondissements').select();

      _listArrondissement = (response as List)
          .map((e) => ArrondissementModel.fromJson(e as Map<String, dynamic>))
          .toList();

      log("Premier Arrondissement : ${_listArrondissement.last.arrondissement}");
    } catch (e) {
      debugPrint("Erreur lors du chargement des Arrondissement : $e");
    }

    loading = false;
    notifyListeners();
    return _listArrondissement;
  }


  Future<bool> addArrondissement(String arrondissementName) async {

    try {
      final response = await supabase.from('arrondissements').insert({
        'arrondissement': arrondissementName
      });

      if (kDebugMode) {
        print('Arrondissement ajouté : $response');
      }
      notifyListeners();
      return true;

    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de l’ajout du Arrondissement : $e');
      }
      return false;
    }
  }



  Future<bool> editArrondissement({
    required int id,
    required String newArrondissementName,
  }) async {
    try {
      final response = await supabase.from('arrondissements').update({'arrondissement': newArrondissementName}).eq('id', id);

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Erreur lors de la modification de l' Arrondissement : $e");
      return false;
    }
  }




  Future<bool> deleteArrondissement(int id) async {
    try {

      final deleteSecteurs = await supabase.from('secteurs').delete().eq('arrondissement_id', id);


      final response = await supabase.from('arrondissements').delete().eq('id', id);

      return true;
    } catch (e) {
      debugPrint("Erreur lors de la suppression : $e");
      return false;
    }
  }




}




