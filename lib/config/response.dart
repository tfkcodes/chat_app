class Response {
  int status;
  Map<String, dynamic> data;
  String? body;
  String? message;

  Response({required this.status, required this.data, this.body, this.message});
}
