import 'package:dio/dio.dart';
import 'package:flutterotica/env/global.dart';

class DioLoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.method == 'POST' || options.method == 'GET') {
      logController.addLog('Request [${options.method}] => URL: ${options.uri}');
      //logController.addLog('Headers: ${options.headers}');
      //logController.addLog('Request Data: ${options.data}');
    }
    handler.next(options); // Continue with the request
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.requestOptions.method == 'POST' || response.requestOptions.method == 'GET') {
      logController.addLog('Response [${response.requestOptions.method}] => URL: ${response.requestOptions.uri}');
      logController.addLog('Status Code: ${response.statusCode}');
      //logController.addLog('Response Data: ${response.data}');
    }
    handler.next(response); // Continue with the response
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.requestOptions.method == 'POST' || err.requestOptions.method == 'GET') {
      logController.addLog('Error [${err.requestOptions.method}] => URL: ${err.requestOptions.uri}');
      logController.addLog('Error: ${err.error}');
      logController.addLog('Error Response Data: ${err.response?.data}');
    }
    handler.next(err); // Continue with the error
  }
}
