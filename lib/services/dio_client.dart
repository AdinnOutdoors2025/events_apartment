import 'package:apartment_project/services/storage_service.dart';
import 'package:apartment_project/utils/snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';

class DioClient {
  late Dio dio;

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 70),
        receiveTimeout: const Duration(seconds: 70),

        headers: {"Content-Type": "application/json"},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest:
            (RequestOptions options, RequestInterceptorHandler handler) async {
              final requireToken = options.headers["isRequireAuth"] == true;
              if (requireToken) {
                final token = await StorageService.getToken();

                if (token != null && token.isNotEmpty) {
                  options.headers["Authorization"] = "Bearer $token";
                }
              }
              // options.headers["Accept"] = "application/json";
              return handler.next(options);
            },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          if (kDebugMode) {
            print("STATUS CODE => ${response.statusCode}");
            print("RESPONSE => ${response.data}");
          }

          handler.next(response);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) {
          String errorMessage = handleError(error);

          if (kDebugMode) {
            print("ERROR => $errorMessage");
          }

          /// Unauthorized
          if (error.response?.statusCode == 401) {
            /// Logout logic

            // StorageService.clear();

            // Get.offAllNamed(Routes.login);
          }

          /// Snackbar Error
          //      Get.snackbar("Error", errorMessage);
        //  AppToast.showSuccess(errorMessage);
          if (kDebugMode) {
            print("ERRORDio => $errorMessage");
          }

          handler.next(error);
        },
      ),
    );
  }
}

String handleError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      return "Connection timeout";

    case DioExceptionType.sendTimeout:
      return "Request timeout";

    case DioExceptionType.receiveTimeout:
      return "Server timeout";

    case DioExceptionType.connectionError:
      return "No internet connection";

    case DioExceptionType.cancel:
      return "Request cancelled";

    case DioExceptionType.badResponse:
      final response = error.response;

      if (response != null) {
        final data = response.data;

        if (data is Map<String, dynamic>) {
          if (data["message"] != null) {
            return data["message"];
          }
        }

        switch (response.statusCode) {
          case 400:
            return "Bad request";

          case 401:
            return "Unauthorized";

          case 404:
            return "API not found";

          case 500:
            return "Internal server error";

          default:
            return "Something went wrong";
        }
      }

      return "Server error";

    case DioExceptionType.unknown:
      return error.message ?? "Something went wrong";

    default:
      return "Unexpected error occurred";
  }
}
