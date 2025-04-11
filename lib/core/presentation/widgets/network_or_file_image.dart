// import 'dart:io';
// import 'package:farmersfriendapp/core/utils/app_constants.dart';
// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';

// /// Displays an image from either a network URL or a local file path,
// /// with placeholder and error handling.
// class NetworkOrFileImage extends StatelessWidget {
//   final String? imageUrl; // Can be file path or URL
//   final String placeholderAsset;
//   final BoxFit fit;
//   final double? width;
//   final double? height;

//   const NetworkOrFileImage({
//     super.key,
//     required this.imageUrl,
//     required this.placeholderAsset,
//     this.fit = BoxFit.cover,
//     this.width,
//     this.height,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (imageUrl == null || imageUrl!.isEmpty) {
//       return Image.asset(
//         placeholderAsset,
//         fit: fit,
//         width: width,
//         height: height,
//       );
//     }

//     if (imageUrl!.startsWith('http')) {
//       // Network Image
//       return CachedNetworkImage(
//         imageUrl: imageUrl!,
//         fit: fit,
//         width: width,
//         height: height,
//         placeholder: (context, url) => Center(
//             child: CircularProgressIndicator(
//                 color: AppConstants.primaryColorDark)),
//         errorWidget: (context, url, error) => Image.asset(
//           placeholderAsset,
//           fit: fit,
//           width: width,
//           height: height,
//         ),
//       );
//     } else {
//       // Local File
//       return Image.file(
//         File(imageUrl!),
//         fit: fit,
//         width: width,
//         height: height,
//         errorBuilder: (context, error, stackTrace) => Image.asset(
//           placeholderAsset,
//           fit: fit,
//           width: width,
//           height: height,
//         ),
//       );
//     }
//   }
// }
