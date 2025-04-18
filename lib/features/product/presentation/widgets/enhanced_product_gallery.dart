import 'package:badges/badges.dart' as badges;
import 'package:extensionresoft/extensionresoft.dart' hide AppImage;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vintiora/__.dart';
import 'package:vintiora/core/router/nav.dart';
import 'package:vintiora/core/router/routes.dart';
import 'package:vintiora/core/theme/app_colors.dart';
import 'package:vintiora/core/theme/app_theme.dart';
import 'package:vintiora/core/utils/constants.dart';
import 'package:vintiora/core/utils/utils.dart';

class EnhancedProductGallery extends StatefulWidget {
  final String image;
  final List<String> images;
  final String productName;
  final double defaultDiscount;
  final int defaultQuantity;
  final String stockStatus;
  final bool isNewArrival;
  final String heroTag;

  const EnhancedProductGallery({
    super.key,
    required this.image,
    required this.images,
    required this.productName,
    required this.defaultDiscount,
    required this.defaultQuantity,
    required this.stockStatus,
    required this.isNewArrival,
    required this.heroTag,
  });

  @override
  State<EnhancedProductGallery> createState() => _EnhancedProductGalleryState();
}

class _EnhancedProductGalleryState extends State<EnhancedProductGallery> {
  late PageController _pageController;
  late ScrollController _thumbnailController;
  int _currentPage = 0;

  static const double _thumbnailSize = 60.0;
  static const double _thumbnailSpacing = 10.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    _thumbnailController = ScrollController();
    _pageController.addListener(_handleMainPageScroll);
  }

  @override
  void dispose() {
    _pageController.removeListener(_handleMainPageScroll);
    _pageController.dispose();
    _thumbnailController.dispose();
    super.dispose();
  }

  void _handleMainPageScroll() {
    if (!_pageController.hasClients || _pageController.page == null) return;

    final currentPage = _pageController.page!.round();
    if (currentPage != _currentPage) {
      setState(() => _currentPage = currentPage);
      _scrollThumbnailIntoView(currentPage);
    }
  }

  void _scrollThumbnailIntoView(int index) {
    if (!_thumbnailController.hasClients) return;

    final targetPosition = ((_thumbnailSize + _thumbnailSpacing) * index) - (1.sw / 2) + (_thumbnailSize / 2);

    final maxScroll = _thumbnailController.position.maxScrollExtent;
    final scrollTo = targetPosition.clamp(0.0, maxScroll);

    _thumbnailController.animateTo(
      scrollTo,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onThumbnailTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Main Image PageView
        SizedBox(
          height: 250,
          child: Hero(
            tag: widget.heroTag,
            flightShuttleBuilder: (_, animation, __, ___, ____) {
              return FadeTransition(
                opacity: animation,
                child: AppImage(
                  Constants.baseUrl + widget.image,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              );
            },
            child: condition(
              widget.images.isNotEmpty,
              PageView.builder(
                padEnds: true,
                controller: _pageController,
                itemCount: widget.images.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  return _buildProductVariantCard(Constants.baseUrl + widget.images[index]);
                },
              ),
              _buildProductVariantCard(Constants.baseUrl + widget.image),
            ),
          ),
        ),

        SizedBox(height: 8),

        // Thumbnail Gallery
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: _ThumbnailGallery(
            image: widget.image,
            images: widget.images,
            selectedIndex: _currentPage,
            onTap: _onThumbnailTapped,
            scrollController: _thumbnailController,
            thumbnailSize: _thumbnailSize,
            spacing: _thumbnailSpacing,
          ),
        ),
      ],
    );
  }

  Widget _buildProductVariantCard(String image) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: isDark(context) ? AppColors.black4 : AppColors.primary2,
        // color: Colors.white.withAlpha(80),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigate to fullscreen gallery view
                    Nav.push(
                      Routes.gallery,
                      // images: images.map((img) => Constants.baseUrl + img).toList(),
                      // initialIndex: index,
                    );
                  },
                  child: AppImage(
                    image,
                    height: 190,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                badges.Badge(
                  badgeAnimation: const badges.BadgeAnimation.fade(toAnimate: false),
                  badgeStyle: badges.BadgeStyle(
                    badgeColor: Utils.getStockStatusColor(widget.stockStatus),
                    shape: badges.BadgeShape.square,
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(8)),
                  ),
                  badgeContent: Text(
                    '${widget.defaultDiscount.toStringAsFixed(1)}% Off',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                if (widget.isNewArrival)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: badges.Badge(
                      badgeAnimation: const badges.BadgeAnimation.fade(toAnimate: false),
                      badgeStyle: badges.BadgeStyle(
                        badgeColor: Colors.green.shade700,
                        shape: badges.BadgeShape.square,
                      ),
                      badgeContent: const Text(
                        'NEW',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                if (widget.defaultQuantity < 10 && widget.defaultQuantity > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: badges.Badge(
                      badgeAnimation: const badges.BadgeAnimation.fade(toAnimate: false),
                      badgeStyle: badges.BadgeStyle(
                        badgeColor: Theme.of(context).colorScheme.onError,
                        shape: badges.BadgeShape.square,
                      ),
                      badgeContent: Text(
                        'Only ${widget.defaultQuantity} left',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Extracted reusable Thumbnail Gallery widget
class _ThumbnailGallery extends StatelessWidget {
  final String image;
  final List<String> images;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final ScrollController scrollController;
  final double thumbnailSize;
  final double spacing;

  const _ThumbnailGallery({
    required this.image,
    required this.images,
    required this.selectedIndex,
    required this.onTap,
    required this.scrollController,
    required this.thumbnailSize,
    required this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 46,
          decoration: BoxDecoration(
            color: isDark(context) ? AppColors.black4 : AppColors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: condition(
              images.isNotEmpty,
              SingleChildScrollView(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Row(
                  children: List.generate(images.length, (index) {
                    final isSelected = selectedIndex == index;

                    return GestureDetector(
                      onTap: () => onTap(index),
                      child: Container(
                        width: thumbnailSize,
                        height: thumbnailSize,
                        margin: EdgeInsets.only(right: index == images.length - 1 ? 0 : spacing),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected ? (isDark(context) ? AppColors.grey7 : AppColors.grey2) : AppColors.transparent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: ColoredBox(
                                color: AppColors.primary2,
                                child: AppImage(
                                  Constants.baseUrl + images[index],
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                            ),
                            if (isSelected)
                              Positioned(
                                top: 4,
                                right: 4,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.check, color: Colors.white, size: 12),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              Container(
                width: thumbnailSize,
                height: thumbnailSize,
                margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: ColoredBox(
                        color: Colors.white,
                        child: AppImage(
                          Constants.baseUrl + image,
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check, color: Colors.white, size: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
