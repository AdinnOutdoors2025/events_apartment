import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
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
        data: {"phoneNumber": phone, "password": password, "role": 1},
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
}
