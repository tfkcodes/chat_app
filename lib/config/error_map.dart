class ErrorMap {
  int? status;
  String? message;
  String? body;
  Map<String, dynamic>? errorMap;

  ErrorMap({
    this.body,
    this.message,
    this.status,
    this.errorMap,
  });

  factory ErrorMap.empty() {
    return ErrorMap();
  }
}

String handleServerError(dynamic data) {
  if (data is Map) {
    // Try to extract meaningful error from server response
    final error = data['error'] ?? data['message'] ?? data['error-message'];
    if (error != null) return error.toString();

    // Laravel debug mode might expose errors
    if (data['exception'] != null || data['file'] != null) {
      return 'Server error occurred. Please try again later.';
    }
  }
  return 'Internal server error. Please try again.';
}
