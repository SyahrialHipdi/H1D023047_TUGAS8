class ApiUrl {
  static const String baseUrl = 'http://192.168.1.69:8000';

  static const String registrasi = baseUrl + '/api/register';
  static const String login = baseUrl + '/api/login';
  static const String listProduk = baseUrl + '/api/komputers';
  static const String createProduk = baseUrl + '/api/komputers';

  static String updateProduk(int id) {
    return baseUrl + '/api/komputers/' + id.toString();
  }

  static String showProduk(int id) {
    return baseUrl + '/api/komputers/' + id.toString();
  }

  static String deleteProduk(int id) {
    return baseUrl + '/api/komputers/' + id.toString();
  }
}
