class Login {
  bool? success;
  String? message;
  // bool? status;
  int? userID;
  String? userEmail;
  Login({this.success, this.message, this.userID, this.userEmail});
  factory Login.fromJson(Map<String, dynamic> obj) {
    return Login(
      success: obj['success'],
      message: obj['message'],
      // token: obj['data']['token'],
      // userID: int.parse(obj['data']),
      // userEmail: obj['data']['email'],
      userID: obj['data'] != null ? obj['data']['id'] : null,
      userEmail: obj['data'] != null ? obj['data']['email'] : null,
    );
  }
}
