import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cubits/doctors_cubit/doctor_cubit.dart';
import 'package:health_app/models/doctor_model.dart';
import 'package:health_app/pages/doctor_female.dart';
import 'package:health_app/pages/doctor_page.dart';
import 'package:health_app/pages/doctor_page_information.dart';
import 'package:health_app/pages/doctor_rating.dart';
import 'package:health_app/widgets/container_doctor_male.dart';
import 'package:health_app/widgets/default_icon.dart';

class Male extends StatefulWidget {
  static const String routeName = '/male';

  const Male({super.key});

  @override
  State<Male> createState() => _MaleState();
}

class _MaleState extends State<Male> {
  bool isSearching = false;
  List<DoctorModel> filteredDoctors = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<DoctorCubit>(context).getDoctorsByGender(gender: '0');
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
          padding: EdgeInsets.all(width * 0.04),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new_outlined,
                      size: width * 0.05,
                      color: AppTheme.green,
                    ),
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
                                  color: Colors.grey, fontSize: width * 0.04),
                              border: InputBorder.none,
                            ),
                          )
                        : Center(
                            child: Text(
                              'Male Doctors',
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
                      shape: BoxShape.circle,
                      color: AppTheme.gray,
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
                        size: width * 0.045,
                        color: AppTheme.green,
                      ),
                    ),
                  ),
                ],
              ),
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
                      icon: Icon(Icons.sort_by_alpha,
                          size: width * 0.045, color: AppTheme.green),
                      containerClolor: AppTheme.gray,
                    ),
                    SizedBox(width: width * 0.02),
                    Defaulticon(
                      onTap: () {
                        Navigator.of(context).pushNamed(Rating.routeName);
                      },
                      icon: Icon(Icons.star_border,
                          size: width * 0.045, color: AppTheme.green),
                      containerClolor: AppTheme.gray,
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
                        BlocProvider.of<DoctorCubit>(context)
                            .getDoctorsByGender(gender: '0');
                      },
                      icon: Icon(Icons.male,
                          size: width * 0.045, color: AppTheme.white),
                      containerClolor: AppTheme.green,
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
                              color: Colors.black, fontSize: width * 0.045),
                        ),
                        subtitle: Text(
                          doctor.specializationName ?? 'No Specialty',
                          style: TextStyle(
                              color: Colors.grey, fontSize: width * 0.04),
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
                      return Center(
                          child: CircularProgressIndicator(
                        strokeWidth: width * 0.01,
                      ));
                    } else if (state is DoctorFailure) {
                      return Center(
                        child: Text(
                          'Error: ${state.errorMessage}',
                          style: TextStyle(
                              color: Colors.red, fontSize: width * 0.045),
                        ),
                      );
                    } else if (state is DoctorSuccess) {
                      final doctors = state.doctorsList;
                      return ListView.builder(
                        itemCount: doctors.length,
                        itemBuilder: (_, index) => ContainerDoctorMale(
                          doctorAddress: doctors[index].address ?? 'No Address',
                          doctorNmae:
                              doctors[index].doctorName ?? 'Dr. Unknown',
                          descrabtion: doctors[index].specializationName ??
                              'No Specialty',
                          doctorImage: 'assets/images/male.png',
                          doctorid: doctors[index],
                        ),
                      );
                    }
                    return Center(
                      child: Text('No doctors available.',
                          style: TextStyle(fontSize: width * 0.045)),
                    );
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
