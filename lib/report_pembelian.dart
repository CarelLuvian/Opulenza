import 'package:flutter/material.dart';

class ReportPembelianPage extends StatefulWidget {
  @override
  _ReportPembelianPageState createState() => _ReportPembelianPageState();
}

class _ReportPembelianPageState extends State<ReportPembelianPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int jumlahPembelian = 25000000;
  int transaksiBerhasil = 2;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  Widget buildSummaryCard(String title, String value) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(4),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            SizedBox(height: 4),
            Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget buildPenawaranTab() {
    List<Map<String, dynamic>> data = [
      {
        "produk": "LV",
        "penawaran": "15.000.000",
        "status": "Setuju",
        "color": Colors.green
      },
      {
        "produk": "LV",
        "penawaran": "11.000.000",
        "status": "Tolak",
        "color": Colors.red
      },
    ];

    return buildTableHeader(["Produk", "Penawaran Kamu", "Berakhir"], data.map((item) {
      return TableRow(children: [
        Text(item["produk"]),
        Text(item["penawaran"]),
        Text(item["status"], style: TextStyle(color: item["color"])),
      ]);
    }).toList());
  }

  Widget buildTertundaTab() {
    List<Map<String, dynamic>> data = [
      {
        "produk": "Gucci Bag",
        "status": "Menunggu Konfirmasi",
        "tindakan": "Tertunda",
        "color": Colors.green
      },
    ];

    return buildTableHeader(["Produk", "Status", "Tindakan"], data.map((item) {
      return TableRow(children: [
        Text(item["produk"]),
        Text(item["status"]),
        Text(item["tindakan"], style: TextStyle(color: item["color"])),
      ]);
    }).toList());
  }

  Widget buildDiprosesTab() {
    List<Map<String, dynamic>> data = [
      {
        "produk": "Iphone 14 Pro",
        "status": "Dikemas",
        "tindakan": "Diproses",
        "color": Colors.green
      },
    ];

    return buildTableHeader(["Produk", "Status", "Tindakan"], data.map((item) {
      return TableRow(children: [
        Text(item["produk"]),
        Text(item["status"]),
        Text(item["tindakan"], style: TextStyle(color: item["color"])),
      ]);
    }).toList());
  }

  Widget buildRiwayatTab() {
    List<Map<String, dynamic>> data = [
      {
        "produk": "Macbook Air",
        "harga": "13.000.000",
        "status": "Selesai",
        "color": Colors.green
      },
    ];

    return buildTableHeader(["Produk", "Harga", "Status"], data.map((item) {
      return TableRow(children: [
        Text(item["produk"]),
        Text(item["harga"]),
        Text(item["status"], style: TextStyle(color: item["color"])),
      ]);
    }).toList());
  }

  Widget buildTableHeader(List<String> headers, List<TableRow> rows) {
    return Column(
      children: [
        Divider(),
        Table(
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(border: Border(bottom: BorderSide())),
              children: headers
                  .map((h) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(h,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ))
                  .toList(),
            ),
            ...rows.map((row) => TableRow(
              children: row.children!.map((cell) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: cell,
                );
              }).toList(),
            )),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.pushReplacementNamed(context, '/akun'),
          color: Colors.black,
        ),
        title: Text('Pembelian', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Row(
            children: [
              buildSummaryCard('Jumlah Pembelian', 'Rp $jumlahPembelian'),
              buildSummaryCard('Transaksi Berhasil', '$transaksiBerhasil'),
            ],
          ),
          SizedBox(height: 8),
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
                buildPenawaranTab(),
                buildTertundaTab(),
                buildDiprosesTab(),
                buildRiwayatTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
