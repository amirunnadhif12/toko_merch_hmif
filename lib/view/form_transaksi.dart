import 'package:flutter/material.dart';
import 'package:toko_merch_hmif/controller/transaksiController.dart';
import 'package:toko_merch_hmif/controller/userController.dart';
import 'package:toko_merch_hmif/models/merchandise.dart';
import 'package:toko_merch_hmif/models/transaksi.dart';
import 'package:toko_merch_hmif/view/ringkasan_transaksi.dart';

class FormTransaksiScreen extends StatefulWidget {
  final Merchandise merchandise;

  const FormTransaksiScreen({
    super.key,
    required this.merchandise,
  });

  @override
  State<FormTransaksiScreen> createState() => _FormTransaksiScreenState();
}

class _FormTransaksiScreenState extends State<FormTransaksiScreen> {
  final _formKey = GlobalKey<FormState>();
  final TransaksiController _transaksiController = TransaksiController();
  final UserController _userController = UserController();

  final TextEditingController _qtyController = TextEditingController(text: '1');
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();

  String _metodePembayaran = 'Transfer Bank';
  final List<String> _metodeList = ['Transfer Bank', 'E-Wallet', 'COD'];
  
  int _qty = 1;
  double _total = 0;
  int? _userId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _total = widget.merchandise.harga;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await _userController.getCurrentUser();
    if (userData != null) {
      setState(() {
        _userId = userData['id'];
        _namaController.text = userData['nama'] ?? '';
        _emailController.text = userData['email'] ?? '';
      });
    }
  }

  void _updateTotal() {
    setState(() {
      _qty = int.tryParse(_qtyController.text) ?? 1;
      if (_qty < 1) _qty = 1;
      _total = widget.merchandise.harga * _qty;
    });
  }

  String formatRupiah(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }

  Future<void> _simpanTransaksi() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final transaksi = Transaksi(
        userId: _userId ?? 0,
        namaBarang: widget.merchandise.nama,
        harga: widget.merchandise.harga,
        qty: _qty,
        total: _total,
        namaPembeli: _namaController.text,
        emailPembeli: _emailController.text,
        teleponPembeli: _teleponController.text,
        alamatPengiriman: _alamatController.text,
        metodePembayaran: _metodePembayaran,
        statusPembayaran: 'LUNAS',
        tanggalTransaksi: DateTime.now().toString(),
      );

      final id = await _transaksiController.simpanTransaksi(transaksi);
      transaksi.id = id;

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RingkasanTransaksiScreen(
              transaksi: transaksi,
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan transaksi: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        title: const Text('Form Transaksi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian A - Data Barang
              _buildSectionTitle('Data Barang'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.shopping_bag,
                              size: 40,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.merchandise.nama,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formatRupiah(widget.merchandise.harga),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.merchandise.deskripsi,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const Divider(height: 32),
                      
                      // Quantity
                      Row(
                        children: [
                          const Text(
                            'Jumlah (Qty):',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            onPressed: () {
                              if (_qty > 1) {
                                _qtyController.text = (_qty - 1).toString();
                                _updateTotal();
                              }
                            },
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                          SizedBox(
                            width: 60,
                            child: TextFormField(
                              controller: _qtyController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(vertical: 8),
                              ),
                              onChanged: (value) => _updateTotal(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Wajib';
                                }
                                if (int.tryParse(value) == null || int.parse(value) < 1) {
                                  return 'Min 1';
                                }
                                return null;
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _qtyController.text = (_qty + 1).toString();
                              _updateTotal();
                            },
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Total
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Pembayaran:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              formatRupiah(_total),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Bagian B - Data Pembeli
              _buildSectionTitle('Data Pembeli'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _namaController,
                        decoration: const InputDecoration(
                          labelText: 'Nama Pembeli *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama pembeli wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email Pembeli *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email pembeli wajib diisi';
                          }
                          if (!value.contains('@')) {
                            return 'Email tidak valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _teleponController,
                        decoration: const InputDecoration(
                          labelText: 'Nomor Telepon *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nomor telepon wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _alamatController,
                        decoration: const InputDecoration(
                          labelText: 'Alamat Pengiriman *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_on),
                          alignLabelWithHint: true,
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Alamat pengiriman wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _metodePembayaran,
                        decoration: const InputDecoration(
                          labelText: 'Metode Pembayaran *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.payment),
                        ),
                        items: _metodeList.map((String metode) {
                          return DropdownMenuItem<String>(
                            value: metode,
                            child: Text(metode),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _metodePembayaran = value ?? 'Transfer Bank';
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _simpanTransaksi,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Simpan Transaksi / Bayar',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _qtyController.dispose();
    _namaController.dispose();
    _emailController.dispose();
    _teleponController.dispose();
    _alamatController.dispose();
    super.dispose();
  }
}
