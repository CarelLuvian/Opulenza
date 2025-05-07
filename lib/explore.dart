import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:opulenza/akun.dart';
import 'package:opulenza/pengajuan_penjualan.dart';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';
import 'home.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<String> videoUrls = [];
  bool isLoading = true;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    fetchVideos();
  }

  Future<void> fetchVideos() async {
    const apiKey = 'I6tzeJIQc2stk1fykzLrqXCcq66pAeznPPMMTuuGDtnqZq9BnoUnsn47';
    final response = await http.get(
      Uri.parse('https://api.pexels.com/videos/popular?per_page=10'),
      headers: {'Authorization': apiKey},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final videos = data['videos'] as List;
      setState(() {
        videoUrls = videos
            .map((v) => (v['video_files'] as List)
            .firstWhere(
                (file) => file['quality'] == 'sd' || file['quality'] == 'hd',
            orElse: () => v['video_files'][0])['link']
        as String)
            .toList();
        isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengambil video dari API')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  void _pickVideoFromGallery() async {
    final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Video berhasil dipilih')),
      );
    }
  }

  void _goToProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigasi ke halaman profil')),
    );
  }

  void _goToSearch() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigasi ke halaman pencarian')),
    );
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
        break;
      case 1:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ExplorePage()));
        break;
      case 2:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PengajuanPenjualanPage()));
        break;
      case 3:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AkunPage()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: videoUrls.length,
            itemBuilder: (context, index) {
              return VideoItem(url: videoUrls[index]);
            },
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.person_outline, color: Colors.white),
                    onPressed: _goToProfile,
                  ),
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: _goToSearch,
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_box_outlined, color: Colors.white),
                    onPressed: _pickVideoFromGallery,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFFB19174),
        unselectedItemColor: const Color(0xFF6C757D),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.sell), label: 'Penjualan'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
        ],
      ),
    );
  }
}

class VideoItem extends StatefulWidget {
  final String url;

  const VideoItem({Key? key, required this.url}) : super(key: key);

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Stack(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _controller.value.isPlaying ? _controller.pause() : _controller.play();
            });
          },
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller.value.size.width,
              height: _controller.value.size.height,
              child: VideoPlayer(_controller),
            ),
          ),
        ),
        if (!_controller.value.isPlaying)
          const Center(
            child: Icon(Icons.play_circle_outline, color: Colors.white70, size: 64),
          ),
      ],
    )
        : const Center(child: CircularProgressIndicator());
  }
}
