import 'package:flutter/material.dart';
import 'auth/sign_in.dart';
import 'auth/sign_up.dart';
import 'car rent/carssearch.dart';
import 'flights/flightsearch.dart';
import 'hotels/hotel_search.dart';

class TempHome extends StatelessWidget {
  const TempHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Dev Menu', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Main Screens', style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            _navButton(context, 'Hotels', Icons.hotel, Colors.teal, () => HotelSearch()),
            const SizedBox(height: 12),
            _navButton(context, 'Flights', Icons.flight, Colors.blue, () => FlightSearch()),
            const SizedBox(height: 12),
            _navButton(context, 'Car Rent', Icons.directions_car, Colors.orange, () => CarsSearch()),
            const SizedBox(height: 32),
            const Text('Auth', style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            _navButton(context, 'Sign In', Icons.login, Colors.green, () => const SignIn()),
            const SizedBox(height: 12),
            _navButton(context, 'Sign Up', Icons.person_add, Colors.purple, () => const SignUp()),
          ],
        ),
      ),
    );
  }

  Widget _navButton(BuildContext context, String label, IconData icon, Color color, Widget Function() page) {
    return ElevatedButton.icon(
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page())),
      icon: Icon(icon),
      label: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
    );
  }
}