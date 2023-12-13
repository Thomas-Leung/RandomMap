import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_map/models/nearby_search_model.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            color: Colors.white.withOpacity(0.97),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Builder(builder: (context) {
                return Consumer<NearbySearchModel>(
                    builder: (context, nearbySearchModel, child) {
                  return Text(
                    nearbySearchModel.msg,
                    style: Theme.of(context).textTheme.labelMedium,
                  );
                });
              }),
            ),
          ),
        ),
      ),
    );
  }
}
