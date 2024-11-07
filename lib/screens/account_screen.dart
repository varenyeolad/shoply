import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoply/Firebase/firebase_auth.dart';
import 'package:shoply/constants/routes.dart';
import 'package:shoply/provider/app_provider.dart';
import 'package:shoply/screens/change_password.dart';
import 'package:shoply/screens/edit_profile.dart';
import 'package:shoply/screens/favourate_screen.dart';
import 'package:shoply/screens/order_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Account",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Profile Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildProfileAvatar(appProvider),
                const SizedBox(height: 10),
                _buildProfileName(appProvider),
                _buildProfileEmail(appProvider),
              ],
            ),
          ),
          const Divider(thickness: 1, color: Colors.grey),
          // Account Menu
          Expanded(
            child: ListView(
              children: [
                _buildCustomListTile(
                  title: "Orders",
                  icon: Icons.shopping_bag_outlined,
                  onTap: () {
                    Routes().push(const OrderScreen(), context);
                  },
                ),
                _buildCustomListTile(
                  title: "Favourites",
                  icon: Icons.favorite_outline,
                  onTap: () {
                    Routes().push(const FavourateScreen(), context);
                  },
                ),
                _buildCustomListTile(
                  title: "Edit Profile",
                  icon: Icons.edit,
                  onTap: () {
                    Routes().push(const EditProfile(), context);
                  },
                ),
                _buildCustomListTile(
                  title: "Change Password",
                  icon: Icons.security_outlined,
                  onTap: () {
                    Routes().push(const ChangePassword(), context);
                  },
                ),
                _buildCustomListTile(
                  title: "About Us",
                  icon: Icons.info_outline,
                  onTap: () {},
                ),
                _buildCustomListTile(
                  title: "Support",
                  icon: Icons.support_agent,
                  onTap: () {},
                ),
                const Divider(thickness: 1, color: Colors.grey),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    "Sign Out",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                  onTap: () {
                    FirebaseAuthHelper.instance.signOut();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar(AppProvider appProvider) {
    return CircleAvatar(
      radius: 40,
      backgroundImage: appProvider.getUserInformation.image != null
          ? NetworkImage(appProvider.getUserInformation.image!)
          : null,
      child: appProvider.getUserInformation.image == null
          ? const Icon(Icons.person, size: 40, color: Colors.grey)
          : null,
    );
  }

  Widget _buildProfileName(AppProvider appProvider) {
    return Text(
      appProvider.getUserInformation.name,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildProfileEmail(AppProvider appProvider) {
    return Text(
      appProvider.getUserInformation.email,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black54,
      ),
    );
  }

  Widget _buildCustomListTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
      onTap: onTap,
    );
  }
}
