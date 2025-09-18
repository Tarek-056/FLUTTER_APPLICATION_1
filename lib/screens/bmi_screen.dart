import 'package:flutter/material.dart';
import '../models/bmi_record.dart';
import 'edit_bmi_screen.dart';

class BMIScreen extends StatefulWidget {
  @override
  _BMIScreenState createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();

  List<BMIRecord> bmiHistory = [];
  int _idCounter = 0;

  void _calculateAndSaveBMI() {
    int? age = int.tryParse(ageController.text);
    double? weight = double.tryParse(weightController.text);
    double? height = double.tryParse(heightController.text);

    if (age == null || age <= 0) {
      _showError('Please enter a valid age');
      return;
    }
    if (weight == null || weight <= 0) {
      _showError('Please enter a valid weight');
      return;
    }
    if (height == null || height <= 0) {
      _showError('Please enter a valid height');
      return;
    }

    double bmi = weight / (height * height);
    String category = _getBMICategory(bmi);

    setState(() {
      bmiHistory.add(
        BMIRecord(
          id: _idCounter++,
          age: age,
          weight: weight,
          height: height,
          bmi: bmi,
          category: category,
        ),
      );
    });

    ageController.clear();
    weightController.clear();
    heightController.clear();
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  String _getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 24.9) return 'Normal weight';
    if (bmi < 29.9) return 'Overweight';
    return 'Obese';
  }

  void _deleteRecord(int id) {
    setState(() {
      bmiHistory.removeWhere((record) => record.id == id);
    });
  }

  void _editRecord(BMIRecord record) async {
    final updatedRecord = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditBMIScreen(record: record)),
    );

    if (updatedRecord != null && updatedRecord is BMIRecord) {
      setState(() {
        final index = bmiHistory.indexWhere((r) => r.id == updatedRecord.id);
        if (index != -1) {
          bmiHistory[index] = updatedRecord;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String email =
        ModalRoute.of(context)?.settings.arguments as String? ?? "User";

    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Welcome, $email'),
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Age (years)'),
            ),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Weight (kg)'),
            ),
            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Height (m)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateAndSaveBMI,
              child: Text('Save BMI'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: bmiHistory.isEmpty
                  ? Text('No BMI records yet.')
                  : ListView.builder(
                      itemCount: bmiHistory.length,
                      itemBuilder: (context, index) {
                        final record = bmiHistory[index];
                        return ListTile(
                          title: Text(
                            'Age: ${record.age}, BMI: ${record.bmi.toStringAsFixed(2)} (${record.category})',
                          ),
                          subtitle: Text(
                            'Weight: ${record.weight} kg, Height: ${record.height} m',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.orange),
                                onPressed: () => _editRecord(record),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteRecord(record.id),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
