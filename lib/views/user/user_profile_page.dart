import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/user_avatar.png'), // Replace with user image
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'John Doe', // Replace with user's name
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'johndoe@example.com', // Replace with user's email
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Handle edit profile
                    },
                    child: const Text('Edit Profile'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Account Information Section
            Text(
              'Account Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            ListTile(
              title: const Text('Shipping Address'),
              subtitle: const Text('1234 Street, City, Country'), // Replace with actual address
              trailing: const Icon(Icons.edit),
              onTap: () {
                // Handle address edit
              },
            ),
            ListTile(
              title: const Text('Payment Method'),
              subtitle: const Text('Visa **** 4242'), // Replace with actual payment method
              trailing: const Icon(Icons.edit),
              onTap: () {
                // Handle payment method edit
              },
            ),
            const SizedBox(height: 20),

            // Order History Section
            Text(
              'Order History',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            ListTile(
              leading: Image.asset('assets/images/wine-1.png', width: 50, height: 50), // Replace with wine image
              title: const Text('Order #12345'),
              subtitle: const Text('Delivered on 12 Aug 2024'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                // Handle view order details
              },
            ),
            ListTile(
              leading: Image.asset('assets/images/wine-2.png', width: 50, height: 50),
              title: const Text('Order #12346'),
              subtitle: const Text('Shipped on 10 Aug 2024'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                // Handle view order details
              },
            ),
            TextButton(
              onPressed: () {
                // Handle view all orders
              },
              child: const Text('View All Orders'),
            ),
            const SizedBox(height: 20),

            // Favorites Section
            Text(
              'Favorites',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildFavoriteItem('assets/images/wine-3.png', 'Red Wine'),
                _buildFavoriteItem('assets/images/wine-4.png', 'White Wine'),
              ],
            ),
            TextButton(
              onPressed: () {
                // Handle browse more wines
              },
              child: const Text('Browse More Wines'),
            ),
            const SizedBox(height: 20),

            // Settings Section
            Text(
              'Settings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SwitchListTile(
              title: const Text('Receive Notifications'),
              value: true, // Replace with actual state
              onChanged: (bool value) {
                // Handle notification toggle
              },
            ),
            ListTile(
              title: const Text('Language & Region'),
              subtitle: const Text('English (US)'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                // Handle language and region settings
              },
            ),
            ListTile(
              title: const Text('Privacy Settings'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                // Handle privacy settings
              },
            ),
            ListTile(
              title: const Text('App Theme'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                // Handle theme settings
              },
            ),
            const SizedBox(height: 20),

            // Logout Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle logout
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Logout button color
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                ),
                child: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build favorite items
  Widget _buildFavoriteItem(String imagePath, String title) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, width: 60, height: 60),
          const SizedBox(height: 10),
          Text(title),
        ],
      ),
    );
  }
}
