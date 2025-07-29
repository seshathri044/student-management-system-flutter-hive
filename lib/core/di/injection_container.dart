// lib/core/di/injection_container.dart
import 'package:hive/hive.dart';
import '../../data/datasources/student_local_datasource.dart';
import '../../data/repositories/student_repository_impl.dart';
import '../../domain/repositories/student_repository.dart';
import '../../domain/usecases/add_student_usecase.dart';
import '../../domain/usecases/check_roll_number_exists_usecase.dart';
import '../../domain/usecases/delete_student_usecase.dart';
import '../../domain/usecases/get_students_by_class_usecase.dart';
import '../../domain/usecases/update_student_usecase.dart';

class InjectionContainer {
  static late InjectionContainer _instance;
  static InjectionContainer get instance => _instance;

  late final Box _studentsBox;
  
  // Data sources
  late final StudentLocalDataSource _studentLocalDataSource;
  
  // Repositories
  late final StudentRepository _studentRepository;
  
  // Use cases
  late final GetStudentsByClassUseCase _getStudentsByClassUseCase;
  late final AddStudentUseCase _addStudentUseCase;
  late final UpdateStudentUseCase _updateStudentUseCase;
  late final DeleteStudentUseCase _deleteStudentUseCase;
  late final CheckRollNumberExistsUseCase _checkRollNumberExistsUseCase;

  static Future<void> init() async {
    _instance = InjectionContainer._internal();
    await _instance._setup();
  }

  InjectionContainer._internal();

  Future<void> _setup() async {
    // Initialize Hive box
    _studentsBox = Hive.box("StudentsBox");

    // Data sources
    _studentLocalDataSource = StudentLocalDataSourceImpl(
      studentsBox: _studentsBox,
    );

    // Repositories
    _studentRepository = StudentRepositoryImpl(
      localDataSource: _studentLocalDataSource,
    );

    // Use cases
    _getStudentsByClassUseCase = GetStudentsByClassUseCase(
      repository: _studentRepository,
    );
    
    _addStudentUseCase = AddStudentUseCase(
      repository: _studentRepository,
    );
    
    _updateStudentUseCase = UpdateStudentUseCase(
      repository: _studentRepository,
    );
    
    _deleteStudentUseCase = DeleteStudentUseCase(
      repository: _studentRepository,
    );
    
    _checkRollNumberExistsUseCase = CheckRollNumberExistsUseCase(
      repository: _studentRepository,
    );
  }

  // Getters for dependencies
  GetStudentsByClassUseCase get getStudentsByClassUseCase => _getStudentsByClassUseCase;
  AddStudentUseCase get addStudentUseCase => _addStudentUseCase;
  UpdateStudentUseCase get updateStudentUseCase => _updateStudentUseCase;
  DeleteStudentUseCase get deleteStudentUseCase => _deleteStudentUseCase;
  CheckRollNumberExistsUseCase get checkRollNumberExistsUseCase => _checkRollNumberExistsUseCase;
}

// Extension for easy access
extension InjectionContainerExtension on InjectionContainer {
  T get<T>() {
    switch (T) {
      case GetStudentsByClassUseCase:
        return getStudentsByClassUseCase as T;
      case AddStudentUseCase:
        return addStudentUseCase as T;
      case UpdateStudentUseCase:
        return updateStudentUseCase as T;
      case DeleteStudentUseCase:
        return deleteStudentUseCase as T;
      case CheckRollNumberExistsUseCase:
        return checkRollNumberExistsUseCase as T;
      default:
        throw Exception('Dependency $T not found');
    }
  }
}