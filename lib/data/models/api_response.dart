// ignore_for_file: avoid_annotating_with_dynamic

class ApiResponse<T> {
  const ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.errors,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? dataParser,
  ) {
    return ApiResponse(
      success: json["success"] as bool? ?? false,
      data: dataParser != null && json["data"] != null
          ? dataParser(json["data"])
          : json["data"] as T?,
      message: json["message"] as String?,
      errors: (json["errors"] as Map<String, dynamic>?)?.map(
        (k, v) => MapEntry(k, (v as List).cast<String>()),
      ),
    );
  }

  final bool success;
  final T? data;
  final String? message;
  final Map<String, List<String>>? errors;

  String? get firstError {
    if (errors == null || errors!.isEmpty) return message;
    return errors!.values.first.firstOrNull ?? message;
  }
}
