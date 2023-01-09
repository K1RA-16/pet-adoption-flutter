import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pet_adoption/utils/dbStruct.dart';
import 'package:pet_adoption/utils/themes.dart';
import 'package:pet_adoption/views/petList.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '../view_models/homeViewModel.dart';

class AdoptedPetView extends StatefulWidget {
  final List<DbStruct> petData;
  const AdoptedPetView({super.key, required this.petData});

  @override
  State<AdoptedPetView> createState() => _AdoptedPetViewState();
}

class _AdoptedPetViewState extends State<AdoptedPetView> {
  Brightness? _brightness;
  @override
  Widget build(BuildContext context) {
    _brightness = WidgetsBinding.instance.window.platformBrightness;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Adopted Pets",
            style: TextStyle(
              color:
                  _brightness == Brightness.dark ? Colors.white : Colors.black,
            ),
          ),
          backgroundColor: _brightness == Brightness.dark
              ? MyThemes.barcolorDark
              : MyThemes.barcolor,
        ),
        backgroundColor: _brightness == Brightness.dark
            ? MyThemes.backgroundColorDark
            : MyThemes.backgroundColor,
        body: ListBuilder(
          petData: widget.petData,
        ));
  }
}

class ListBuilder extends StatelessWidget {
  final List<DbStruct> petData;
  const ListBuilder({super.key, required this.petData});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: petData.length,
      itemBuilder: (context, index) {
        return ListInflate(petData: petData[index]);
      },
    );
  }
}
