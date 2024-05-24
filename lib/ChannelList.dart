import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Video.dart';

class ChannelListScreen extends StatefulWidget {
  @override
  _ChannelListScreenState createState() => _ChannelListScreenState();
}

class _ChannelListScreenState extends State<ChannelListScreen> {
  late Future<List<Channel>> _channelListFuture;
  final String api = 'https://iptv.macvision.global/API/ip_data.php'; // Replace with your API endpoint
  late VideoPlayerScreen _videoPlayerScreen;

  @override
  void initState() {
    super.initState();
    _channelListFuture = fetchAndLoadM3UFile(api);
    _videoPlayerScreen = VideoPlayerScreen(videoUrl: ''); // Initial VideoPlayerScreen instance
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.blue,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: FutureBuilder<List<Channel>>(
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
                      title: Text(channels[index].name,style: TextStyle(color: Colors.white),),
                      onTap: () {
                        setState(() {
                          _videoPlayerScreen = VideoPlayerScreen(
                            videoUrl: channels[index].url,
                          );
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: _videoPlayerScreen,
          ),
        ],
      ),
    );
  }
}

class Channel {
  final String name;
  final String url;

  Channel(this.name, this.url);
}

Future<List<Channel>> fetchAndLoadM3UFile(String apiUrl) async {
  final response = await http.get(Uri.parse(apiUrl));
  print(response.statusCode);
  print(response.body);

  if (response.statusCode != 200) {
    throw Exception('Failed to fetch channel list');
  }

  final responseData = json.decode(response.body);

  print(responseData);

  final m3uFileUrl = responseData['data']['ipdata']; // Assuming the URL is directly provided by the API


  print( responseData['data']['ipdata']);


  final m3uResponse = await http.get(Uri.parse('https://iptv-org.github.io/iptv/languages/mal.m3u'));

  if (m3uResponse.statusCode != 200) {
    throw Exception('Failed to load m3u file');
  }

  final List<String> lines = m3uResponse.body.split('\n');
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
