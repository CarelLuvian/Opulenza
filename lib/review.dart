import 'package:flutter/material.dart';

class ReviewPage extends StatefulWidget {
  final String category;
  final String itemName;
  final int itemPrice;
  final int quantity;

  const ReviewPage({
    super.key,
    required this.category,
    required this.itemName,
    required this.itemPrice,
    required this.quantity,
  });

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  String? name;
  String? address;
  String? detailAddress;
  String selectedBank = 'BCA Virtual Account';
  String? selectedCoupon;
  final List<String> banks = ['BRI', 'BNI', 'MANDIRI', 'BCA', 'OPZ Credit'];
  final List<String> coupons = ['DISKON10', 'SALE20', 'PAKAIHEMAT'];

  bool isAddressSet = false;
  bool showBankDropdown = false;
  bool showCouponDropdown = false;

  void selectAddress() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) {
        final nameController = TextEditingController();
        final addressController = TextEditingController();
        final detailController = TextEditingController();

        return AlertDialog(
          title: const Text('Atur Alamat'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nama Pemesan')),
              TextField(controller: addressController, decoration: const InputDecoration(labelText: 'Alamat')),
              TextField(controller: detailController, decoration: const InputDecoration(labelText: 'Detail Alamat')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, {
                  'name': nameController.text,
                  'address': addressController.text,
                  'detail': detailController.text,
                });
              },
              child: const Text('Oke'),
            )
          ],
        );
      },
    );

    if (result != null) {
      setState(() {
        name = result['name'];
        address = result['address'];
        detailAddress = result['detail'];
        isAddressSet = true;
      });
    }
  }

  int get itemTotal => widget.itemPrice * widget.quantity;
  int get fee => 7500;
  int get additional => 7500;
  int get finalTotal => itemTotal + fee + additional;

  void navigateBackToDetail() {
    Navigator.pop(context); // Ganti dengan pop agar tidak error
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Header
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: navigateBackToDetail,
                ),
                const SizedBox(width: 8),
                const Text('Review Pesanan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            const SizedBox(height: 8),

            // Alamat Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                title: const Text('Alamat pengiriman'),
                subtitle: isAddressSet
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('📍 $address ● $name'),
                    Text(detailAddress ?? '', style: const TextStyle(color: Colors.grey)),
                  ],
                )
                    : const Text('Belum ada alamat'),
                trailing: IconButton(icon: const Icon(Icons.arrow_forward_ios), onPressed: selectAddress),
              ),
            ),

            const SizedBox(height: 8),

            // Pesanan Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.itemName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Harga'),
                        Text('Rp ${widget.itemPrice}'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Jumlah'),
                        Text('${widget.quantity} item'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            const Text('Rincian Harga', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            // Harga Rincian
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  _buildPriceRow('Harga Produk', itemTotal),
                  _buildPriceRow('Fee', fee),
                  _buildPriceRow('Tambahan yang diambil', additional),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Metode Pembayaran
            _buildSelectableCard(
              title: 'Metode Pembayaran',
              trailing: InkWell(
                onTap: () => setState(() => showBankDropdown = !showBankDropdown),
                child: const Text('Lihat Semua', style: TextStyle(color: Colors.blue)),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(selectedBank),
                  if (showBankDropdown)
                    DropdownButton<String>(
                      value: selectedBank,
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          selectedBank = value!;
                          showBankDropdown = false;
                        });
                      },
                      items: banks.map((bank) => DropdownMenuItem(value: bank, child: Text(bank))).toList(),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            const Text('Pakai Kupon'),
            const SizedBox(height: 4),

            // Kupon Card
            _buildSelectableCard(
              title: '',
              trailing: InkWell(
                onTap: () => setState(() => showCouponDropdown = !showCouponDropdown),
                child: const Text('Tambah', style: TextStyle(color: Colors.blue)),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(selectedCoupon ?? 'Kupon'),
                  if (showCouponDropdown)
                    DropdownButton<String>(
                      value: selectedCoupon,
                      hint: const Text('Pilih kupon'),
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          selectedCoupon = value;
                          showCouponDropdown = false;
                        });
                      },
                      items: coupons.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Harga total dan Bayar
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Harga Total', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Rp $finalTotal', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB19174),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          // Bayar
                        },
                        child: Text(
                          'Bayar dengan $selectedBank',
                          style: const TextStyle(color: Colors.white),
                        ),
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

  Widget _buildPriceRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text('Rp $value'),
        ],
      ),
    );
  }

  Widget _buildSelectableCard({
    required String title,
    required Widget trailing,
    required Widget content,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title), trailing]),
          const SizedBox(height: 6),
          content,
        ]),
      ),
    );
  }
}
