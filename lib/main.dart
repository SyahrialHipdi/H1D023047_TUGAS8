import 'package:flutter/material.dart';
import 'package:pertemuan10/helpers/user_info.dart';
import 'package:pertemuan10/ui/login_page.dart';
import 'package:pertemuan10/ui/produk_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Toko Kita',
      debugShowCheckedModeBanner: false,
      home: ProdukPage(),
    );
  }
}
