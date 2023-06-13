import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_invoice/routes/route_const.dart';

import '../../const/string_const.dart';
import '../../providers/user_provider.dart';
import '../widgets/custom_text_field_widget.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  bool _isPasswordVisible = false;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Text(
                  'Sign in to continue',
                  style: TextStyle(fontSize: 20.sp),
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      child: CustomTextFieldWidget(
                        controller: _emailController,
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        labelText: "Email",
                        prefixIcon: const Icon(Icons.email_outlined),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      child: CustomTextFieldWidget(
                        controller: _passwordController,
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
                  ],
                ),
              ),
              userAuth.isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    )
                  : FilledButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          ref.read(userAuthProvider.notifier).signIn(
                                _emailController.text,
                                _passwordController.text,
                              );
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Kindly fill the required fields!!"),
                          ));
                        }
                      },
                      child: const Text('Sign In'),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, RouteConst.signUp);
                      },
                      child: const Text("Sign Up"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
