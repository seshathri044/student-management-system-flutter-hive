// lib/student_management_page.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class StudentManagementPage extends StatefulWidget {
  final String className;
  
  const StudentManagementPage({super.key, required this.className});

  @override
  State<StudentManagementPage> createState() => _StudentManagementPageState();
}

class _StudentManagementPageState extends State<StudentManagementPage> {
  late Box studentsBox;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _rollNumberController = TextEditingController();
  String _selectedAttendance = 'Present';

  @override
  void initState() {
    super.initState();
    studentsBox = Hive.box("StudentsBox");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _rollNumberController.dispose();
    super.dispose();
  }

  void addOrUpdateStudent({String? key}) {
    if (key != null) {
      final student = studentsBox.get(key);
      if (student != null) {
        _nameController.text = student['name'] ?? "";
        _ageController.text = student['age'].toString();
        _rollNumberController.text = student['rollNumber'].toString();
        _selectedAttendance = student['attendance'] ?? 'Present';
      }
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
                  Text(
                    key == null ? 'Add Student' : 'Update Student',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
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
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final name = _nameController.text.trim();
                        final age = int.tryParse(_ageController.text.trim());
                        final rollNumber = int.tryParse(_rollNumberController.text.trim());

                        if (name.isEmpty || age == null || rollNumber == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please enter valid name, age, and roll number"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        // Check for duplicate roll numbers (excluding current student if updating)
                        bool rollExists = false;
                        for (int i = 0; i < studentsBox.length; i++) {
                          final existingKey = studentsBox.keyAt(i).toString();
                          final existingStudent = studentsBox.get(existingKey);
                          if (existingStudent != null &&
                              existingStudent['class'] == widget.className &&
                              existingStudent['rollNumber'] == rollNumber &&
                              existingKey != key) {
                            rollExists = true;
                            break;
                          }
                        }

                        if (rollExists) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Roll number already exists in this class"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        final studentData = {
                          "name": name,
                          "age": age,
                          "rollNumber": rollNumber,
                          "attendance": _selectedAttendance,
                          "class": widget.className,
                        };

                        if (key == null) {
                          final newKey = DateTime.now().microsecondsSinceEpoch.toString();
                          studentsBox.put(newKey, studentData);
                        } else {
                          studentsBox.put(key, studentData);
                        }

                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(key == null ? "Student added successfully" : "Student updated successfully"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        key == null ? "Add Student" : "Update Student",
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

  void deleteStudent(String key) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Student'),
        content: const Text('Are you sure you want to delete this student?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              studentsBox.delete(key);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Student deleted successfully"),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  List<MapEntry<dynamic, dynamic>> getClassStudents() {
    return studentsBox.toMap().entries.where((entry) {
      return entry.value['class'] == widget.className;
    }).toList()
      ..sort((a, b) => (a.value['rollNumber'] as int).compareTo(b.value['rollNumber'] as int));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Class ${widget.className} Students'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder(
          stream: Stream.periodic(const Duration(milliseconds: 100)),
          builder: (context, snapshot) {
            final classStudents = getClassStudents();
            
            if (classStudents.isEmpty) {
              return const Center(
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
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: classStudents.length,
              itemBuilder: (context, index) {
                final student = classStudents[index];
                final key = student.key.toString();
                final data = student.value;
                
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
                                data['rollNumber'].toString(),
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
                                    data['name'] ?? "Unknown",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Age: ${data['age'] ?? 'Unknown'}",
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
                                color: data['attendance'] == 'Present' ? Colors.green : Colors.red,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                data['attendance'] ?? 'Unknown',
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
                              onPressed: () => addOrUpdateStudent(key: key),
                              icon: const Icon(Icons.edit, size: 18),
                              label: const Text('Edit'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.blue,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => deleteStudent(key),
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
            );
          },
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
