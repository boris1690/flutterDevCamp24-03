class Character {
  final int id;
  final String name;
  final String image;
  final String ki;
  final String maxKi;
  final String race;
  final String gender;
  final String description;
  final String affiliation;

  Character({
    required this.id,
    required this.name,
    required this.image,
    required this.ki,
    required this.maxKi,
    required this.race,
    required this.gender,
    required this.description,
    required this.affiliation,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      ki: json['ki'],
      maxKi: json['maxKi'],
      race: json['race'],
      gender: json['gender'],
      description: json['description'],
      affiliation: json['affiliation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'ki': ki,
      'maxKi': maxKi,
      'race': race,
      'gender': gender,
      'description': description,
      'affiliation': affiliation,
    };
  }
}
