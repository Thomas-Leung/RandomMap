import 'package:flutter/material.dart';

class PickRandomWidget extends StatefulWidget {
  const PickRandomWidget({super.key});

  @override
  State<PickRandomWidget> createState() => _PickRandomWidgetState();
}

class _PickRandomWidgetState extends State<PickRandomWidget> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Center(
          child: ElevatedButton(
            child: const Text('showBottomSheet'),
            onPressed: () {
              Scaffold.of(context).showBottomSheet<void>(
                (BuildContext context) {
                  return Container(
                    height: 200,
                    color: Colors.amber,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Text('Hello from Persistent Bottom Sheet'),
                          ElevatedButton(
                            child: const Text('Close BottomSheet'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      }
    );
  }
}
