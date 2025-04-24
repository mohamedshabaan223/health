import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:health_app/models/get_all_review_model.dart';
import 'package:meta/meta.dart';
import 'package:health_app/core/api/api_consumer.dart';
import 'package:health_app/core/errors/exceptions.dart';

part 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final ApiConsumer api;
  ReviewCubit(this.api) : super(ReviewInitial());

  Future<void> addReview({
    required String comment,
    required int rating,
    required int patientId,
    required int doctorId,
  }) async {
    emit(ReviewLoading());

    try {
      final response = await api.post(
        'http://10.0.2.2:5282/Api/V1/Review/AddReview',
        data: jsonEncode({
          "comment": comment,
          "rating": rating,
          "patientId": patientId,
          "doctorId": doctorId,
        }),
      );
      final message = response.toString();
      emit(ReviewSuccess(message));
    } on ServerException catch (e) {
      emit(ReviewError(e.errorModel.errorMessage));
    } catch (e) {
      emit(ReviewError("Unexpected error: $e"));
    }
  }

  Future<void> getReviewsByDoctorId(int doctorId) async {
    emit(ReviewLoading());

    try {
      final response = await api.get(
        'http://10.0.2.2:5282/Api/V1/Review/GetAllReviewsByDrId?doctorId=$doctorId',
      );
      List<dynamic> jsonData = response;

      List<ReviewModel> reviews =
          jsonData.map((data) => ReviewModel.fromJson(data)).toList();

      emit(ReviewListSuccess(reviews));
    } on ServerException catch (e) {
      emit(ReviewError(e.errorModel.errorMessage));
    } catch (e) {
      emit(ReviewError("Unexpected error: $e"));
    }
  }
}
