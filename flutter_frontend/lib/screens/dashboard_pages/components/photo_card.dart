import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/api_client.dart';
import 'package:flutter_frontend/api_endpoints.dart';
import 'package:flutter_frontend/models/car.dart';

class PhotoCard extends StatefulWidget {
  final Car car;
  final String photoId;
  final double width;
  final double height;
  const PhotoCard(this.car, this.photoId, {super.key, this.width = 200.0, this.height = 200.0});

  @override
  State<PhotoCard> createState() => _PhotoCardState();
}

class _PhotoCardState extends State<PhotoCard> {
  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    return FutureBuilder(
      future: ApiClient.getUserToken(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: widget.width,
              minHeight: widget.height,
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

        return ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: CachedNetworkImage(
            width: widget.width,
            height: widget.height,
            fit: BoxFit.cover,
            imageUrl:
                '${ApiEndpoints.carsEndpoint}/${widget.car.id}/photos/${widget.photoId}',
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
        );
      },
    );
  }
}
