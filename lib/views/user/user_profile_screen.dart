import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        //backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to Edit Profile page
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            _buildProfileHeader(context),

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
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.deepPurple.shade50,
      child: Row(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage('assets/profile_picture.png'), // Placeholder image
          ),
          const SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Kenneth Amadi',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4.0),
              Text(
                'kenresoft@gmail.com',
                style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Account Information', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8.0),
          ListTile(
            leading: const Icon(Icons.location_on, color: Colors.deepPurple),
            title: const Text('Shipping Address'),
            subtitle: const Text('123 Main St, Springfield, IL'),
            trailing: const Icon(Icons.edit),
            onTap: () {
              // Navigate to Manage Addresses page
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.credit_card, color: Colors.deepPurple),
            title: const Text('Payment Methods'),
            subtitle: const Text('Visa **** 1234'),
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
          const Text('Order History', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8.0),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 3, // Example: Show the last 3 orders
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: Image.asset('assets/images/wine-${index + 1}.png', width: 50, height: 50),
                  // Placeholder image
                  title: Text('Order #${index + 1}'),
                  subtitle: const Text('Delivered on 12 Aug, 2024'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to Order Details page
                  },
                ),
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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Favorites', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8.0),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              //childAspectRatio: 2 / 3,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemCount: 4,
            // Example: Show the last 4 favorites
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // Navigate to Wine Details page
                },
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/wine-${index + 1}.png',
                        fit: BoxFit.contain,
                        width: 60,
                        height: 60,
                      ),
                      const SizedBox(height: 4.0),
                      Text('Wine ${index + 1}', style: const TextStyle(fontSize: 16.0)),
                    ],
                  ),
                ) /*Column(
                  children: [
                    Expanded(
                      child: Image.asset('assets/images/wine-${index + 1}.png', fit: BoxFit.cover),
                    ),
                    const SizedBox(height: 4.0),
                    Text('Wine ${index + 1}', style: const TextStyle(fontSize: 16.0)),
                  ],
                )*/
                ,
              );
            },
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
                Navigator.of(context).pop();
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
