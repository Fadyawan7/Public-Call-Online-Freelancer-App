String getErrorMessage(Map<dynamic, dynamic> map) {
  // Extract errors from the map and cast it to Map<String, dynamic>?
  final errors = map["errors"] as Map<String, dynamic>?;

  // Extract the first error message
  String? errorMessage;
  if (errors != null && errors.isNotEmpty) {
    errorMessage = errors.values.first; // Get the first error message
  } else {
    errorMessage = map["message"] ?? 'An error occurred'; // Fallback to a generic message
  }

  return errorMessage!;
}