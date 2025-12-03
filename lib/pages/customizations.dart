import 'package:flutter/material.dart';

class CustomizationPage extends StatefulWidget {
  const CustomizationPage({super.key});

  @override
  State<CustomizationPage> createState() => _CustomizationPageState();
}

class _CustomizationPageState extends State<CustomizationPage> {
  // State variables for customization options
  String _budgetAmount = ''; 
  String _selectedBudgetFrequency = 'Weekly'; 
  String _selectedReminderFrequency = 'Daily';
  TimeOfDay _selectedTime = const TimeOfDay(hour: 20, minute: 0); // Default to 8:00 PM

  // Lists for dropdown options
  final List<String> _budgetFrequencies = ['Weekly', 'Monthly'];
  final List<String> _reminderFrequencies = ['Daily', 'Weekly', 'Monthly'];

  // Text controller for the budget input field
  final TextEditingController _budgetController = TextEditingController();

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  // Function to show the time picker dialog
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // Function called when the Done button is pressed
  void _saveCustomizations() {
    _budgetAmount = _budgetController.text;

    // Output settings (Replace with actual save logic later)
    print('--- Customizations Saved ---');
    print('Budget Amount: \$$_budgetAmount');
    print('Budget Cycle: $_selectedBudgetFrequency');
    print('Reminder Frequency: $_selectedReminderFrequency');
    print('Reminder Time: ${_selectedTime.format(context)}');
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Customizations saved successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. Center the content to simulate mobile view on web
      body: Center( 
        child: SingleChildScrollView(
          child: Container(
            // 2. Constrain width and add card styling
            width: 380, 
            padding: const EdgeInsets.all(24.0),
            margin: const EdgeInsets.symmetric(vertical: 24.0),
            decoration: BoxDecoration(
              color: const Color(0xFFB0BCC9), // The grey/blue card color
              borderRadius: BorderRadius.circular(20), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 10),
                
                // --- HEADER SECTION ---
                const Center(
                  child: Text(
                    "Customization",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3E50),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(color: Colors.black12, thickness: 1), 
                const SizedBox(height: 20),

                // --- 1. Set Your Budget ---
                _buildSectionTitle('Set your budget'),
                _buildBudgetInputField(),
                const SizedBox(height: 16),

                // --- 2. Choose Your Budget Cycle ---
                _buildSectionTitle('Choose your budget cycle'),
                _buildDropdownSelector(
                  value: _selectedBudgetFrequency,
                  items: _budgetFrequencies,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedBudgetFrequency = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // --- 3. Set Your Reminder Frequency ---
                _buildSectionTitle('Set your reminder frequency'),
                _buildReminderRow(context),
                const SizedBox(height: 32),

                // --- 4. Done Button ---
                ElevatedButton(
                  onPressed: _saveCustomizations,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: const Color(0xFF1E2B3C), // Dark Navy button
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                // Skip button removed from here
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  // Helper widget for section titles
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13, 
          fontWeight: FontWeight.bold,
          color: Color(0xFF2D3E50)
        ),
      ),
    );
  }

  // Helper widget for the budget input field (White Box Style)
  Widget _buildBudgetInputField() {
    return TextField(
      controller: _budgetController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Enter your budget here',
        filled: true,
        fillColor: Colors.white, // White background
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none, // Remove the border line
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  // Helper widget for a generic dropdown selector (White Box Style)
  Widget _buildDropdownSelector({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white, // White background
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
          items: items.map<DropdownMenuItem<String>>((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: const TextStyle(fontSize: 14)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // Helper widget for the reminder frequency and time row
  Widget _buildReminderRow(BuildContext context) {
    return Row(
      children: [
        // Frequency Dropdown
        Expanded(
          flex: 3,
          child: _buildDropdownSelector(
            value: _selectedReminderFrequency,
            items: _reminderFrequencies,
            onChanged: (newValue) {
              setState(() {
                _selectedReminderFrequency = newValue!;
              });
            },
          ),
        ),
        const SizedBox(width: 10),
        
        // Time Button (White Box Style)
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTap: () => _selectTime(context),
            child: Container(
              height: 48, // Match height of dropdowns roughly
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedTime.format(context),
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  const Icon(Icons.access_time, size: 18, color: Colors.black54),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}