// lib/services/my_path_service.dart

// 1. ALL DIRECTIVES (like 'export' and 'import') MUST COME FIRST.
export 'my_path_service_io.dart' if (dart.library.html) 'my_path_service_web.dart';

// 2. THEN, you can have your declarations (classes, functions, variables).
abstract class MyPathService {
  Future<String> getDbDirectory();
}