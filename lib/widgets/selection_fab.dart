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
  double distance = 3350;
  List<List> types = [
    ["Coffee", Icons.local_cafe_outlined],
    ["Light", Icons.lunch_dining_outlined],
    ["Restaurant", Icons.dinner_dining_outlined]
  ];
  int selectedType = -1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      customFAB.onPressed!();
    });
  }

  @override
  Widget build(BuildContext context) {
    customFAB = FloatingActionButton(
      backgroundColor: Colors.white,
      onPressed: () {
        _bsController = showBottomSheet(
          context: context,
          builder: (context) => StatefulBuilder(builder: (context, setState) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.transparent),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              height: 360,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Types of food:',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          ElevatedButton(
                            onPressed: () => setState(
                              () => selectedType = -1,
                            ),
                            child: const Text("Reset"),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 100,
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 10,
                                  childAspectRatio: 1.1),
                          itemCount: types.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedType = index;
                                });
                              },
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(16.0)),
                                child: Container(
                                  color: selectedType == index
                                      ? Colors.white54
                                      : Colors.white,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(types[index][1]),
                                        Text('${types[index][0]}'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Maximum Distance:',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            "${distance.toInt()} meters",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      Slider(
                        value: distance,
                        onChanged: (newDistance) {
                          setState(() => distance = newDistance);
                        },
                        min: 500,
                        max: 10000,
                        label: "${distance.toInt()}",
                        divisions: 10,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          child: const Text(
                            'Generate',
                          ),
                          onPressed: () {
                            context
                                .read<NearbySearchModel>()
                                .pickARandomRestaurant(
                                    distance,
                                    selectedType == -1
                                        ? "restaurants"
                                        : types[selectedType][0]);
                            closeAppBottomSheet();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
      child: const Icon(Icons.search_rounded),
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
