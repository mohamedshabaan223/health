import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cubits/doctors_cubit/doctor_cubit.dart';
import 'package:health_app/models/doctor_model.dart';
import 'package:health_app/pages/doctor_female.dart';
import 'package:health_app/pages/doctor_male.dart';
import 'package:health_app/pages/doctor_page.dart';
import 'package:health_app/widgets/container_doctor_rating.dart';
import 'package:health_app/widgets/default_icon.dart';

class Rating extends StatefulWidget {
  static const String routeName = '/rating';

  const Rating({super.key});

  @override
  _RatingState createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  bool isSearching = false;
  List<DoctorModel> filteredDoctors = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<DoctorCubit>(context).getAllDoctorsByTopRating();
    });
  }

  void _filterDoctors(String query) {
    final state = BlocProvider.of<DoctorCubit>(context).state;
    if (state is DoctorSuccess) {
      final allDoctors = state.doctorsList;
      setState(() {
        filteredDoctors = allDoctors
            .where((doctor) =>
                doctor.doctorName!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(width * 0.03),
          child: Column(
            children: [
              // الهيدر
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new_outlined,
                        size: width * 0.05,
                        color: AppTheme.green,
                      )),
                  Expanded(
                    child: isSearching
                        ? TextField(
                            controller: _searchController,
                            autofocus: true,
                            onChanged: _filterDoctors,
                            decoration: InputDecoration(
                              hintText: 'Search for a doctor...',
                              hintStyle: TextStyle(
                                  fontSize: width * 0.04, color: Colors.grey),
                              border: InputBorder.none,
                            ),
                          )
                        : Center(
                            child: Text(
                              'Rating',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontSize: width * 0.05),
                            ),
                          ),
                  ),
                  Container(
                    height: width * 0.1,
                    width: width * 0.1,
                    decoration: const BoxDecoration(
                      color: AppTheme.gray,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          isSearching = !isSearching;
                          if (!isSearching) {
                            _searchController.clear();
                            filteredDoctors = [];
                          }
                        });
                      },
                      icon: Icon(
                        isSearching ? Icons.close : Icons.search,
                        size: width * 0.05,
                        color: AppTheme.green,
                      ),
                    ),
                  ),
                ],
              ),

              // أيقونات الترتيب
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: width * 0.02, horizontal: width * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Sort By',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: width * 0.04,
                            color: AppTheme.green,
                          ),
                    ),
                    SizedBox(width: width * 0.02),
                    Defaulticon(
                      onTap: () {
                        Navigator.of(context).pushNamed(DoctorPage.routeName);
                      },
                      icon: Icon(Icons.sort_by_alpha_outlined,
                          size: width * 0.045, color: AppTheme.green),
                      containerClolor: AppTheme.gray,
                    ),
                    SizedBox(width: width * 0.02),
                    Defaulticon(
                      onTap: () {
                        BlocProvider.of<DoctorCubit>(context)
                            .getAllDoctorsByTopRating();
                      },
                      icon: Icon(Icons.star_border,
                          size: width * 0.045, color: AppTheme.white),
                      containerClolor: AppTheme.green,
                    ),
                    SizedBox(width: width * 0.02),
                    Defaulticon(
                      onTap: () {
                        Navigator.of(context).pushNamed(Female.routeName);
                      },
                      icon: Icon(Icons.female,
                          size: width * 0.045, color: AppTheme.green),
                      containerClolor: AppTheme.gray,
                    ),
                    SizedBox(width: width * 0.02),
                    Defaulticon(
                      onTap: () {
                        Navigator.of(context).pushNamed(Male.routeName);
                      },
                      icon: Icon(Icons.male,
                          size: width * 0.045, color: AppTheme.green),
                      containerClolor: AppTheme.gray,
                    ),
                  ],
                ),
              ),

              // عرض الدكاترة حسب التقييم
              Expanded(
                child: BlocBuilder<DoctorCubit, DoctorState>(
                  builder: (context, state) {
                    if (state is DoctorLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is DoctorSuccess) {
                      final doctors =
                          isSearching && _searchController.text.isNotEmpty
                              ? filteredDoctors
                              : state.doctorsList;
                      return ListView.builder(
                        itemCount: doctors.length,
                        itemExtent: height * 0.18,
                        itemBuilder: (context, index) {
                          final doctor = doctors[index];
                          return ContainrDoctorRating(doctor: doctor);
                        },
                      );
                    } else if (state is DoctorFailure) {
                      return Center(
                          child: Text(state.errorMessage,
                              style: TextStyle(color: Colors.red)));
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
