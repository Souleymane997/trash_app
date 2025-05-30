import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../shared/colors.dart';
import '../../../../shared/custom_text.dart';


class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {

  List<DateTime> generateSpecialDates(DateTime startDate, DateTime endDate) {
    List<DateTime> dates = [];

    DateTime currentDate = startDate;
    while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
      dates.add(currentDate);
      currentDate = currentDate.add(Duration(days: 7));
    }

    return dates;
  }



  late List<DateTime> specialDates;

  @override
  void initState() {
    super.initState();


    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now().add(Duration(days: 35)); // Exemple de date de fin


    specialDates = generateSpecialDates(startDate, endDate);
  }




  // final List<DateTime> specialDates = [
  //   DateTime.now(),
  //   DateTime.now().add(Duration(days: 7)),
  //   DateTime.now().add(Duration(days: 14)),
  //   DateTime.now().add(Duration(days: 21)),
  //   DateTime.now().add(Duration(days: 28)),
  // ];

  // void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
  //   // Gérer la sélection ici
  //   if (kDebugMode) {
  //     print(args.value);
  //   }
  // }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

                  // SfDateRangePicker(
                  //   backgroundColor: vert(),
                  //   onSelectionChanged: _onSelectionChanged,
                  //   selectionMode: DateRangePickerSelectionMode.range,
                  //   initialSelectedRange: PickerDateRange(
                  //     DateTime.now().subtract(const Duration(days: 4)),
                  //     DateTime.now().add(const Duration(days: 3)),
                  //   ),
                  // ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}