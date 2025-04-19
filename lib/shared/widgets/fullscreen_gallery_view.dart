import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vintiora/__.dart';
import 'package:vintiora/core/theme/app_colors.dart';
import 'package:vintiora/core/theme/app_theme.dart';
import 'package:vintiora/core/utils/asset_handler.dart';
import 'package:vintiora/core/utils/constants.dart';
import 'package:vintiora/features/main/presentation/widgets/custom_app_bar.dart';
import 'package:vintiora/shared/widgets/animated_fade_scale.dart';

/// A controller class to manage the state of the gallery view
class GalleryController {
  final ValueNotifier<int> currentIndexNotifier;
  final ValueNotifier<bool> isZoomedNotifier;
  final ValueNotifier<bool> controlsVisibleNotifier;
  final PageController pageController;
  final TransformationController transformationController;

  GalleryController({required int initialIndex})
      : currentIndexNotifier = ValueNotifier(initialIndex),
        isZoomedNotifier = ValueNotifier(false),
        controlsVisibleNotifier = ValueNotifier(true),
        pageController = PageController(initialPage: initialIndex),
        transformationController = TransformationController();

  void dispose() {
    currentIndexNotifier.dispose();
    isZoomedNotifier.dispose();
    controlsVisibleNotifier.dispose();
    pageController.dispose();
    transformationController.dispose();
  }

  int get currentIndex => currentIndexNotifier.value;

  bool get isZoomed => isZoomedNotifier.value;

  bool get controlsVisible => controlsVisibleNotifier.value;

  void setCurrentIndex(int index) => currentIndexNotifier.value = index;

  void setIsZoomed(bool value) => isZoomedNotifier.value = value;

  void toggleControls() => controlsVisibleNotifier.value = !controlsVisibleNotifier.value;
}

class FullscreenGalleryView extends StatefulWidget {
  /// Factory method to navigate to gallery view with proper transitions
  static void navigate(
    BuildContext context, {
    required List<String> images,
    int initialIndex = 0,
    required String heroTag,
  }) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) => FullscreenGalleryView(
          images: images,
          initialIndex: initialIndex,
          heroTag: heroTag,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  final List<String> images;
  final int initialIndex;
  final String heroTag;

  const FullscreenGalleryView({
    super.key,
    required this.images,
    this.initialIndex = 0,
    required this.heroTag,
  });

  @override
  State<FullscreenGalleryView> createState() => _FullscreenGalleryViewState();
}

class _FullscreenGalleryViewState extends State<FullscreenGalleryView> with SingleTickerProviderStateMixin {
  late final GalleryController _controller;
  late final AnimationController _animationController;
  Animation<Matrix4>? _animation;

  @override
  void initState() {
    super.initState();
    _controller = GalleryController(initialIndex: widget.initialIndex);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(_handleAnimationUpdate);

    _setupSystemUI();
  }

  void _setupSystemUI() {
    // Enhanced immersive experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void _resetSystemUI() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  void _handleAnimationUpdate() {
    if (_animation != null) {
      _controller.transformationController.value = _animation!.value;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    _resetSystemUI();
    super.dispose();
  }

  void _resetZoom() {
    _animation = Matrix4Tween(
      begin: _controller.transformationController.value,
      end: Matrix4.identity(),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _animationController.forward(from: 0);
    _controller.setIsZoomed(false);
  }

  void _handleInteractionEnd(ScaleEndDetails details) {
    // Performance optimization: only update state when needed
    final isNowZoomed = _controller.transformationController.value != Matrix4.identity();

    if (_controller.isZoomed != isNowZoomed) {
      _controller.setIsZoomed(isNowZoomed);
    }
  }

  void _handleDoubleTap() {
    if (_controller.isZoomed) {
      _resetZoom();
    } else {
      // Zoom to 2.5x on double tap
      final Matrix4 newMatrix = Matrix4.identity()
        ..translate(-100.0, -100.0)
        ..scale(2.5);

      _animation = Matrix4Tween(
        begin: _controller.transformationController.value,
        end: newMatrix,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ));

      _animationController.forward(from: 0);
      _controller.setIsZoomed(true);
    }
  }

  void _handlePageChange(int index) {
    _controller.setCurrentIndex(index);
    // Reset zoom when changing pages
    if (_controller.isZoomed) {
      _resetZoom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main image viewer with performance optimizations
          _buildMainImageViewer(),

          // Top navigation bar
          _buildTopNavigationBar(),

          // Bottom thumbnail gallery
          _buildBottomThumbnailGallery(),

          // Reset zoom button (only visible when zoomed)
          _buildZoomResetButton(),
        ],
      ),
    );
  }

  Widget _buildMainImageViewer() {
    return ValueListenableBuilder<bool>(
      valueListenable: _controller.isZoomedNotifier,
      builder: (context, isZoomed, _) {
        return GestureDetector(
          onTap: _controller.toggleControls,
          onDoubleTap: _handleDoubleTap,
          child: PageView.builder(
            controller: _controller.pageController,
            physics: isZoomed ? const NeverScrollableScrollPhysics() : const PageScrollPhysics(),
            onPageChanged: _handlePageChange,
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return Hero(
                tag: index == widget.initialIndex ? widget.heroTag : 'gallery_image_$index',
                child: InteractiveViewer(
                  transformationController: _controller.transformationController,
                  minScale: 1.0,
                  maxScale: 4.0,
                  onInteractionEnd: _handleInteractionEnd,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 48.h + 16),
                    child: AppImage(
                      Constants.baseUrl + widget.images[index],
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTopNavigationBar() {
    return ValueListenableBuilder<bool>(
      valueListenable: _controller.controlsVisibleNotifier,
      builder: (context, controlsVisible, _) {
        return AnimatedOpacity(
          opacity: controlsVisible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: Visibility(
            visible: controlsVisible,
            maintainState: true,
            maintainAnimation: true,
            maintainSize: false,
            child: ValueListenableBuilder<int>(
              valueListenable: _controller.currentIndexNotifier,
              builder: (context, currentIndex, _) {
                return Container(
                  height: kToolbarHeight + MediaQuery.paddingOf(context).top,
                  padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
                  /*decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.black1, Colors.transparent],
                    ),
                  ),*/
                  child: _GalleryAppBar(
                    currentIndexNotifier: _controller.currentIndexNotifier,
                    totalImages: widget.images.length,
                    onSharePressed: () {
                      // Share functionality would go here
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomThumbnailGallery() {
    return ValueListenableBuilder<bool>(
      valueListenable: _controller.controlsVisibleNotifier,
      builder: (context, controlsVisible, _) {
        return AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          bottom: controlsVisible ? 0 : -100,
          left: 0,
          right: 0,
          child: ValueListenableBuilder<int>(
            valueListenable: _controller.currentIndexNotifier,
            builder: (context, currentIndex, _) {
              return Container(
                height: 80,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [AppColors.black1, AppColors.transparent],
                  ),
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.images.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index) {
                    final isSelected = currentIndex == index;
                    return GestureDetector(
                      onTap: () {
                        _controller.pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: AnimatedFadeScale(
                        delay: Duration(milliseconds: 50 * index),
                        child: Container(
                          width: 60,
                          height: 60,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected ? Colors.white : Colors.transparent,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: AppImage(
                              Constants.baseUrl + widget.images[index],
                              fit: BoxFit.contain,
                              // memCacheWidth: 120, // Memory optimization
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildZoomResetButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: _controller.isZoomedNotifier,
      builder: (context, isZoomed, _) {
        return isZoomed
            ? Positioned(
                bottom: MediaQuery.paddingOf(context).bottom + 24,
                right: 24,
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor: AppColors.grey8,
                  onPressed: _resetZoom,
                  child: const Icon(Icons.zoom_out, color: Colors.white),
                ),
              )
            : const SizedBox.shrink(); // Zero-cost widget when not visible
      },
    );
  }
}

// Extension to make the GalleryRoute easy to use
extension GalleryRouteExtension on BuildContext {
  void openGallery({
    required List<String> images,
    int initialIndex = 0,
    required String heroTag,
  }) {
    FullscreenGalleryView.navigate(
      this,
      images: images,
      initialIndex: initialIndex,
      heroTag: heroTag,
    );
  }
}

class _GalleryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ValueNotifier<int> currentIndexNotifier;
  final int totalImages;
  final VoidCallback onSharePressed;

  const _GalleryAppBar({
    required this.currentIndexNotifier,
    required this.totalImages,
    required this.onSharePressed,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: currentIndexNotifier,
      builder: (context, currentIndex, _) {
        return CustomAppBar(
          backgroundColor: isDark(context) ? AppColors.black4 : AppColors.grey1,
          // elevation: 1,
          title: '${currentIndex + 1} / $totalImages',
          action: Assets.profile,
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(48.h);
}
