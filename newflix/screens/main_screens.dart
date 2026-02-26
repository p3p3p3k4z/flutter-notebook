//  lib/screens/main_screens.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import '../providers/video_provider.dart';
// import '../models/video.dart';
// import 'package:video_player/video_player.dart';
// import 'package:chewie/chewie.dart';

import '../providers/video_provider.dart' show VideoProvider;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VideoProvider>(context);

    if (provider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('NewFlix'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.list), text: 'Videos'),
            Tab(icon: Icon(Icons.play_circle_fill), text: 'Reproductor'),
            Tab(icon: Icon(Icons.photo_library), text: 'Galería'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SizedBox(width: 100, height: 30),
          SizedBox(width: 100, height: 30),
          SizedBox(width: 100, height: 30),
          // _buildVideoList(context, provider),
          // _buildVideoPlayer(context, provider),
          // _buildGallery(context, provider),
        ],
      ),
    );
  }
}
