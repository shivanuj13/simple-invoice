import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_invoice/const/string_const.dart';
import 'package:simple_invoice/ui/widgets/custom_text_field_widget.dart';

import '../../data/models/user_model.dart';
import '../../providers/user_provider.dart';
import '../../routes/route_const.dart';
import '../widgets/image_picker_bottom_sheet_widget.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  String? imgPath;
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _mobile = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  bool _isPasswordVisible = false;
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _mobile.dispose();
    _address.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAuth = ref.watch(userAuthProvider);
    ref.listen(userAuthProvider, (previous, next) {
      if (next.asError != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(next.error.toString()),
        ));
      } else if (next.asData != null) {
        next.whenData((value) {
          if (value != null) {
            Navigator.pushReplacementNamed(context, RouteConst.home);
          }
        });
      }
    });
    return Scaffold(
        appBar: AppBar(
          title: const Text(StringConst.appName),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 1.h,
                ),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        showDragHandle: true,
                        context: context,
                        builder: (context) {
                          return ImagePickerBottomSheetWidget(
                            ontTap: (ImageSource imageSource) async {
                              Navigator.pop(context);
                              XFile? image = await ImagePicker().pickImage(
                                  source: imageSource, imageQuality: 20);
                              if (image != null) {
                                setState(() {
                                  imgPath = image.path;
                                });
                              }
                            },
                          );
                        });
                  },
                  child: CircleAvatar(
                    radius: 50,
                    child: imgPath == null
                        ? const Icon(Icons.add_a_photo)
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.file(
                              File(imgPath!),
                              height: double.infinity,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )),
                  ),
                ),
                Text(
                  "Your Logo",
                  style: TextStyle(fontSize: 17.sp),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                        child: CustomTextFieldWidget(
                          controller: _name,
                          labelText: 'Organization Name',
                          prefixIcon: const Icon(Icons.business_outlined),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Name can\'t be empty';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.name,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                        child: CustomTextFieldWidget(
                          controller: _email,
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email_outlined),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email can\'t be empty';
                            } else {
                              if (!RegExp(
                                      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                        child: CustomTextFieldWidget(
                          controller: _mobile,
                          labelText: 'Mobile (Optional)',
                          prefixIcon: const Icon(Icons.phone_android_outlined),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                        child: CustomTextFieldWidget(
                          controller: _address,
                          labelText: 'Address (Optional)',
                          prefixIcon: const Icon(Icons.home_outlined),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                        child: CustomTextFieldWidget(
                          controller: _password,
                          style: TextStyle(letterSpacing: 1.w),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password can\'t be empty';
                            }
                            return null;
                          },
                          obscureText: !_isPasswordVisible,
                          keyboardType: TextInputType.visiblePassword,
                          labelText: "Password",
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                              icon: Icon(_isPasswordVisible
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                        child: CustomTextFieldWidget(
                          controller: _confirmPassword,
                          style: TextStyle(letterSpacing: 1.w),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password can\'t be empty';
                            }
                            return null;
                          },
                          obscureText: !_isPasswordVisible,
                          keyboardType: TextInputType.visiblePassword,
                          labelText: "Confirm Password",
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                              icon: Icon(_isPasswordVisible
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined)),
                        ),
                      ),
                    ],
                  ),
                ),
                userAuth.isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      )
                    : FilledButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            await ref.read(userAuthProvider.notifier).signUp(
                                  UserModel(
                                    id: "",
                                    name: _name.text,
                                    email: _email.text,
                                    mobile: _mobile.text,
                                    password: _password.text,
                                    address: _address.text,
                                    logoUrl: imgPath ?? '',
                                    createdAt: DateTime.now(),
                                    token: "",
                                  ),
                                  context,
                                );
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content:
                                  Text("Kindly fill the required fields!!"),
                            ));
                          }
                        },
                        child: const Text('Sign Up'),
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, RouteConst.signIn);
                        },
                        child: const Text("Sign In"))
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
