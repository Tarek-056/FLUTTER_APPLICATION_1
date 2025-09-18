class BMIRecord {
  final int id;
  final int age; // <-- new
  final double weight;
  final double height;
  final double bmi;
  final String category;

  BMIRecord({
    required this.id,
    required this.age, // <-- new
    required this.weight,
    required this.height,
    required this.bmi,
    required this.category,
  });
}
