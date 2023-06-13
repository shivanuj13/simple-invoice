import 'dart:convert';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:simple_invoice/const/url_const.dart';

import '../../data/models/user_model.dart';

final userApiProvider = Provider<UserApi>((ref) {
  return UserApi();
});

class UserApi {
  String userUrl = "$baseUrl/user";
  Map<String, String> headersList = {
    'Accept': '*/*',
    'User-Agent': 'Simple Invoice Android App',
    'Content-Type': 'application/json'
  };
  Future<UserModel> signUp(UserModel user, Map<String, dynamic> secrets) async {
    try {
      if (user.logoUrl.isNotEmpty) {
        user.logoUrl = await uploadImage(user.logoUrl, secrets);
      }
      http.Response response = await http.post(
        Uri.parse("$userUrl/signUp"),
        body: user.toJson(),
        headers: headersList,
      );
      Map<String, dynamic> res = jsonDecode(response.body);
      if (res["status"]) {
        UserModel userModel = UserModel.fromMap(res["data"]["user"]);
        userModel.token = res["data"]["token"];
        return userModel;
      } else {
        throw Exception(res["error"]);
      }
    } on Exception {
      rethrow;
    }
  }

  Future<UserModel> signIn(String email, String password) async {
    try {
      http.Response response = await http.post(
        Uri.parse("$userUrl/signIn"),
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
        headers: headersList,
      );
      Map<String, dynamic> res = jsonDecode(response.body);
      if (res["status"]) {
        UserModel userModel = UserModel.fromMap(res["data"]["user"]);
        userModel.token = res["data"]["token"];
        return userModel;
      } else {
        throw Exception(res["error"]);
      }
    } on Exception {
      rethrow;
    }
  }

  Future<UserModel> update(UserModel user, String token, String? newImgPath,
      Map<String, dynamic> secrets) async {
    try {
      headersList['Authorization'] = "Bearer $token";
      if (newImgPath != null) {
        user.logoUrl = await uploadImage(newImgPath, secrets);
      }
      http.Response response = await http.post(
        Uri.parse("$userUrl/update"),
        body: user.toJson(),
        headers: headersList,
      );
      Map<String, dynamic> res = jsonDecode(response.body);
      if (res["status"]) {
        UserModel userModel = UserModel.fromMap(res["data"]["user"]);
        userModel.token = token;
        return userModel;
      } else {
        throw Exception(res["error"]);
      }
    } on Exception {
      rethrow;
    }
  }

  Future<String> uploadImage(String path, Map<String, dynamic> secrets) async {
    try {
      CloudinaryPublic cloudinaryPublic = CloudinaryPublic(
        secrets["cloudName"]!,
        secrets["uploadPreset"]!,
        cache: true,
      );

      CloudinaryResponse response = await cloudinaryPublic.uploadFile(
        CloudinaryFile.fromFile(path,
            resourceType: CloudinaryResourceType.Image),
      );
      return response.secureUrl;
    } on Exception {
      rethrow;
    }
  }
}
