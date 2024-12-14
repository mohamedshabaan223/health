import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/widgets/default_icon.dart';


class ContainerDoctor extends StatefulWidget {
  ContainerDoctor({required this.doctorNmae ,required this.descrabtion, required this.doctorImage});
  final String doctorNmae ;
  final String descrabtion;
  final String doctorImage;
 
  @override
  State<ContainerDoctor> createState() => _ContainerDoctorState();
}

class _ContainerDoctorState extends State<ContainerDoctor> {
  bool isSelected = false;
  bool isFavorite = false;
 

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20 , vertical: 10),
      width: 300,
      height: 131,
      decoration: BoxDecoration(
        color: AppTheme.gray,
        borderRadius: BorderRadius.circular(17)
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 14.0),
            child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(widget.doctorImage),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30 , left: 10 , bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.doctorNmae, style: Theme.of(context).textTheme.labelMedium,),
                Text(widget.descrabtion , style: Theme.of(context)
                .textTheme.titleSmall?.copyWith(fontSize: 14),),
               SizedBox(height: 15,),
                 Row(
                children: [
                  InkWell(
                    onTap: (){
                      
                    },
                    child: Container(
                      height: 29,
                      width: 50,
                      decoration: BoxDecoration(
                        color: AppTheme.green,
                        borderRadius: BorderRadius.circular(18)
                      ),
                      child: Center(
                        child: Text('info' , style:Theme.of(context).textTheme.
                        labelMedium?.copyWith(color: AppTheme.white, fontSize: 16),
                                          ),
                      ),
                  ),),
                  SizedBox(width: width * 0.06,),
                   Defaulticon(
                    onTap: (){
                      isSelected = !isSelected;
                      setState(() {
                        
                      });
                    },
                    icon: Icon(Icons.calendar_month , size: 17 , color: isSelected?AppTheme.white: AppTheme.green,),
                    containerClolor: isSelected ? AppTheme.green: AppTheme.white,
                   ),
                    SizedBox(width: 4,),
                   Defaulticon(onTap: (){},
                   icon: Icon(CupertinoIcons.exclamationmark , size: 17, color: AppTheme.green,),
                    containerClolor: AppTheme.white, ),
                   SizedBox(width: 4,),
                    Defaulticon(
                      onTap: (){},
                    icon: Icon(Icons.question_mark , size: 17 , color: AppTheme.green,),
                    containerClolor: AppTheme.white,
                   ),
                   SizedBox(width: 4,),
                    Defaulticon(
                      onTap: (){
                         isFavorite= !isFavorite;
                        setState(() {
                          
                        });
                      },
                    icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border ,  size: 17 , color: AppTheme.green),
                    containerClolor: AppTheme.white,
                   ),
                  
                   
                   
                ],
               )  
              ],
            ),
          ),
           
        ],
      )
    );
  }
}