import 'dart:convert';

class DbStruct {
  String uid;
  String name;
  String breed;
  int age;
  String gender;
  String size;
  String description;
  String photo;

  DbStruct({
    required this.uid,
    required this.name,
    required this.breed,
    required this.age,
    required this.gender,
    required this.size,
    required this.description,
    required this.photo,
  });

  DbStruct copyWith({
    String? uid,
    String? name,
    String? breed,
    int? age,
    String? gender,
    String? size,
    String? description,
    String? photo,
  }) {
    return DbStruct(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      breed: breed ?? this.breed,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      size: size ?? this.size,
      description: description ?? this.description,
      photo: photo ?? this.photo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'breed': breed,
      'age': age,
      'gender': gender,
      'size': size,
      'description': description,
      'photo': photo,
    };
  }

  factory DbStruct.fromMap(Map<String, dynamic> map) {
    return DbStruct(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      breed: map['breed'] ?? '',
      age: map['age']?.toInt() ?? 0,
      gender: map['gender'] ?? '',
      size: map['size'] ?? '',
      description: map['description'] ?? '',
      photo: map['photo'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DbStruct.fromJson(String source) =>
      DbStruct.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DbStruct(uid: $uid, name: $name, breed: $breed, age: $age, gender: $gender, size: $size, description: $description, photo: $photo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DbStruct &&
        other.uid == uid &&
        other.name == name &&
        other.breed == breed &&
        other.age == age &&
        other.gender == gender &&
        other.size == size &&
        other.description == description &&
        other.photo == photo;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        breed.hashCode ^
        age.hashCode ^
        gender.hashCode ^
        size.hashCode ^
        description.hashCode ^
        photo.hashCode;
  }
}
