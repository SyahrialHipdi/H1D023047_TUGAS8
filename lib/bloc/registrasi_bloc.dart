import 'dart:convert';
import 'package:pertemuan10/helpers/api.dart';
import 'package:pertemuan10/helpers/api_url.dart';
import 'package:pertemuan10/model/registrasi.dart';

class RegistrasiBloc {
  static Future<Registrasi> registrasi({
    String? name,
    String? email,
    String? password,
  }) async {
    String apiUrl = ApiUrl.registrasi;
    var body = {"name": name, "email": email, "password": password};
    var response = await Api().post(apiUrl, body);

    Map<String, dynamic> jsonObj = json.decode(response.body);

    return Registrasi.fromJson(jsonObj);
    // var jsonObj = json.decode(response.body);
    // return jsonObj['status'];
    // return Registrasi.fromJson(jsonObj);
    // return Registrasi.fromJson(response);
    // return response['success'];
  }
}
