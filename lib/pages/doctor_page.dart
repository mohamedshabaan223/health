import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cubits/doctors_cubit/doctor_cubit.dart';
import 'package:health_app/models/doctor_model.dart';
import 'package:health_app/pages/doctor_female.dart';
import 'package:health_app/pages/doctor_male.dart';
import 'package:health_app/pages/doctor_page_information.dart';
import 'package:health_app/pages/doctor_rating.dart';
import 'package:health_app/widgets/container_doctor.dart';
import 'package:health_app/widgets/default_icon.dart';

class DoctorPage extends StatefulWidget {
  static const String routeName = '/doctor';
  const DoctorPage({super.key});

  @override
  State<DoctorPage> createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {
  bool isSortByAlpha = false;
  bool isSearching = false;
  List<DoctorModel> filteredDoctors = [];
  final TextEditingController _searchController = TextEditingController();
  DoctorCubit? _doctorCubit;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _doctorCubit = BlocProvider.of<DoctorCubit>(context);
      _doctorCubit?.getAllDoctorsByOrderType(orderType: 'ASC');
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

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: 10),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back_ios_new_outlined,
                        size: width * 0.05, color: AppTheme.green),
                  ),
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
                              'All Doctors',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontSize: width * 0.05),
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
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 10, horizontal: width * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Sort By',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                fontSize: width * 0.04, color: AppTheme.green)),
                    SizedBox(width: width * 0.02),
                    Defaulticon(
                      onTap: () {
                        setState(() {
                          isSortByAlpha = !isSortByAlpha;
                        });
                        BlocProvider.of<DoctorCubit>(context)
                            .getAllDoctorsByOrderType(
                                orderType: isSortByAlpha ? "ASC" : "DESC");
                      },
                      icon: Icon(Icons.sort_by_alpha_outlined,
                          size: width * 0.045, color: AppTheme.white),
                      containerClolor: AppTheme.green,
                    ),
                    SizedBox(width: width * 0.02),
                    Defaulticon(
                      onTap: () {
                        Navigator.of(context).pushNamed(Rating.routeName);
                      },
                      icon: Icon(Icons.star_border,
                          size: width * 0.04, color: AppTheme.green),
                      containerClolor: AppTheme.gray,
                    ),
                    SizedBox(width: width * 0.02),
                    Defaulticon(
                      onTap: () {
                        Navigator.of(context).pushNamed(Female.routeName);
                      },
                      icon: Icon(Icons.female,
                          size: width * 0.04, color: AppTheme.green),
                      containerClolor: AppTheme.gray,
                    ),
                    SizedBox(width: width * 0.02),
                    Defaulticon(
                      onTap: () {
                        Navigator.of(context).pushNamed(Male.routeName);
                      },
                      icon: Icon(Icons.male,
                          size: width * 0.04, color: AppTheme.green),
                      containerClolor: AppTheme.gray,
                    ),
                  ],
                ),
              ),
              if (isSearching && _searchController.text.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredDoctors.length,
                    itemBuilder: (context, index) {
                      final doctor = filteredDoctors[index];
                      return ListTile(
                        title: Text(
                          doctor.doctorName ?? 'Unknown',
                          style: TextStyle(
                              fontSize: width * 0.04, color: Colors.black),
                        ),
                        subtitle: Text(
                          doctor.specializationName ?? 'No Specialty',
                          style: TextStyle(
                              fontSize: width * 0.035, color: Colors.grey),
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              DoctorInformation.routeName,
                              arguments: doctor.id);
                        },
                      );
                    },
                  ),
                ),
              Expanded(
                child: BlocBuilder<DoctorCubit, DoctorState>(
                  builder: (context, state) {
                    if (state is DoctorLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is DoctorFailure) {
                      return Center(
                          child: Text('Error: ${state.errorMessage}'));
                    } else if (state is DoctorSuccess) {
                      final doctors = state.doctorsList;
                      return ListView.builder(
                        itemCount: doctors.length,
                        itemBuilder: (_, index) => ContainerDoctor(
                          doctorAddress: doctors[index].address ?? 'No Address',
                          doctorNmae:
                              doctors[index].doctorName ?? 'Dr. Unknown',
                          descrabtion: doctors[index].specializationName ??
                              'No Specialty',
                          doctorImage: 'assets/images/doctor_image.png',
                          doctorid: doctors[index],
                        ),
                      );
                    }
                    return const Center(child: Text('No doctors available.'));
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
