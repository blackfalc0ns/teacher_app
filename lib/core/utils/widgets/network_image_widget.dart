import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

class NetworkImageWidget extends StatefulWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final Widget placeholder;
  final Widget errorWidget;

  const NetworkImageWidget({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
    required this.placeholder,
    required this.errorWidget,
  });

  @override
  State<NetworkImageWidget> createState() => _NetworkImageWidgetState();
}

class _NetworkImageWidgetState extends State<NetworkImageWidget> {
  Uint8List? _imageBytes;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(NetworkImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _loadImage();
    }
  }

  Future<void> _loadImage() async {
    if (!mounted) return;

    ////print('========== NETWORK IMAGE WIDGET ==========');
    ////print('Loading image: ${widget.imageUrl}');

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final dio = Dio();
      ////print('Making request...');

      final response = await dio.get<List<int>>(
        widget.imageUrl,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          validateStatus: (status) => status! < 500,
        ),
      );

      ////print('Response status: ${response.statusCode}');
      ////print('Response data length: ${response.data?.length ?? 0}');

      if (!mounted) return;

      if (response.statusCode == 200 && response.data != null) {
        ////print('✅ Image loaded successfully! ${response.data!.length} bytes');

        // Try to decode using image package
        try {
          ////print('Attempting to decode with image package...');
          final decodedImage = img.decodeImage(
            Uint8List.fromList(response.data!),
          );

          if (decodedImage != null) {
            ////print(
            //   '✅ Image decoded successfully! ${decodedImage.width}x${decodedImage.height}',
            // );

            // Convert to PNG (guaranteed to work)
            final pngBytes = img.encodePng(decodedImage);
            ////print('✅ Converted to PNG: ${pngBytes.length} bytes');

            setState(() {
              _imageBytes = Uint8List.fromList(pngBytes);
              _isLoading = false;
            });
            ////print('✅ State updated with converted image');
          } else {
            ////print('❌ Could not decode image with image package');
            setState(() {
              _hasError = true;
              _isLoading = false;
            });
          }
        } catch (decodeError) {
          ////print('❌ Decode error: $decodeError');
          setState(() {
            _hasError = true;
            _isLoading = false;
          });
        }
      } else {
        ////print('❌ Bad response: ${response.statusCode}');
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      ////print('❌ ERROR loading image: $e');
      ////print('Stack trace: $stackTrace');
      if (!mounted) return;

      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }

    ////print('==========================================');
  }

  @override
  Widget build(BuildContext context) {
    ////print(
    //   'NetworkImageWidget build - isLoading: $_isLoading, hasError: $_hasError, hasBytes: ${_imageBytes != null}',
    // );

    if (_isLoading) {
      ////print('Showing placeholder...');
      return widget.placeholder;
    }

    if (_hasError || _imageBytes == null) {
      ////print('Showing error widget...');
      return widget.errorWidget;
    }

    ////print('Showing image! Bytes length: ${_imageBytes!.length}');
    return Image.memory(
      _imageBytes!,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      errorBuilder: (context, error, stackTrace) {
        ////print('Image.memory error: $error');
        return widget.errorWidget;
      },
    );
  }
}
