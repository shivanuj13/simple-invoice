
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ImagePickerBottomSheetWidget extends StatelessWidget {
  const ImagePickerBottomSheetWidget({
    super.key,
    required this.ontTap,
  });
  final void Function(ImageSource) ontTap;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 11.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton.filledTonal(
                  onPressed: () {
                    ontTap(ImageSource.camera);
                  },
                  iconSize: 4.h,
                  padding: EdgeInsets.all(1.h),
                  icon: const Icon(Icons.camera_alt)),
              const Text('Camera')
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton.filledTonal(
                  onPressed: () {
                    ontTap(ImageSource.gallery);
                  },
                  iconSize: 4.h,
                  padding: EdgeInsets.all(1.h),
                  icon: const Icon(Icons.photo)),
              const Text('Gallery')
            ],
          ),
        ],
      ),
    );
  }
}


// bottom sheet to select which image picker method to use (camera or gallery)

