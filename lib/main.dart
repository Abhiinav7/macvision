import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ChannelListScreen(),
    );
  }
}



class Channel {
  final String name;
  final String url;

  Channel(this.name, this.url);
}

Future<List<Channel>> loadM3UFile(String path) async {
  final String fileContent = await rootBundle.loadString(path);
  final List<String> lines = fileContent.split('\n');
  final List<Channel> channels = [];

  String? currentName;

  for (final line in lines) {
    if (line.trim().isEmpty) continue;
    if (line.startsWith('#EXTINF')) {
      currentName = line.split(',')[1].trim();
    } else if (currentName != null) {
      channels.add(Channel(currentName, line.trim()));
      currentName = null;
    }
  }


  return channels;
}



class ChannelListScreen extends StatefulWidget {
  @override
  _ChannelListScreenState createState() => _ChannelListScreenState();
}

class _ChannelListScreenState extends State<ChannelListScreen> {
  late Future<List<Channel>> _channelListFuture;

  @override
  void initState() {
    super.initState();
    _channelListFuture = loadM3UFile('assets/satip.m3u');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Channel List'),
      ),
      body: FutureBuilder<List<Channel>>(
        future: _channelListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading channels'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No channels available'));
          }

          final List<Channel> channels = snapshot.data!;

          return ListView.builder(
            itemCount: channels.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(channels[index].name),
                onTap: () {
                  print(channels[index].url);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayerScreen(
                        videoUrl: channels[index].url,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  VideoPlayerScreen({required this.videoUrl});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller.play();
        _controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: Center(
        child: _isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : CircularProgressIndicator(),
      ),
    );
  }
}
