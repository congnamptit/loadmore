import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MovieCart extends HookWidget {
  const MovieCart({
    Key? key,
    required this.title,
    required this.poster_path,
    required this.vote_average,
  }) : super(key: key);

  final String? title;
  final String? poster_path;
  final double? vote_average;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image:
                  NetworkImage('https://image.tmdb.org/t/p/w500$poster_path'),
              fit: BoxFit.fill,
            ),
          ),
        ),
        if (vote_average != null)
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment(0.8, 1),
                  colors: <Color>[
                    Color(0xffffb56b),
                    Color(0xffca485c),
                    // Color(0xffe16b5c),
                  ],
                  tileMode: TileMode.mirror,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    vote_average.toString().split('.')[0],
                    style: const TextStyle(color: Colors.white, fontSize: 32),
                  ),
                  const Text(
                    '.',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  Text(
                    vote_average.toString().split('.')[1],
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ],
              ),
            ),
          ),
        Positioned(
          bottom: 16,
          left: 16,
          child: Text(
            title!.toUpperCase(),
            maxLines: 2,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
