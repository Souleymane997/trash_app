import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';

import '../../../../shared/colors.dart';
import '../../../../shared/custom_text.dart';


class InfosPage extends StatefulWidget {
  const InfosPage({super.key});

  @override
  State<InfosPage> createState() => _InfosPageState();
}

class _InfosPageState extends State<InfosPage> {

  CarouselSliderController buttonCarouselController = CarouselSliderController();

  final List<Map<String, String>> items = [
    {
      'title': 'Évitez de jeter les déchets par terre',
      'description': 'Jeter ses déchets dans la rue ou la nature pollue l’environnement, bouche les caniveaux et crée des conditions insalubres. Utilisez toujours une poubelle, même pour les petits déchets comme les papiers ou les emballages.'
    },
    {
      'title': 'Faites le tri des déchets à la maison',
      'description': 'Séparer les plastiques, papiers, verres et déchets organiques permet de faciliter le recyclage et de réduire la quantité de déchets envoyés en décharge. C’est un geste simple mais très efficace pour l’environnement.'
    },
    {
      'title': 'Compostez vos déchets organiques',
      'description': 'Les épluchures de fruits et légumes, les restes de repas ou les feuilles mortes peuvent être transformés en compost naturel. Cela réduit les ordures ménagères et permet d’enrichir le sol de façon écologique.'
    },
    {
      'title': 'Réduisez les produits jetables',
      'description': 'Privilégiez l’utilisation d’objets réutilisables comme les sacs en tissu, les gourdes ou les contenants alimentaires. Cela diminue les déchets plastiques qui mettent des siècles à se décomposer.'
    },
    {
      'title': 'Déposez les déchets dangereux dans des points de collecte',
      'description': 'Les piles, batteries, huiles usées ou ampoules doivent être apportées dans des centres spécialisés. Leur mauvaise gestion peut entraîner une pollution grave des sols et de l’eau.'
    },
    {
      'title': 'Participez aux nettoyages communautaires',
      'description': 'S’impliquer dans des opérations de nettoyage de quartier renforce le lien social, améliore l’environnement local et sensibilise toute la communauté à la propreté.'
    },
    {
      'title': 'Sensibilisez votre entourage',
      'description': 'Parlez autour de vous des bonnes pratiques de gestion des déchets et de l’importance de garder son environnement propre. Le changement commence avec chacun de nous.'
    },
    {
      'title': 'Ne brûlez jamais vos ordures',
      'description': 'La combustion à l’air libre libère des substances toxiques dangereuses pour la santé et pollue gravement l’air. Utilisez les circuits de collecte officiels.'
    },
    {
      'title': 'Signalez les décharges sauvages',
      'description': 'Prévenez les autorités locales en cas de dépôts illégaux d’ordures. Cela permet de réagir rapidement pour limiter les nuisances et faire respecter la loi.'
    },
    {
      'title': 'Gardez les caniveaux et rivières propres',
      'description': 'Les ordures jetées dans les caniveaux et rivières causent des inondations et propagent des maladies. Jeter les déchets au bon endroit protège toute la communauté.'
    },
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grisLight(),
      appBar: AppBar(
        title: CustomText("Informations"),
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
                'assets/icons/infos.svg',
                height: 80,
                width: 80,
                semanticsLabel: 'str',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: CustomText(
                'Informations',
                color: noir(),
                fontWeight: FontWeight.w700,
              ),
            ),
            Container(height: 15,) ,

            Center(
              child: CarouselSlider.builder(
                itemCount: items.length,
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height * 0.65,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.8,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  autoPlayAnimationDuration: Duration(milliseconds: 2000),
                ),
                itemBuilder: (context, index, realIndex) {
                  final item = items[index];
                  return  Center(
                    child: Container(
                        decoration: ShapeDecoration(
                          color: gris(),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.63,
                        child: Column(
                          children: [
                            Container(
                              width:  MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.31,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25),
                                ),
                                image: DecorationImage(
                                  image: AssetImage("assets/images/img.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 8,) ,
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: CustomText(
                                item['title'],
                                color: noir(),
                                tex: TailleText(context).titre  ,
                                textAlign: TextAlign.center,
                                family: 'Lobster',
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            SizedBox(height: 8,) ,

                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: CustomText(
                                  item['description'],
                                color: noir(),
                                tex: TailleText(context).soustitre * 0.8,
                                textAlign: TextAlign.center,
                                family: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            Spacer(),
                            SizedBox(
                                width: 50,
                                child: Divider( thickness: 3,))

                          ],
                        )
                    ),
                  ) ;
                },
              ),
            ),








          ],
        ),
      ),
    ) ;
  }
}
