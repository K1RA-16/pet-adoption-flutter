// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';

import 'package:pet_adoption/main.dart';
import 'package:pet_adoption/utils/db.dart';
import 'package:pet_adoption/utils/dbStruct.dart';
import 'package:pet_adoption/view_models/homeViewModel.dart';
import 'package:pet_adoption/views/homeView.dart';

import 'package:provider/provider.dart';

void main() {
  test('Load Adopted pets', () async {
    var adoptedPets = [];
    var petList = [];
    petList.add(DbStruct(
        uid: "id3",
        name: "Max",
        breed: "German Shepherd",
        age: 7,
        gender: "male",
        size: "large",
        description:
            "Max is a loyal and protective German Shepherd who is looking for an experienced owner. He is highly intelligent and would excel in obedience training or other activities that challenge his mind. Max is good with kids and gets along well with other dogs. He would make a great companion for someone who is looking for a companion to do activities with.",
        photo: "assets/german.png"));
    petList.add(DbStruct(
        uid: "id4",
        name: "Lucy",
        breed: "Beagle",
        age: 2,
        gender: "female",
        size: "small",
        description:
            "Lucy is a energetic and playful Beagle who loves to go on adventures. She is curious and always sniffing around for new things to discover. Lucy is good with kids and gets along well with other dogs. She would make a great companion for someone who is looking for an active dog.",
        photo: "assets/beagle.png"));
    petList.add(DbStruct(
        uid: "id5",
        name: "Charlie",
        breed: "Golden Retriever",
        age: 4,
        gender: "male",
        size: "large",
        description:
            "Charlie is a friendly and outgoing Golden Retriever who loves to make new friends. He is good with kids and gets along well with other dogs. Charlie is highly trainable and loves to learn new tricks. He would make a great companion for someone who is looking for a dog to do activities with.",
        photo: "assets/golden.png"));
    List<String> savedList = ["id3", "id5"];
    for (String petId in savedList) {
      var pet = petList.singleWhere((petData) => petData.uid == petId);
      adoptedPets.add(pet);
    }
    expect(adoptedPets.length, 2);
    expect(adoptedPets.contains(petList[0]), true);
    expect(adoptedPets.contains(petList[1]), false);
  });
}

