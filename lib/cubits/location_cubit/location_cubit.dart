import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:location/location.dart';
import 'package:health_app/core/api/api_consumer.dart';
import 'package:health_app/cache/cache_helper.dart';
import 'package:dio/dio.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final ApiConsumer api;
  final CacheHelper cache;
  final Location _location;

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
        emit(LocationError('معلومات المستخدم غير متوفرة.'));
        return;
      }

      final locData = await _determineLocation();
      final body = {
        'userId': userId,
        'latitude': locData.latitude,
        'longitude': locData.longitude,
      };

      await api.post(
        'http://10.0.2.2:5282/Api/V1/Location/AddOrUpdateLocation',
        data: jsonEncode(body),
      );

      emit(LocationSuccess());
    } on DioException catch (e) {
      emit(LocationError('فشل في الإرسال: ${e.response?.data ?? e.message}'));
    } catch (e) {
      emit(LocationError('خطأ: ${e.toString()}'));
    }
  }

  Future<void> fetchNearbyDoctors() async {
    try {
      emit(LocationLoading());

      // Get current location
      final locData = await _determineLocation();
      final double? lat = locData.latitude;
      final double? lng = locData.longitude;

      if (lat == null || lng == null) {
        emit(LocationError('تعذر تحديد الموقع.'));
        return;
      }

      const double distanceInKm = 20; // مسافة ثابتة

      final response = await api.get(
        'http://10.0.2.2:5282/Api/V1/Location/NearbyDoctors',
        queryParameters: {
          'lat': lat,
          'lng': lng,
          'distanceInKm': distanceInKm,
        },
      );

      final List<dynamic> doctors = response;
      emit(NearbyDoctorsLoaded(doctors));
    } on DioException catch (e) {
      emit(LocationError(
          'فشل في جلب الدكاترة: ${e.response?.data ?? e.message}'));
    } catch (e) {
      emit(LocationError('حدث خطأ غير متوقع: ${e.toString()}'));
    }
  }
}
