// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class RandomResultWidget extends StatefulWidget {
  const RandomResultWidget({super.key});

  @override
  State<RandomResultWidget> createState() => _RandomResultWidgetState();
}

class _RandomResultWidgetState extends State<RandomResultWidget> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          child: Container(
            constraints: BoxConstraints(minHeight: 250, maxWidth: 600),
            height: height * 0.30,
            color: Colors.white.withOpacity(0.97),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.black.withAlpha(230),
                        child: Icon(
                          Icons.restaurant_rounded,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Flexible(
                        child: Text(
                          "2150 Yonge St, Toronto, ON M4S 2A8, Canada",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black.withAlpha(200),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          "Juicy Dumpling in Midtown",
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(
                        width: 32,
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.star_rate_rounded),
                              Text(
                                "4.8",
                                style: TextStyle(
                                    fontSize: 40,
                                    height: 0.8,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          Text(
                            "200 Reviews",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(0, 0, 0, 1),
                            foregroundColor: Colors.white,
                            shadowColor: Colors.transparent,
                            elevation: 0.0),
                        onPressed: () {},
                        icon: Icon(Icons.arrow_forward_rounded),
                        label: Text("Get direction")),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
