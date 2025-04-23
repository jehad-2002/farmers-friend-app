class PlantDisease {
  final String name;
  final int? index; // Optional: If you want to store the index
  final String? description; // Optional: For more information

  PlantDisease({required this.name, this.index, this.description});

  @override
  String toString() {
    return 'PlantDisease{name: $name, index: $index, description: $description}';
  }
}
