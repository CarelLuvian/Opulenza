import 'package:flutter/material.dart';

class ReviewTersierPage extends StatefulWidget {
  final String namaItem;
  final int hargaItem;
  final String category;

  const ReviewTersierPage({
    super.key,
    required this.namaItem,
    required this.hargaItem,
    required this.category,
  });

  @override
  State<ReviewTersierPage> createState() => _ReviewTersierPageState();
}

class _ReviewTersierPageState extends State<ReviewTersierPage> {
  String selectedBank = "BCA Virtual Account";
  String selectedKupon = "";
  String? waktuPertemuan;

  final List<String> bankList = [
    "BRI",
    "BNI",
    "MANDIRI",
    "BCA",
    "OPZ Credit",
  ];

  final List<String> kuponList = [
    "HEMAT10",
    "DISKON25",
    "ONGKIRFREE",
  ];

  int fee = 7500;

  void pilihPertemuan() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selected != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          waktuPertemuan =
          "${selected.day}/${selected.month}/${selected.year} - ${time.hour}:${time.minute.toString().padLeft(2, '0')}";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalHarga = widget.hargaItem + fee;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Review Pesanan",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CARD PESANAN
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                title: Text(widget.namaItem),
                subtitle: const Text("Total 1 item"),
                trailing: Text(
                  "Rp ${widget.hargaItem.toStringAsFixed(0)}",
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // CARD ATUR PERTEMUAN
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                title: const Text("Atur Pertemuan"),
                subtitle: Text(waktuPertemuan ?? "Belum dipilih"),
                trailing: TextButton(
                  onPressed: pilihPertemuan,
                  child: const Text("Atur"),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // RINCIAN HARGA
            const Text("Rincian Harga", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  ListTile(
                    title: const Text("Harga"),
                    trailing: Text(
                      "Rp ${widget.hargaItem.toStringAsFixed(0)}",
                      style: const TextStyle(color: Colors.green),
                    ),
                  ),
                  ListTile(
                    title: const Text("Fee"),
                    trailing: Text(
                      "Rp ${fee.toStringAsFixed(0)}",
                      style: const TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // METODE PEMBAYARAN
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Metode Pembayaran"),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (_) {
                                return ListView(
                                  children: bankList.map((bank) {
                                    return ListTile(
                                      title: Text(bank),
                                      onTap: () {
                                        setState(() {
                                          selectedBank = "$bank Virtual Account";
                                        });
                                        Navigator.pop(context);
                                      },
                                    );
                                  }).toList(),
                                );
                              },
                            );
                          },
                          child: const Text("Lihat Semua", style: TextStyle(color: Colors.blue)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.account_balance, color: Colors.blue),
                        const SizedBox(width: 10),
                        Text(
                          selectedBank,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // PAKAI KUPON
            const Text("Pakai Kupon"),
            const SizedBox(height: 8),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: const Icon(Icons.local_offer_outlined),
                title: const Text("Kupon"),
                subtitle: Text(selectedKupon.isNotEmpty ? selectedKupon : "Belum dipilih"),
                trailing: TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) {
                        return ListView(
                          children: kuponList.map((kupon) {
                            return ListTile(
                              title: Text(kupon),
                              onTap: () {
                                setState(() {
                                  selectedKupon = kupon;
                                });
                                Navigator.pop(context);
                              },
                            );
                          }).toList(),
                        );
                      },
                    );
                  },
                  child: const Text("Tambah", style: TextStyle(color: Colors.blue)),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // TOTAL + BAYAR
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Harga Total"),
                        Text("Rp $totalHarga", style: const TextStyle(color: Colors.green)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Tambahkan logika pembayaran atau navigasi selanjutnya
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB19174),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: Text(
                        "Bayar dengan $selectedBank",
                        style: const TextStyle(color: Colors.white),
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
