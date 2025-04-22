import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vintiora/core/router/nav.dart';
import 'package:vintiora/core/router/routes.dart';
import 'package:vintiora/core/theme/app_button_theme.dart';
import 'package:vintiora/core/theme/app_colors.dart';
import 'package:vintiora/core/theme/app_theme.dart';
import 'package:vintiora/core/theme/bloc/theme_bloc.dart';
import 'package:vintiora/core/utils/constants.dart';
import 'package:vintiora/core/utils/extensions.dart';
import 'package:vintiora/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:vintiora/features/main/presentation/widgets/custom_app_bar.dart';
import 'package:vintiora/features/order/presentation/bloc/shipment/shipment_bloc.dart';
import 'package:vintiora/features/product/domain/entities/product.dart';
// import 'package:vintiora/features/product/data/models/responses/product.dart';
import 'package:vintiora/features/product/presentation/bloc/favorite/favs_bloc.dart';
import 'package:vintiora/features/user/presentation/bloc/profile/profile_bloc.dart';
import 'package:vintiora/features/user/presentation/pages/user_profile_edit_page.dart';
import 'package:vintiora/features/user/presentation/widgets/shipping_form_address.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.current) {
      // context.read<ProfileBloc>().add(const ProfileFetch());
      // context.read<FavsBloc>().add(LoadFavs());
      // context.read<ShipmentBloc>().add(GetShipmentDetails());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      if (state.status == ProfileStatus.loading) {
        return _buildShimmerLoading();
      } else if (state.status == ProfileStatus.failure) {
        return _buildShimmerLoading();
      }
      return Scaffold(
        appBar: CustomAppBar(
          title: 'User Profile',
          actions: [
            IconButton(
              icon: FontAwesomeIcons.penFancy.ic,
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return UserProfileEditPage(profile: state.profile!);
                  },
                ),
              ),
            ),
          ],
        ),
        body: buildBody(context, state),
      );
    });
  }

// Build the Shimmers
  Widget _buildShimmerLoading() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return ListView(
      children: [
        _buildShimmerProfileHeader(isDarkMode),
        _buildShimmerAccountInfo(isDarkMode),
        _buildShimmerOrderHistory(isDarkMode),
        _buildShimmerFavoritesSection(isDarkMode),
      ],
    );
  }

  Widget _buildShimmerProfileHeader(bool isDarkMode) {
    return Shimmer.fromColors(
      baseColor: isDarkMode ? AppColors.grey8 : AppColors.grey1,
      highlightColor: isDarkMode ? AppColors.grey6 : AppColors.white4,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        color: isDarkMode ? AppColors.grey7 : AppColors.white1,
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: isDarkMode ? AppColors.grey6 : AppColors.grey1,
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 20,
                    width: double.infinity,
                    color: isDarkMode ? AppColors.grey6 : AppColors.grey1,
                  ),
                  const SizedBox(height: 4.0),
                  Container(
                    height: 15,
                    width: 150,
                    color: isDarkMode ? AppColors.grey6 : AppColors.grey1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerAccountInfo(bool isDarkMode) {
    return Shimmer.fromColors(
      baseColor: isDarkMode ? AppColors.grey8 : AppColors.grey1,
      highlightColor: isDarkMode ? AppColors.grey6 : AppColors.white4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 20,
              width: 200,
              color: isDarkMode ? AppColors.grey6 : AppColors.grey1,
            ),
            const SizedBox(height: 8.0),
            Container(
              height: 40,
              color: isDarkMode ? AppColors.grey6 : AppColors.grey1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerOrderHistory(bool isDarkMode) {
    return Shimmer.fromColors(
      baseColor: isDarkMode ? AppColors.grey8 : AppColors.grey1,
      highlightColor: isDarkMode ? AppColors.grey6 : AppColors.white4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 20,
              width: 200,
              color: isDarkMode ? AppColors.grey6 : AppColors.grey1,
            ),
            const SizedBox(height: 8.0),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Card(
                  color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
                  child: ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      color: isDarkMode ? AppColors.grey6 : AppColors.grey1,
                    ),
                    title: Container(
                      height: 20,
                      width: 150,
                      color: isDarkMode ? AppColors.grey6 : AppColors.grey1,
                    ),
                    subtitle: Container(
                      height: 15,
                      width: 100,
                      color: isDarkMode ? AppColors.grey6 : AppColors.grey1,
                    ),
                    trailing: Container(
                      width: 20,
                      height: 20,
                      color: isDarkMode ? AppColors.grey6 : AppColors.grey1,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerFavoritesSection(bool isDarkMode) {
    return Shimmer.fromColors(
      baseColor: isDarkMode ? AppColors.grey8 : AppColors.grey1,
      highlightColor: isDarkMode ? AppColors.grey6 : AppColors.white4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 20,
              width: 200,
              color: isDarkMode ? AppColors.grey6 : AppColors.grey1,
            ),
            const SizedBox(height: 8.0),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return Card(
                  color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        color: isDarkMode ? AppColors.grey6 : AppColors.grey1,
                      ),
                      const SizedBox(height: 4.0),
                      Container(
                        height: 15,
                        width: 80,
                        color: isDarkMode ? AppColors.grey6 : AppColors.grey1,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  ///

  Widget buildBody(BuildContext context, ProfileState state) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(6, (index) {
          return AnimatedFadeScale(
            delay: Duration(milliseconds: 50 * index),
            child: switch (index) {
              0 => _buildProfileHeader(context, state),
              1 => _buildAccountInfo(context),
              2 => _buildFavoritesSection(context),
              3 => _buildAccountSettings(context),
              4 => _buildHelpSupport(context),
              5 => _buildLogoutButton(context),
              // 6 => _buildOrderHistory(context),
              _ => const SizedBox.shrink(),
            },
          );
        }),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, ProfileState state) {
    final imagePath = state.profile?.profileImage;
    return Container(
      padding: const EdgeInsets.all(16.0).r,
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {},
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: colorScheme(context).tertiary),
                borderRadius: BorderRadius.circular(40),
              ),
              child: AppCircleImage(
                imagePath != null ? '${Constants.baseUrl}$imagePath' : null,
                radius: 40,
                fallbackImage: Constants.imagePlaceholder,
                backgroundColor: colorScheme(context).tertiary.withValues(alpha: 0.1),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Flexible(
            child: SizedBox(
              width: 285.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.profile!.username,
                    maxLines: 2,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    state.profile!.email,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0).r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Account Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8.h),
          BlocBuilder<ShipmentBloc, ShipmentState>(
            builder: (context, state) {
              String? shippingAddress;
              if (state is ShipmentLoaded) {
                shippingAddress = state.shipment.address;
              }
              return ListTile(
                leading: FontAwesomeIcons.mapLocation.ic,
                title: Text('Shipping Address', style: TextStyle(fontSize: 14)),
                subtitle: Text(shippingAddress ?? 'No address specified!', style: TextStyle(fontSize: 14)),
                trailing: FontAwesomeIcons.circleChevronRight.ic,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const ShippingAddressForm();
                    },
                  ),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: FontAwesomeIcons.creditCard.ic,
            title: Text('Payment Methods', style: TextStyle(fontSize: 14)),
            subtitle: Text('Visa **** 1234', style: TextStyle(fontSize: 14)),
            trailing: FontAwesomeIcons.circleChevronRight.ic,
            onTap: () {
              // Navigate to Manage Payment Methods page
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0).r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Favorites', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8.h),
          BlocBuilder<FavsBloc, FavsState>(
            builder: (context, state) {
              if (state.status == FavsStatus.loading) {
                return Center(child: CircularProgressIndicator());
              }

              if (state.status == FavsStatus.error) {
                return Center(child: Text(state.error.toString()));
              }

              final favorites = state.favorites;
              final count = 3;

              return SizedBox(
                height: 165,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: favorites.length < count ? favorites.length + 1 : count + 1,
                  itemBuilder: (context, index) {
                    if (index == (favorites.length < count ? favorites.length : count)) {
                      return SizedBox(
                        width: 150,
                        child: AnimatedFadeScale(
                          delay: Duration(milliseconds: 50 * index),
                          child: Center(
                            child: OutlinedButton(
                              style: AppButtonTheme.activeSelectableButton,
                              onPressed: () => Nav.push(Routes.favorites),
                              child: const Text('View All Favorites', textAlign: TextAlign.center),
                            ),
                          ),
                        ),
                      );
                    }

                    if (index >= favorites.length) {
                      return const SizedBox.shrink();
                    }

                    final product = favorites[index];
                    return SizedBox(
                      width: 135,
                      child: GestureDetector(
                        onTap: () => _viewProductDetails(product),
                        child: AnimatedFadeScale(
                          delay: Duration(milliseconds: 50 * index),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        minWidth: double.infinity,
                                        maxHeight: 90,
                                      ),
                                      child: Hero(
                                        tag: product.id,
                                        transitionOnUserGestures: true,
                                        child: AppImage(
                                          Constants.baseUrl + product.image,
                                          fit: BoxFit.contain,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    product.name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
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
        ],
      ),
    );
  }

  Widget _buildAccountSettings(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0).copyWith(top: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Account Settings', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8.0),
          ListTile(
            leading: Icons.notifications.icon,
            title: const Text('Notification Preferences'),
            onTap: () {
              // Navigate to Notification Preferences page
            },
          ),
          const Divider(),
          ListTile(
            leading: FontAwesomeIcons.language.ic,
            title: const Text('Language & Region'),
            onTap: () {
              // Navigate to Language & Region page
            },
          ),
          const Divider(),
          ListTile(
            leading: FontAwesomeIcons.userSecret.ic,
            title: const Text('Privacy Settings'),
            onTap: () {
              // Navigate to Privacy Settings page
            },
          ),
          const Divider(),
          ListTile(
            leading: FontAwesomeIcons.solidSun.ic,
            title: const Text('App Theme'),
            onTap: () {
              // Navigate to App Theme settings page
              context.read<ThemeBloc>().add(ToggleThemeEvent());
              /*showDialog(
                context: context,
                builder: (context) => ThemeSettingsDialog(),
              );*/
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSupport(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Help & Support', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8.0),
          ListTile(
            leading: Icons.help.icon,
            title: const Text('Help Center'),
            onTap: () {
              // Navigate to Help Center
            },
          ),
          const Divider(),
          ListTile(
            leading: Icons.support.icon,
            title: const Text('Contact Support'),
            onTap: () {
              // Navigate to Contact Support page
            },
          ),
          const Divider(),
          ListTile(
            leading: FontAwesomeIcons.mobileScreen.ic,
            title: Text('App Version'),
            subtitle: Text('Version 1.0.0'),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: SizedBox(
          width: 180,
          height: 46,
          child: ElevatedButton(
            style: AppButtonTheme.defaultElevatedButton,
            onPressed: () {
              _showLogoutDialog(context);
            },
            child: const Text('Logout'),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(LogoutEvent());
                context.read<AuthBloc>().stream.listen((state) {
                  if (state is Unauthenticated) {
                    Nav.navigateAndRemoveUntil(Routes.login);
                  }
                });
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void _viewProductDetails(Product product) {
    Nav.push(Routes.productDetails, arguments: product.id);
    /*Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return ProductDetailScreen(product: product);
      },
    ));*/
  }
}
