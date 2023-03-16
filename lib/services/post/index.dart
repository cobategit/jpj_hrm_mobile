import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:jpj_hrm_mobile/models/index.dart';
import 'package:http_parser/http_parser.dart';

class PostData {
  static dynamic client = http.Client();

  Future<Map<String, dynamic>> postData(ApiModel? apiModel) async {
    Map<String, dynamic> resJson;

    dynamic url = Uri.parse('${apiModel!.url}${apiModel.path}');

    Map<String, dynamic> header;
    if (apiModel.isToken!) {
      header = {
        'Content-type': 'application/json',
        'Accept': 'application/*',
        'Authorization': 'Bearer ${apiModel.token}'
      };
    } else {
      header = {
        'Content-type': 'application/json',
        'Accept': 'application/*',
      };
    }

    try {
      http.Response resData = await http
          .post(url, body: json.encode(apiModel.body), headers: {...header});

      if (resData.statusCode == 200) {
        resJson = json.decode(resData.body);
      } else {
        resJson = json.decode(resData.body);
      }

      if (kDebugMode) {
        print('response post => $resJson');
      }
      return resJson;
    } catch (e) {
      if (kDebugMode) {
        print('error catch post => $e');
      }
      resJson = {'error': e};
      return resJson;
    }
  }

  Future<Map<String, dynamic>> putData(ApiModel? apiModel) async {
    Map<String, dynamic> resJson;

    dynamic url = Uri.parse('${apiModel!.url}${apiModel.path}');

    Map<String, dynamic> header;
    if (apiModel.isToken!) {
      header = {
        'Content-type': 'application/json',
        'Accept': 'application/*',
        'Authorization': 'Bearer ${apiModel.token}'
      };
    } else {
      header = {
        'Content-type': 'application/json',
        'Accept': 'application/*',
      };
    }

    try {
      http.Response resData = await http
          .put(url, body: json.encode(apiModel.body), headers: {...header});

      if (resData.statusCode == 200) {
        resJson = json.decode(resData.body);
      } else {
        resJson = json.decode(resData.body);
      }

      if (kDebugMode) {
        print('response post => $resJson');
      }
      return resJson;
    } catch (e) {
      if (kDebugMode) {
        print('error catch post => $e');
      }
      resJson = {'error': e};
      return resJson;
    }
  }

  Future<Map<String, dynamic>> postFormData(
      ApiModel? apiModel, String? method) async {
    Map<String, dynamic> resJson;

    dynamic url = Uri.parse('${apiModel!.url}${apiModel.path}');

    try {
      final request = http.MultipartRequest(method!, url);
      request.headers['Authorization'] = 'Bearer ${apiModel.token}';
      request.headers['Content-type'] = 'multipart/form-data';

      apiModel.body?.forEach((key, value) {
        if (key != 'picture') {
          request.fields[key] = value;
        }
      });
      request.files.add(
        http.MultipartFile(
          'picture',
          File(apiModel.body!['picture']).readAsBytes().asStream(),
          File(apiModel.body!['picture']).lengthSync(),
          filename: apiModel.body!['picture'].split("/").last,
          contentType: MediaType(
              "image", "${File(apiModel.body!['picture']).runtimeType}"),
        ),
      );

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        resJson = json.decode(responseData.body);
      } else {
        final responseData = await http.Response.fromStream(response);
        resJson = json.decode(responseData.body);
      }

      if (kDebugMode) {
        print('response post => $resJson');
      }
      return resJson;
    } catch (e) {
      if (kDebugMode) {
        print('error catch post form data => $e');
      }
      resJson = {'error': e};
      return resJson;
    }
  }
}
