import 'package:flutter/material.dart';

class ReportPenjualanPage extends StatefulWidget {
  @override
  _ReportPenjualanPageState createState() => _ReportPenjualanPageState();
}

class _ReportPenjualanPageState extends State<ReportPenjualanPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  double jumlahPenjualan = 26000000;
  int transaksiBerhasil = 2;

  final List<Map<String, dynamic>> penawaranList = [
    {'produk': 'LV', 'harga': 15000000, 'status': 'Setuju'},
    {'produk': 'LV', 'harga': 11000000, 'status': 'Tolak'},
  ];

  final List<Map<String, dynamic>> tertundaList = [
    {'produk': 'Tas Gucci', 'status': 'Menunggu Konfirmasi', 'tindakan': 'Tertunda'},
  ];

  final List<Map<String, dynamic>> diprosesList = [
    {'produk': 'Sepatu Adidas', 'status': 'Sedang Diproses', 'tindakan': 'Diproses'},
  ];

  final List<Map<String, dynamic>> riwayatList = [
    {'produk': 'Jam Rolex', 'harga': 32000000, 'status': 'Selesai'},
  ];

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  Widget buildCard(String title, String value) {
    return Expanded(
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: TextStyle(color: Colors.grey)),
            SizedBox(height: 4),
            Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Color getStatusColor(String status) {
    if (status.toLowerCase() == 'setuju' ||
        status.toLowerCase() == 'selesai' ||
        status.toLowerCase() == 'diproses' ||
        status.toLowerCase() == 'tertunda') {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  Widget buildHeaderRow(List<String> titles) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        children: titles
            .map(
              (title) => Expanded(
            child: Text(title,
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
        )
            .toList(),
      ),
    );
  }

  Widget buildPenawaranContent() {
    return Column(
      children: [
        buildHeaderRow(['Produk', 'Harga yang Ditawarkan', 'Berakhir']),
        ...penawaranList.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            child: Row(
              children: [
                Expanded(child: Text(item['produk'])),
                Expanded(child: Text('Rp ${item['harga']}')),
                Expanded(
                  child: Text(
                    item['status'],
                    style: TextStyle(color: getStatusColor(item['status'])),
                  ),
                ),
              ],
            ),
          );
        }).toList()
      ],
    );
  }

  Widget buildTertundaContent() {
    return Column(
      children: [
        buildHeaderRow(['Produk', 'Status', 'Tindakan']),
        ...tertundaList.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            child: Row(
              children: [
                Expanded(child: Text(item['produk'])),
                Expanded(child: Text(item['status'])),
                Expanded(
                  child: Text(
                    item['tindakan'],
                    style: TextStyle(color: getStatusColor(item['tindakan'])),
                  ),
                ),
              ],
            ),
          );
        }).toList()
      ],
    );
  }

  Widget buildDiprosesContent() {
    return Column(
      children: [
        buildHeaderRow(['Produk', 'Status', 'Tindakan']),
        ...diprosesList.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            child: Row(
              children: [
                Expanded(child: Text(item['produk'])),
                Expanded(child: Text(item['status'])),
                Expanded(
                  child: Text(
                    item['tindakan'],
                    style: TextStyle(color: getStatusColor(item['tindakan'])),
                  ),
                ),
              ],
            ),
          );
        }).toList()
      ],
    );
  }

  Widget buildRiwayatContent() {
    return Column(
      children: [
        buildHeaderRow(['Produk', 'Harga', 'Status']),
        ...riwayatList.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            child: Row(
              children: [
                Expanded(child: Text(item['produk'])),
                Expanded(child: Text('Rp ${item['harga']}')),
                Expanded(
                  child: Text(
                    item['status'],
                    style: TextStyle(color: getStatusColor(item['status'])),
                  ),
                ),
              ],
            ),
          );
        }).toList()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Penjualan", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/akun');
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Row(
              children: [
                buildCard("Jumlah Penjualan", "Rp ${jumlahPenjualan.toInt()}"),
                buildCard("Transaksi Berhasil", "$transaksiBerhasil"),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            tabs: [
              Tab(text: 'Penawaran'),
              Tab(text: 'Tertunda'),
              Tab(text: 'Diproses'),
              Tab(text: 'Riwayat'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                buildPenawaranContent(),
                buildTertundaContent(),
                buildDiprosesContent(),
                buildRiwayatContent(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
