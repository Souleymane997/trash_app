// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart';
import 'package:trash_app/mobilephone/widgets/screens/violation/violationsend.dart';
import 'package:trash_app/shared/dialoguetoast.dart';
import 'package:trash_app/shared/loading.dart';

import '../../../../controllers/photo_controller.dart';
import '../../../../models/photo_model.dart';
import '../../../../shared/colors.dart';
import '../../../../shared/custom_text.dart';
import '../../../../shared/slidepage.dart';

class SendPhoto extends StatefulWidget {
  const SendPhoto({super.key});

  @override
  State<SendPhoto> createState() => _SendPhotoState();
}

class _SendPhotoState extends State<SendPhoto> {
  late TextEditingController violationController = TextEditingController();
  late TextEditingController lieuController = TextEditingController();

  File? _image;
  bool isLoad = false ;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);

    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  Future<void> _uploadImage(BuildContext context) async {
    if (_image == null) return;

    setState(() {
      isLoad = true ;
    });

    final fileName = basename(_image!.path);
    final fileBytes = await _image!.readAsBytes();

    String desc = (violationController.text.isNotEmpty) ? violationController.text : "Aucune description" ;
    String lieu = (lieuController.text.isNotEmpty) ? lieuController.text : "Aucun lieu" ;
    String date = '${DateTime.now().day}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().year.toString().padLeft(2, '0')}' ;

    PhotoModel photo = PhotoModel(id: '1', user_id: '', image_path: 'uploads/$fileName', date_upload: date, description:  desc , lieu: lieu) ;
    bool res = await PhotoController().addPhotoViolation(photo) ;

    final response = await Supabase.instance.client.storage
        .from('photos') // nom du bucket Supabase
        .uploadBinary('uploads/$fileName', fileBytes);

    if (response.isNotEmpty && res) {
      debugPrint("Image envoyée avec succès !");
      DInfo.toastSuccess('image envoyé') ;
      Navigator.pushReplacement(
          context,
          SlideRightRoute(
              child: ViolationSendPage(),
              page: ViolationSendPage(),
              direction: AxisDirection.left)
      );
    } else {
      debugPrint("Erreur lors de l'envoi.");
      setState(() {
        isLoad = false ;
      });
    }
  }



  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      hintStyle: TextStyle(color: grisLight()),
      fillColor: blanc(),
      contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: vert()),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: vert(), width: 2),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [Scaffold(
        backgroundColor: grisLight(),
        appBar: AppBar(
          title: CustomText("Photo"),
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          backgroundColor: vert(),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _image != null
                  ? Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.3,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.file(
                    _image!,
                    fit: BoxFit.cover,
                  ),
                ),
              )
                  : Center(child: Icon(Icons.image, size: MediaQuery.of(context).size.width * 0.8,)),
              SizedBox(height: 20),

              _image != null
                  ? Padding(
                padding: const EdgeInsets.all(5.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: TextFormField(
                    controller: violationController,
                    maxLines: 3,
                    decoration: _inputDecoration("Description"),
                    keyboardType:TextInputType.text,
                    onChanged: (value){
                      setState(() {
                        violationController.text = value ;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'violation requis';
                      return null;
                    },
                  ),
                ),
              ) : Container(),
              SizedBox(height: 10),
              _image != null
                  ?Padding(
                padding: const EdgeInsets.all(5.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: TextFormField(
                    controller: lieuController,
                    decoration: _inputDecoration("Lieu"),
                    keyboardType:TextInputType.text,
                    onChanged: (value){
                      setState(() {
                        lieuController.text = value ;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'lieu requis';
                      return null;
                    },
                  ),
                ),
              ) : Container(),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor:  (_image != null) ? gris() : vert(),
                  foregroundColor: (_image != null) ? vert() : blanc(),
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: vert(), width: 1),
                  ),
                ),
                child: (_image != null)?  Text("Reprendre la photo") : Text("Prendre une photo"),
              ),

              SizedBox(height: 15),
              if (_image != null)
                ElevatedButton(
                  onPressed:(){
                    _uploadImage(context) ;
                  } ,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: vert(),
                    foregroundColor: blanc(),
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: vert(), width: 1),
                    ),
                  ),
                  child: Text("Envoyer la photo"),
                ),
            ],
          ),
        ),
      ),
        isLoad ? Loading() : Container()
    ]
    );
  }
}

