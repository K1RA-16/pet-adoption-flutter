import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_adoption/utils/savedPetData.dart';
import 'package:pet_adoption/views/petList.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '../utils/themes.dart';
import '../view_models/homeViewModel.dart';
import 'descriptionView.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool databaseLoaded = false;
  Brightness? _brightness;
  @override
  void initState() {
    super.initState();
    databaseLoaded = false;
  }

  @override
  Widget build(BuildContext context) {
    HomeViewModel homeViewModel = context.watch<HomeViewModel>();
    _brightness = WidgetsBinding.instance.window.platformBrightness;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (!databaseLoaded) {
        databaseLoaded = true;
        await homeViewModel.loadDb();
      }
    });
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: _brightness == Brightness.dark
            ? MyThemes.backgroundColorDark
            : MyThemes.backgroundColor,
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                    flex: 1,
                    child: AnimatedOpacity(
                      opacity: homeViewModel.loading ? 0.1 : 1,
                      duration: const Duration(milliseconds: 500),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                          color: _brightness == Brightness.dark
                              ? MyThemes.barcolorDark
                              : MyThemes.barcolor,
                        ),
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.topLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            "Dogs".text.size(40).bold.make().pOnly(
                                top: 50, left: 20, right: 20, bottom: 10),
                            if (PetList.savedList.isNotEmpty)
                              InkWell(
                                      onTap: () {
                                        homeViewModel.loadAdoptedPets(context);
                                      },
                                      child: const Icon(Icons.history))
                                  .pOnly(
                                      top: 50, left: 20, right: 10, bottom: 10)
                          ],
                        ),
                      ),
                    )),
                Expanded(
                    flex: 7,
                    child: AnimatedOpacity(
                        opacity: homeViewModel.loading ? 0.1 : 1,
                        duration: const Duration(milliseconds: 500),
                        child: const ListBuilder()))
                  
              ],
            ),
            if (homeViewModel.loading)
              Center(
                child: SizedBox(
                    width: 400,
                    height: 400,
                    child: Lottie.asset("assets/loading.json")),
              )
          ],
        ),
      ),
    );
  }
}

class ListBuilder extends StatelessWidget {
  const ListBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    HomeViewModel homeViewModel = context.watch<HomeViewModel>();
    return ListView.builder(
      // physics: const BouncingScrollPhysics(),
      controller: homeViewModel.sc,
      shrinkWrap: true,
      itemCount: homeViewModel.petData.length,
      itemBuilder: (context, index) {
        return ListInflate(petData: homeViewModel.petData[index]);
      },
    );
  }
}
