import 'dart:convert';
import 'dart:io';

import 'package:chat_app/config/response.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class ApplicationBaseRequest {
  String baseUrl;
  String endpoint;
  String method;
  Map<String, dynamic>? data;
  String? token;
  Uri Function(String, String, [Map<String, dynamic>?]) getUri;

  ApplicationBaseRequest._({
    required this.baseUrl,
    required this.endpoint,
    required this.method,
    this.data,
    this.token,
    required this.getUri,
  });

  factory ApplicationBaseRequest.bootstrap({
    required String baseUrl,
    required String endpoint,
    required String method,
    Map<String, dynamic>? data,
    String? token,
  }) {
    getUri(String baseUrl, String endpoint, [Map<String, dynamic>? params]) {
      return Uri.https(baseUrl, endpoint, params);
    }

    return ApplicationBaseRequest._(
      baseUrl: baseUrl,
      endpoint: endpoint,
      method: method,
      data: data,
      token: token,
      getUri: getUri,
    );
  }

  factory ApplicationBaseRequest.get(
    String baseUrl,
    String endpoint, {
    Map<String, dynamic>? params,
    String token = "",
  }) =>
      ApplicationBaseRequest.bootstrap(
        baseUrl: baseUrl,
        endpoint: endpoint,
        method: 'get',
        data: params,
        token: token,
      );

  factory ApplicationBaseRequest.delete(
    String baseUrl,
    String endpoint, {
    Map<String, dynamic>? params,
    String token = "",
  }) =>
      ApplicationBaseRequest.bootstrap(
        baseUrl: baseUrl,
        endpoint: endpoint,
        method: 'delete',
        data: params,
        token: token,
      );

  factory ApplicationBaseRequest.post(
    String baseUrl,
    String endpoint,
    Map<String, dynamic> payload, {
    String token = "",
  }) =>
      ApplicationBaseRequest.bootstrap(
        baseUrl: baseUrl,
        endpoint: endpoint,
        method: 'post',
        data: payload,
        token: token,
      );

  factory ApplicationBaseRequest.patch(
    String baseUrl,
    String endpoint,
    Map<String, dynamic> payload, {
    String token = "",
  }) =>
      ApplicationBaseRequest.bootstrap(
        baseUrl: baseUrl,
        endpoint: endpoint,
        method: "put",
        data: payload,
        token: token,
      );

  Future<Response> request() async {
    late http.Response response;
    try {
      if (method.toLowerCase() == "get") {
        final Map<String, String?> params = data != null
            ? data!.map(
                (key, value) => MapEntry(
                  key,
                  value?.toString(),
                ),
              )
            : {};
        final Uri requestUrl = getUri(baseUrl, endpoint, params);
        response = await http.get(
          requestUrl,
          headers: _getHeaders(),
        );
      }

      if (method.toLowerCase() == "delete") {
        final Uri requestUrl = getUri(baseUrl, endpoint);
        var req = http.MultipartRequest(
          method.toUpperCase(),
          requestUrl,
        );
        data!.forEach((key, value) async {
          if (value is String) {
            req.fields[key] = value;
          }
          if (value is double || value is int) {
            req.fields[key] = value.toString();
          }
          if (value is PlatformFile) {
            req.files.add(http.MultipartFile.fromBytes(
              key,
              value.bytes!.toList(),
            ));
          }
        });

        req.headers.addAll(_getHeaders());
        response = await http.Response.fromStream(await req.send());
      }

      if (method.toLowerCase() == "post") {
        final Uri requestUrl = getUri(baseUrl, endpoint);

        var req = http.MultipartRequest(
          method.toUpperCase(),
          requestUrl,
        );
        data!.forEach((key, value) async {
          if (value is String) {
            req.fields[key] = value;
          }
          if (value is DateTime) {
            req.fields[key] = value.toString();
          }
          if (value is double || value is int) {
            req.fields[key] = value.toString();
          }
          if (value is List) {
            int i = 0;
            for (dynamic v in value) {
              req.fields["$key[$i]"] = v.toString();
              i++;
            }
          }
          if (value is PlatformFile) {
            req.files.add(await http.MultipartFile.fromPath(
              key,
              value.path!,
            ));
          }
          if (value is File) {
            req.files.add(await http.MultipartFile.fromPath(
              key,
              value.path,
            ));
          }
        });
        req.headers.addAll(_getHeaders());
        response = await http.Response.fromStream(await req.send());
      }

      if (method.toLowerCase() == "put") {
        final Uri requestUrl = getUri(baseUrl, endpoint);
        var req = http.MultipartRequest(
          method.toUpperCase(),
          requestUrl,
        );
        req.fields['_method'] = "PUT";
        data!.forEach((key, value) async {
          if (value is String) {
            req.fields[key] = value;
          }
          if (value is double || value is int) {
            req.fields[key] = value.toString();
          }
        });

        req.headers.addAll(_getHeaders());
        response = await http.Response.fromStream(await req.send());
      }
    } catch (e) {
      response = http.Response("{\"message\":\"Unknown Error\"}", 404);
    }

    var response0;
    try {
      if (response.statusCode ~/ 100 == 2) {
        response0 = jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        response0 = jsonDecode(response.body);
      } else if (response.statusCode == 502) {
        response0 = jsonDecode("{\"message\":\"Process Failed\"}");
      } else {
        return Response(
          status: response.statusCode,
          data: jsonDecode(response.body) as Map<String, dynamic>,
          message: response.reasonPhrase,
          body: response.body,
        );
      }
    } catch (e) {
      response0 = {
        "error": "Decoding Error",
        "response": response.body,
      };
      return Response(
        status: response.statusCode,
        data: response0,
        message: response.reasonPhrase,
        body: response.body,
      );
    }

    return Response(
      status: response.statusCode,
      data: response0,
      message: response.reasonPhrase,
      body: response.body,
    );
  }

  Map<String, String> _getHeaders() {
    return <String, String>{
      'access-control-allow-origin': '*',
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
    };
  }
}
