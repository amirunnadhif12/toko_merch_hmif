class Merchandise {
  final int id;
  final String nama;
  final double harga;
  final String deskripsi;
  final String gambar;

  Merchandise({
    required this.id,
    required this.nama,
    required this.harga,
    required this.deskripsi,
    required this.gambar,
  });
}

// Data Dummy Merchandise HMIF
List<Merchandise> dummyMerchandise = [
  Merchandise(
    id: 1,
    nama: "Kaos HMIF",
    harga: 85000,
    deskripsi: "Kaos official HMIF dengan bahan cotton combed 30s, nyaman dipakai sehari-hari",
    gambar: "assets/kaos.png",
  ),
  Merchandise(
    id: 2,
    nama: "Hoodie HMIF",
    harga: 175000,
    deskripsi: "Hoodie premium HMIF dengan bahan fleece tebal, cocok untuk cuaca dingin",
    gambar: "assets/hoodie.png",
  ),
  Merchandise(
    id: 3,
    nama: "Topi HMIF",
    harga: 45000,
    deskripsi: "Topi baseball HMIF dengan bordir logo, adjustable strap",
    gambar: "assets/topi.png",
  ),
  Merchandise(
    id: 4,
    nama: "Lanyard HMIF",
    harga: 25000,
    deskripsi: "Lanyard exclusive HMIF dengan bahan polyester berkualitas",
    gambar: "assets/lanyard.png",
  ),
  Merchandise(
    id: 5,
    nama: "Stiker Pack HMIF",
    harga: 15000,
    deskripsi: "Paket stiker HMIF berisi 10 desain unik, bahan vinyl anti air",
    gambar: "assets/stiker.png",
  ),
  Merchandise(
    id: 6,
    nama: "Tumbler HMIF",
    harga: 65000,
    deskripsi: "Tumbler stainless steel HMIF 500ml, tahan panas dan dingin",
    gambar: "assets/tumbler.png",
  ),
  Merchandise(
    id: 7,
    nama: "Totebag HMIF",
    harga: 55000,
    deskripsi: "Totebag canvas HMIF, ramah lingkungan dan serbaguna",
    gambar: "assets/totebag.png",
  ),
  Merchandise(
    id: 8,
    nama: "Notebook HMIF",
    harga: 35000,
    deskripsi: "Notebook A5 HMIF dengan 100 halaman ruled, cover hardcover",
    gambar: "assets/notebook.png",
  ),
];
