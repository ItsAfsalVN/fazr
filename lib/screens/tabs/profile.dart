import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 32,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Text(
                        'Hello,',
                        style: TextStyle(color: colors.primary, fontSize: 20),
                      ),
                      Text(
                        'Afsal VN',
                        style: TextStyle(
                          height: .3,
                          color: colors.secondary,
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'someone@email.com',
                        style: TextStyle(
                          color: colors.primary.withValues(alpha: 0.7),
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis, 
                      ),
                    ],
                  ),
                ),

                CircleAvatar(backgroundColor: colors.primary, radius: 36),
              ],
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.primary, width: .5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Edit profile',
                      style: TextStyle(fontSize: 16, color: colors.primary),
                    ),
                  ),
                  Divider(height: 1, thickness: .5, color: colors.primary),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Notification',
                      style: TextStyle(color: colors.primary, fontSize: 16),
                    ),
                  ),
                  Divider(height: 1, thickness: .5, color: colors.primary),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Logout',
                      style: TextStyle(color: colors.primary, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),

            InkWell(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.error),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 12,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Delete Account',
                        style: TextStyle(color: colors.error, fontSize: 16),
                      ),
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
