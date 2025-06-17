// lib/services/my_path_service_io.dart

import 'package:path_provider/path_provider.dart';
import 'dart:io'; // For Directory
import 'my_path_service.dart'; // Import the interface from the main file

class MyPathServiceImpl implements MyPathService {
  @override
  Future<String> getDbDirectory() async {
    final directory = await getApplicationSupportDirectory();
    return directory.path;
  }
}

// This function provides the concrete implementation for non-web platforms.
MyPathService getMyPathService() => MyPathServiceImpl();