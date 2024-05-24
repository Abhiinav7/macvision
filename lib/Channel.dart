import 'dart:convert';

import 'package:http/http.dart' as http;
class Channel {
  final String name;
  final String url;

  Channel(this.name, this.url);
}

Future<List<Channel>> fetchAndLoadM3UFile(String apiUrl) async {
  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode != 200) {
    throw Exception('Failed to load m3u file URL');
  }

  final responseData = json.decode(response.body);
  final m3uFileUrl = 'https://iptv.macvision.global${responseData['data']['ipdata']}';
  final m3uResponse = await http.get(Uri.parse(m3uFileUrl));

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