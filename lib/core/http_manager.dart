// ignore_for_file: avoid_print

import 'package:dio/dio.dart';

enum RequestType { get }

const successCodes = [200, 201];

class HttpManager {
  final Dio dio;
  HttpManager({
    required this.dio,
  }) {
    dio.options.connectTimeout = 15000;
    dio.options.receiveTimeout = 15000;
  }

  Future get(String endpoint) =>
      _futureNetworkRequest(RequestType.get, endpoint, {});
  Future _futureNetworkRequest(
    RequestType type,
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      late Response response;
      switch (type) {
        case RequestType.get:
          response = await dio.get(endpoint);
          break;
        default:
          print("Error");
      }
      if (successCodes.contains(response.statusCode)) {
        return response.data;
      }
    } catch (e) {
      if (e is DioError) {
        if (e.type == DioErrorType.connectTimeout ||
            e.type == DioErrorType.receiveTimeout) {
          print("Error con la conexion del servidor");
        }
      }
    }
  }
}
