import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vintiora/core/router/nav.dart';
import 'package:vintiora/core/router/routes.dart';
import 'package:vintiora/core/theme/app_theme.dart';
import 'package:vintiora/core/utils/constants.dart';
import 'package:vintiora/core/utils/extensions.dart';
import 'package:vintiora/core/utils/utils.dart';
import 'package:vintiora/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:vintiora/features/favorite/favorites_screen.dart';
import 'package:vintiora/features/order/presentation/bloc/shipment/shipment_bloc.dart';
import 'package:vintiora/features/product/data/models/responses/product.dart';
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
      context.read<ProfileBloc>().add(const ProfileFetch());
      context.read<FavsBloc>().add(LoadFavs());
      context.read<ShipmentBloc>().add(GetShipmentDetails());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      return switch (state) {
        ProfileFetching() => _buildShimmerLoading(),
        // ProfileFetching() => const Center(child: CircularProgressIndicator()),
        ProfileError() => _buildShimmerLoading(),
        // ProfileError() => const Center(child: CircularProgressIndicator()),
        // ProfileError() => Center(child: Text(state.error)),
        ProfileLoaded() => Scaffold(
            appBar: AppBar(
              title: const Text('User Profile'),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: FontAwesomeIcons.penFancy.ic,
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return UserProfileEditPage(profile: state.profile);
                      },
                    ),
                  ),
                ),
              ],
            ),
            body: buildBody(context, state),
          ),
      };
    });
  }

  // Build the Shimmers
  Widget _buildShimmerLoading() {
    return ListView(
      children: [
        _buildShimmerProfileHeader(),
        _buildShimmerAccountInfo(),
        _buildShimmerOrderHistory(),
        _buildShimmerFavoritesSection(),
      ],
    );
  }

  Widget _buildShimmerProfileHeader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.grey[200],
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 20,
                    width: double.infinity,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 4.0),
                  Container(
                    height: 15,
                    width: 150,
                    color: Colors.grey[300],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerAccountInfo() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 20,
              width: 200,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 8.0),
            Container(
              height: 40,
              color: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerOrderHistory() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
              width: 200,
            ),
            const SizedBox(height: 8.0),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: SizedBox(
                      width: 50,
                      height: 50,
                    ),
                    title: SizedBox(
                      height: 20,
                      width: 150,
                    ),
                    subtitle: SizedBox(
                      height: 15,
                      width: 100,
                    ),
                    trailing: SizedBox(
                      width: 20,
                      height: 20,
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

  Widget _buildShimmerFavoritesSection() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 20,
              width: 200,
              color: Colors.grey[300],
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 4.0),
                      Container(
                        height: 15,
                        width: 80,
                        color: Colors.grey[300],
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

  Widget buildBody(BuildContext context, ProfileLoaded state) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          _buildProfileHeader(context, state),

          // Account Information
          _buildAccountInfo(context),

          // Order History
          // _buildOrderHistory(context),

          // Favorites
          _buildFavoritesSection(context),

          // Account Settings
          _buildAccountSettings(context),

          // Help & Support
          _buildHelpSupport(context),

          // Logout
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, ProfileLoaded state) {
    final imagePath = state.profile.profileImage;
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
              child: CircleAvatar(
                radius: 40,
                backgroundImage: conditionFunction(
                  imagePath != null,
                  () => NetworkImage('${Constants.baseUrl}$imagePath'),
                  () => AssetImage(Constants.imagePlaceholder),
                ),
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
                    state.profile.username,
                    maxLines: 2,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    state.profile.email,
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
              return switch (state) {
                // FavsLoading() => const Center(child: CircularProgressIndicator()),
                FavsError() => Center(child: Text(state.error)),
                FavsLoaded() => GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 3.5.w / 4.h,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemCount: state.favorites.take(6).length,
                    itemBuilder: (context, index) {
                      final product = state.favorites[index].product;
                      return GestureDetector(
                        onTap: () {
                          // Navigate to Wine Details page
                          _viewProductDetails(product);
                        },
                        child: Card(
                          // color: Colors.red,
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
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image(
                                        image: Utils.networkImage(product.image),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  product.name ?? 'No product',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                _ => SizedBox(),
              };
            },
          ),
          const SizedBox(height: 8.0),
          Center(
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return FavoritesScreen();
                    },
                  ),
                );
              },
              child: const Text('View All Favorites'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSettings(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            // backgroundColor: Colors.redAccent,
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          ),
          onPressed: () {
            _showLogoutDialog(context);
          },
          child: const Text('Logout', style: TextStyle(fontSize: 18.0)),
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
              onPressed: () {
                Navigator.of(context).pop();
              },
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
    Nav.push(Routes.productDetails, arguments: product);
    /*Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return ProductDetailScreen(product: product);
      },
    ));*/
  }
}
