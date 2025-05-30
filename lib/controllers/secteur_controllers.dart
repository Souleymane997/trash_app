// ignore_for_file: unused_local_variable

import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/secteur.dart';


class SecteurController with ChangeNotifier {

  final SupabaseClient supabase = Supabase.instance.client;

  List<SecteurModel> _listSecteurs = [];
  List<SecteurModel> get roles => _listSecteurs;
  bool loading = false;

  Future<List<SecteurModel>> getListSecteur() async {
    loading = true;
    notifyListeners();

    try {
      final response = await supabase.from('secteurs').select();

      _listSecteurs = (response as List)
          .map((e) => SecteurModel.fromJson(e as Map<String, dynamic>))
          .toList();

      log("Premier Secteurs : ${_listSecteurs.last.secteur}");
    } catch (e) {
      debugPrint("Erreur lors du chargement des Secteurs : $e");
    }

    loading = false;
    notifyListeners();
    return _listSecteurs;
  }


  Future<bool> addASecteur(String secteur, int idArrond) async {

    try {
      final response = await supabase.from('secteurs').insert({
        'secteur':secteur,
        'arrondissement_id': idArrond
      });

      if (kDebugMode) {
        print('Secteur ajouté : $response');
      }
      notifyListeners();
      return true;

    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de l’ajout du Secteur : $e');
      }
      return false;
    }
  }



  Future<bool> editSecteur({
    required int id,
    required String secteur,
    required int idArrond,

  }) async {
    try {
      final response = await supabase.from('secteurs').update({'secteur': secteur , 'arrondissement_id': idArrond}).eq('id', id);

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Erreur lors de la modification du Secteur : $e");
      return false;
    }
  }



  Future<bool> deleteSecteur(int id) async {
    try {
      final response = await supabase.from('secteurs').delete().eq('id', id);

      return true;
    } catch (e) {
      debugPrint("Erreur lors de la suppression : $e");
      return false;
    }
  }





  Future<List<SecteurModel>> getSecteursWithArrondissement() async {
    final List<SecteurModel> secteurs = [];
    try {
      final response = await Supabase.instance.client
          .from('secteurs')
          .select('id, secteur, arrondissements(id, arrondissement)');

      for (var item in response) {
        secteurs.add(SecteurModel.fromJson(item));
      }
    } catch (e) {
      debugPrint("Erreur chargement secteurs : $e");
    }
    return secteurs;
  }





}




