import 'package:flutter/material.dart';

class SelectionFAB extends StatefulWidget {
  const SelectionFAB({super.key});

  @override
  State<SelectionFAB> createState() => _SelectionFABState();
}

class _SelectionFABState extends State<SelectionFAB> {
  late FloatingActionButton customFAB;
  PersistentBottomSheetController? _bsController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // showAppBottomSheet(context);
      customFAB.onPressed!();
    });
  }

  @override
  Widget build(BuildContext context) {
    customFAB = FloatingActionButton(
      onPressed: () {
        _bsController = showBottomSheet(
            context: context,
            builder: (context) => Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.transparent),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20))),
                  height: 320,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Text('BottomSheet'),
                        ElevatedButton(
                          child: const Text('Close BottomSheet'),
                          onPressed: () {
                            closeAppBottomSheet();
                          },
                        ),
                      ],
                    ),
                  ),
                ));
      },
    );
    return customFAB;
  }

  closeAppBottomSheet() {
    if (_bsController != null) {
      _bsController!.close();
      _bsController = null;
    }
  }
}
