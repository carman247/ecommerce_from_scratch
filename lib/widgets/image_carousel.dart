import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';

class ImageCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Carousel(
        boxFit: BoxFit.cover,
        autoplay: true,
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(milliseconds: 1000),
        dotSize: 4.0,
        dotIncreaseSize: 2,
        showIndicator: true,
        indicatorBgPadding: 4.0,
        images: [
          Image.network(
            'http://secureservercdn.net/160.153.138.163/nhd.12a.myftpupload.com/wp-content/uploads/2019/03/pexels-photo-1342609.jpg',
            fit: BoxFit.cover,
          ),
          Image.network(
            'https://www.luxurylifestylemag.co.uk/wp-content/uploads/2017/11/IMG_7222.jpg',
            fit: BoxFit.cover,
          ),
          Image.network(
            'https://www.vuelio.com/uk/wp-content/uploads/2018/06/mens-fashion-feature.jpg',
            fit: BoxFit.cover,
          ),
          Image.network(
            'https://www.telegraph.co.uk/content/dam/men/2018/07/02/TELEMMGLPICT000168190077_trans_NvBQzQNjv4BqpVlberWd9EgFPZtcLiMQfyf2A9a6I9YchsjMeADBa08.jpeg',
            fit: BoxFit.cover,
          ),
          Image.network(
            'https://www.theupcoming.co.uk/wp-content/uploads/2018/11/pexels-photo-842811-1024x620.jpeg',
            fit: BoxFit.cover,
          )
        ],
      ),
    );
  }
}
