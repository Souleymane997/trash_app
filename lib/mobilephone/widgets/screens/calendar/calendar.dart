import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../controllers/programme_controller.dart';
import '../../../../controllers/structures_controller.dart';
import '../../../../models/programme_model.dart';
import '../../../../models/structure_model.dart';
import '../../../../shared/colors.dart';
import '../../../../shared/custom_text.dart';
import '../../../../shared/loading.dart';


class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key, required this.idArrond});
  final int idArrond;

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {

  List<String> joursChoisis = [];
  List<ProgrammeModel?> prog = [] ;
  List<DateTime> specialDates = [];
  String idStructure = "";
  bool isLoad = true;
  int idJour1 = 0 ;
  int idJour2 = 0 ;

  StructureModel structure = StructureModel(
    id: 'id',
    nomStructure: 'nomStructure',
    tel: 'tel',
    arrondissement_id: 0,
    arrondissement: 'arrondissement',
    email: 'email',
    password: 'password',
    role_id: 0,
  );

  getStructureData() async {
    StructureModel? item = await StructureController().getStructureDetails(
      idArrond: widget.idArrond,
    );
    if (item != null) {
      setState(() {
        structure = item;
        idStructure = structure.id;
      });
    }

    getProgramme() ;

  }

  getProgramme() async{
    List<ProgrammeModel?> list = await ProgrammeController().getProgrammeByUser(idStructure) ;

    if(list.isNotEmpty){
      setState(() {
        prog = list ;
        joursChoisis.clear() ;
        joursChoisis = [ prog.first!.jour1.toString() ,  prog.first!.jour2.toString() ] ;

        idJour1 = stringToWeekday(joursChoisis[0])! ;
        idJour2 = stringToWeekday(joursChoisis[1])! ;

        DateTime startDate = getWeekdayDatesOverWeeks( startDate: DateTime.now() , weekday: idJour1) ;
        DateTime endDate = DateTime.now().add(Duration(days: 35)); // Exemple de date de fin
        specialDates = generateSpecialDates(startDate, endDate);

        DateTime startDate1 = getWeekdayDatesOverWeeks( startDate: DateTime.now() , weekday: idJour2) ;
        DateTime endDate1 = DateTime.now().add(Duration(days: 35)); // Exemple de date de fin
        List<DateTime> specialDats = generateSpecialDates(startDate1, endDate1);

        for (int i = 0; i < specialDats.length; i++) {
          specialDates.add(specialDats[i]) ;
        }


        Timer(Duration(seconds: 2), () {
          setState(() {
            isLoad = false;
          });
        });

      });
    }
  }

  int? stringToWeekday(String jour) {
    const map = {
      'Lundi': DateTime.monday,
      'Mardi': DateTime.tuesday,
      'Mercredi': DateTime.wednesday,
      'Jeudi': DateTime.thursday,
      'Vendredi': DateTime.friday,
      'Samedi': DateTime.saturday,
      'Dimanche': DateTime.sunday,
    };

    return map[jour];
  }

  DateTime getWeekdayDatesOverWeeks({
    required DateTime startDate,
    required int weekday,
    int numberOfWeeks = 4,
  }) {

    int daysToAdd = (weekday - startDate.weekday) % 7;
    if (daysToAdd < 0) daysToAdd += 7;

    DateTime current = startDate.add(Duration(days: daysToAdd));


    return current;
  }



  List<DateTime> generateSpecialDates(DateTime startDate, DateTime endDate) {
    List<DateTime> dates = [];

    DateTime currentDate = startDate;
    while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
      dates.add(currentDate);
      currentDate = currentDate.add(Duration(days: 7));
    }
    return dates;
  }


  @override
  void initState() {
    super.initState();
    getStructureData() ;
  }




  @override
  Widget build(BuildContext context) {
    return Stack(
      children:[ Scaffold(
        backgroundColor: grisLight(),
        appBar: AppBar(
          title: CustomText("Calendar"),
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          backgroundColor: vert(),
        ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(height: 25,) ,
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SvgPicture.asset(
                    'assets/icons/calendar.svg',
                    height: 80,
                    width: 80,
                    semanticsLabel: 'str',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: CustomText(
                    'Calendrier de Passage',
                    color: noir(),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(height: 15,) ,
                Center(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.all(10),
                    decoration: ShapeDecoration(
                      color: vert(),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: SfDateRangePicker(
                      backgroundColor: vert(),
                      selectionMode: DateRangePickerSelectionMode.single, // requis
                      onSelectionChanged: null,
                      enablePastDates: false,
                      showNavigationArrow: true,
                      monthViewSettings: DateRangePickerMonthViewSettings(
                        firstDayOfWeek: 1,
                        specialDates: specialDates,
                      ),
                      monthCellStyle: DateRangePickerMonthCellStyle(
                        textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        specialDatesTextStyle: TextStyle(color: blanc(), fontWeight: FontWeight.bold),
                        specialDatesDecoration: BoxDecoration(
                          color: jaune(),
                          shape: BoxShape.circle,
                        ),
                      ),
                      headerStyle: DateRangePickerHeaderStyle(
                        textStyle: TextStyle(
                          color: Colors.white,           // Couleur du texte "mai 2025"
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        backgroundColor: vert(), // 👈 Couleur de fond de la zone d’en-tête
                      ),
                      selectionTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      todayHighlightColor: Colors.white,
                    ),

                  ),
                ),
                Gap(15),

                Padding(
                  padding: const EdgeInsets.only(
                    left: 10.0,
                    top: 15.0,
                    bottom: 0.0,
                    right: 0.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SvgPicture.asset(
                          'assets/icons/heure.svg',
                          height: 20,
                          width: 20,
                          semanticsLabel: 'h',
                        ),
                      ),

                      CustomText(
                        'Jour de Ramassage',
                        color: noir(),
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                ),


                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.only(bottom: 5),
                  decoration: ShapeDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.16, 0.23),
                      end: Alignment(0.86, 0.79),
                      colors:
                          [grisFonce(), grisFonce()],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: (joursChoisis.isNotEmpty) ? CustomText(
                      '     ${joursChoisis[0]}    et    ${joursChoisis[1]}  ',
                      tex: TailleText(context).soustitre,
                      family: 'Poppins',
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w700,
                    ) : CustomText(
                      'Pas de Jour de ramassage encore definis',
                      tex: TailleText(context).soustitre,
                      family: 'Poppins',
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ),
        isLoad ? Loading() : Container(),
      ]
    );
  }
}