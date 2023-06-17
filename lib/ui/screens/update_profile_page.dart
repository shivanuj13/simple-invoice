import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_invoice/const/string_const.dart';
import 'package:simple_invoice/ui/widgets/custom_text_field_widget.dart';

import '../../data/models/user_model.dart';
import '../../providers/user_provider.dart';
import '../widgets/image_picker_bottom_sheet_widget.dart';

class UpdateProfilePage extends ConsumerStatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  ConsumerState<UpdateProfilePage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<UpdateProfilePage> {
  String? imgPath;
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _mobile = TextEditingController();
  final TextEditingController _address = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    final user = ref.read(userAuthProvider).value;
    if (user != null) {
      _name.text = user.name;
      _email.text = user.email;
      _mobile.text = user.mobile;
      _address.text = user.address;
    }
    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _mobile.dispose();
    _address.dispose();
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
            Navigator.pop(context);
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
                        ? userAuth.value!.logoUrl.isEmpty
                            ? const Icon(Icons.add_a_photo)
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.network(
                                  userAuth.value!.logoUrl,
                                  height: double.infinity,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ))
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
                            await ref
                                .read(userAuthProvider.notifier)
                                .updateUser(
                                  UserModel(
                                    id: "",
                                    name: _name.text,
                                    email: _email.text,
                                    mobile: _mobile.text,
                                    password: "",
                                    address: _address.text,
                                    logoUrl: userAuth.value?.logoUrl ?? "",
                                    createdAt: DateTime.now(),
                                    token: "",
                                  ),
                                  imgPath,
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
                        child: const Text('Update'),
                      ),
              ],
            ),
          ),
        ));
  }
}
