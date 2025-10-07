// lib/components/edit_profile_modal.dart

import 'package:fazr/components/button.dart';
import 'package:fazr/components/input_field.dart';
import 'package:fazr/models/user_model.dart';
import 'package:fazr/providers/user_provider.dart';
import 'package:fazr/services/database_services.dart';
// Make sure you have a utility for showing snackbars
import 'package:fazr/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfileModal extends StatefulWidget {
  const EditProfileModal({super.key});

  @override
  State<EditProfileModal> createState() => _EditProfileModalState();
}

class _EditProfileModalState extends State<EditProfileModal> {
  // 1. Declare the controller without `final`
  late TextEditingController _fullNameController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // 2. Initialize controller with the user's current name
    final user = context.read<UserProvider>().user;
    _fullNameController = TextEditingController(text: user?.fullname ?? '');
  }

  @override
  void dispose() {
    // 3. Always dispose your controllers
    _fullNameController.dispose();
    super.dispose();
  }

  /// Handles the update logic
  Future<void> _handleOnTap() async {
    final userProvider = context.read<UserProvider>();
    final UserModel? user = userProvider.user;
    final newName = _fullNameController.text.trim();

    // 4. Validate input
    if (user == null)
      return; // Should not happen if modal is shown for a logged-in user
    if (newName.isEmpty) {
      showSnackBar(context, SnackBarType.error, "Name cannot be empty.");
      return;
    }
    // Avoids an unnecessary database write if the name hasn't changed
    if (newName == user.fullname) {
      Navigator.pop(context);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 5. Call the database service to update the user
      await updateUserInFirestore(user.id, {'fullname': newName});

      // 6. Update the local user state in the provider for instant UI refresh
      // NOTE: You will need to add the `updateUserName` method to your UserProvider
      userProvider.updateUserName(newName);

      if (mounted) {
        showSnackBar(context, SnackBarType.success, "Profile updated!");
        Navigator.pop(context); // Close the modal on success
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(
          context,
          SnackBarType.error,
          "Update failed. Please try again.",
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.55,
        minChildSize: 0.55,
        maxChildSize: 0.55,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: ListView(
              controller: scrollController,
              children: [
                Text(
                  'Edit Profile',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colors.secondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 24),
                InputField(
                  label: 'Change full name',
                  hint: 'Enter your new full name',
                  controller: _fullNameController,
                ),
                const SizedBox(height: 20),
                Button(
                  label: 'Update Profile',
                  onTap: _handleOnTap,
                  isLoading: _isLoading,
                  borderRadius: 12,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
