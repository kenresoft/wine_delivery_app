import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wine_delivery_app/views/user/theme_dialog.dart';

import '../../bloc/navigation/bottom_navigation_bloc.dart';
import '../../bloc/product/favorite/favs/favs_bloc.dart';
import '../../bloc/profile/profile_bloc.dart';
import '../../bloc/shipment/shipment_bloc.dart';
import '../../repository/auth_repository.dart';
import '../../utils/constants.dart';
import '../auth/login_page.dart';
import '../product/order/shipping_form_address.dart';
import 'user_profile_edit_page.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        if (state != const PageChanged(selectedIndex: 3)) {
          return const Center(child: CircularProgressIndicator());
        } else {
        context.read<ProfileBloc>().add(const ProfileFetch());
        context.read<FavsBloc>().add(LoadFavs());
        context.read<ShipmentBloc>().add(GetShipmentDetails());
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
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit),
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
    });
  }

  ///

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
            Container(
              height: 20,
              width: 200,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 8.0),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      color: Colors.grey[300],
                    ),
                    title: Container(
                      height: 20,
                      width: 150,
                      color: Colors.grey[300],
                    ),
                    subtitle: Container(
                      height: 15,
                      width: 100,
                      color: Colors.grey[300],
                    ),
                    trailing: Container(
                      width: 20,
                      height: 20,
                      color: Colors.grey[300],
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          _buildProfileHeader(context, state),

          // Account Information
          _buildAccountInfo(context),

          // Order History
          _buildOrderHistory(context),

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
    return Container(
      padding: const EdgeInsets.all(16.0).r,
      color: Colors.deepPurple.shade50,
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              /*print('AccessToken: ${await authRepository.getAccessToken()}');
              print('RefreshToken: ${await authRepository.getRefreshToken()}');
              print('AuthStatus: ${await authRepository.checkAuthStatus()}');*/
            },
            child: CircleAvatar(
              radius: 40.r,
              backgroundImage: NetworkImage(Constants.baseUrl + state.profile.profileImage),
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
                    style: TextStyle(fontSize: 20.r, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    state.profile.email,
                    maxLines: 1,
                    style: TextStyle(fontSize: 16.r, color: Colors.grey[600]),
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
          Text('Account Information', style: TextStyle(fontSize: 18.r, fontWeight: FontWeight.bold)),
          SizedBox(height: 8.h),
          BlocBuilder<ShipmentBloc, ShipmentState>(
            builder: (context, state) {
              String? shippingAddress;
              if (state is ShipmentLoaded) {
                shippingAddress = state.shipment.address;
              }
              return ListTile(
                leading: const Icon(Icons.location_on, color: Colors.deepPurple),
                title: Text('Shipping Address', style: TextStyle(fontSize: 14.r)),
                subtitle: Text(shippingAddress ?? 'No address specified!', style: TextStyle(fontSize: 14.r)),
                trailing: const Icon(Icons.edit),
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
            leading: const Icon(Icons.credit_card, color: Colors.deepPurple),
            title: Text('Payment Methods', style: TextStyle(fontSize: 14.r)),
            subtitle: Text('Visa **** 1234', style: TextStyle(fontSize: 14.r)),
            trailing: const Icon(Icons.edit),
            onTap: () {
              // Navigate to Manage Payment Methods page
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOrderHistory(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order History', style: TextStyle(fontSize: 18.r, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8.0),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 3, // Example: Show the last 3 orders
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Image.asset('assets/images/wine-${index + 1}.png', width: 50.r, height: 50.r),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Order #${index + 1}', style: TextStyle(fontSize: 14.r)),
                        Text('Delivered on 12 Aug, 2024', style: TextStyle(fontSize: 14.r)),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 24.r,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 8.0),
          Center(
            child: TextButton(
              onPressed: () {
                // Navigate to full Order History page
              },
              child: const Text('View All Orders', style: TextStyle(color: Colors.deepPurple)),
            ),
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
          Text('Favorites', style: TextStyle(fontSize: 18.r, fontWeight: FontWeight.bold)),
          SizedBox(height: 8.h),
          BlocBuilder<FavsBloc, FavsState>(
            builder: (context, state) {
              return switch (state) {
                FavsInitial() => const Center(child: CircularProgressIndicator()),
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
                    itemCount: state.favs.take(6).length,
                    // Example: Show the last 4 favorites
                    itemBuilder: (context, index) {
                      final favItem = state.favs[index];
                      return GestureDetector(
                        onTap: () {
                          // Navigate to Wine Details page
                        },
                        child: Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/${favItem.image}',
                                // 'assets/images/wine-${index + 1}.png',
                                fit: BoxFit.fitHeight,
                                width: 60.h,
                                height: 60.h,
                              ),
                              SizedBox(height: 4.h),
                              Text(favItem.name, style: TextStyle(fontSize: 16.r)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              };
            },
          ),
          const SizedBox(height: 8.0),
          Center(
            child: TextButton(
              onPressed: () {
                // Navigate to full Favorite page
              },
              child: const Text('View All Favorites', style: TextStyle(color: Colors.deepPurple)),
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
            leading: const Icon(Icons.notifications, color: Colors.deepPurple),
            title: const Text('Notification Preferences'),
            onTap: () {
              // Navigate to Notification Preferences page
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language, color: Colors.deepPurple),
            title: const Text('Language & Region'),
            onTap: () {
              // Navigate to Language & Region page
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.privacy_tip, color: Colors.deepPurple),
            title: const Text('Privacy Settings'),
            onTap: () {
              // Navigate to Privacy Settings page
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.brightness_6, color: Colors.deepPurple),
            title: const Text('App Theme'),
            onTap: () {
              // Navigate to App Theme settings page
              showDialog(
                context: context,
                builder: (context) => ThemeSettingsDialog(),
              );
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
            leading: const Icon(Icons.help, color: Colors.deepPurple),
            title: const Text('Help Center'),
            onTap: () {
              // Navigate to Help Center
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.contact_support, color: Colors.deepPurple),
            title: const Text('Contact Support'),
            onTap: () {
              // Navigate to Contact Support page
            },
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.info_outline, color: Colors.deepPurple),
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
            backgroundColor: Colors.redAccent,
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
                // Perform logout operation
                authRepository.logout().then(
                  (value) {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const LoginPage();
                        },
                      ),
                    );
                  },
                );
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
