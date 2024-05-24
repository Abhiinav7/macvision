import 'package:flutter/material.dart';
import 'package:macvision2/Provider/HotelDetailProvider.dart';
import 'package:macvision2/home.dart';
import 'package:provider/provider.dart';


import 'ChannelList.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
       ChangeNotifierProvider(create:(context)=> HotelDetailProvider())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        home: BottomNavigation(),
      ),
    );
  }
}

