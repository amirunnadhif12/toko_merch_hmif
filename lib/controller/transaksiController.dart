import 'package:toko_merch_hmif/database/user_helper.dart';
import 'package:toko_merch_hmif/models/transaksi.dart';

class TransaksiController {
  final dbHelper = UserDataBaseHelper.instance;

  Future<int> simpanTransaksi(Transaksi transaksi) async {
    Map<String, dynamic> row = {
      'user_id': transaksi.userId,
      'nama_barang': transaksi.namaBarang,
      'harga': transaksi.harga,
      'qty': transaksi.qty,
      'total': transaksi.total,
      'nama_pembeli': transaksi.namaPembeli,
      'email_pembeli': transaksi.emailPembeli,
      'telepon_pembeli': transaksi.teleponPembeli,
      'alamat_pengiriman': transaksi.alamatPengiriman,
      'metode_pembayaran': transaksi.metodePembayaran,
      'status_pembayaran': transaksi.statusPembayaran,
      'tanggal_transaksi': transaksi.tanggalTransaksi,
    };
    return await dbHelper.insertTransaksi(row);
  }

  Future<List<Transaksi>> getSemuaTransaksi() async {
    List<Map<String, dynamic>> results = await dbHelper.queryAllTransaksi();
    return results.map((map) => Transaksi.fromMap(map)).toList();
  }

  Future<List<Transaksi>> getTransaksiByUserId(int userId) async {
    List<Map<String, dynamic>> results = await dbHelper.queryTransaksiByUserId(userId);
    return results.map((map) => Transaksi.fromMap(map)).toList();
  }

  Future<Transaksi?> getTransaksiById(int id) async {
    Map<String, dynamic>? result = await dbHelper.queryTransaksiById(id);
    if (result != null) {
      return Transaksi.fromMap(result);
    }
    return null;
  }
}
