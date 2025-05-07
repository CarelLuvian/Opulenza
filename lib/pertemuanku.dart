import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PertemuankuPage extends StatefulWidget {
  @override
  _PertemuankuPageState createState() => _PertemuankuPageState();
}

class _PertemuankuPageState extends State<PertemuankuPage> {
  DateTime selectedDate = DateTime.now();

  List<Map<String, String>> meetingList = []; // Akan diisi dari halaman Review Pesanan nanti

  void _goBack() {
    Navigator.pushReplacementNamed(context, '/akun');
  }

  void _selectDateFromCalendar() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      locale: const Locale('id', 'ID'), // pastikan ini ditambahkan
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('EEE, dd MMM yyyy', 'id_ID').format(date); // Misal: Sen, 05 Mei 2025
  }

  List<DateTime> getNextDates(DateTime baseDate) {
    return [baseDate, baseDate.add(const Duration(days: 1))];
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> dates = getNextDates(selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal Pertemuan', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: _goBack,
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: dates.map((date) {
                        bool isSelected = DateUtils.isSameDay(date, selectedDate);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDate = date;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: isSelected ? Colors.black : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                            ),
                            child: Text(
                              _formatDate(date),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: isSelected ? Colors.black : Colors.grey,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                InkWell(
                  onTap: _selectDateFromCalendar,
                  child: Column(
                    children: const [
                      Icon(Icons.calendar_today_outlined, size: 20, color: Colors.black),
                      SizedBox(height: 4),
                      Text('Kalender', style: TextStyle(fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Header tabel
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text('Nama Pertemuan', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(child: Text('Tempat', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(child: Text('Berakhir', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
          ),

          // Isi tabel
          Expanded(
            child: meetingList.isEmpty
                ? const Center(child: Text('Belum ada pertemuan untuk tanggal ini.'))
                : ListView.builder(
              itemCount: meetingList.length,
              itemBuilder: (context, index) {
                final item = meetingList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(item['nama'] ?? '')),
                      Expanded(child: Text(item['tempat'] ?? '')),
                      Expanded(child: Text(item['berakhir'] ?? '')),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
