// lib/presentation/pages/student_management_page.dart
import 'package:flutter/material.dart';
import 'dart:async';
import '../../core/di/injection_container.dart';
import '../../core/entities/student_entity.dart';
import '../../core/error/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/usecases/add_student_usecase.dart';
import '../../domain/usecases/delete_student_usecase.dart';
import '../../domain/usecases/get_students_by_class_usecase.dart';
import '../../domain/usecases/update_student_usecase.dart';

class StudentManagementPage extends StatefulWidget {
  final String className;
  
  const StudentManagementPage({super.key, required this.className});

  @override
  State<StudentManagementPage> createState() => _StudentManagementPageState();
}

class _StudentManagementPageState extends State<StudentManagementPage> {
  // Use cases
  late final GetStudentsByClassUseCase _getStudentsByClassUseCase;
  late final AddStudentUseCase _addStudentUseCase;
  late final UpdateStudentUseCase _updateStudentUseCase;
  late final DeleteStudentUseCase _deleteStudentUseCase;

  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _rollNumberController = TextEditingController();
  String _selectedAttendance = 'Present';

  // State
  List<StudentEntity> _students = [];
  bool _isLoading = false;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _initializeUseCases();
    _loadStudents();
    // Set up automatic refresh every 500ms to keep UI in sync
    _refreshTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) {
        _loadStudentsQuietly();
      }
    });
  }

  void _initializeUseCases() {
    final di = InjectionContainer.instance;
    _getStudentsByClassUseCase = di.get<GetStudentsByClassUseCase>();
    _addStudentUseCase = di.get<AddStudentUseCase>();
    _updateStudentUseCase = di.get<UpdateStudentUseCase>();
    _deleteStudentUseCase = di.get<DeleteStudentUseCase>();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _nameController.dispose();
    _ageController.dispose();
    _rollNumberController.dispose();
    super.dispose();
  }

  Future<void> _loadStudents() async {
    setState(() => _isLoading = true);
    await _loadStudentsQuietly();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadStudentsQuietly() async {
    final result = await _getStudentsByClassUseCase(widget.className);
    
    if (mounted) {
      if (result is Success<List<StudentEntity>>) {
        final newStudents = result.data;
        // Only update if there's actually a change to avoid unnecessary rebuilds
        if (_studentsChanged(newStudents)) {
          setState(() {
            _students = newStudents;
          });
        }
      } else if (result is Error<List<StudentEntity>>) {
        // Only show error if it's the first load
        if (_students.isEmpty) {
          _showErrorSnackBar(result.failure.message);
        }
      }
    }
  }

  bool _studentsChanged(List<StudentEntity> newStudents) {
    if (_students.length != newStudents.length) return true;
    
    for (int i = 0; i < _students.length; i++) {
      if (_students[i] != newStudents[i]) return true;
    }
    
    return false;
  }

  void _showSuccessSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void addOrUpdateStudent({StudentEntity? existingStudent}) {
    // Clear or populate form based on whether we're editing
    if (existingStudent != null) {
      _nameController.text = existingStudent.name;
      _ageController.text = existingStudent.age.toString();
      _rollNumberController.text = existingStudent.rollNumber.toString();
      _selectedAttendance = existingStudent.attendance;
    } else {
      _nameController.clear();
      _ageController.clear();
      _rollNumberController.clear();
      _selectedAttendance = 'Present';
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Modal handle
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Title
                  Text(
                    existingStudent == null ? 'Add Student' : 'Update Student',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Name field
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Student Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 15),
                  
                  // Age field
                  TextField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Age",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.cake),
                    ),
                  ),
                  const SizedBox(height: 15),
                  
                  // Roll number field
                  TextField(
                    controller: _rollNumberController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Roll Number",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.numbers),
                    ),
                  ),
                  const SizedBox(height: 15),
                  
                  // Attendance selection
                  const Text(
                    'Attendance Status:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Present'),
                          value: 'Present',
                          groupValue: _selectedAttendance,
                          onChanged: (value) {
                            setModalState(() {
                              _selectedAttendance = value!;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Absent'),
                          value: 'Absent',
                          groupValue: _selectedAttendance,
                          onChanged: (value) {
                            setModalState(() {
                              _selectedAttendance = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _handleAddOrUpdateStudent(existingStudent),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        existingStudent == null ? "Add Student" : "Update Student",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _handleAddOrUpdateStudent(StudentEntity? existingStudent) async {
    final name = _nameController.text.trim();
    final age = int.tryParse(_ageController.text.trim());
    final rollNumber = int.tryParse(_rollNumberController.text.trim());

    if (name.isEmpty || age == null || rollNumber == null) {
      _showErrorSnackBar("Please enter valid name, age, and roll number");
      return;
    }

    Navigator.pop(context); // Close modal immediately for better UX

    Result result;
    
    if (existingStudent == null) {
      // Add new student
      final params = AddStudentParams(
        name: name,
        age: age,
        rollNumber: rollNumber,
        attendance: _selectedAttendance,
        className: widget.className,
      );
      result = await _addStudentUseCase(params);
    } else {
      // Update existing student
      final params = UpdateStudentParams(
        id: existingStudent.id,
        name: name,
        age: age,
        rollNumber: rollNumber,
        attendance: _selectedAttendance,
        className: widget.className,
      );
      result = await _updateStudentUseCase(params);
    }

    if (mounted) {
      if (result is Success) {
        _showSuccessSnackBar(
          existingStudent == null 
            ? "Student added successfully" 
            : "Student updated successfully"
        );
        // Force immediate refresh
        await _loadStudentsQuietly();
      } else if (result is Error) {
        _showErrorSnackBar(result.failure.message);
      }
    }
  }

  void deleteStudent(StudentEntity student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Student'),
        content: Text('Are you sure you want to delete ${student.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => _handleDeleteStudent(student),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _handleDeleteStudent(StudentEntity student) async {
    Navigator.pop(context); // Close dialog immediately
    
    final result = await _deleteStudentUseCase(student.id);
    
    if (mounted) {
      if (result is Success) {
        _showSuccessSnackBar("Student deleted successfully");
        // Force immediate refresh
        await _loadStudentsQuietly();
      } else if (result is Error) {
        _showErrorSnackBar(result.failure.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Class ${widget.className} Students'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadStudents,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _isLoading && _students.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : _students.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.school_outlined, size: 100, color: Colors.grey),
                        SizedBox(height: 20),
                        Text(
                          "No students added yet",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Tap + to add your first student",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadStudents,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _students.length,
                      itemBuilder: (context, index) {
                        final student = _students[index];
                        
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.blue.shade600,
                                      child: Text(
                                        student.rollNumber.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            student.name,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "Age: ${student.age}",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: student.attendance == 'Present' ? Colors.green : Colors.red,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        student.attendance,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () => addOrUpdateStudent(existingStudent: student),
                                      icon: const Icon(Icons.edit, size: 18),
                                      label: const Text('Edit'),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.blue,
                                      ),
                                    ),
                                    TextButton.icon(
                                      onPressed: () => deleteStudent(student),
                                      icon: const Icon(Icons.delete, size: 18),
                                      label: const Text('Delete'),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        onPressed: () => addOrUpdateStudent(),
        icon: const Icon(Icons.add),
        label: const Text('Add Student'),
      ),
    );
  }
}