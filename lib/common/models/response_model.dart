class ResponseModel {
  final bool _isSuccess;
  final String? _message;
  final Map<String, dynamic>? _errors;

  ResponseModel(this._isSuccess, this._message, {Map<String, dynamic>? errors})
      : _errors = errors;

  String? get message => _message;
  bool get isSuccess => _isSuccess;
  Map<String, dynamic>? get errors => _errors;

  // Helper method to get the first error message
  String? get firstErrorMessage {
    if (_errors != null && _errors.isNotEmpty) {
      return _errors.values.first;
    }
    return null;
  }

  // Helper method to get all error messages as a single string
  String? get allErrorMessages {
    if (_errors != null && _errors.isNotEmpty) {
      return _errors.entries.map((entry) => entry.value).join('\n');
    }
    return null;
  }
}