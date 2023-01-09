import 'dart:async';
import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_adoption/utils/animatedCheckmark.dart';
import 'package:pet_adoption/utils/savedPetData.dart';

import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:velocity_x/velocity_x.dart';

import '../utils/themes.dart';
import '../view_models/descriptionViewModel.dart';

class DescriptionView extends StatefulWidget {
  final petData;
  const DescriptionView({super.key, this.petData});

  @override
  State<DescriptionView> createState() => _DescriptionViewState();
}

class _DescriptionViewState extends State<DescriptionView>
    with SingleTickerProviderStateMixin {
  bool databaseLoaded = false;
  late AnimationController animationController;
  late Animation<double> _animation;
  late RiveAnimationController controller;
  bool _isPlaying = false;
  late ConfettiController controllerCenterRight;
  late ConfettiController controllerCenterLeft;
  Brightness? _brightness;
  @override
  void initState() {
    super.initState();
    controllerCenterRight =
        ConfettiController(duration: const Duration(seconds: 3));
    controllerCenterLeft =
        ConfettiController(duration: const Duration(seconds: 3));
    controller = OneShotAnimation(
      'active',
      autoplay: false,
      onStop: () => setState(() => _isPlaying = false),
      onStart: () => setState(() => _isPlaying = true),
    );
    animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );

    // animationController.repeat();
    databaseLoaded = false;
  }

  @override
  void dispose() {
    animationController.dispose();
    controllerCenterRight.dispose();
    controllerCenterLeft.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _brightness = WidgetsBinding.instance.window.platformBrightness;
    DescriptionViewModel descriptionViewModel =
        context.watch<DescriptionViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (descriptionViewModel.dogAdopted) {
        controllerCenterLeft.play();
        controllerCenterRight.play();
        showDialog(
            context: context,
            builder: (BuildContext context) =>
                _buildPopUp(context, descriptionViewModel.name));
      }
      if (!databaseLoaded) {
        databaseLoaded = true;
        await descriptionViewModel.selectPet(widget.petData, context);
      }
    });
    return WillPopScope(
      onWillPop: () async {
        descriptionViewModel.clearPet();
        return true;
      },
      child: Scaffold(
        backgroundColor: _brightness == Brightness.dark
            ? MyThemes.backgroundColorDark
            : MyThemes.backgroundColor,
        appBar: AppBar(
          title: Text(
            descriptionViewModel.name,
            style: TextStyle(
              color:
                  _brightness == Brightness.dark ? Colors.white : Colors.black,
            ),
          ),
          backgroundColor: _brightness == Brightness.dark
              ? MyThemes.barcolorDark
              : MyThemes.barcolor,
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(children: [
            Expanded(
                flex: 8,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 300,
                        child: Stack(children: [
                          if (descriptionViewModel.photo != "")
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Hero(
                                  tag: widget.petData.uid,
                                  transitionOnUserGestures: true,
                                  child: Image.asset(
                                    descriptionViewModel.photo,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          Positioned(
                            top: 230,
                            bottom: 0,
                            left: 180,
                            right: 0,
                            child: Center(
                              child: SizedBox(
                                width: 100,
                                height: 50,
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    if (!PetList.savedList
                                        .contains(descriptionViewModel.petId)) {
                                      descriptionViewModel
                                          .setAdopted(context); //popup
                                    }
                                  },
                                  child: Card(
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    color: MyThemes.cardColor,
                                    child: PetList.savedList.contains(
                                            descriptionViewModel.petId)
                                        ? "Adopted"
                                            .text
                                            .black
                                            .bold
                                            .make()
                                            .centered()
                                        : "Adopt Me <3"
                                            .text
                                            .black
                                            .bold
                                            .make()
                                            .centered(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 120,
                            bottom: 0,
                            left: 190,
                            right: 0,
                            child: AnimatedOpacity(
                              // If the widget is visible, animate to 0.0 (invisible).
                              // If the widget is hidden, animate to 1.0 (fully visible).
                              opacity: PetList.savedList
                                      .contains(descriptionViewModel.petId)
                                  ? 1.0
                                  : 0.0,
                              duration: const Duration(milliseconds: 500),
                              child: Center(
                                child: SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: Lottie.asset("assets/adopted.json")),
                              ),
                            ),
                          ),
                          confettiWidget(context),
                        ]),
                      ).py12(),
                      10.heightBox,
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: descriptionViewModel.breed.text
                            .maxLines(5)
                            .overflow(
                              TextOverflow.ellipsis,
                            )
                            .bold
                            .size(30)
                            .make()
                            .p(10),
                      ).px(40),
                      10.heightBox,
                      AnimatedOpacity(
                        opacity: descriptionViewModel.animation ? 0 : 1,
                        duration: const Duration(milliseconds: 500),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: descriptionViewModel.description.text
                              .maxLines(1000)
                              .overflow(
                                TextOverflow.ellipsis,
                              )
                              .size(20)
                              .make()
                              .p(10),
                        ).px(40),
                      ),
                      10.heightBox,
                    ],
                  ),
                )),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: _brightness == Brightness.dark
                      ? MyThemes.barcolorDark
                      : MyThemes.barcolor,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              descriptionViewModel.gender == "male"
                                  ? Icons.male
                                  : Icons.female,
                              color: _brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                              size: descriptionViewModel.windowSceneSize,
                            ),
                            descriptionViewModel.gender.text
                                .overflow(
                                  TextOverflow.ellipsis,
                                )
                                .bold
                                .size(15)
                                .make()
                          ]),
                    ),
                    10.heightBox,
                    Expanded(
                      flex: 1,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.child_care,
                              color: _brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                              size: descriptionViewModel.windowSceneSize,
                            ),
                            "${descriptionViewModel.age} yrs"
                                .text
                                .overflow(
                                  TextOverflow.ellipsis,
                                )
                                .bold
                                .size(15)
                                .make()
                          ]),
                    ),
                    10.heightBox,
                    Expanded(
                      flex: 1,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.height_rounded,
                              color: _brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                              size: descriptionViewModel.windowSceneSize,
                            ),
                            descriptionViewModel.size.text
                                .overflow(
                                  TextOverflow.ellipsis,
                                )
                                .bold
                                .size(15)
                                .make()
                          ]),
                    ),
                    10.heightBox,
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  Widget _buildPopUp(BuildContext context, String name) {
    _brightness = WidgetsBinding.instance.window.platformBrightness;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AlertDialog(
        backgroundColor: _brightness == Brightness.dark
            ? MyThemes.backgroundColorDark
            : MyThemes.backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text("You’ve now adopted $name").centered(),
        titleTextStyle: const TextStyle(
            fontSize: 40, color: Colors.black, fontWeight: FontWeight.bold),
        actions: <Widget>[
          Column(
            children: [
              Center(
                child: SizedBox(
                    height: 200,
                    width: 400,
                    child: Lottie.asset("assets/doneAnimation.json")),
              ),
              20.heightBox,
            ],
          ),
        ],
      ),
    );
  }

  Widget confettiWidget(BuildContext context) {
    return Column(children: [
      Align(
        alignment: Alignment.centerRight,
        child: ConfettiWidget(
          confettiController: controllerCenterRight,
          blastDirection: pi, // radial value - LEFT
          particleDrag: 0.05, // apply drag to the confetti
          emissionFrequency: 0.05, // how often it should emit
          numberOfParticles: 20, // number of particles to emit
          gravity: 0.05, // gravity - or fall speed
          shouldLoop: false,
          colors: const [
            Colors.green,
            Colors.blue,
            Colors.pink
          ], // manually specify the colors to be used
        ),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: ConfettiWidget(
          confettiController: controllerCenterLeft,
          blastDirection: 0, // radial value - RIGHT
          emissionFrequency: 0.6,
          minimumSize: const Size(10,
              10), // set the minimum potential size for the confetti (width, height)
          maximumSize: const Size(50,
              50), // set the maximum potential size for the confetti (width, height)
          numberOfParticles: 1,
          gravity: 0.1,
        ),
      ),
    ]);
  }
}
