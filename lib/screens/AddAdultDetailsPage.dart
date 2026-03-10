import 'package:flutter/material.dart';

const Color teal = Color(0xFF00897B);

class AddAdultDetailsPage extends StatefulWidget {
  const AddAdultDetailsPage({super.key});

  @override
  State<AddAdultDetailsPage> createState() => _AddAdultDetailsPageState();
}

class _AddAdultDetailsPageState extends State<AddAdultDetailsPage> {
  String selectedTitle = '';
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: teal),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add Adult 1 details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Selection
            Row(
              children: ['Mr', 'Ms', 'Mrs'].map((title) {
                final isSelected = selectedTitle == title;
                return Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => selectedTitle = title),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? teal.withOpacity(0.1) : Colors.white,
                        border: Border.all(
                          color: isSelected ? teal : Colors.grey.shade300,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        title,
                        style: TextStyle(
                          color: isSelected ? teal : Colors.black54,
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
            _buildTextField('First name *', firstNameController),
            SizedBox(height: 12),

            // Middle Name
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField('Middle name', middleNameController),
                Padding(
                  padding: EdgeInsets.only(left: 4, top: 4),
                  child: Text('Optional', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ),
              ],
            ),
            SizedBox(height: 12),

            // Last Name
            _buildTextField('Last name *', lastNameController),
            SizedBox(height: 12),

            // Date of Birth
            _buildDropdownField('Date of birth *'),
            SizedBox(height: 12),

            // Nationality
            _buildDropdownField('Nationality *'),
            SizedBox(height: 24),

            // Travel Document Section
            Text(
              'Travel document',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 16),

            // Document Type
            _buildDropdownFieldWithLabel('Document type *', 'Passport'),
            SizedBox(height: 12),

            // Passport Number
            _buildTextField('Passport number *', TextEditingController()),
            SizedBox(height: 12),

            // Issuing Country
            _buildDropdownField('Issuing country *'),
            SizedBox(height: 12),

            // Expiry Date
            _buildDropdownField('Expiry date *'),
            SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: teal,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 0,
            ),
            child: Text(
              'Set as Adult 1',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: teal),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildDropdownField(String hint) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(hint, style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
          Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildDropdownFieldWithLabel(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value, style: TextStyle(color: Colors.black87, fontSize: 14)),
              Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }
}