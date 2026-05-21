import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:whatsapp/models/status_item.dart';

class StatusTile extends StatelessWidget {
  const StatusTile({
    super.key,
    required this.item,
    required this.onTap,
  });

  final StatusItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: Colors.black12,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(12.r), child: _buildThumb()),
            if (item.type == StatusType.video)
              Center(
                child: Icon(
                  Icons.play_circle_fill_rounded,
                  color: Colors.white,
                  size: 40.r,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumb() {
    if (item.type == StatusType.image) {
      return Image.file(
        item.file,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const ColoredBox(
          color: Colors.black12,
          child: Icon(Icons.broken_image_outlined),
        ),
      );
    }

    return FutureBuilder<Uint8List?>(
      future: VideoThumbnail.thumbnailData(
        video: item.file.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 256,
        quality: 65,
      ),
      builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
        if (snapshot.hasError) {
          print('Video thumbnail error for ${item.file.path}: ${snapshot.error}');
          return const ColoredBox(
            color: Colors.black26,
            child: Icon(Icons.videocam_rounded),
          );
        }
        if (snapshot.hasData && snapshot.data != null) {
          return Image.memory(
            snapshot.data!,
            fit: BoxFit.cover,
            gaplessPlayback: true,
          );
        }
        return const ColoredBox(
          color: Colors.black26,
          child: Icon(Icons.videocam_rounded),
        );
      },
    );
  }
}
