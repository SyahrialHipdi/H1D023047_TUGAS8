import 'package:flutter/material.dart';
import 'package:pertemuan10/bloc/produk_bloc.dart';
import 'package:pertemuan10/model/produk.dart';
import 'package:pertemuan10/ui/produk_form.dart';
import 'package:pertemuan10/ui/produk_page.dart';
import 'package:pertemuan10/widget/warning_dialog.dart';

class ProdukDetail extends StatefulWidget {
  final Produk? produk;
  const ProdukDetail({Key? key, required this.produk}) : super(key: key);

  @override
  _ProdukDetailState createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Produk H1D023047_Syahrial')),
      body: Center(
        child: Column(
          children: [
            Text(
              "kode: ${widget.produk!.kodeProduk}",
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              "nama: ${widget.produk!.namaProduk}",
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              "harga: ${widget.produk!.hargaProduk}",
              style: const TextStyle(fontSize: 18),
            ),
            _tombolHapusEdit(),
          ],
        ),
      ),
    );
  }

  Widget _tombolHapusEdit() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProdukForm(produk: widget.produk!),
              ),
            );
          },
          child: const Text('Edit'),
        ),
        OutlinedButton(
          child: const Text('Hapus'),
          onPressed: () => confirmHapus(),
        ),
      ],
    );
  }

  void confirmHapus() {
    AlertDialog alertDialog = AlertDialog(
      content: const Text("Yakin ingin menghapus data ini?"),
      actions: [
        OutlinedButton(
          child: const Text('Ya'),
          onPressed: () {
            ProdukBloc.deleteProduk(id: int.parse(widget.produk!.id!)).then(
              (value) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ProdukPage()),
                );
              },
              onError: (error) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      WarningDialog(description: "Hapus gagal, coba lagi"),
                );
              },
            );
          },
        ),

        OutlinedButton(
          child: const Text("Batal"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
    showDialog(context: context, builder: (context) => alertDialog);
  }
}
