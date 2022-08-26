import 'package:http/http.dart' as http;

class GoogleAuthClient extends http.BaseClient {
  final http.Client _client = http.Client();
  final Map<String, String> _headers;
  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}
