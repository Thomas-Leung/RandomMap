// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:random_map/models/nearby_search_model.dart';
import 'package:url_launcher/url_launcher.dart';

class RandomResultWidget extends StatefulWidget {
  const RandomResultWidget({super.key});

  @override
  State<RandomResultWidget> createState() => _RandomResultWidgetState();
}

class _RandomResultWidgetState extends State<RandomResultWidget> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
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
              child: Consumer<NearbySearchModel>(
                builder: (context, nearbySearchModel, child) {
                  return Column(
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
                            child: GestureDetector(
                              onTap: () async {
                                await Clipboard.setData(
                                  ClipboardData(
                                      text: nearbySearchModel
                                          .randomRestaurant!.formattedAddress),
                                );
                              },
                              child: AutoSizeText(
                                nearbySearchModel
                                    .randomRestaurant!.formattedAddress,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black.withAlpha(200),
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: SizedBox(
                              height: height * 0.135,
                              child: Center(
                                child: AutoSizeText(
                                  nearbySearchModel
                                      .randomRestaurant!.displayName.text,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  minFontSize: 12,
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.star_rate_rounded),
                                  Text(
                                    nearbySearchModel.randomRestaurant!.rating
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 40,
                                        height: 0.8,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              Text(
                                "${nearbySearchModel.randomRestaurant!.userRatingCount} Reviews",
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
                            onPressed: () async {
                              Uri uri = Uri(
                                  scheme: "google.navigation",
                                  queryParameters: {
                                    'q': nearbySearchModel
                                        .randomRestaurant!.formattedAddress
                                  });
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri);
                              } else {
                                // open browser
                                uri = Uri(
                                    scheme: 'https',
                                    host: 'www.google.com',
                                    path:
                                        'maps/place/${nearbySearchModel.randomRestaurant!.formattedAddress}');
                                await launchUrl(uri);
                              }
                            },
                            icon: Icon(Icons.arrow_forward_rounded),
                            label: Text("Get direction")),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
