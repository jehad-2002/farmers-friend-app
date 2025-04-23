
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For SystemUiOverlayStyle

// --- Constants (Replace with your actual App constants) ---
class AppColors {
  static const Color primary = Color(0xFF4CAF50); // Green shade
  static const Color primaryDark = Color(0xFF388E3C);
  static const Color accent = Color(0xFF8BC34A);
  static const Color background = Color(0xFFF5F5F5); // Light grey background
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textOnPrimary = Colors.white;
  static const Color iconColor = Color(0xFF616161);
  static const Color lightGreenBadge = Color(0xFFDCEDC8); // Light green for "Active"
  static const Color lightGreenBadgeText = Color(0xFF558B2F);
  static const Color lightGreyBadge = Color(0xFFE0E0E0); // Light grey for "Farmer"
  static const Color lightGreyBadgeText = Color(0xFF424242);
  static const Color divider = Color(0xFFE0E0E0);
}

class AppConstant {
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double borderRadius = 12.0;
  static const double avatarRadius = 40.0;
  static const double avatarEditIconSize = 18.0;
}

// --- Main Profile Screen Widget ---
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 4; // Default to Profile tab

  // --- Dummy Data (Replace with actual user data) ---
  final String userName = "جهاد عبد السلام علي محمد الوحيد";
  final String userRole = "admin"; // Or fetch dynamically
  final String userEmail = "qazqazqaz12q@g..."; // Masked or full
  final String userPhone = "0773818200";
  final String? avatarUrl = null; // Use null for placeholder
  final bool isActive = true;
  final bool isFarmer = true;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Add navigation logic based on index here
    // e.g., switch(index) { case 0: Navigator.pushNamed(context, '/home'); ... }
    print("Tapped index: $index");
  }

  @override
  Widget build(BuildContext context) {
    // Set status bar color to match app bar
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Make it transparent
      statusBarIconBrightness: Brightness.dark, // Icons dark on light background
      statusBarBrightness: Brightness.light, // For iOS
    ));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background, // Match scaffold background
        elevation: 0, // No shadow
        title: const Text(
          'My Profile',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.textPrimary),
          onPressed: () {
            // Handle drawer opening or back navigation
          },
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // Make it transparent
          statusBarIconBrightness: Brightness.dark, // Icons dark on light background
          statusBarBrightness: Brightness.light, // For iOS
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppConstant.defaultPadding, vertical: AppConstant.smallPadding),
        children: [
          // --- Profile Header Card ---
          _ProfileHeaderCard(
            avatarUrl: avatarUrl,
            name: userName,
            role: userRole,
            email: userEmail,
            phone: userPhone,
            isFarmer: isFarmer,
            isActive: isActive,
            onEditAvatarTap: () {
              print("Edit Avatar Tapped");
              // Add image picker logic
            },
            onEditProfileTap: () {
              print("Edit Profile Tapped");
              // Navigate to Edit Profile Screen
            },
          ),
          const SizedBox(height: AppConstant.defaultPadding * 1.5),

          // --- Account Section ---
          _SectionTitle(title: 'Account'),
          const SizedBox(height: AppConstant.smallPadding),
          _ProfileMenuItem(
            icon: Icons.shopping_basket_outlined,
            title: 'My Products',
            onTap: () {
              print("My Products Tapped");
              // Navigate to My Products Screen
              // Example: Navigator.push(context, MaterialPageRoute(builder: (_) => ProductListPage(userId: yourUserId)));
            },
          ),
          _ProfileMenuItem(
            icon: Icons.menu_book_outlined, // Or Icons.library_books_outlined
            title: 'My Guidelines',
            onTap: () {
              print("My Guidelines Tapped");
              // Navigate to My Guidelines Screen
            },
          ),
          _ProfileMenuItem(
            icon: Icons.favorite_border,
            title: 'Favorites',
            onTap: () {
              print("Favorites Tapped");
              // Navigate to Favorites Screen
            },
          ),
          const SizedBox(height: AppConstant.defaultPadding * 1.5),

          // --- Preferences Section ---
          _SectionTitle(title: 'Preferences'),
          const SizedBox(height: AppConstant.smallPadding),
          _ProfileMenuItem(
            icon: Icons.settings_outlined,
            title: 'Settings',
            onTap: () {
              print("Settings Tapped");
              // Navigate to Settings Screen
            },
          ),
           const SizedBox(height: AppConstant.defaultPadding), // Add some padding at the bottom
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home), // Optional: different icon when active
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.eco_outlined), // Leaf icon
             activeIcon: Icon(Icons.eco),
            label: 'Crops',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront_outlined), // Market/Store icon
             activeIcon: Icon(Icons.storefront),
            label: 'Market',
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined), // Guide icon
            activeIcon: Icon(Icons.menu_book),
            label: 'Guide',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary, // Color for selected icon and label
        unselectedItemColor: AppColors.iconColor, // Color for unselected items
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Ensures all items are visible and labels shown
        backgroundColor: AppColors.cardBackground, // Background color of the bar
        elevation: 8.0, // Add some elevation/shadow
        showUnselectedLabels: true, // Make sure labels are always shown
         selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500), // Style for selected label
        unselectedLabelStyle: const TextStyle(fontSize: 12), // Style for unselected label
      ),
    );
  }
}


// --- Sub-Widgets ---

// Widget for Section Titles (Account, Preferences)
class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstant.smallPadding),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary.withOpacity(0.8),
        ),
      ),
    );
  }
}

// Widget for Menu Items (My Products, Settings, etc.)
class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card( // Wrap with Card for background and shape
       margin: const EdgeInsets.symmetric(vertical: AppConstant.smallPadding / 2),
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(AppConstant.borderRadius),
       ),
       color: AppColors.cardBackground,
       elevation: 0.5, // Subtle elevation
       child: InkWell( // Use InkWell for tap feedback
         onTap: onTap,
         borderRadius: BorderRadius.circular(AppConstant.borderRadius), // Match card shape
         splashColor: AppColors.primary.withOpacity(0.1),
         highlightColor: AppColors.primary.withOpacity(0.05),
         child: Padding(
           padding: const EdgeInsets.symmetric(
               horizontal: AppConstant.defaultPadding,
               vertical: AppConstant.defaultPadding * 0.85), // Adjust vertical padding
           child: Row(
             children: [
               Icon(icon, color: AppColors.primary, size: 24),
               const SizedBox(width: AppConstant.defaultPadding),
               Expanded(
                 child: Text(
                   title,
                   style: const TextStyle(
                     fontSize: 16,
                     fontWeight: FontWeight.w500,
                     color: AppColors.textPrimary,
                   ),
                 ),
               ),
               const Icon(Icons.chevron_right, color: AppColors.iconColor, size: 24),
             ],
           ),
         ),
       ),
    );
  }
}


// Widget for the main Profile Header section
class _ProfileHeaderCard extends StatelessWidget {
  final String? avatarUrl;
  final String name;
  final String role;
  final String email;
  final String phone;
  final bool isFarmer;
  final bool isActive;
  final VoidCallback onEditAvatarTap;
  final VoidCallback onEditProfileTap;

  const _ProfileHeaderCard({
    Key? key,
    this.avatarUrl,
    required this.name,
    required this.role,
    required this.email,
    required this.phone,
    required this.isFarmer,
    required this.isActive,
    required this.onEditAvatarTap,
    required this.onEditProfileTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0, // Subtle elevation
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstant.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstant.defaultPadding),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Avatar with Edit Button ---
                Stack(
                  children: [
                    CircleAvatar(
                      radius: AppConstant.avatarRadius,
                      backgroundColor: AppColors.background, // Placeholder background
                      backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                      child: avatarUrl == null
                          ? Icon(
                              Icons.person,
                              size: AppConstant.avatarRadius, // Icon size slightly smaller than radius
                              color: AppColors.iconColor.withOpacity(0.6),
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell( // Use InkWell for larger tap area
                        onTap: onEditAvatarTap,
                        customBorder: const CircleBorder(),
                        child: Container(
                           padding: const EdgeInsets.all(AppConstant.smallPadding / 2),
                           decoration: const BoxDecoration(
                             color: AppColors.cardBackground, // White background for edit icon
                             shape: BoxShape.circle,
                             boxShadow: [ // Subtle shadow for depth
                               BoxShadow(
                                 color: Colors.black12,
                                 blurRadius: 4,
                                 offset: Offset(1,1),
                               )
                             ]
                           ),
                           child: const Icon(
                             Icons.edit_outlined,
                             size: AppConstant.avatarEditIconSize,
                             color: AppColors.primary, // Green edit icon
                           ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: AppConstant.defaultPadding),
                // --- Name, Role, Badges ---
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.start, // Good for LTR/RTL consistency
                      ),
                      const SizedBox(height: AppConstant.smallPadding / 2),
                      Text(
                        role,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppConstant.smallPadding),
                      Wrap( // Use Wrap for badges if they might exceed width
                         spacing: AppConstant.smallPadding, // Horizontal space between badges
                         runSpacing: AppConstant.smallPadding / 2, // Vertical space if wraps
                         children: [
                           if (isFarmer)
                            _StatusBadge(
                              text: 'Farmer',
                              backgroundColor: AppColors.lightGreyBadge,
                              textColor: AppColors.lightGreyBadgeText,
                            ),
                           if (isActive)
                             _StatusBadge(
                               text: 'Active',
                               backgroundColor: AppColors.lightGreenBadge,
                               textColor: AppColors.lightGreenBadgeText,
                             ),
                         ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstant.defaultPadding),
            const Divider(color: AppColors.divider, height: 1), // Subtle divider
            const SizedBox(height: AppConstant.defaultPadding),
            // --- Email and Phone ---
            Row(
              children: [
                Expanded(
                  child: _ContactInfoItem(title: 'Email:', value: email),
                ),
                const SizedBox(width: AppConstant.defaultPadding), // Space between Email and Phone
                Expanded(
                  child: _ContactInfoItem(title: 'Phone:', value: phone),
                ),
              ],
            ),
            const SizedBox(height: AppConstant.defaultPadding * 1.5),
            // --- Edit Profile Button ---
            SizedBox(
              width: double.infinity, // Make button full width
              child: ElevatedButton(
                onPressed: onEditProfileTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary, // Button background color
                  foregroundColor: AppColors.textOnPrimary, // Text color
                  padding: const EdgeInsets.symmetric(vertical: AppConstant.defaultPadding * 0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstant.borderRadius),
                  ),
                  elevation: 2.0, // Button elevation
                ),
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper Widget for Email/Phone display
class _ContactInfoItem extends StatelessWidget {
  final String title;
  final String value;

  const _ContactInfoItem({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppConstant.smallPadding / 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis, // Handle long emails/numbers
        ),
      ],
    );
  }
}

// Helper Widget for Status Badges (Farmer, Active)
class _StatusBadge extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;

  const _StatusBadge({
    Key? key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppConstant.smallPadding * 1.2, vertical: AppConstant.smallPadding / 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppConstant.borderRadius * 2), // Make it pill-shaped
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}