part of 'google_drive_service.dart';

class _GoogleAuthClient extends http.BaseClient {
  final http.Client client = http.Client();
  final Map<String, String> headers;

  _GoogleAuthClient(this.headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return client.send(request..headers.addAll(headers));
  }
}
