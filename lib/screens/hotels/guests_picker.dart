import 'package:flutter/material.dart';

class RoomData {
  int adults;
  int children;

  RoomData({this.adults = 2, this.children = 0});
}

class GuestsPicker extends StatefulWidget {
  final List<RoomData> initialRooms;
  final Function(List<RoomData> rooms) onDone;

  GuestsPicker({
    required this.initialRooms,
    required this.onDone,
  });

  @override
  _GuestsPickerState createState() => _GuestsPickerState();
}

class _GuestsPickerState extends State<GuestsPicker> {
  late List<RoomData> rooms;

  @override
  void initState() {
    super.initState();
    rooms = List.from(widget.initialRooms);
  }

  void addRoom() {
    setState(() {
      rooms.add(RoomData(adults: 1, children: 0));
    });
  }

  void removeRoom(int index) {
    if (rooms.length > 1) {
      setState(() {
        rooms.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Guests',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),

          Text(
            'The maximum number of guests allowed per room is 8.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),

          SizedBox(height: 20),

          // Scrollable list of rooms
          Expanded(
            child: ListView.builder(
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                return _buildRoomCard(index);
              },
            ),
          ),

          SizedBox(height: 10),

          // Add another room button
          OutlinedButton.icon(
            onPressed: addRoom,
            icon: Icon(Icons.add_circle_outline),
            label: Text('Add another room'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.blue,
              side: BorderSide(color: Colors.blue),
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),

          SizedBox(height: 10),

          // Done button
          ElevatedButton(
            onPressed: () {
              widget.onDone(rooms);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Text(
              'Done',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomCard(int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Room header with removal option
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.bed, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(
                    'Room ${index + 1}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (rooms.length > 1)
                TextButton(
                  onPressed: () => removeRoom(index),
                  child: Text(
                    'Remove',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),

          SizedBox(height: 15),

          // Adults counter
          _buildCounter(
            'Adults',
            'Age (12+)',
            rooms[index].adults,
            () {
              if (rooms[index].adults > 1) {
                setState(() => rooms[index].adults--);
              }
            },
            () {
              int total = rooms[index].adults + rooms[index].children;
              if (total < 8) {
                setState(() => rooms[index].adults++);
              }
            },
          ),

          SizedBox(height: 15),

          // Children counter
          _buildCounter(
            'Children',
            'Age (0-11)',
            rooms[index].children,
            () {
              if (rooms[index].children > 0) {
                setState(() => rooms[index].children--);
              }
            },
            () {
              int total = rooms[index].adults + rooms[index].children;
              if (total < 8) {
                setState(() => rooms[index].children++);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCounter(
    String label,
    String subtitle,
    int value,
    VoidCallback onDecrease,
    VoidCallback onIncrease,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.remove_circle_outline),
              color: Colors.blue,
              iconSize: 32,
              onPressed: onDecrease,
            ),
            SizedBox(
              width: 40,
              child: Text(
                '$value',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.add_circle_outline),
              color: Colors.blue,
              iconSize: 32,
              onPressed: onIncrease,
            ),
          ],
        ),
      ],
    );
  }
}