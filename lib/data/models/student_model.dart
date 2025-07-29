// lib/data/models/student_model.dart
import '../../core/entities/student_entity.dart';

class StudentModel extends StudentEntity {
  const StudentModel({
    required super.id,
    required super.name,
    required super.age,
    required super.rollNumber,
    required super.attendance,
    required super.className,
  });

  // Convert from Map (Hive storage format) to StudentModel
  factory StudentModel.fromMap(String id, Map<dynamic, dynamic> map) {
    return StudentModel(
      id: id,
      name: map['name'] ?? '',
      age: map['age'] ?? 0,
      rollNumber: map['rollNumber'] ?? 0,
      attendance: map['attendance'] ?? 'Present',
      className: map['class'] ?? '',
    );
  }

  // Convert StudentModel to Map (for Hive storage)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'rollNumber': rollNumber,
      'attendance': attendance,
      'class': className,
    };
  }

  // Convert StudentEntity to StudentModel
  factory StudentModel.fromEntity(StudentEntity entity) {
    return StudentModel(
      id: entity.id,
      name: entity.name,
      age: entity.age,
      rollNumber: entity.rollNumber,
      attendance: entity.attendance,
      className: entity.className,
    );
  }

  // Convert StudentModel to StudentEntity
  StudentEntity toEntity() {
    return StudentEntity(
      id: id,
      name: name,
      age: age,
      rollNumber: rollNumber,
      attendance: attendance,
      className: className,
    );
  }

  // ✅ Fix: CopyWith returning StudentModel instead of StudentEntity
  StudentModel copyWith({
    String? id,
    String? name,
    int? age,
    int? rollNumber,
    String? attendance,
    String? className,
  }) {
    return StudentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      rollNumber: rollNumber ?? this.rollNumber,
      attendance: attendance ?? this.attendance,
      className: className ?? this.className,
    );
  }
}
