import 'package:dio/dio.dart';
import 'package:get/get.dart';

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
}
