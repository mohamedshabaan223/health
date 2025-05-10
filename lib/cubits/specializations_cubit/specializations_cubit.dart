import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:health_app/core/api/api_consumer.dart';
import 'package:health_app/core/api/end_points.dart';
import 'package:health_app/core/errors/exceptions.dart';
import 'package:health_app/cubits/specializations_cubit/specializations_state.dart';
import 'package:health_app/models/specializations_model.dart';
import 'package:path_provider/path_provider.dart';

class SpecializationsCubit extends Cubit<SpecialityState> {
  final ApiConsumer api;

  SpecializationsCubit(this.api) : super(SpecialityInitial());

  String specializationImagePath = "";
  Future<void> getAllSpecializations() async {
    try {
      emit(SpecialityLoading());
      final response = await api.get(EndPoints.allSpecialities);

      final List<dynamic> data = response;
      final List<SpecializationModel> specializations =
          data.map((json) => SpecializationModel.fromJson(json)).toList();
      for (var specialization in specializations) {
        if (specialization.image != null && specialization.image!.isNotEmpty) {
          try {
            File savedFile =
                await saveSpecializationImage(specialization.image!);
            specialization.imagePath = savedFile.path;
          } catch (e) {
            print("Failed to process specialization image: $e");
          }
        }
      }

      emit(SpecialitySuccess(specializations));
    } on ServerException catch (e) {
      emit(SpecialityFailure(errorMessage: e.errorModel.errorMessage));
    } catch (e) {
      emit(SpecialityFailure(errorMessage: "Unexpected error occurred: $e"));
    }
  }

  Future<File> saveSpecializationImage(String base64String) async {
    try {
      final String base64Data = base64String.split(',').last;
      Uint8List bytes = base64Decode(base64Data);

      final directory = await getApplicationDocumentsDirectory();
      final String filePath = '${directory.path}/specialization_image.png';

      final File file = File(filePath);
      await file.writeAsBytes(bytes);

      print("Specialization Image saved at: $filePath");
      return file;
    } catch (e) {
      print("Failed to save specialization image: $e");
      rethrow;
    }
  }

  void resetState() {
    emit(SpecialityInitial());
  }
}
