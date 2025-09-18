import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';

class ProfileImageWidget extends StatefulWidget {
  final String? imageUrl;
  final Function(File?) onImageSelected;

  const ProfileImageWidget({
    super.key,
    required this.imageUrl,
    required this.onImageSelected,
  });

  @override
  State<ProfileImageWidget> createState() => _ProfileImageWidgetState();
}

class _ProfileImageWidgetState extends State<ProfileImageWidget> {
  File? _file;
  final ImagePicker _picker = ImagePicker();

  Future<void> _chooseImage() async {
    try {
      // Pick image from gallery
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        // Crop the picked image
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          compressFormat: ImageCompressFormat.png,
          compressQuality: 30,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: Theme.of(context).primaryColor,
              toolbarWidgetColor: Colors.white,
              activeControlsWidgetColor: Theme.of(context).primaryColor,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: true,
            ),
            IOSUiSettings(
              title: 'Crop Image',
              aspectRatioLockEnabled: true,
            ),
          ],
        );

        if (croppedFile != null) {
          // Copy cropped file to temp directory
          final tempDir = await getTemporaryDirectory();
          final newFile = await File(croppedFile.path).copy(
            '${tempDir.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.png',
          );

          setState(() {
            _file = newFile; // ✅ set new file in state
          });

          // Pass file to parent
          widget.onImageSelected(_file);

          debugPrint('✅ Image selected: ${_file?.path}');
        }
      }
    } catch (e) {
      debugPrint('❌ Error picking/cropping image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageToShow = _file != null
        ? Image.file(_file!, width: 80, height: 80, fit: BoxFit.cover)
        : (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
            ? CustomImageWidget(
                placeholder: Images.placeholderUser,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                image: widget.imageUrl!,
              )
            : Image.asset(
                Images.placeholderUser,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraLarge),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ColorResources.borderColor,
        border: Border.all(color: Colors.white54, width: 3),
        shape: BoxShape.circle,
      ),
      child: InkWell(
        onTap: _chooseImage,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(80 / 2),
              child: imageToShow,
            ),
            Positioned(
              bottom: 15,
              right: -10,
              child: InkWell(
                onTap: _chooseImage,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: const Icon(Icons.edit, size: 13, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// // profile_image_widget.dart
// import 'dart:io';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
// import 'package:flutter_restaurant/utill/color_resources.dart';
// import 'package:flutter_restaurant/utill/dimensions.dart';
// import 'package:flutter_restaurant/utill/images.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image/image.dart' as img;
// import 'package:path_provider/path_provider.dart';

// class ProfileImageWidget extends StatefulWidget {
//   final String? imageUrl;
//   final Function(File?) onImageSelected;

//   const ProfileImageWidget({
//     super.key,
//     required this.imageUrl,
//     required this.onImageSelected,
//   });

//   @override
//   State<ProfileImageWidget> createState() => _ProfileImageWidgetState();
// }

// class _ProfileImageWidgetState extends State<ProfileImageWidget> {
//   File? _file;
//   final ImagePicker _picker = ImagePicker();

//   Future<void> _chooseImage() async {
//     try {
//       final pickedFile = await _picker.pickImage(
//         source: ImageSource.gallery,
//         imageQuality: 50,
//       );

//       if (pickedFile != null) {
//         // Read and decode the image
//         final imageBytes = await File(pickedFile.path).readAsBytes();
//         final originalImage = img.decodeImage(imageBytes);

//         if (originalImage != null) {
//           final minDimension = min(originalImage.width, originalImage.height);
//           final offsetX = (originalImage.width - minDimension) ~/ 2;
//           final offsetY = (originalImage.height - minDimension) ~/ 2;

//           // Crop to square
//           final croppedImage = img.copyCrop(
//             originalImage,
//             x: offsetX,
//             y: offsetY,
//             width: minDimension,
//             height: minDimension,
//           );

//           // Resize to 500x500
//           final resizedImage =
//               img.copyResize(croppedImage, width: 500, height: 500);

//           // Save to temporary file
//           final tempDir = await getTemporaryDirectory();
//           final processedFile = File(
//               '${tempDir.path}/processed_${DateTime.now().millisecondsSinceEpoch}.png');
//           await processedFile.writeAsBytes(img.encodePng(resizedImage));

//           setState(() {
//             _file = processedFile;
//           });
//           widget.onImageSelected(_file);
//         }
//       }
//     } catch (e) {
//       debugPrint('Error processing image: $e');
//       // Optionally show error to user
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(
//           vertical: Dimensions.paddingSizeExtraLarge),
//       alignment: Alignment.center,
//       decoration: BoxDecoration(
//         color: ColorResources.borderColor,
//         border: Border.all(color: Colors.white54, width: 3),
//         shape: BoxShape.circle,
//       ),
//       child: InkWell(
//         onTap: _chooseImage,
//         child: Stack(
//           clipBehavior: Clip.none,
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(50),
//               child: _file != null
//                   ? Image.file(_file!, width: 80, height: 80, fit: BoxFit.fill)
//                   : CustomImageWidget(
//                       placeholder: Images.placeholderUser,
//                       width: 80,
//                       height: 80,
//                       fit: BoxFit.cover,
//                       image: widget.imageUrl!,
//                     ),
//             ),
//             Positioned(
//               bottom: 15,
//               right: -10,
//               child: InkWell(
//                 onTap: _chooseImage,
//                 child: Container(
//                   alignment: Alignment.center,
//                   padding:
//                       const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Theme.of(context).primaryColor,
//                   ),
//                   child: const Icon(Icons.edit, size: 13, color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
