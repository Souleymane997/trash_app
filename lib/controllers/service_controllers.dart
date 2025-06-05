// ignore_for_file: unused_local_variable

import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/service_model.dart';


class ServiceController with ChangeNotifier {

  final SupabaseClient supabase = Supabase.instance.client;

  List<ServiceModel> _list= [];
  List<ServiceModel> get roles => _list;
  bool loading = false;

  Future<List<ServiceModel>> getList(String idStructure) async {
    loading = true;
    notifyListeners();

    try {
      final response = await supabase.from('services').select().eq('structure_id', idStructure);

      _list = (response as List)
          .map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
          .toList();

      log("service: ${_list.last.nom_service}");
    } catch (e) {
      debugPrint("Erreur lors du chargement des Services : $e");
    }

    loading = false;
    notifyListeners();
    return _list;
  }


  Future<bool> addService(ServiceModel item) async {

    try {
      final response = await supabase.from('services').insert({
      'structure_id' : item.structure_id,
      'nom_service' : item.nom_service ,
      'nbre' : item.nbre ,
      'tarif' : item.tarif ,
      'description' : item.description
      });

      if (kDebugMode) {
        print('Service ajouté : $response');
      }
      notifyListeners();
      return true;

    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de l’ajout du Service : $e');
      }
      return false;
    }
  }



  Future<bool> editService({
    required int id,
    required ServiceModel item,
  }) async {
    try {
      final response = await supabase.from('services').update({
        'structure_id' : item.structure_id,
        'nom_service' : item.nom_service ,
        'nbre' : item.nbre ,
        'tarif' : item.tarif ,
        'description' : item.description
      }).eq('service_id', id);

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Erreur lors de la modification du service : $e");
      return false;
    }
  }




  Future<bool> deleteService(int id) async {
    try {
      final response = await supabase.from('services').delete().eq('service_id', id);

      return true;
    } catch (e) {
      debugPrint("Erreur lors de la suppression : $e");
      return false;
    }
  }




}




