// import 'package:flutter/material.dart';
// import 'package:simple_animations/simple_animations.dart';

// class AnimatedBackground extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final tween = ([
//       Track("color1").add(Duration(seconds: 3),
//           ColorTween(begin: Color(0xffD38312), end: Colors.lightBlue.shade900)),
//       Tween("color2").add(Duration(seconds: 3),
//           ColorTween(begin: Color(0xffA83279), end: Colors.blue.shade600))
//     ]);

//     return MirrorAnimationBuilder(
//       tween: tween,
//       duration: tween.duration,
//       builder: (context,, animation) {
//         return Container(
//           decoration: BoxDecoration(
//               gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [animation["color1"], animation["color2"]])),
//         );
//       },
//     );
//   }
// }
