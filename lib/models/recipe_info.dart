class RecipeInfo {
  final String name;
  final String description;
  final String? pictureName;
  final String steps;

  const RecipeInfo({
    required this.name,
    required this.description,
    required this.pictureName,
    required this.steps,
  });

  static RecipeInfo fromJson(Map<String, dynamic> json) {
    return RecipeInfo(
      name: json["name"] as String,
      description: json["description"] as String,
      pictureName: json["recipePictureName"],
      steps: json["steps"] as String,
    );
  }
}
