// lib/core/entities/student_entity.dart
class StudentEntity {
  final String id;
  final String name;
  final int age;
  final int rollNumber;
  final String attendance;
  final String className;

  const StudentEntity({
    required this.id,
    required this.name,
    required this.age,
    required this.rollNumber,
    required this.attendance,
    required this.className,
  });

  StudentEntity copyWith({
    String? id,
    String? name,
    int? age,
    int? rollNumber,
    String? attendance,
    String? className,
  }) {
    return StudentEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      rollNumber: rollNumber ?? this.rollNumber,
      attendance: attendance ?? this.attendance,
      className: className ?? this.className,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StudentEntity &&
        other.id == id &&
        other.name == name &&
        other.age == age &&
        other.rollNumber == rollNumber &&
        other.attendance == attendance &&
        other.className == className;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        age.hashCode ^
        rollNumber.hashCode ^
        attendance.hashCode ^
        className.hashCode;
  }
}