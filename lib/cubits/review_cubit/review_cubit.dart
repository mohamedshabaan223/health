import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:health_app/core/api/api_consumer.dart';
import 'package:health_app/core/errors/exceptions.dart';
import 'package:health_app/models/get_all_review_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:meta/meta.dart';

part 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final ApiConsumer api;
  ReviewCubit(this.api) : super(ReviewInitial());

  String patientProfilePhotoPath = "";
  Future<File> savePatientProfileImage(String base64String) async {
    try {
      final String base64Data = base64String.split(',').last;
      Uint8List bytes = base64Decode(base64Data);

      final directory = await getApplicationDocumentsDirectory();
      final String filePath = '${directory.path}/patient_profile_image.png';

      final File file = File(filePath);
      await file.writeAsBytes(bytes);

      print("patient Image saved at: $filePath");
      return file;
    } catch (e) {
      print("Failed to save patient image: $e");
      rethrow;
    }
  }

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
      emit(ReviewError("حدث خطأ غير متوقع: $e"));
    }
  }

  Future<void> getReviewsByDoctorId(int doctorId) async {
    if (state is ReviewLoading)
      return; // إذا كانت الحالة بالفعل في وضع تحميل، لا نعيد التبديل.

    emit(ReviewLoading()); // عرض دائرة التحميل.

    try {
      final response = await api.get(
          'http://10.0.2.2:5282/Api/V1/Review/GetAllReviewsByDrId?doctorId=$doctorId');
      List<dynamic> jsonData = response;

      List<ReviewModel> reviews =
          jsonData.map((data) => ReviewModel.fromJson(data)).toList();

      for (var review in reviews) {
        if (review.senderImage != null && review.senderImage!.isNotEmpty) {
          try {
            if (review.senderImage!.contains('data:image')) {
              await savePatientProfileImage(review.senderImage!).then((file) {
                review.localImagePath = file.path;
              });
            } else {
              review.localImagePath = review.senderImage;
            }
          } catch (e) {
            print("Failed to save patient profile image: $e");
          }
        }
      }

      emit(ReviewListSuccess(reviews)); // الحالة بنجاح بعد تحميل المراجعات.
    } on ServerException catch (e) {
      emit(ReviewError(e.errorModel.errorMessage));
    } catch (e) {
      emit(ReviewError("حدث خطأ غير متوقع: $e"));
    }
  }

  void resetState() {
    emit(ReviewInitial());
  }
}
