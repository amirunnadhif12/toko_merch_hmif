import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:toko_merch_hmif/controller/barangControler.dart';
import 'package:toko_merch_hmif/models/barang.dart';

class HalamanBarang extends StatefulWidget {
  const HalamanBarang({super.key});

  @override
  State<HalamanBarang> createState() => _HalamanBarangState();
}

class _HalamanBarangState extends State<HalamanBarang> {

  BarangController barangController = BarangController();
  String _temp = "waiting respose...";
  List<Barang> listBarang = [];
  
  String  cariBarang = "";

  @override
  void initState() {
    super.initState();
    bacaData(cariBarang);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                label: Text("Cari Barang"),
                icon: Icon(Icons.search),
              ),
              onFieldSubmitted: (value) {
                setState(() {
                  cariBarang = value;
                });
                
                bacaData(cariBarang);

              },
            ),
            SizedBox(height: 50,),
            Expanded(
              child: daftarBarang(listBarang),
            ),
          ],
        ),
      )
    );
  }

  bacaData(String cariBarang) async {
    Future<String> data = barangController.fetchData(cariBarang);
    
    data.then((value) {
      listBarang.clear();
      Map json = jsonDecode(value);
      for (var item in json['data']) {
        listBarang.add(Barang.fromJson(item));
      }

      setState(() {
        _temp = listBarang[2].deskripsi;
      });
    });
  }

  Widget daftarBarang(listBarang) {
    if (listBarang.isEmpty || listBarang == null) {
      return CircularProgressIndicator();
    }else {
      return ListView.builder(
        itemCount: listBarang.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(listBarang[index].namaBarang),
            subtitle: Text(listBarang[index].deskripsi),
          );
        },
      );
    }
  }
}