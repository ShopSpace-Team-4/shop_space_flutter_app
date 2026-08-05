/// Standard API envelope `{ message, status, data }`.
///
/// Parsed ONLY in `core/network/` (contract `contracts/network-pipeline.md`);
/// feature code never sees the envelope — repositories receive the unwrapped
/// `data` only.
class ApiEnvelope<T> {
  const ApiEnvelope({
    required this.message,
    required this.status,
    required this.data,
  });

  factory ApiEnvelope.fromJson(Map<String, dynamic> json) {
    return ApiEnvelope<T>(
      message: json['message'] as String? ?? '',
      status: json['status'] as String? ?? '',
      data: json['data'] as T,
    );
  }

  final String message;
  final String status;
  final T data;
}
