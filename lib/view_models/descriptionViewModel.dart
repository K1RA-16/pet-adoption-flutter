import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:pet_adoption/utils/savedPetData.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/db.dart';

class DescriptionViewModel extends ChangeNotifier {
  String name = "";
  String breed = "";
  int age = 0;
  String gender = "";
  String size = "";
  String description = "";
  String photo = "";
  double windowSceneSize = 0.0;
  bool dogAdopted = false;
  bool animation = true;
  String petId = "";

  selectPet(petData, BuildContext context) {
    dogAdopted = false;
    petId = petData.uid;
    name = petData.name;
    breed = petData.breed;
    age = petData.age;
    gender = petData.gender;
    size = petData.size;
    description = petData.description;
    photo = petData.photo;
    windowSceneSize = MediaQuery.of(context).size.width * 0.07;
    animation = false;
    notifyListeners();
  }

  setAdopted(BuildContext context) {
    dogAdopted = true;
    saveList();
    notifyListeners();
    final _ = Timer(
        const Duration(seconds: 3),
        () => {
              Navigator.pop(context),
            });
  }

  saveList() async {
    if (petId != "") {
      try {
        PetList.savedList.add(petId);
        print(PetList.savedList);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setStringList('petIdList', PetList.savedList);
        // ignore: empty_catches
      } catch (e) {}
    }
  }

  clearPet() {
    animation = true;
    dogAdopted = false;
    name = "";
    breed = "";
    age = 0;
    gender = "";
    size = "";
    description = "";
    photo = "";
    petId = "";
  }
}
