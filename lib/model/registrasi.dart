class Registrasi {
  bool? success;
  String? message;
  dynamic data;
  Registrasi({this.success, this.message, this.data});
  factory Registrasi.fromJson(Map<String, dynamic> obj) {
    return Registrasi(
      success: obj['success'],
      message: obj['message'],
      data: obj['data'],
    );
  }
}
