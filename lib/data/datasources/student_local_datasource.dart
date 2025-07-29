// lib/data/datasources/student_local_datasource.dart
import 'package:hive/hive.dart';
import '../models/student_model.dart';

abstract class StudentLocalDataSource {
  Future<List<StudentModel>> getStudentsByClass(String className);
  Future<StudentModel> addStudent(StudentModel student);
  Future<StudentModel> updateStudent(StudentModel student);
  Future<void> deleteStudent(String studentId);
  Future<bool> isRollNumberExists(String className, int rollNumber, {String? excludeStudentId});
}

class StudentLocalDataSourceImpl implements StudentLocalDataSource {
  final Box studentsBox;

  StudentLocalDataSourceImpl({required this.studentsBox});

  @override
  Future<List<StudentModel>> getStudentsByClass(String className) async {
    try {
      final students = <StudentModel>[];
      
      for (int i = 0; i < studentsBox.length; i++) {
        final key = studentsBox.keyAt(i).toString();
        final value = studentsBox.get(key);
        
        if (value != null && value['class'] == className) {
          students.add(StudentModel.fromMap(key, value));
        }
      }
      
      // Sort by roll number
      students.sort((a, b) => a.rollNumber.compareTo(b.rollNumber));
      return students;
    } catch (e) {
      throw Exception('Failed to get students: $e');
    }
  }

  @override
  Future<StudentModel> addStudent(StudentModel student) async {
    try {
      final key = student.id.isEmpty ? 
          DateTime.now().microsecondsSinceEpoch.toString() : 
          student.id;
      
      await studentsBox.put(key, student.toMap());
      
      return student.copyWith(id: key) as StudentModel;
    } catch (e) {
      throw Exception('Failed to add student: $e');
    }
  }

  @override
  Future<StudentModel> updateStudent(StudentModel student) async {
    try {
      await studentsBox.put(student.id, student.toMap());
      return student;
    } catch (e) {
      throw Exception('Failed to update student: $e');
    }
  }

  @override
  Future<void> deleteStudent(String studentId) async {
    try {
      await studentsBox.delete(studentId);
    } catch (e) {
      throw Exception('Failed to delete student: $e');
    }
  }

  @override
  Future<bool> isRollNumberExists(String className, int rollNumber, {String? excludeStudentId}) async {
    try {
      for (int i = 0; i < studentsBox.length; i++) {
        final key = studentsBox.keyAt(i).toString();
        final value = studentsBox.get(key);
        
        if (value != null && 
            value['class'] == className && 
            value['rollNumber'] == rollNumber &&
            key != excludeStudentId) {
          return true;
        }
      }
      return false;
    } catch (e) {
      throw Exception('Failed to check roll number: $e');
    }
  }
}