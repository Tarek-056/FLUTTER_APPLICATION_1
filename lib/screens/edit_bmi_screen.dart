import 'package:flutter/material.dart';
import '../models/bmi_record.dart';

class EditBMIScreen extends StatefulWidget {
  final BMIRecord record;

  EditBMIScreen({required this.record});

  @override
  _EditBMIScreenState createState() => _EditBMIScreenState();
}

class _EditBMIScreenState extends State<EditBMIScreen> {
  late TextEditingController ageController;
  late TextEditingController weightController;
  late TextEditingController heightController;

  @override
  void initState() {
    super.initState();
    ageController = TextEditingController(text: widget.record.age.toString());
    weightController = TextEditingController(
      text: widget.record.weight.toString(),
    );
    heightController = TextEditingController(
      text: widget.record.height.toString(),
    );
  }

  void _saveUpdatedRecord() {
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
    String category;

    if (bmi < 18.5)
      category = 'Underweight';
    else if (bmi < 24.9)
      category = 'Normal weight';
    else if (bmi < 29.9)
      category = 'Overweight';
    else
      category = 'Obese';

    BMIRecord updated = BMIRecord(
      id: widget.record.id,
      age: age,
      weight: weight,
      height: height,
      bmi: bmi,
      category: category,
    );

    Navigator.pop(context, updated);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit BMI Record')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
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
            ElevatedButton(onPressed: _saveUpdatedRecord, child: Text('Save')),
          ],
        ),
      ),
    );
  }
}
