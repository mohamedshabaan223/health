import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:health_app/app_theme.dart';

class ContainerDoctorFavorite extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: 
          Container(
            margin: EdgeInsets.symmetric(vertical: 10 , horizontal: 15),
            height: height * 0.15,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppTheme.gray,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(children: [
              Padding(
              padding: const EdgeInsets.only(left: 14.0),
              child: CircleAvatar(
                      radius:37,
                      backgroundImage: AssetImage('assets/images/doctor_image.png'),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 Row(children: [Image.asset('assets/images/professional.png',),
                 SizedBox(width: 4,),
                 Text('Professianol Doctor' , style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontSize: 14,
                 ),)],
                 ),
                 SizedBox(height: 5,),
                  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: width * 0.6,
                      height: height * 0.06,
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 20.0, top: 2, bottom: 2),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Dr. Olivia Turner, M.D',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.green,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Dermato-Endocrinology',
                                  style: TextStyle(
                                    color: AppTheme.green3,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.only(right: 9.0),
                              
                              child: Icon(Icons.favorite , color: AppTheme.green,)
                            ),
                          ],
                        ),
                        ),),
                        SizedBox(height: 10,),
                        Container(
                          height: 25,
                          width: width * 0.6,
                          decoration: BoxDecoration(
                            color: AppTheme.green,
                            borderRadius: BorderRadius.circular(13)
                          ),
                          child: Center(
                            child: Text('Make Appointment' , style: Theme.of(context).
                            textTheme.titleSmall?.copyWith(color: AppTheme.white
                            ),),
                          ),
                        )
                ],
              ),
            
            ],),
          ),
        
      
           ] ),),);
  }
}