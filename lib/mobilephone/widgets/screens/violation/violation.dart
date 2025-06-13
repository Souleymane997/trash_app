import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:banner_carousel/banner_carousel.dart';
import 'package:trash_app/mobilephone/widgets/screens/violation/formulaire.dart';
import 'package:trash_app/mobilephone/widgets/screens/violation/sendphoto.dart';

import '../../../../shared/colors.dart';
import '../../../../shared/custom_text.dart';
import '../../../../shared/slidepage.dart';

class ViolationPage extends StatefulWidget {
  const ViolationPage({super.key});

  @override
  State<ViolationPage> createState() => _ViolationPageState();
}

class _ViolationPageState extends State<ViolationPage> {

  List<BannerModel> listBanners = [
    BannerModel( id: "1", imagePath: 'assets/images/viol.png'),
    BannerModel( id: "2", imagePath: 'assets/images/viol2.png'),
    BannerModel( id: "3", imagePath: 'assets/images/clean2.png'),
    BannerModel( id: "4", imagePath: 'assets/images/clean3.png'),
    BannerModel( id: "5", imagePath: 'assets/images/default.png'),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grisLight(),
      appBar: AppBar(
        title: CustomText("Violation"),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: vert(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          left: 16,
          right: 16,
          top: MediaQuery.of(context).size.height * 0.02,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: SvgPicture.asset(
                'assets/icons/violation.svg',
                height: 80,
                width: 80,
                semanticsLabel: 'str',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: CustomText(
                'Violation',
                color: noir(),
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10,),
            BannerCarousel(
              banners: listBanners,
              customizedIndicators: IndicatorModel.animation(width: 20, height: 5, spaceBetween: 2, widthAnimation: 50),
              height: 150,
              width: double.infinity,
              activeColor: Colors.amberAccent,
              disableColor: Colors.white,
              animation: true,
              borderRadius: 10,
              indicatorBottom: false,
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 334,
                child: CustomText(
                  "Si vous êtes témoin d' une violation, nous vous encourageons à la signaler immédiatement. Votre signalement permet de maintenir un environnement sûr et respectueux pour tous. Veuillez fournir autant de détails que possible, notamment la nature de la violation, les personnes impliquées, ainsi que la date, l'heure et le lieu de l'incident. ",
                  color: noir(),
                  tex: TailleText(context).contenu * 1.15,
                  textAlign: TextAlign.center,
                  family: 'Poppins',
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: (){
                  Navigator.push(
                      context,
                      SlideRightRoute(
                          child: FormulairePage(),
                          page: FormulairePage(),
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
                child: CustomText("Formulaire de Violation ", family: 'Inter', fontWeight: FontWeight.w500,),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: (){
                  Navigator.push(
                      context,
                      SlideRightRoute(
                          child: SendPhoto(),
                          page: SendPhoto(),
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText("Prendre une photo", family: 'Inter', fontWeight: FontWeight.w500,),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Icon(Icons.camera),
                    )
                    // prendre une photo et envoyer a l'administrateur ..
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ) ;
  }
}




