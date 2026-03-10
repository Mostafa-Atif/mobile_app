// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:mobile_app/screens/hotels/hotel_details.dart';
import 'package:mobile_app/screens/onboarding/onboarding_screen_2.dart';
import 'package:mobile_app/screens/onboarding/onboarding_screen_3.dart';

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.blue,
              child: Image.asset(
                'images/onboarding/onboarding1.png',
                // width: 200,
                // height: 200,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),

              // clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 40,
                ),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        "Plan Your Trip",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        "Create your dream trip with ease. Choose a destination, find the perfect place to stay, and create an itinerary that suits your preferences.",
                          style: TextStyle(
                            fontSize: 16,
                            // fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,  // full width
                          height: 56,              // height
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => OnboardingScreen2()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),  // rounded corners
                              ),
                            ),
                            child: Text(
                              'Next',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 5,
                              backgroundColor: Colors.blue,
                            ),
                            SizedBox(width: 10),
                            CircleAvatar(
                              radius: 5,
                              backgroundColor: Colors.grey,
                            ),
                            SizedBox(width: 10),
                            CircleAvatar(
                              radius: 5,
                              backgroundColor: Colors.grey,
                            ),
                          ],
                        )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}