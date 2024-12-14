import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/pages/doctor_favorite.dart';
import 'package:health_app/pages/doctor_female.dart';
import 'package:health_app/pages/doctor_page.dart';
import 'package:health_app/pages/doctor_rating.dart';
import 'package:health_app/widgets/container_doctor.dart';
import 'package:health_app/widgets/default_icon.dart';
import 'package:health_app/widgets/top_icon_in_home_page.dart';

class Male extends StatefulWidget {
  static const String routeName ='/male';

  @override
  State<Male> createState() => _MaleState();
}

class _MaleState extends State<Male> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
      child:Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
         Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           IconButton(onPressed: (){
          Navigator.of(context).pop(DoctorPage.routeName);
        }, icon: Icon(Icons.arrow_back_ios_new_outlined,
             size: 30,color: AppTheme.green,)),
             Text('Male' , style:  Theme.of(context).textTheme.titleMedium,
             ),
             Row(
               children: [
                 TopIconInHomePage(icons: Icon(Icons.search , color: AppTheme.green,), 
                 containerBackgroundColor: AppTheme.gray),
                 SizedBox(width: 8,),
                InkWell(
                  onTap: (){},
                  child: Image.asset('assets/images/filter1.png')),
                
               ],
             ),
          ],),
         Padding(
           padding: const EdgeInsets.symmetric(vertical: 10 , horizontal: 20),
           child: Row(
            children: [
             Text('Sort By' ,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppTheme.green),
              ),
                     SizedBox(width: 5,),
                     Defaulticon(
                      onTap: (){
                         Navigator.of(context).pushNamed(Rating.routeName);
                      },
                      icon: Icon(Icons.star_border, size: 17 , 
                      color: AppTheme.green,),
                      containerClolor:  AppTheme.gray,
                     ),
                      SizedBox(width: 5,),
                     Defaulticon(
                       onTap: (){
                        Navigator.of(context).pushNamed(Favorite.routeName);
                       },
                      icon: Icon(Icons.favorite_border, size: 17 ,
                       color: AppTheme.green,),
                      containerClolor: AppTheme.gray,
                     ),
                      SizedBox(width: 5,),
                     Defaulticon(
                       onTap: (){
                         Navigator.of(context).pushNamed(Female.routeName);
                      },
                      icon: Icon(Icons.female , size: 17 ,
                       color:  AppTheme.green,),
                      containerClolor:  AppTheme.white,
                     ),
                     SizedBox(width: 5,),
                     Defaulticon(
                      onTap: (){},
                      icon: Icon(Icons.male , size: 17 ,
                       color:  AppTheme.white,),
                      containerClolor: AppTheme.green,
                     ),
            ],
           ),
         ),
         Expanded(child: ListView.builder(itemBuilder: (_ , index) =>ContainerDoctor(
          doctorNmae: 'Dr.Alexander Bennett , Ph.D.',
          descrabtion: 'Dermato-Genetics',
          doctorImage: 'assets/images/male.png',
         ) ,
         itemCount: 3,),
         ),
        
          ],
        ),
      ) ),);
  }
}
 