import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:jpj_hrm_mobile/models/index.dart';

class GetData {
  static dynamic client = http.Client();

  Future<Map<String, dynamic>> getData(ApiModel apiModel) async {
    Map<String, dynamic> resMap;

    dynamic url = Uri.parse('${apiModel.url}${apiModel.path}');

    try {
      http.Response resData = await http.get(url, headers: {
        'Accept': 'application/*',
        'Authorization': 'Bearer ${apiModel.token}'
      });

      if (resData.statusCode == 200) {
        resMap = json.decode(resData.body);
      } else {
        resMap = json.decode(resData.body);
      }

      if (kDebugMode || kReleaseMode) {
        print('response get ${apiModel.path} => $resMap');
      }
      return resMap;
    } catch (e) {
      if (kDebugMode || kReleaseMode) {
        print('error catch get => $e');
      }
      resMap = {'message': e};
      return resMap;
    }
  }
}
