import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:provider/provider.dart';

import 'Provider/HotelDetailProvider.dart';





class HomeStart extends StatelessWidget {

  @override
  Widget build(BuildContext context) {


    final hotelObj=Provider.of<HotelDetailProvider>(context);
    hotelObj.fetchImages();


    Size size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        height: size.height * 0.593,
        width: size.width,
        decoration: const BoxDecoration(
          image: ,
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 5,
                spreadRadius: 4,
              ),
            ],
            color: Colors.blue

        ),
        child: hotelObj.isLoading
            ? const Center(child: CircularProgressIndicator())
            : CarouselSlider(
          options: CarouselOptions(
            height: size.height * 0.593,
            enlargeCenterPage: false,
            autoPlay: true,
            aspectRatio: 16 / 9,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            viewportFraction: 1.0,
          ),
          items: hotelObj.imgList
              .map((item) => Container(
            color: Colors.white,
            child:CachedNetworkImage(
              imageUrl:item ,
              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),

              fit: BoxFit.cover,
              width: size.width,

            ),
          ))
              .toList(),
        ),
      ),
    );
  }
}
