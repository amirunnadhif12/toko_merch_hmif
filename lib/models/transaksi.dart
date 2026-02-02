class Transaksi {
  int? id;
  int userId;
  String namaBarang;
  double harga;
  int qty;
  double total;
  String namaPembeli;
  String emailPembeli;
  String teleponPembeli;
  String alamatPengiriman;
  String metodePembayaran;
  String statusPembayaran;
  String tanggalTransaksi;

  Transaksi({
    this.id,
    required this.userId,
    required this.namaBarang,
    required this.harga,
    required this.qty,
    required this.total,
    required this.namaPembeli,
    required this.emailPembeli,
    required this.teleponPembeli,
    required this.alamatPengiriman,
    required this.metodePembayaran,
    required this.statusPembayaran,
    required this.tanggalTransaksi,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'nama_barang': namaBarang,
      'harga': harga,
      'qty': qty,
      'total': total,
      'nama_pembeli': namaPembeli,
      'email_pembeli': emailPembeli,
      'telepon_pembeli': teleponPembeli,
      'alamat_pengiriman': alamatPengiriman,
      'metode_pembayaran': metodePembayaran,
      'status_pembayaran': statusPembayaran,
      'tanggal_transaksi': tanggalTransaksi,
    };
  }

  factory Transaksi.fromMap(Map<String, dynamic> map) {
    return Transaksi(
      id: map['id'],
      userId: map['user_id'],
      namaBarang: map['nama_barang'],
      harga: map['harga'],
      qty: map['qty'],
      total: map['total'],
      namaPembeli: map['nama_pembeli'],
      emailPembeli: map['email_pembeli'],
      teleponPembeli: map['telepon_pembeli'],
      alamatPengiriman: map['alamat_pengiriman'],
      metodePembayaran: map['metode_pembayaran'],
      statusPembayaran: map['status_pembayaran'],
      tanggalTransaksi: map['tanggal_transaksi'],
    );
  }
}
