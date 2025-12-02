import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pertemuan10/helpers/user_info.dart';
import 'app_exception.dart';

class Api {
  Future<dynamic> post(dynamic url, dynamic data) async {
    var token = await UserInfo().getToken();
    var responseJson;
    try {
      final headers = <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
      };
      if (token != null && token.isNotEmpty) {
        headers[HttpHeaders.authorizationHeader] = "Bearer $token";
      }
      // Debug logging
      try {
        print('API POST -> url=$url');
        print(
          'headers=${headers.map((k, v) => MapEntry(k, k == HttpHeaders.authorizationHeader ? '***token***' : v))}',
        );
        print('body=${json.encode(data)}');
      } catch (e) {
        // ignore print errors
      }
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(data),
        headers: headers,
      );
      print('API POST <- status=${response.statusCode} body=${response.body}');
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      // Print exception and rethrow wrapped for UI
      print('API POST Exception: $e');
      rethrow;
    }
    return responseJson;
  }

  Future<dynamic> get(dynamic url) async {
    var token = await UserInfo().getToken();
    var responseJson;
    try {
      final headers = <String, String>{};
      if (token != null && token.isNotEmpty) {
        headers[HttpHeaders.authorizationHeader] = "Bearer $token";
      }
      try {
        print('API GET -> url=$url');
        print(
          'headers=${headers.map((k, v) => MapEntry(k, k == HttpHeaders.authorizationHeader ? '***token***' : v))}',
        );
      } catch (e) {}
      final response = await http.get(
        Uri.parse(url),
        headers: headers.isEmpty ? null : headers,
      );
      print('API GET <- status=${response.statusCode} body=${response.body}');
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      print('API GET Exception: $e');
      rethrow;
    }
    return responseJson;
  }

  Future<dynamic> put(dynamic url, dynamic data) async {
    var token = await UserInfo().getToken();
    var responseJson;
    try {
      final headers = <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
      };
      if (token != null && token.isNotEmpty) {
        headers[HttpHeaders.authorizationHeader] = "Bearer $token";
      }
      try {
        print('API PUT -> url=$url');
        print(
          'headers=${headers.map((k, v) => MapEntry(k, k == HttpHeaders.authorizationHeader ? '***token***' : v))}',
        );
        print('body=${json.encode(data)}');
      } catch (e) {}
      final response = await http.put(
        Uri.parse(url),
        body: json.encode(data),
        headers: headers,
      );
      print('API PUT <- status=${response.statusCode} body=${response.body}');
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      print('API PUT Exception: $e');
      rethrow;
    }
    return responseJson;
  }

  Future<dynamic> delete(dynamic url) async {
    var token = await UserInfo().getToken();
    var responseJson;
    try {
      final headers = <String, String>{};
      if (token != null && token.isNotEmpty) {
        headers[HttpHeaders.authorizationHeader] = "Bearer $token";
      }
      try {
        print('API DELETE -> url=$url');
        print(
          'headers=${headers.map((k, v) => MapEntry(k, k == HttpHeaders.authorizationHeader ? '***token***' : v))}',
        );
      } catch (e) {}
      final response = await http.delete(
        Uri.parse(url),
        headers: headers.isEmpty ? null : headers,
      );
      print(
        'API DELETE <- status=${response.statusCode} body=${response.body}',
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      print('API DELETE Exception: $e');
      rethrow;
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return response;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 422:
        throw InvalidInputException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
          'Error occured while Communication with Server with StatusCode : ${response.statusCode}',
        );
    }
  }
}
