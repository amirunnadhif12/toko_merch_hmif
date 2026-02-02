import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toko_merch_hmif/models/transaksi.dart';
import 'package:toko_merch_hmif/view/home.dart';

class RingkasanTransaksiScreen extends StatelessWidget {
  final Transaksi transaksi;

  const RingkasanTransaksiScreen({
    super.key,
    required this.transaksi,
  });

  String formatRupiah(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }

  String formatTanggal(String tanggal) {
    try {
      DateTime dateTime = DateTime.parse(tanggal);
      return DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(dateTime);
    } catch (e) {
      return tanggal;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        title: const Text('Ringkasan Transaksi'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Success Icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                size: 80,
                color: Colors.green[600],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Transaksi Berhasil!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Terima kasih telah berbelanja di Toko Merchandise HMIF',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),

            // 1. Informasi Transaksi
            _buildCard(
              context,
              title: 'Informasi Transaksi',
              icon: Icons.receipt_long,
              children: [
                _buildInfoRow('Nomor/ID Transaksi', '#TRX${transaksi.id.toString().padLeft(6, '0')}'),
                _buildInfoRow('Tanggal & Waktu', formatTanggal(transaksi.tanggalTransaksi)),
                _buildInfoRow('Metode Pembayaran', transaksi.metodePembayaran),
                _buildStatusRow('Status Pembayaran', transaksi.statusPembayaran),
              ],
            ),

            const SizedBox(height: 16),

            // 2. Data Pembeli
            _buildCard(
              context,
              title: 'Data Pembeli',
              icon: Icons.person,
              children: [
                _buildInfoRow('Nama Pembeli', transaksi.namaPembeli),
                _buildInfoRow('Email', transaksi.emailPembeli),
                _buildInfoRow('Nomor Telepon', transaksi.teleponPembeli),
                _buildInfoRow('Alamat Pengiriman', transaksi.alamatPengiriman),
              ],
            ),

            const SizedBox(height: 16),

            // 3. Detail Barang
            _buildCard(
              context,
              title: 'Detail Barang',
              icon: Icons.shopping_bag,
              children: [
                _buildInfoRow('Nama Barang', transaksi.namaBarang),
                _buildInfoRow('Harga Satuan', formatRupiah(transaksi.harga)),
                _buildInfoRow('Jumlah (Qty)', '${transaksi.qty} pcs'),
                const Divider(height: 24),
                _buildTotalRow('Total Pembayaran', formatRupiah(transaksi.total)),
              ],
            ),

            const SizedBox(height: 32),

            // Button Selesai
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Selesai / Kembali ke Home',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ),
          const Text(': '),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: Colors.green[800],
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
