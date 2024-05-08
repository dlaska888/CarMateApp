import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/api_client.dart';
import 'package:flutter_frontend/api_endpoints.dart';
import 'package:flutter_frontend/models/car_mate_user.dart';

class UserAvatar extends StatefulWidget {
  final CarMateUser user;
  const UserAvatar(this.user, {super.key});

  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final screenWidth = MediaQuery.of(context).size.width;

    return FutureBuilder(
      future: ApiClient.getUserToken(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: screenWidth > 768 ? 300 : 200,
              minHeight: screenWidth > 768 ? 300 : 200,
            ),
            child: Center(
                child: Icon(
              Icons.photo_camera_outlined,
              size: 40.0,
              color: primary,
            )),
          );
        }

        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        return Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: primary, width: 2.0)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(300.0),
            child: CachedNetworkImage(
              width: screenWidth > 768 ? 300 : 200,
              height: screenWidth > 768 ? 300 : 200,
              fit: BoxFit.cover,
              imageUrl: '${ApiEndpoints.accountEndpoint}/profile-photo/${widget.user.photoId}',
              placeholder: (context, url) => Center(
                  child: Icon(
                Icons.photo_camera_outlined,
                size: 40.0,
                color: primary,
              )),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              httpHeaders: {"Authorization": "Bearer ${snapshot.data}"},
              imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet,
            ),
          ),
        );
      },
    );
  }
}
