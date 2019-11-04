import 'dart:convert';
import 'package:http/http.dart';


/// Collection of convenience methods for REST handling.
/// Based on http-package for platform independence.
class RestToolsHttp {

  final Client _client;

  /// defaults to dart's Client, can be replaced with other implementations or mocks
  RestToolsHttp({
      Client client
      }) : _client = client != null ? client : Client();


  /// returns utf-8 encoded json
  Future<String> getJsonBodyString(
      String authority,
      String path,
      {
        Map<String, String> headerParameters = const {},
        Map<String, String> queryParameters = const {},
      }) async {
    Uri uri = Uri.https(authority, path, queryParameters);
    Map<String, String> headers = {
      "content-type": 'application/json; charset=utf-8'
    };
    // add header params from method-caller
    headerParameters?.forEach((key, value) {
      headers[key] = value;
    });

    Response response = await _client.get(uri, headers: headers);
    String bodyStr = response.body;

    String msg;
    switch (response.statusCode) {
      case 200:
        return bodyStr;

      case 400:
        msg = "Error: Bad request.";
        break;
      case 401:
        msg = "Unauthorized: Authenticate field of header may tell you more."
            "\nAuthenticate: ${response.headers["Authenticate"]}";
        break;
      case 403:
        msg = "Forbidden: You are not authorized or https resource was opened via http.";
        break;
      case 404:
        msg = "Not found.";
        break;
      case 405:
        msg = "Method not allowed.";
        break;
      case 500:
      default:
        msg = "Error while communicating with Server. StatusCode: ${response.statusCode}";
        break;
    }

    throw Exception("$msg"
        "\nReason: ${response.reasonPhrase}"
        "\nResponse body: $bodyStr"
    );
  }


  Future<Map<String, dynamic>> getJsonMap(String authority,
      String path,
      {
        Map<String, String> headerParameters = const {},
        Map<String, String> queryParameters = const {},
      }) async {
    String body = await getJsonBodyString(authority, path, headerParameters: headerParameters, queryParameters: queryParameters);
    Map<String, dynamic> jsonMap = json.decode(body);
    return jsonMap;
  }


  Future<List<dynamic>> getJsonList(String authority,
      String path,
      {
        Map<String, String> headerParameters = const {},
        Map<String, String> queryParameters = const {},
      }) async {
    String body = await getJsonBodyString(authority, path, headerParameters: headerParameters, queryParameters: queryParameters);
    List<dynamic> jsonMap = json.decode(body);
    return jsonMap;
  }

}