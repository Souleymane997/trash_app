import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../shared/colors.dart';
import '../../../../shared/custom_text.dart';
import '../../../../shared/slidepage.dart';
import 'sendFeed.dart';
class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {

  final _avisController = TextEditingController();
  List<bool> booleans = List.generate(5, (index) => false);


  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      hintStyle: TextStyle(color: grisLight()),
      fillColor: blanc(),
      contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: blanc()),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: blanc(), width: 1),
      ),

    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: grisLight(),
      appBar: AppBar(
        title: CustomText("Ma structure"),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: vert(),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: SvgPicture.asset(
                  'assets/icons/structure.svg',
                  height: 80,
                  width: 80,
                  semanticsLabel: 'str',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: CustomText(
                  'Wend Panga clean',
                  color: noir(),
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: CustomText(
                  'Evaluer le service ',
                  tex: 1.5,
                  color: noir(),
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05,),

              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: CustomText(
                        'Votre avis nous interresse:',
                        tex: TailleText(context).contenu,
                        color: noir(),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _avisController,
                  maxLines: 4,
                  decoration: _inputDecoration(""),
                  keyboardType:TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Avis requis';
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  for (int i = 0; i < 5; i++)
                    InkWell(
                        onTap: (){
                          setState(() {
                            booleans[i] = !booleans[i] ;

                            for (int j = 0; j < i ; j++) {
                              booleans[j] = true ;
                            }

                            for (int k = i+1; k<5; k++) {
                              booleans[k] = false ;
                            }
                          });
                        },
                        child: star(booleans[i])
                    ),

                ],
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: (){

                    Navigator.pushReplacement(
                        context,
                        SlideRightRoute(
                            child: SendfeedPage(),
                            page: SendfeedPage(),
                            direction: AxisDirection.left)
                    );

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: vert(),
                    foregroundColor: blanc(),
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: vert(), width: 1),
                    ),
                  ),
                  child: CustomText("Soumettre", family: 'Inter', fontWeight: FontWeight.w500,),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget star(bool val){

    return  (val) ? InkWell(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SvgPicture.asset(
          'assets/icons/star1.svg',
          height: 30,
          width: 30,
          semanticsLabel: 'Logo',
        ),
      ),
    ) : Padding(
      padding: const EdgeInsets.all(5.0),
      child: SvgPicture.asset(
        'assets/icons/star.svg',
        height: 30,
        width: 30,
        semanticsLabel: 'Logo',
      ),
    ) ;


  }


}
