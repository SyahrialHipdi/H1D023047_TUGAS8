class Produk {
  int? id;
  String? namaProduk;
  String? merkProduk;
  int? hargaProduk;
  int? jumlahProduk;
  String? tanggalProduk;
  Produk({
    this.id,
    this.namaProduk,
    this.merkProduk,
    this.hargaProduk,
    this.jumlahProduk,
    this.tanggalProduk,
  });
  factory Produk.fromJson(Map<String, dynamic> obj) {
    return Produk(
      id: obj['id'],
      namaProduk: obj['nama'],
      merkProduk: obj['merk'],
      hargaProduk: obj['harga'],
      jumlahProduk: obj['jumlah'],
      tanggalProduk: obj['tanggal_masuk'],
    );
  }
}
