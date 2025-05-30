// ignore_for_file: unused_local_variable

import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trash_app/models/structure_model.dart';


class StructureController with ChangeNotifier {

  final SupabaseClient supabase = Supabase.instance.client;

  List<StructureModel> _listStructure = [];
  List<StructureModel> get roles => _listStructure;
  bool loading = false;

  Future<List<StructureModel>> getListStructure() async {
    loading = true;
    notifyListeners();

    try {
      final response = await supabase.from('structures').select();

      _listStructure = (response as List)
          .map((e) => StructureModel.fromJson(e as Map<String, dynamic>))
          .toList();

      log("Premiere structure: ${_listStructure.last.nomStructure}");
    } catch (e) {
      debugPrint("Erreur lors du chargement des Structures : $e");
    }

    loading = false;
    notifyListeners();
    return _listStructure ;
  }




  Future<List<StructureModel>> getStructureWithArrondissement() async {
    final List<StructureModel> structures = [];
    try {
      final response = await Supabase.instance.client
          .from('structures')
          .select('id, nom_structure,tel,email,password, arrondissements(id, arrondissement)');

      for (var item in response) {
        structures.add(StructureModel.fromJson(item));
      }
    } catch (e) {
      debugPrint("Erreur chargement des structures : $e");
    }
    return structures;
  }


  Future<bool> addAStructure(StructureModel item) async {

    try {
      final response = await supabase.from('structures').insert({
        'nom_structure': item.nomStructure,
        'tel': item.tel,
        'email': item.email,
        'arrondissement_id': item.arrondissement_id,
        'password': item.password
      });

      if (kDebugMode) {
        print('Structure ajouté : $response');
      }
      notifyListeners();
      return true;

    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de l’ajout de la structure : $e');
      }
      return false;
    }
  }



  Future<bool> editStructure({
    required int id,
    required StructureModel item

  }) async {
    try {
      final response = await supabase.from('structures').update({
        'nom_structure': item.nomStructure,
        'tel': item.tel,
        'email': item.email,
        'arrondissement_id': item.arrondissement_id,
        'password': item.password
      }).eq('id', id);

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Erreur lors de la modification de la structure : $e");
      return false;
    }
  }



  Future<bool> deleteStructure(int id) async {
    try {
      final response = await supabase.from('structures').delete().eq('id', id);

      return true;
    } catch (e) {
      debugPrint("Erreur lors de la suppression : $e");
      return false;
    }
  }

}




