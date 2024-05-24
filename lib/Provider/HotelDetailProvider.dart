import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart'as http;

class HotelDetailProvider extends ChangeNotifier{

  final String api = 'https://iptv.macvision.global/API/view_hotel_images.php';
  List<String> imgList = [];
  bool isLoading = true;
  Future<void> fetchImages() async {
    try {
      final response = await http.get(Uri.parse(api));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('data')) {

          imgList = [
            'https://iptv.macvision.global/${data['data']['h_image1']}',
            'https://iptv.macvision.global/${data['data']['h_image2']}',
            'https://iptv.macvision.global/${data['data']['h_image3']}',
          ];

          isLoading = false;
          notifyListeners();
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load images');
      }
    } catch (e) {
      print(e);
      isLoading = false;
      notifyListeners();
    }
  }
}