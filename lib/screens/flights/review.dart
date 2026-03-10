import 'package:flutter/material.dart';

class Review extends StatelessWidget {
  const Review({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Review your trip',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.blue),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    'Cairo to Dubai',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Total duration  14h 20m',
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                      Text(
                        'Mon, 23 Feb 2026',
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildTimeline(),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Icon(Icons.keyboard_arrow_up, size: 16, color: Colors.black54),
                    Text(
                      'QAR 770',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE84560),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 36,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: Column(
              children: [
                _timeLabel('04:15 AM', '23 Feb'),
                _durationLabel('02h 50m'),
                _timeLabel('08:05 AM', '23 Feb'),
                _waitLabel('10h 5m'),
                _timeLabel('06:10 PM', '23 Feb'),
                _durationLabel('01h 25m'),
                _timeLabel('08:35 PM', '23 Feb'),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 20,
            child: Column(
              children: [
                _dot(),
                _line(height: 60),
                _dot(),
                _line(height: 90),
                _dot(),
                _line(height: 60),
                _dot(),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _airportCard(
                  name: 'Cairo International Airport',
                  code: '(CAI)',
                  sub1: 'Terminal 2',
                  sub2: 'Cairo, Egypt',
                ),
                _flightCard(airline: 'Gulf Air GF-80', cabin: 'Economy'),
                _airportCard(
                  name: 'Bahrain International Airport',
                  code: '(BAH)',
                  sub1: 'Bahrain, Bahrain',
                ),
                _waitCard('Waiting time between flights in BAH, Bahrain'),
                _airportCard(
                  name: 'Bahrain International Airport',
                  code: '(BAH)',
                  sub1: 'Bahrain, Bahrain',
                ),
                _flightCard(airline: 'Gulf Air GF-510', cabin: 'Economy'),
                _airportCard(
                  name: 'Dubai International Airport',
                  code: '(DXB)',
                  sub1: 'Terminal 1',
                  sub2: 'Dubai, United Arab Emirates',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeLabel(String time, String date) {
    return SizedBox(
      height: 60,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(time,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87)),
          Text(date,
              style: const TextStyle(fontSize: 11, color: Colors.black45)),
        ],
      ),
    );
  }

  Widget _durationLabel(String duration) {
    return SizedBox(
      height: 90,
      child: Center(
        child: Text(duration,
            style: const TextStyle(fontSize: 11, color: Colors.black45)),
      ),
    );
  }

  Widget _waitLabel(String duration) {
    return SizedBox(
      height: 110,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFE3F0FF),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(duration,
              style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF2979FF),
                  fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }

  Widget _dot() {
    return Container(
      width: 10,
      height: 10,
      decoration: const BoxDecoration(
          color: Color(0xFF2979FF), shape: BoxShape.circle),
    );
  }

  Widget _line({required double height}) {
    return Container(width: 2, height: height, color: const Color(0xFF2979FF));
  }

  Widget _airportCard({
    required String name,
    required String code,
    String? sub1,
    String? sub2,
  }) {
    return SizedBox(
      height: 60,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 13, color: Colors.black87),
              children: [
                TextSpan(
                    text: name,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                TextSpan(text: ' $code'),
              ],
            ),
          ),
          if (sub1 != null)
            Text(sub1,
                style: const TextStyle(fontSize: 12, color: Colors.black54)),
          if (sub2 != null)
            Text(sub2,
                style: const TextStyle(fontSize: 12, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _flightCard({required String airline, required String cabin}) {
    return SizedBox(
      height: 90,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF1B2A4A),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.flight, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(airline,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87)),
              Text(cabin,
                  style:
                  const TextStyle(fontSize: 12, color: Colors.black54)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _waitCard(String message) {
    return Container(
      height: 110,
      alignment: Alignment.center,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFE3F0FF),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(message,
            style:
            const TextStyle(fontSize: 12, color: Color(0xFF1565C0))),
      ),
    );
  }
}