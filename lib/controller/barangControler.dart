import 'package:http/http.dart' as http;

class BarangController {
  Future<String> fetchData(String cariBarang) async {
    // Implementasi pengambilan data barang dari API
    final response = await http.post(
      Uri.parse('http://10.2.20.19/api_toko_hmif/getBarang.php'),
      body: {
        'cari': cariBarang
      });
      
    if (response.statusCode == 200) {
      // Berhasil mendapatkan data
      return response.body;
    } else {
      // Gagal mendapatkan data
      return "Data gagal diambil";
    }
  }
}