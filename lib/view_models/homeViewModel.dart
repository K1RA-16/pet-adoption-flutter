import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pet_adoption/utils/savedPetData.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/db.dart';
import '../utils/dbStruct.dart';
import '../views/adoptedPetView.dart';
import '../views/descriptionView.dart';

class HomeViewModel extends ChangeNotifier {
  List<DbStruct> _petData = [];
  List<DbStruct> _adoptedPets = [];

  List<DbStruct> get petData => _petData;
  List<DbStruct> get adoptedPets => _adoptedPets;
  bool loading = false;
  ScrollController sc = ScrollController();
  ThemeData? theme;
  int pageStart = 0;
  int pageEnd = 3;
  Timer? timer;
  bool dataAvailable = true;

  void setLoading(bool value) {
    timer?.cancel();
    loading = value;
  }

  setTheme() {
    // theme =
    // notifyListeners();
  }

  Future<void> readJson() async {
    String response = await rootBundle.loadString('assets/pet.json');
    final data = await json.decode(response);
    Db.data = List.from(data['dogs'])
        .map<DbStruct>((item) => DbStruct.fromMap(item))
        .toList();
  }

  Future<void> loadDb() async {
    getList();
    sc.addListener(() {
      if (sc.position.pixels == sc.position.maxScrollExtent) {
        if (dataAvailable) {
          pageEnd += 3;
          loadPetData();
        }
      }
    });
    await readJson();
    loadPetData();
  }

  void loadPetData() {
    setLoading(true);
    notifyListeners();
    timer = Timer(
        const Duration(seconds: 2),
        () => {
              if (pageEnd >= Db.data.length)
                {
                  pageEnd = Db.data.length,
                  dataAvailable = false,
                },
              _petData += Db.data.sublist(pageStart, pageEnd),
              pageStart = pageEnd,
              setLoading(false),
              notifyListeners()
            });
  }

  getList() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      List<String> savedList = prefs.getStringList('petIdList')!;
      // savedList.clear();
      PetList.savedList = savedList;
      notifyListeners();
      // ignore: empty_catches
    } catch (e) {}
  }

  void loadAdoptedPets(
    BuildContext context,
  ) {
    _adoptedPets.clear();
    List<String> savedList = PetList.savedList;
    for (String petId in savedList) {
      var pet = Db.data.singleWhere((petData) => petData.uid == petId);
      print(pet);
      _adoptedPets.add(pet);
    }
    _adoptedPets = _adoptedPets.reversed.toList();
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              AdoptedPetView(petData: adoptedPets),
        ));
    // notifyListeners();
  }
}
