import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GroupTile extends StatelessWidget {
  final String name;
  final String imageUrl;
  final bool isMember;
  final VoidCallback onTap;
  final VoidCallback onToggleMembership;

  const GroupTile({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.isMember,
    required this.onTap,
    required this.onToggleMembership,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 24,
        backgroundImage: NetworkImage(imageUrl),
        onBackgroundImageError: (_, __) {},
        backgroundColor: Colors.grey[300],
        child:
            imageUrl.isEmpty
                ? Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
                : null,
      ),
      title: Text(
        name,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      trailing: TextButton(
        onPressed: onToggleMembership,
        style: TextButton.styleFrom(
          backgroundColor:
              isMember
                  ? Colors.grey[200]
                  : AppTheme.primaryColor.withOpacity(0.1),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          isMember ? 'Leave' : 'Join',
          style: TextStyle(
            color: isMember ? Colors.red : AppTheme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
