import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_invoice/data/models/user_model.dart';
import 'package:simple_invoice/services/api/user_api.dart';

import '../services/helpers/shared_pref.dart';

final userAuthProvider =
    AsyncNotifierProvider<UserAuthNotifier, UserModel?>(UserAuthNotifier.new);

class UserAuthNotifier extends AsyncNotifier<UserModel?> {
  @override
  FutureOr<UserModel?> build() {
    return SharedPref.getUser();
  }

  Future<void> signUp(UserModel user, BuildContext context) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      Map<String, dynamic> secrets = jsonDecode(
          await DefaultAssetBundle.of(context)
              .loadString("assets/secrets.json"));
      return await ref.read(userApiProvider).signUp(user, secrets);
    });
    if (state.value != null) SharedPref.setUser(state.value!);
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref.read(userApiProvider).signIn(email, password);
    });
    if (state.value != null) SharedPref.setUser(state.value!);
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    await SharedPref.clearUser();
    state = const AsyncValue.data(null);
  }

  Future<void> updateUser(
      UserModel user, String? newImgPath, BuildContext context) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      Map<String, dynamic> secrets = jsonDecode(
          await DefaultAssetBundle.of(context)
              .loadString("assets/secrets.json"));
      return await ref
          .read(userApiProvider)
          .update(user, state.value!.token, newImgPath, secrets);
    });
    if (state.value != null) SharedPref.setUser(state.value!);
  }
}
