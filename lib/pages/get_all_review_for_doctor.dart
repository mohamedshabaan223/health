import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/cache/cache_helper.dart';
import 'package:health_app/cubits/review_cubit/review_cubit.dart';
import 'package:health_app/models/get_all_review_model.dart';
import 'package:health_app/widgets/container_review.dart';

class GetAllReviewForDoctor extends StatelessWidget {
  const GetAllReviewForDoctor({super.key});
  static const String id = '/doctor_review';

  @override
  Widget build(BuildContext context) {
    final doctorId = CacheHelper().getData(key: 'id');
    Future.microtask(() {
      context.read<ReviewCubit>().getReviewsByDoctorId(doctorId!);
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back, color: Color(0xFF58CFA4)),
        ),
        titleSpacing: MediaQuery.of(context).size.width * 0.2,
        title: const Column(
          children: [
            SizedBox(height: 15),
            Text(
              'All reviews',
              style: TextStyle(
                color: Color(0xFF58CFA4),
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: BlocBuilder<ReviewCubit, ReviewState>(
        builder: (context, state) {
          if (state is ReviewLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ReviewError) {
            return Center(child: Text('Error: ${state.error}'));
          }

          if (state is ReviewListSuccess) {
            List<ReviewModel> reviews = state.reviews;

            if (reviews.isEmpty) {
              return Center(
                child: Text(
                  'No reviews available.',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: ContainerReview(review: reviews[index]),
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return const Center(child: Text('No reviews available.'));
        },
      ),
    );
  }
}
