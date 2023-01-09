import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_adoption/utils/dbStruct.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '../utils/savedPetData.dart';
import '../utils/themes.dart';
import '../view_models/homeViewModel.dart';
import 'descriptionView.dart';

class ListInflate extends StatefulWidget {
  final DbStruct petData;

  const ListInflate({Key? key, required this.petData}) : super(key: key);

  @override
  State<ListInflate> createState() => _ListInflateState();
}

class _ListInflateState extends State<ListInflate> {
  Brightness? _brightness;
  @override
  Widget build(BuildContext context) {
    _brightness = WidgetsBinding.instance.window.platformBrightness;
    HomeViewModel homeViewModel = context.watch<HomeViewModel>();
    return InkWell(
        onTap: (() {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    DescriptionView(petData: widget.petData),
              )).then((value) => homeViewModel.getList());
        }),
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 50,
          child: Stack(children: [
            Positioned(
              top: MediaQuery.of(context).size.width - 240,
              left: 50,
              right: 50,
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 50,
                  height: MediaQuery.of(context).size.width - 200,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    color: _brightness == Brightness.dark
                        ? MyThemes.cardColorDark
                        : MyThemes.cardColor,
                  ),
                ),
              ),
            ),
            Center(
              child: VxBox(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                    Column(
                      children: [
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Hero(
                              tag: widget.petData.uid,
                              transitionOnUserGestures: true,
                              child: Image.asset(
                                widget.petData.photo,
                                width: MediaQuery.of(context).size.width * 0.7,
                                height: 180,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        10.heightBox,
                        SizedBox(
                            width: MediaQuery.of(context).size.width - 150,
                            child: widget.petData.name.text
                                .overflow(
                                  TextOverflow.ellipsis,
                                )
                                .bold
                                .size(30)
                                .make()
                            // .pOnly(left: 10),
                            ),
                        10.heightBox,
                        SizedBox(
                            width: MediaQuery.of(context).size.width - 150,
                            child: widget.petData.breed.text
                                .overflow(
                                  TextOverflow.ellipsis,
                                )
                                .make()
                            // .pOnly(left: 10),
                            ),
                        10.heightBox,
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 150,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                  child: "${widget.petData.age} yrs"
                                      .text
                                      .overflow(
                                        TextOverflow.ellipsis,
                                      )
                                      .bold
                                      .size(20)
                                      .make()
                                  // .pOnly(left: 10),
                                  ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ]))
                  .roundedLg
                  .square(MediaQuery.of(context).size.width - 50)
                  .make()
                  .pOnly(left: 30, right: 30, bottom: 20),
            ),
            if (PetList.savedList.contains(widget.petData.uid))
              Positioned(
                top: MediaQuery.of(context).size.width - 200,
                left: MediaQuery.of(context).size.width - 230,
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                          width: 200,
                          height: 100,
                          child: Lottie.asset("assets/adoptedhome.json")),
                      "Already adopted".text.make()
                    ],
                  ),
                ),
              ),
          ]),
        ));
  }
}
