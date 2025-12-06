import 'package:flutter/material.dart';
import 'package:pertemuan10/model/produk.dart';
import 'package:pertemuan10/bloc/produk_bloc.dart';
import 'package:pertemuan10/ui/produk_page.dart';
import 'package:pertemuan10/widget/warning_dialog.dart';

class ProdukForm extends StatefulWidget {
  final Produk? produk;
  ProdukForm({Key? key, this.produk}) : super(key: key);
  @override
  _ProdukFormState createState() => _ProdukFormState();
}

class _ProdukFormState extends State<ProdukForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "TAMBAH PRODUK H1D023047_Syahrial";
  String tombolSubmit = "SIMPAN";
  final _namaProdukTextboxController = TextEditingController();
  final _merkProdukTextboxController = TextEditingController();
  final _hargaProdukTextboxController = TextEditingController();
  final _jumlahProdukTextboxController = TextEditingController();
  final _tanggalProdukTextboxController = TextEditingController();
  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  isUpdate() {
    if (widget.produk != null) {
      setState(() {
        judul = "UBAH PRODUK H1D023047_Syahrial";
        tombolSubmit = "UBAH";
        _namaProdukTextboxController.text = widget.produk!.namaProduk!;
        _merkProdukTextboxController.text = widget.produk!.merkProduk!;
        _hargaProdukTextboxController.text = widget.produk!.hargaProduk
            .toString();
        _jumlahProdukTextboxController.text = widget.produk!.jumlahProduk
            .toString();
        _tanggalProdukTextboxController.text = widget.produk!.tanggalProduk!;
      });
    } else {
      judul = "TAMBAH PRODUK H1D023047_Syahrial";
      tombolSubmit = "SIMPAN";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(judul)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _namaProdukTextField(),
                _merkProdukTextField(),
                _hargaProdukTextField(),
                _jumlahProdukTextField(),
                _tanggalProdukTextField(),
                _buttonSubmit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _namaProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Nama Produk"),
      keyboardType: TextInputType.text,
      controller: _namaProdukTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Nama Produk harus diisi";
        }
        return null;
      },
    );
  }

  Widget _merkProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Merk Produk"),
      keyboardType: TextInputType.text,
      controller: _merkProdukTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Nama Produk harus diisi";
        }
        return null;
      },
    );
  }

  Widget _hargaProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Harga"),
      keyboardType: TextInputType.text,
      controller: _hargaProdukTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Harga harus diisi";
        }
        return null;
      },
    );
  }

  Widget _jumlahProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Jumlah"),
      keyboardType: TextInputType.text,
      controller: _jumlahProdukTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Jumlah harus diisi";
        }
        return null;
      },
    );
  }

  Widget _tanggalProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Tanggal"),
      keyboardType: TextInputType.text,
      controller: _tanggalProdukTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Tanggal harus diisi";
        }
        return null;
      },
    );
  }

  Widget _buttonSubmit() {
    return OutlinedButton(
      child: Text(tombolSubmit),
      onPressed: () {
        var validate = _formKey.currentState!.validate();
        if (validate) {
          if (!_isLoading) {
            if (widget.produk != null) {
              //kondisi ubah produk
              ubah();
            } else {
              //kondisi tambah produk
              simpan();
            }
          }
        }
      },
    );
  }

  simpan() {
    setState(() {
      _isLoading = true;
    });
    Produk createProduk = Produk(id: null);
    createProduk.namaProduk = _namaProdukTextboxController.text;
    createProduk.merkProduk = _merkProdukTextboxController.text;
    createProduk.hargaProduk = int.parse(_hargaProdukTextboxController.text);
    createProduk.jumlahProduk = int.parse(_jumlahProdukTextboxController.text);
    createProduk.tanggalProduk = _tanggalProdukTextboxController.text;
    ProdukBloc.addProduk(produk: createProduk).then(
      (value) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => const ProdukPage(),
          ),
        );
      },
      onError: (error) {
        showDialog(
          context: context,
          builder: (BuildContext context) => const WarningDialog(
            description: "Simpan gagal, silahkan coba lagi",
          ),
        );
      },
    );
    setState(() {
      _isLoading = false;
    });
  }

  ubah() {
    setState(() {
      _isLoading = true;
    });
    Produk updateProduk = Produk(id: widget.produk!.id!);
    updateProduk.namaProduk = _namaProdukTextboxController.text;
    updateProduk.merkProduk = _merkProdukTextboxController.text;
    updateProduk.hargaProduk = int.parse(_hargaProdukTextboxController.text);
    updateProduk.jumlahProduk = int.parse(_jumlahProdukTextboxController.text);
    updateProduk.tanggalProduk = _tanggalProdukTextboxController.text;
    ProdukBloc.updateProduk(produk: updateProduk).then(
      (value) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => const ProdukPage(),
          ),
        );
      },
      onError: (error) {
        showDialog(
          context: context,
          builder: (BuildContext context) => const WarningDialog(
            description: "Permintaan ubah data gagal, silahkan coba lagi",
          ),
        );
      },
    );
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _namaProdukTextboxController.dispose();
    _merkProdukTextboxController.dispose();
    _hargaProdukTextboxController.dispose();
    _jumlahProdukTextboxController.dispose();
    _tanggalProdukTextboxController.dispose();
    super.dispose();
  }
}
