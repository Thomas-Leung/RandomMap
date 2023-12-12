import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_map/models/nearby_search_model.dart';

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
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   customFAB.onPressed!();
    // });
  }

  @override
  Widget build(BuildContext context) {
    customFAB = FloatingActionButton(
      backgroundColor: Colors.white,
      onPressed: () {
        context.read<NearbySearchModel>().pickARandomRestaurant();
        // _bsController = showBottomSheet(
        //   context: context,
        //   builder: (context) => Container(
        //     decoration: BoxDecoration(
        //       border: Border.all(color: Colors.transparent),
        //       borderRadius: const BorderRadius.vertical(
        //         top: Radius.circular(20),
        //       ),
        //     ),
        //     height: 320,
        //     child: Center(
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         mainAxisSize: MainAxisSize.min,
        //         children: <Widget>[
        //           ElevatedButton(
        //             child: const Text('Generate Result'),
        //             onPressed: () {
        //               context.read<NearbySearchModel>().pickARandomRestaurant();
        //               closeAppBottomSheet();
        //             },
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // );
      },
      child: const Icon(Icons.autorenew_rounded),
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
