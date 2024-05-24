import 'package:flutter/material.dart';
import 'package:macvision2/ChannelList.dart';
import 'package:macvision2/Mess.dart';
import 'package:macvision2/Provider/HotelDetailProvider.dart';
import 'package:macvision2/Weather.dart';
import 'package:macvision2/Info.dart';

import 'HomeStart.dart';


class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}


class _BottomNavigationState extends State<BottomNavigation> {

  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeStart(),
    ChannelListScreen(),
    Mess(),
    Weather(),
    Info(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(

        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        selectedIconTheme:IconThemeData(color: Colors.white) ,
        unselectedIconTheme: IconThemeData(color: Colors.black),
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },

        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.blue,
            icon: Icon(Icons.home,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.live_tv_sharp,),
            label: 'Live TV',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.room_service,),
            label: 'Mess',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sunny,),
            label: 'Weather',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info,),
            label: 'Info',
          ),
        ],
      ),
    );
  }
}

