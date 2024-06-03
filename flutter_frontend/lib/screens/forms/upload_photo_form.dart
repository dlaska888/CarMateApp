import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_frontend/helpers/api_client.dart';
import 'package:flutter_frontend/helpers/notification_service.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:http/http.dart' as http;

class UploadPhotoForm extends StatefulWidget {
  final String url;
  final Function onSubmit;
  const UploadPhotoForm(this.url, this.onSubmit, {super.key});

  @override
  State<UploadPhotoForm> createState() => _UploadPhotoFormState();
}



class _UploadPhotoFormState extends State<UploadPhotoForm> {
  final _formKey = GlobalKey<FormState>();
  http.MultipartFile? file;
  var _isLoading = false;
  var _isCameraAvailable = false;

  Future<bool> isCameraAvailable() async {
    final cameras = await availableCameras();
    return cameras.isNotEmpty;
  }

  Future _networkImageToBlob(String imageUrl) async {
    http.Response response = await http.get(Uri.parse(imageUrl));
    final bytes = response.bodyBytes;
    return bytes;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      ApiClient.postPhoto(widget.url, file!).then((_) {
        widget.onSubmit();
        Navigator.pop(context);
      }).catchError((error) {
        NotificationService.showNotification("Error: $error",
            type: MessageType.error);
      }).whenComplete(() {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  @override
  void initState() {
    isCameraAvailable().then((value) {
      setState(() {
        _isCameraAvailable = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final imageSources = _isCameraAvailable
        ? [ImageSourceOption.camera, ImageSourceOption.gallery]
        : [ImageSourceOption.gallery];

    return KeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKeyEvent: (event) {
          if (event.logicalKey == LogicalKeyboardKey.enter) {
            _submit();
          } else if (event.logicalKey == LogicalKeyboardKey.escape) {
            Navigator.pop(context);
          }
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: _formKey,
                  child: FormBuilderImagePicker(
                    name: 'photos',
                    decoration: const InputDecoration(
                        labelText: 'Select photo to upload',
                        contentPadding: EdgeInsets.all(16.0)),
                    maxImages: 1,
                    iconColor: primary,
                    backgroundColor: Colors.white,
                    availableImageSources: imageSources,
                    previewWidth: 300,
                    previewHeight: 300,
                    fit: BoxFit.cover,
                    maxWidth: 1000,
                    maxHeight: 1000,
                    validator: (values) {
                      if (values!.isEmpty) return 'Please select a photo';
                      return null;
                    },
                    onChanged: (val) {
                      try {
                        _networkImageToBlob(val!.first.path).then((blob) {
                          file = http.MultipartFile.fromBytes('photo', blob,
                              filename: val.first.name);
                        });
                        setState(() {});
                      } catch (e) {
                        log(e.toString());
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: _submit,
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : const Text("Upload"),
                      ),
                    ],
                  ),
                ),
              ],
            )),
          ),
        ));
  }
}
