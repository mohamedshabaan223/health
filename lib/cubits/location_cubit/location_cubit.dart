import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:health_app/models/doctor_model_for_nearby_doctor.dart';
import 'package:health_app/models/nearby_doctor_model.dart';
import 'package:location/location.dart';
import 'package:health_app/core/api/api_consumer.dart';
import 'package:health_app/cache/cache_helper.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final ApiConsumer api;
  final CacheHelper cache;
  final Location _location;

  double? _currentLat;
  double? _currentLng;

  LocationCubit(this.api, this.cache)
      : _location = Location(),
        super(LocationInitial());

  int? _getUserId() => cache.getData(key: 'id') as int?;

  Future<void> _ensureServiceEnabled() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }
    }
  }

  Future<File> saveNearByDoctorImage(
      String base64String, String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final String filePath = '${directory.path}/$fileName.png';
      final File file = File(filePath);
      final String metaPath = '${directory.path}/$fileName.txt';

      final String base64Data = base64String.split(',').last;
      String cleanedBase64 =
          base64Data.replaceAll(RegExp(r'[^A-Za-z0-9+/=]'), '');
      String paddedBase64 = cleanedBase64;
      while (paddedBase64.length % 4 != 0) {
        paddedBase64 += "=";
      }

      if (await file.exists() && await File(metaPath).exists()) {
        final oldBase64 = await File(metaPath).readAsString();
        if (oldBase64 == paddedBase64) {
          print("Image already exists and is the same. Skipping save.");
          return file;
        }
      }

      Uint8List bytes = base64Decode(paddedBase64);
      await file.writeAsBytes(bytes);
      await File(metaPath).writeAsString(paddedBase64);
      print("Image saved at: $filePath");
      return file;
    } catch (e) {
      print("Failed to save image: $e");
      rethrow;
    }
  }

  Future<void> _ensurePermissionGranted() async {
    PermissionStatus permission = await _location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await _location.requestPermission();
      if (permission != PermissionStatus.granted) {
        throw Exception('Location permission denied.');
      }
    }
    if (permission == PermissionStatus.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }
  }

  Future<LocationData> _determineLocation() async {
    await _ensureServiceEnabled();
    await _ensurePermissionGranted();
    return await _location.getLocation();
  }

  Future<void> addOrUpdateLocation() async {
    try {
      emit(LocationLoading());

      final userId = _getUserId();
      if (userId == null) {
        emit(LocationError('User ID not found in cache.'));
        return;
      }

      final locData = await _determineLocation();
      _currentLat = locData.latitude;
      _currentLng = locData.longitude;

      final body = {
        'userId': userId,
        'latitude': _currentLat,
        'longitude': _currentLng,
      };

      await api.post(
        'http://medicalservicesproject.runasp.net/Api/V1/Location/AddOrUpdateLocation',
        data: jsonEncode(body),
      );
      await fetchNearbyDoctors(distanceInKm: 5);
    } on DioException catch (e) {
      emit(LocationError(
          'failed in addOrUpdateLocation: ${e.response?.data ?? e.message}'));
    } catch (e) {
      emit(LocationError('error: ${e.toString()}'));
    }
  }

  Future<void> fetchNearbyDoctors({required int distanceInKm}) async {
    if (_currentLat == null || _currentLng == null) {
      emit(LocationError('الموقع غير متوفر.'));
      return;
    }

    try {
      emit(LocationLoading());

      final response = await api.get(
        'http://medicalservicesproject.runasp.net/Api/V1/Location/NearbyDoctors?lat=$_currentLat&lng=$_currentLng&distanceInKm=$distanceInKm',
      );
      if (response is List) {
        final nearbyDoctors =
            response.map((json) => NearbyDoctorModel.fromJson(json)).toList();
        List<DoctorModelForNearByDoctor> fullDoctorModels = [];
        for (var nearbyDoctor in nearbyDoctors) {
          try {
            final doctorResponse = await api.get(
              'http://medicalservicesproject.runasp.net/GetDoctorDetails/${nearbyDoctor.userId}',
            );

            if (doctorResponse != null) {
              String? profileImage = doctorResponse['profileImage'];
              if (profileImage != null && profileImage.isNotEmpty) {
                final savedFile = await saveNearByDoctorImage(
                    profileImage, 'doctor_${nearbyDoctor.userId}.png');
                profileImage = savedFile.path;
              }
              final doctor = DoctorModelForNearByDoctor.fromJson({
                ...doctorResponse,
                'profileImage': doctorResponse['profileImage'],
              });

              doctor.localImagePath = profileImage;
              fullDoctorModels.add(doctor);
            } else {
              print('لا توجد بيانات للطبيب بالـ id ${nearbyDoctor.userId}');
            }
          } catch (e) {
            if (e is DioException && e.response?.statusCode == 404) {
              print(
                  'فشل في تحميل دكتور بالـ id ${nearbyDoctor.userId}: الطبيب غير موجود');
            } else {
              print('فشل في تحميل دكتور بالـ id ${nearbyDoctor.userId}: $e');
            }
          }
        }

        if (fullDoctorModels.isEmpty) {
          emit(LocationError('لم يتم العثور على أطباء قريبين.'));
        } else {
          emit(NearbyDoctorsLoaded(fullDoctorModels));
        }
      } else {
        emit(LocationError('الاستجابة غير متوقعة من السيرفر'));
      }
    } catch (e) {
      emit(LocationError('خطأ: ${e.toString()}'));
    }
  }

  void resetState() {
    emit(LocationInitial());
  }
}
