import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PengajuanPenjualanPage extends StatefulWidget {
  PengajuanPenjualanPage({Key? key}) : super(key: key);

  @override
  State<PengajuanPenjualanPage> createState() => _PenjualanPageState();
}

class _PenjualanPageState extends State<PengajuanPenjualanPage> {
  String? selectedCondition = "Baru";
  String? selectedCountryCode = '+62';
  int _selectedIndex = 2;

  final List<Map<String, String>> countryCodes = [
    {'country': 'Indonesia', 'code': '+62'},
    {'country': 'Malaysia', 'code': '+60'},
    {'country': 'Singapore', 'code': '+65'},
    {'country': 'Thailand', 'code': '+66'},
    {'country': 'Philippines', 'code': '+63'},
    {'country': 'Vietnam', 'code': '+84'},
  ];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  File? selectedImage;

  Future<void> _pickImage() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Kamera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Galeri'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          selectedImage = File(pickedFile.path);
        });
      }
    }
  }

  void _submit() {
    if (nameController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        selectedImage != null) {
      Navigator.pushNamed(context, '/detail_penjualan');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap lengkapi semua data')),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) Navigator.pushNamed(context, '/beranda');
    if (index == 1) Navigator.pushNamed(context, '/explore');
    if (index == 3) Navigator.pushNamed(context, '/akun');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jual Dengan Kami"),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Selamat Anda Telah Berhasil bergabung sebagai\nSeller di Marketplace Kami',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            const Text('Bagaimana Kondisi Product Anda ?'),
            Column(
              children: ['Baru', 'Seperti Baru', 'Bekas'].map((condition) {
                return RadioListTile(
                  title: Text(condition),
                  value: condition,
                  groupValue: selectedCondition,
                  onChanged: (value) {
                    setState(() {
                      selectedCondition = value.toString();
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            _buildTextField("Nama Produk", nameController),
            _buildTextField("Deskripsi", descriptionController),
            _buildTextField("Alamat", addressController),
            const Text("Foto Dokumen"),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: selectedImage != null
                    ? Image.file(selectedImage!, fit: BoxFit.cover)
                    : Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text("Jelajahi File"),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text("No. Ponsel"),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () async {
                      final selected = await showModalBottomSheet<String>(
                        context: context,
                        builder: (context) {
                          return ListView(
                            children: countryCodes.map((entry) {
                              return ListTile(
                                title: Text('${entry['country']} (${entry['code']})'),
                                onTap: () => Navigator.pop(context, entry['code']),
                              );
                            }).toList(),
                          );
                        },
                      );
                      if (selected != null) {
                        setState(() => selectedCountryCode = selected);
                      }
                    },
                    child: Container(
                      height: 56,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(selectedCountryCode ?? '+62'),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: SizedBox(
                    height: 56,
                    child: TextField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        hintText: "Nomor Telepon",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTextField("Di mulai di Harga", priceController, prefixText: "Rp "),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB8926A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: _submit,
              child: const Text("Ajukan Penjualan"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFB8926A),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Jual'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {String? prefixText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixText: prefixText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
