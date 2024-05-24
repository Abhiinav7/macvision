import 'package:flutter/material.dart';

import 'Channel.dart';
import 'Video.dart';

class ChannelListScreen extends StatefulWidget {
  @override
  _ChannelListScreenState createState() => _ChannelListScreenState();
}

class _ChannelListScreenState extends State<ChannelListScreen> {
  late Future<List<Channel>> _channelListFuture;
  final String api = 'https://iptv.macvision.global/API/ip_data.php';

  @override
  void initState() {
    super.initState();
    _channelListFuture = fetchAndLoadM3UFile(api);
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