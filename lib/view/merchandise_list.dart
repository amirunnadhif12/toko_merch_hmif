import 'package:flutter/material.dart';
import 'package:toko_merch_hmif/models/merchandise.dart';
import 'package:toko_merch_hmif/view/form_transaksi.dart';

class MerchandiseListScreen extends StatefulWidget {
  const MerchandiseListScreen({super.key});

  @override
  State<MerchandiseListScreen> createState() => _MerchandiseListScreenState();
}

class _MerchandiseListScreenState extends State<MerchandiseListScreen> {
  String searchQuery = "";
  
  List<Merchandise> get filteredMerchandise {
    if (searchQuery.isEmpty) {
      return dummyMerchandise;
    }
    return dummyMerchandise.where((item) => 
      item.nama.toLowerCase().contains(searchQuery.toLowerCase()) ||
      item.deskripsi.toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        title: const Text('Daftar Merchandise'),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari merchandise...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          
          // Merchandise Grid
          Expanded(
            child: filteredMerchandise.isEmpty
              ? const Center(
                  child: Text('Merchandise tidak ditemukan'),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: filteredMerchandise.length,
                  itemBuilder: (context, index) {
                    final item = filteredMerchandise[index];
                    return MerchandiseCard(
                      merchandise: item,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FormTransaksiScreen(
                              merchandise: item,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}

class MerchandiseCard extends StatelessWidget {
  final Merchandise merchandise;
  final VoidCallback onTap;

  const MerchandiseCard({
    super.key,
    required this.merchandise,
    required this.onTap,
  });

  String formatRupiah(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: Icon(
                Icons.shopping_bag,
                size: 50,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      merchandise.nama,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        merchandise.deskripsi,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formatRupiah(merchandise.harga),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
