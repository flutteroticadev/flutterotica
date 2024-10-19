import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:lit_reader/classes/dio_logging_intercepter.dart';

class DioController extends GetxController {
  final _dio = Dio(
    BaseOptions(
      validateStatus: (status) {
        return status! < 500; // Accept all status codes below 500
      },
    ),
  ).obs;

  Dio get dio => _dio.value;
  set dio(Dio value) => _dio.value = value;

  @override
  void onInit() {
    super.onInit();
    _dio.value.interceptors.add(DioLoggingInterceptor());
  }
}
