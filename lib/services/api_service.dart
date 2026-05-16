import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';
import '../model/get_list_model.dart';
import '../model/recent_upload_model.dart';
import '../model/upload_file_model.dart';
import 'dio_client.dart';

class ApiService {
  final Dio dio = DioClient().dio;

  Future<dynamic> loginPostAPI({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.login,
        data: {"phoneNumber": phone, "password": password},
        options: Options(headers: {"isRequireAuth": false}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw response.data["message"] ?? "Login failed";
      }
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw "Something went wrong";
    }
  }

  Future<UploadFileModel> uploadExcelAPI({required File file}) async {
    try {
      String fileName = file.path.split('/').last;

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path, filename: fileName),
      });

      final response = await dio.post(
        ApiConstants.uploadExcel,
        data: formData,
        options: Options(
          headers: {
            "isRequireAuth": true,
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (kDebugMode) {
          print(response.data);
        }
        return UploadFileModel.fromJson(response.data);
      } else {
        throw response.data["message"] ?? "Upload failed";
      }
    } on DioException catch (e) {
      /*if (e.response != null) {
        throw e.response?.data["message"] ?? "Upload failed";
      } else {
        throw e.message ?? "Something went wrong";
      }*/
      throw handleError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<RecentUploadModel> recentUploadAPI({
    required int pageNumber,
    required int count,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.recentUpload,
        data: {"pageNumber": pageNumber, "count": count},
        options: Options(headers: {"isRequireAuth": true}),
      );

      return RecentUploadModel.fromJson(response.data);
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<GetListModel> getUploadSummaryAPI({required String sessionId}) async {
    try {
      final response = await dio.post(
        ApiConstants.getExcelList,
        data: {"sessionId": sessionId},
        options: Options(headers: {"isRequireAuth": true}),
      );

      return GetListModel.fromJson(response.data);
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw e.toString();
    }
  }
}
