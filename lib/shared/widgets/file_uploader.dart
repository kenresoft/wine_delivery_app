import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:vintiora/core/router/nav.dart';
import 'package:vintiora/core/theme/app_theme.dart';
import 'package:vintiora/core/utils/helpers.dart';

enum AllowedFileType {
  image,
  video,
  all,
}

class FileUploader extends StatefulWidget {
  final Function(List<PlatformFile>?) onFilesSelected;
  final List<PlatformFile>? selectedFiles;
  final bool allowMultiple;
  final AllowedFileType allowedFileType;
  final List<String>? placeholderImageUrls; // Immutable list from backend

  const FileUploader({
    super.key,
    required this.onFilesSelected,
    this.selectedFiles,
    this.allowMultiple = false,
    this.allowedFileType = AllowedFileType.all,
    this.placeholderImageUrls,
  });

  @override
  State<FileUploader> createState() => _FileUploaderState();
}

class _FileUploaderState extends State<FileUploader> {
  late List<String> _mutablePlaceholderImageUrls; // Mutable copy of the placeholder list

  @override
  void initState() {
    super.initState();
    // Initialize the mutable list with the immutable data from the backend
    _mutablePlaceholderImageUrls = List.from(widget.placeholderImageUrls ?? []);
  }

  @override
  void didUpdateWidget(covariant FileUploader oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Re-initialize the mutable list if the immutable data changes (e.g., page reload)
    if (oldWidget.placeholderImageUrls != widget.placeholderImageUrls) {
      _mutablePlaceholderImageUrls = List.from(widget.placeholderImageUrls ?? []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: widget.selectedFiles != null && widget.selectedFiles!.isNotEmpty ? _buildSelectedFiles(context) : _buildUploadSection(context),
    );
  }

  Widget _buildUploadSection(BuildContext context) {
    // Check if placeholder images are provided
    if (_mutablePlaceholderImageUrls.isNotEmpty) {
      return _buildPlaceholderImages(context);
    } else {
      return InkWell(
        onTap: () => _pickFiles(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_upload, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text(
              _getUploadText(),
              style: theme(context).textTheme.displayMedium?.copyWith(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildPlaceholderImages(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _mutablePlaceholderImageUrls.length,
      itemBuilder: (context, index) {
        final imageUrl = _mutablePlaceholderImageUrls[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  width: 282,
                  height: 300,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image, size: 50);
                  },
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    // Remove the placeholder image from the mutable list
                    setState(() {
                      _mutablePlaceholderImageUrls.removeAt(index);
                    });
                  },
                  color: Colors.white,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getUploadText() {
    switch (widget.allowedFileType) {
      case AllowedFileType.image:
        return 'Click to upload image';
      case AllowedFileType.video:
        return 'Click to upload video';
      case AllowedFileType.all:
        return 'Click to upload files';
    }
  }

  Widget _buildSelectedFiles(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.selectedFiles!.length,
      itemBuilder: (context, index) {
        final file = widget.selectedFiles![index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (_isImage(file))
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _buildFilePreview(file, isImage: true),
                )
              else if (_isVideo(file))
                SizedBox(
                  width: 282,
                  height: 300,
                  child: _buildFilePreview(file, isImage: false),
                ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    final updatedFiles = List<PlatformFile>.from(widget.selectedFiles!);
                    updatedFiles.removeAt(index);
                    widget.onFilesSelected(updatedFiles);
                  },
                  color: Colors.white,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilePreview(PlatformFile file, {required bool isImage}) {
    if (isImage) {
      if (isWeb) {
        if (file.bytes != null) {
          return Image.memory(
            file.bytes!,
            width: 282,
            height: 300,
            fit: BoxFit.cover,
          );
        } else {
          return const Icon(Icons.broken_image, size: 50);
        }
      } else {
        if (file.path != null) {
          return Image.file(
            File(file.path!),
            width: 282,
            height: 300,
            fit: BoxFit.cover,
          );
        } else {
          return const Icon(Icons.broken_image, size: 50);
        }
      }
    } else {
      // For video
      if (isWeb) {
        if (file.bytes != null) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.video_file, size: 50),
                SizedBox(height: 8),
                Text('Video preview not available on web'),
              ],
            ),
          );
        } else {
          return const Icon(Icons.broken_image, size: 50);
        }
      } else {
        if (file.path != null) {
          return _VideoPlayer(file: File(file.path!));
        } else {
          return const Icon(Icons.broken_image, size: 50);
        }
      }
    }
  }

  bool _isImage(PlatformFile file) {
    final imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
    return imageExtensions.contains(file.extension?.toLowerCase());
  }

  bool _isVideo(PlatformFile file) {
    final videoExtensions = ['mp4', 'mov', 'webm'];
    return videoExtensions.contains(file.extension?.toLowerCase());
  }

  Future<void> _pickFiles() async {
    FilePickerResult? result;

    try {
      result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: widget.allowMultiple,
        withData: isWeb, // Ensure we get the bytes for web
      );

      // Guard clause to check if the widget is still in the widget tree
      if (!mounted) return;

      if (result != null && result.files.isNotEmpty) {
        // Validate the selected files
        final validFiles = result.files.where((file) {
          if (widget.allowedFileType == AllowedFileType.image) {
            return _isImage(file);
          } else if (widget.allowedFileType == AllowedFileType.video) {
            return _isVideo(file);
          } else {
            return _isImage(file) || _isVideo(file);
          }
        }).toList();

        if (validFiles.isNotEmpty) {
          widget.onFilesSelected(validFiles);
        } else {
          _showInvalidFileWarning();
        }
      }
    } catch (e) {
      debugPrint('Error picking files: $e');
      if (mounted) {
        Nav.showSnackBar('Error picking files: $e');
      }
    }
  }

  void _showInvalidFileWarning() {
    Nav.showModal(
      (context) => AlertDialog(
        title: const Text('Invalid File'),
        content: Text(
          widget.allowedFileType == AllowedFileType.image
              ? 'Please select a valid image file (jpg, jpeg, png, gif, webp).'
              : widget.allowedFileType == AllowedFileType.video
                  ? 'Please select a valid video file (mp4, mov, webm).'
                  : 'Please select a valid image or video file (jpg, jpeg, png, gif, webp, mp4, mov, webm).',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _VideoPlayer extends StatefulWidget {
  final File file;

  const _VideoPlayer({required this.file});

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<_VideoPlayer> {
  late VideoPlayerController _controller;
  final ValueNotifier<bool> _isInitialized = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _hasError = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.file(widget.file);

    try {
      await _controller.initialize();
      if (mounted) {
        _isInitialized.value = true;
        _controller.setLooping(true);
        _controller.play();
      }
    } catch (e) {
      debugPrint('Error initializing video: $e');
      if (mounted) {
        _hasError.value = true;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _isInitialized.dispose();
    _hasError.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _hasError,
      builder: (context, hasError, child) {
        if (hasError) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 40),
                SizedBox(height: 8),
                Text('Error loading video'),
              ],
            ),
          );
        }

        return ValueListenableBuilder<bool>(
          valueListenable: _isInitialized,
          builder: (context, isInitialized, child) {
            return isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        VideoPlayer(_controller),
                        VideoProgressIndicator(
                          _controller,
                          allowScrubbing: true,
                          padding: const EdgeInsets.all(8),
                        ),
                      ],
                    ),
                  )
                : const Center(child: CircularProgressIndicator());
          },
        );
      },
    );
  }
}
