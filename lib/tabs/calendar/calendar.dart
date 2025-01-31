import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/widgets/container_appointment.dart';
import 'package:health_app/widgets/container_complete_doctor.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
 
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title:  Text('All Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
             ContainerAppointment(
              onTap: (){setState(() {
              });},label: 'Complete' ,
               labelColor: AppTheme.white  ,
               containerColor:  AppTheme.green ,
               ),
             ContainerAppointment(onTap: (){setState(() {
              
              });},label: 'Upcoming' ,
             labelColor:   AppTheme.green ,
              containerColor: AppTheme.gray,),
             ContainerAppointment(onTap: (){setState(() {
             ;
              });},label: 'cancelled' ,
             labelColor:  AppTheme.green ,
               containerColor: AppTheme.gray,),
            ],
          ),
          SizedBox(height: 15,),
          Expanded(child: ListView.builder(itemBuilder: (_, index) =>ContainerCompleteDoctor()))
        ],),
      ),
      
    );;
  }
}