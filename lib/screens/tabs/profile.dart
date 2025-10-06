import 'package:fazr/models/user_model.dart';
import 'package:fazr/providers/user_provider.dart';
import 'package:fazr/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _isUploading = false;

  /// Handles picking an image, uploading it, and updating the state.
  Future<void> handleAvatarTap() async {
    final userProvider = context.read<UserProvider>();
    final user = userProvider.user;

    if (user == null || _isUploading) return;

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
    );

    if (image == null || !mounted) return;

    setState(() => _isUploading = true);

    try {
      final String? downloadUrl = await uploadAvatar(image, user.id);

      if (downloadUrl != null && mounted) {
        // IMPORTANT: Also save this URL to your user's document in Firestore!
        // For example: await DatabaseService().updateUserAvatar(user.id, downloadUrl);
        userProvider.updateUserAvatar(downloadUrl);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image upload failed. Please try again.'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    UserModel? user = context.watch<UserProvider>().user;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- USER INFO AND AVATAR SECTION ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello,',
                        style: TextStyle(color: colors.primary, fontSize: 20),
                      ),
                      Text(
                        user.fullname,
                        style: TextStyle(
                          height: 0.9,
                          color: colors.secondary,
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: TextStyle(
                          color: colors.primary.withOpacity(0.7),
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: _isUploading ? null : handleAvatarTap,
                  child: CircleAvatar(
                    backgroundColor: colors.primary,
                    radius: 40,
                    backgroundImage:
                        (user.avatar != null && user.avatar!.isNotEmpty)
                        ? NetworkImage(user.avatar!)
                        : null,
                    child: _isUploading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.0,
                          )
                        : (user.avatar == null || user.avatar!.isEmpty)
                        ? Text(
                            user.fullname.isNotEmpty
                                ? user.fullname[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.primary, width: .5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        'Edit profile',
                        style: TextStyle(fontSize: 16, color: colors.primary),
                      ),
                      onTap: () {},
                    ),
                    Divider(height: 1, thickness: .5, color: colors.primary),
                    ListTile(
                      title: Text(
                        'Notification',
                        style: TextStyle(color: colors.primary, fontSize: 16),
                      ),
                      onTap: () {},
                    ),
                    Divider(height: 1, thickness: .5, color: colors.primary),
                    ListTile(
                      title: Text(
                        'Logout',
                        style: TextStyle(color: colors.error, fontSize: 16),
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // --- DELETE ACCOUNT SECTION ---
            InkWell(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.error),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Delete Account',
                        style: TextStyle(color: colors.error, fontSize: 16),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.delete_outline_rounded,
                        color: colors.error,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
