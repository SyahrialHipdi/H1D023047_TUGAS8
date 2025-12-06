import 'dart:convert';
import 'package:pertemuan10/helpers/api.dart';
import 'package:pertemuan10/helpers/api_url.dart';
import 'package:pertemuan10/model/produk.dart';

class ProdukBloc {
  static Future<List<Produk>> getProduks() async {
    String apiUrl = ApiUrl.listProduk;
    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);
    List<dynamic> listProduk = jsonObj['data'];
    List<Produk> produks = [];
    for (int i = 0; i < listProduk.length; i++) {
      produks.add(Produk.fromJson(listProduk[i]));
    }
    return produks;
  }

  static Future addProduk({Produk? produk}) async {
    String apiUrl = ApiUrl.createProduk;

    var body = {
      "nama": produk!.namaProduk,
      "merk": produk.merkProduk,
      "harga": produk.hargaProduk,
      "jumlah": produk.jumlahProduk,
      "tanggal_masuk": produk.tanggalProduk,
    };

    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  static Future updateProduk({required Produk produk}) async {
    String apiUrl = ApiUrl.updateProduk(produk.id!);
    print(apiUrl);

    var body = {
      "nama": produk.namaProduk,
      "merk": produk.merkProduk,
      "harga": produk.hargaProduk,
      "jumlah": produk.jumlahProduk,
      "tanggal_masuk": produk.tanggalProduk,
    };
    print("Body : $body");
    var response = await Api().put(
      apiUrl,
      body,
    ); // PDF pakai jsonEncode, tp Helper API pakai body map biasa. Sesuaikan.
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  static Future<bool> deleteProduk({int? id}) async {
    String apiUrl = ApiUrl.deleteProduk(id!);
    var response = await Api().delete(apiUrl);
    var jsonObj = json.decode(response.body);
    // return (jsonObj as Map<String, dynamic>)['data'];
    return jsonObj['success'] == true;
  }
}
