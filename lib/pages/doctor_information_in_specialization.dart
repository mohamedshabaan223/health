import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cubits/doctors_cubit/doctor_cubit.dart';
import 'package:health_app/cubits/review_cubit/review_cubit.dart';
import 'package:health_app/models/get_all_review_model.dart';
import 'package:health_app/pages/review_screen_doctor.dart';
import 'package:health_app/widgets/container_doctor_info.dart';
import 'package:health_app/widgets/container_review.dart';

class DoctorInformationInSpecialization extends StatefulWidget {
  static const String routeName = '/doctor-info-in-specialization';

  const DoctorInformationInSpecialization({super.key});

  @override
  State<DoctorInformationInSpecialization> createState() =>
      _DoctorInformationInSpecializationState();
}

class _DoctorInformationInSpecializationState
    extends State<DoctorInformationInSpecialization> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () {
        final doctorId = ModalRoute.of(context)?.settings.arguments as int?;
        if (doctorId != null) {
          context.read<DoctorCubit>().getDoctorById(doctorId: doctorId);
          context.read<ReviewCubit>().getReviewsByDoctorId(doctorId);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final doctorId = ModalRoute.of(context)?.settings.arguments;

    if (doctorId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No doctor ID provided.')),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.04, vertical: size.height * 0.02),
          child: SingleChildScrollView(
            child: BlocBuilder<DoctorCubit, DoctorState>(
                builder: (context, state) {
              if (state is GetDoctorInfoLoading) {
                return SizedBox(
                  height: size.height * 0.7,
                  child: const Center(child: CircularProgressIndicator()),
                );
              }
              if (state is GetDoctorInfoFailure) {
                return Center(
                  child: Text(
                    "Error: ${state.errorMessage}",
                    style: TextStyle(
                        color: Colors.red, fontSize: size.width * 0.045),
                  ),
                );
              }
              if (state is GetDoctorInfoSuccess) {
                final doctor = state.doctorInfo;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_new_outlined,
                            size: size.width * 0.06,
                            color: AppTheme.green,
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'Doctor Information',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontSize: size.width * 0.05,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.02),
                    ContainerDoctorInfo(doctorId: doctorId as int),
                    SizedBox(height: size.height * 0.04),
                    Text(
                      'Profile: ',
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                            fontSize: size.width * 0.05,
                            color: AppTheme.green,
                          ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Text(
                      doctor.focus ?? 'There is no profile.',
                      style: TextStyle(
                        fontSize: size.width * 0.04,
                      ),
                    ),
                    SizedBox(height: size.height * 0.05),
                    Row(
                      children: [
                        Text(
                          'Reviews: ',
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: AppTheme.green3,
                                    fontSize: size.width * 0.05,
                                  ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                                ReviewScreenDoctorReview.id,
                                arguments: doctorId);
                          },
                          child: Text(
                            'See all',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    color: AppTheme.green,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppTheme.green),
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: AppTheme.gray, thickness: 2),
                    BlocBuilder<ReviewCubit, ReviewState>(
                      builder: (context, reviewState) {
                        if (reviewState is ReviewLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (reviewState is ReviewError) {
                          return Center(
                            child: Text('Error: ${reviewState.error}'),
                          );
                        }
                        if (reviewState is ReviewListSuccess) {
                          List<ReviewModel> reviewsToDisplay =
                              reviewState.reviews.take(3).toList();
                          if (reviewsToDisplay.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                'Be the first to write a review!',
                                style: TextStyle(
                                  fontSize: size.width * 0.04,
                                  color: AppTheme.black,
                                ),
                              ),
                            );
                          }
                          return Column(
                            children: reviewsToDisplay
                                .map((review) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 7),
                                      child: ContainerReview(review: review),
                                    ))
                                .toList(),
                          );
                        }
                        return SizedBox(
                          height: size.height * 0.7,
                          child: const Center(
                              child: Text('No reviews available.')),
                        );
                      },
                    ),
                  ],
                );
              } else {
                return SizedBox(
                  height: size.height * 0.7,
                  child: const Center(
                      child: Text('No doctor information available.')),
                );
              }
            }),
          ),
        ),
      ),
    );
  }
}
