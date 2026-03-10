import 'package:flutter/material.dart';
import 'package:travel/AddAdultDetailsPage.dart';

class TravellerDetailsPage extends StatefulWidget {
  @override
  _TravellerDetailsPageState createState() => _TravellerDetailsPageState();
}

class _TravellerDetailsPageState extends State<TravellerDetailsPage> {
  String? title;
  String countryCode = "+20";
  bool saveToProfile = false;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  static const Color teal = Color(0xFF00BFA5);
  static const Color red = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Traveller details",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total to be paid row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total to be paid",
                      style: TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "USD 425.50",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "View booking summary",
                    style: TextStyle(
                      fontSize: 13,
                      color: teal,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Traveller Details Section
            Text(
              "Traveller details",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),

            // Adult 1 card
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person_outline, color: Colors.black87, size: 22),
                      SizedBox(width: 10),
                      Text("Adult 1", style: TextStyle(fontSize: 15)),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddAdultDetailsPage(),
                        ),
                      );
                    },
                    icon: Icon(Icons.add, size: 18),
                    label: Text("Add", style: TextStyle(fontSize: 14)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: teal,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Contact Details Section
            Text(
              "Contact details",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 14),

            // Title chip selection (pill/outline style)
            Row(
              children: ["Mr", "Ms", "Mrs"].map((t) {
                final isSelected = title == t;
                return Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () => setState(() => title = t),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 22, vertical: 9),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: isSelected ? teal : Colors.grey.shade400,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        t,
                        style: TextStyle(
                          fontSize: 14,
                          color: isSelected ? teal : Colors.black87,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 16),

            // First Name
            _buildTextField(firstNameController, "First name *"),
            SizedBox(height: 12),

            // Last Name
            _buildTextField(lastNameController, "Last name *"),
            SizedBox(height: 12),

            // Email
            _buildTextField(
              emailController,
              "Email *",
              keyboardType: TextInputType.emailAddress,
              helperText: "Your purchased tickets will be sent to this email",
            ),
            SizedBox(height: 12),

            // Mobile Number with country code
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 56,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: countryCode,
                      items: ["+20", "+1", "+44"].map((code) =>
                          DropdownMenuItem(value: code, child: Text(code)),
                      ).toList(),
                      onChanged: (value) => setState(() => countryCode = value!),
                      icon: Icon(Icons.keyboard_arrow_down, size: 20),
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _buildTextField(
                    mobileController,
                    "Mobile number *",
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Save details checkbox
            Row(
              children: [
                Checkbox(
                  value: saveToProfile,
                  onChanged: (val) => setState(() => saveToProfile = val!),
                  activeColor: teal,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                ),
                Text(
                  "Save details to my profile",
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Continue Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  "Continue",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: red,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label, {
        TextInputType keyboardType = TextInputType.text,
        String? helperText,
      }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        helperText: helperText,
        helperStyle: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: teal, width: 1.5),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    );
  }
}