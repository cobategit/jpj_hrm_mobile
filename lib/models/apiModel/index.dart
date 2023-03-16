import 'dart:convert';

ApiModel apiModelFromJson(String str) => ApiModel.fromJson(json.decode(str));

String apiModelToJson(ApiModel data) => json.encode(data.toJson());

class ApiModel {
  ApiModel({
    this.path,
    this.body,
    this.token,
    this.url,
    this.isToken,
  });

  String? path, token, url;
  bool? isToken;
  Map<String, dynamic>? body;

  factory ApiModel.fromJson(Map<String, dynamic> json) => ApiModel(
      path: json['path'],
      body: json['body'],
      token: json['token'],
      isToken: json['isToken'],
      url: json['url']);

  Map<String, dynamic> toJson() => {
        'path': path,
        'body': body,
        'token': token,
        'isToken': isToken,
        'url': url
      };
}
