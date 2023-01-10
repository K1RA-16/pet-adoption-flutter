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
import 'package:pet_adoption/utils/db.dart';
import 'package:pet_adoption/utils/dbStruct.dart';
import 'package:pet_adoption/view_models/homeViewModel.dart';
import 'package:pet_adoption/views/homeView.dart';

import 'package:provider/provider.dart';

void main() {
  testWidgets('DB read json', (WidgetTester tester) async {
    // Create an instance of the HomeViewModel
    String response = await rootBundle.loadString('assets/pet.json');
    final data = await json.decode(response);
    Db.data = List.from(data['dogs'])
        .map<DbStruct>((item) => DbStruct.fromMap(item))
        .toList();
    var pet = DbStruct(
        uid: "id3",
        name: "Max",
        breed: "German Shepherd",
        age: 7,
        gender: "male",
        size: "large",
        description:
            "Max is a loyal and protective German Shepherd who is looking for an experienced owner. He is highly intelligent and would excel in obedience training or other activities that challenge his mind. Max is good with kids and gets along well with other dogs. He would make a great companion for someone who is looking for a companion to do activities with.",
        photo: "assets/german.png");
    // Verify that the loading indicator is displayed
    expect(Db.data.length, 11);
    expect(Db.data.contains(pet), true);
  });
  testWidgets('HomeView has a loading indicator', (WidgetTester tester) async {
    // Create an instance of the HomeViewModel
    Provider.debugCheckInvalidValueType = null;
    var homeViewModel = HomeViewModel();
    // Build the widget with the HomeViewModel wrapped in a MultiProvider
    await tester.pumpWidget(
      // have to use pump and settle to use timer
      MaterialApp(
        home: MultiProvider(
          providers: [
            Provider<HomeViewModel>.value(value: homeViewModel),
          ],
          child: HomeView(),
        ),
      ),
    );
    // Verify that the loading indicator is displayed
    expect(find.byType(ListBuilder), findsOneWidget);
  });
}
  // testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(const MyApp());

  //   // Verify that our counter starts at 0.
  //   expect(find.text('0'), findsOneWidget);
  //   expect(find.text('1'), findsNothing);

  //   // Tap the '+' icon and trigger a frame.
  //   await tester.tap(find.byIcon(Icons.history));
  //   await tester.pump();

  //   // Verify that our counter has incremented.
  //   expect(find.text('0'), findsNothing);
  //   expect(find.text('1'), findsOneWidget);
  // });

