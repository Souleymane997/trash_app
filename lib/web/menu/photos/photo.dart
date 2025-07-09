// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:intersperse/intersperse.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trash_app/models/photo_model.dart';

import '../../../controllers/photo_controller.dart';
import '../../../shared/colors.dart';
import '../../../shared/custom_text.dart';
import '../components/content_view.dart';
import '../components/page_header.dart';
import '../components/summary_card.dart';

class ViolationPhotoPage extends StatefulWidget {
  const ViolationPhotoPage({super.key});

  @override
  State<ViolationPhotoPage> createState() => _ViolationPhotoPageState();
}

class _ViolationPhotoPageState extends State<ViolationPhotoPage> {

  List<PhotoModel?> listPhotoViolation = [] ;
  bool isLoad = false ;
  int nbre = 0 ;

  List<String> imageUrls = [] ;


  getList() async{

    List<PhotoModel?> list = await PhotoController().getListPhotos() ;

    if(list.isNotEmpty){
      setState(() {
        listPhotoViolation = list ;
        imageUrls = list.map((item) {
          final path = item?.image_path as String;
          return Supabase.instance.client.storage.from('photos').getPublicUrl(path);
        }).toList();

      });
      Timer(Duration(seconds: 2), () {
        setState(() {
          isLoad = true ;
          nbre = listPhotoViolation.length ;
        });
      });
    }
    else{
      Timer(Duration(seconds: 2), () {
        setState(() {
          isLoad = true ;
          nbre = listPhotoViolation.length ;
        });
      });
    }



    
  }


  @override
  void initState() {
    super.initState();
    getList() ;
    
  }





  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveBreakpoints.of(context);
    var summaryCards = [
      SummaryCard(title: "Nombre de Signalement ", value: '$nbre'),
    ];

    return ContentView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageHeader(
              title: 'Violation',
              description: "reception des alertes de violations",
            ),
            const Gap(16),
            if (responsive.isMobile)
              ...summaryCards
            else
              Row(
                children: summaryCards
                    .map<Widget>((card) => Expanded(child: card))
                    .intersperse(const Gap(16))
                    .toList(),
              ),
            const Gap(16),

            isLoad?
            gridView( listPhotoViolation,)
                : Center(child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
              child: CircularProgressIndicator(),
            )),


          ],
        ));
  }


  Widget gridView(List<PhotoModel?> list){

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        if (constraints.maxWidth >= 1200) {
          crossAxisCount = 3;
        } else if (constraints.maxWidth >= 800) {
          crossAxisCount = 3;
        } else if (constraints.maxWidth >= 600) {
          crossAxisCount = 2;
        } else {
          crossAxisCount = 1;
        }

        if(list.isEmpty)
        {
          return Center(child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 100.0, bottom: 3.0, left: 3.0, right: 3.0),
                child: SvgPicture.asset(
                  'assets/icons/empty.svg',
                  height: 100,
                  width:100,
                  color: noir(),
                  semanticsLabel: 'structure',
                ),
              ),
              CustomText("Liste vide !!", color: noir(),) ,
            ],
          ) ,) ;
        }else{
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1,
            ),
            itemCount: list.length,
            itemBuilder: (context, index) {
              PhotoModel? item= list[index] ;
              return  GestureDetector(
                onTap: () {
                  //openEditStructureDialog(structure) ;
                },
                child: SizedBox(
                  width: double.infinity,
                  // child: Card(
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  //     child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //       children: [
                  //         SizedBox(
                  //           width: double.infinity,
                  //           height: 150,
                  //           child: Image.network(
                  //             imageUrls[index],
                  //             fit: BoxFit.cover,
                  //           ),
                  //         ),
                  //         Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Text('Description :' , style: TextStyle(fontSize: 11 , fontWeight: FontWeight.w600), ),
                  //             Expanded(child: Text(item!.description, style:TextStyle(fontSize: 11 , fontWeight: FontWeight.normal), textAlign: TextAlign.center,)),
                  //           ],
                  //         ),
                  //         Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Text('Date et Lieu :', style: TextStyle(fontSize: 11 , fontWeight: FontWeight.w600), ),
                  //             Expanded(
                  //               child: Text(
                  //                 '${item.date_upload} á ${item.lieu}', textAlign: TextAlign.center,
                  //                 style:TextStyle(fontSize: 11,  fontWeight: FontWeight.normal),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  child: GestureDetector(
                    onTap: (){
                      showImagePopup(context, imageUrls[index]) ;
                    },
                    child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        clipBehavior: Clip.antiAlias,
                        elevation: 4,
                        child: Stack(
                          children: [
                            Ink.image(
                              image: NetworkImage(imageUrls[index]),
                              fit: BoxFit.cover,
                              height: 200,
                              width: double.infinity,
                              child: InkWell(onTap: () {}),
                            ),
                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0.6),
                                    Colors.transparent,
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                            ),
                            Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        item!.description,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Flexible(
                                    child: Text(
                                      '${item.date_upload} à ${item.lieu}',
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                ],
                              ),
                            ),
                          ]
                        ),
                      ),
                  ),
                ),
              );
            },
          );
        }

      },
    );
  }

  void showImagePopup(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }



}