// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_app/screens/hotels/hotelsearch.dart';

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2196F3),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: Image.asset(
                  "images/onboarding/onboarding3.png",
                  // width: 220,
                ),
              ),
            ),

            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                // padding: EdgeInsets.all(60),
                decoration: BoxDecoration(
                  color: Color(0xffFFFFFF),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Explore Local\nAttractions",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 14),
                    Text(
                      "Discover the beauty of local places you\nmay never have visited. Experience local\nlife and enjoy authentic experiences in\neach destination.",
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: SizedBox(
                        width: double.infinity,
                        height: 59,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            )
                            ),
                            onPressed: () {Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => HotelSearch()),
                              );},
                            child: Text("Finish")
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    SvgPicture.asset("assets/images/Frame 3.svg"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
