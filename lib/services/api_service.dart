import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';
import '../model/apartment_update_model.dart';
import '../model/get_list_model.dart';
import '../model/order_history_model.dart';
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

  Future<GetListModel> getApartmentSummary({
    int? pageNumber,
    int? count,
    String? sessionId,
    String? search,
    String? location,
    String? city,
    String? apartmentGroupName,
    int? minRent,
    int? maxRent,
    int? minTG,
    int? maxTG,
  }) async {
    try {
      // Map<String, dynamic> body = {"pageNumber": pageNumber, "count": count};
      final body = <String, dynamic>{};
      if (pageNumber != null) {
        body["pageNumber"] = pageNumber;
      }

      if (count != null) {
        body["count"] = count;
      }
      if (sessionId != null && sessionId.isNotEmpty) {
        body["sessionId"] = sessionId;
      }

      if (search != null && search.isNotEmpty) {
        body["search"] = search;
      }

      if (location != null && location.isNotEmpty) {
        body["Location"] = location;
      }
      if (city != null && city.isNotEmpty) {
        body["City"] = city;
      }
      if (apartmentGroupName != null && apartmentGroupName.isNotEmpty) {
        body["ApartmentGroupName"] = apartmentGroupName;
      }

      if (minRent != null) {
        body["minRent"] = minRent;
      }

      if (maxRent != null) {
        body["maxRent"] = maxRent;
      }

      if (minTG != null) {
        body["minTG"] = minTG;
      }

      if (maxTG != null) {
        body["maxTG"] = maxTG;
      }

      if (kDebugMode) {
        print("REQUEST BODY => $body");
      }
      final response = await dio.post(
        ApiConstants.getExcelList,
        data: body,
        options: Options(headers: {"isRequireAuth": true}),
      );

      return GetListModel.fromJson(response.data);
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<OrderHistoryModel> getOrderHistoryAPI({
    required int pageNumber,
    required int count,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.orderHistory,
        data: {"pageNumber": pageNumber, "count": count},
        options: Options(headers: {"isRequireAuth": true}),
      );

      return OrderHistoryModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateOrderStatus({
    required String orderId,
    required int status,
    PlatformFile? poDocument,
    PlatformFile? statusDocument,
    PlatformFile? voiceDocument,
    String? additionalNotes,
    String? closeLossReason,
  }) async {
    try {
      final formData = FormData();

      formData.fields.add(MapEntry("status", status.toString()));

      if (additionalNotes?.isNotEmpty == true) {
        formData.fields.add(MapEntry("additionalNotes", additionalNotes!));
      }

      if (closeLossReason?.isNotEmpty == true) {
        formData.fields.add(MapEntry("closeLossReason", closeLossReason!));
      }

      if (poDocument != null) {
        formData.files.add(
          MapEntry(
            "poDocument",
            await MultipartFile.fromFile(
              poDocument.path!,
              filename: poDocument.name,
            ),
          ),
        );
      }

      if (statusDocument != null) {
        formData.files.add(
          MapEntry(
            "statusDocument",
            await MultipartFile.fromFile(
              statusDocument.path!,
              filename: statusDocument.name,
            ),
          ),
        );
      }

      if (voiceDocument != null) {
        formData.files.add(
          MapEntry(
            "voiceDocument",
            await MultipartFile.fromFile(
              voiceDocument.path!,
              filename: voiceDocument.name,
            ),
          ),
        );
      }

      await dio.put(
        "${ApiConstants.orderStatusUpdate}?orderId=$orderId",
        data: formData,
        options: Options(
          headers: {
            "isRequireAuth": true,
            "Content-Type": "multipart/form-data",
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Apartment> saveApartment({required Map<String, dynamic> body}) async {
    try {
      final response = await dio.post(
        ApiConstants.apartmentAdd,
        data: body,
        options: Options(headers: {"isRequireAuth": true}),
      );
      return Apartment.fromJson(response.data["data"]);
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw e.toString();
    }
  }
}
