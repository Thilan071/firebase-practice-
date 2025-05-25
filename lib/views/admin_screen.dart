import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock data for flagged posts
  final List<Map<String, dynamic>> _flaggedContent = [
    {
      'id': '1',
      'type': 'message',
      'content':
          'This message contains inappropriate language that violates community guidelines.',
      'reportedBy': 'Sarah Johnson',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'reason': 'Inappropriate content',
    },
    {
      'id': '2',
      'type': 'post',
      'content': 'Join our off-campus party! Alcohol provided for everyone!',
      'reportedBy': 'Mike Smith',
      'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
      'reason': 'Promotes rule violation',
    },
    {
      'id': '3',
      'type': 'message',
      'content': 'I can help you cheat on the exam. DM me for details.',
      'reportedBy': 'Admin System',
      'timestamp': DateTime.now().subtract(const Duration(hours: 8)),
      'reason': 'Academic dishonesty',
    },
  ];

  // Mock data for users
  final List<Map<String, dynamic>> _users = [
    {
      'id': '1',
      'name': 'Alex Johnson',
      'email': 'alex.johnson@example.com',
      'role': 'Student',
      'photoUrl':
          'https://images.unsplash.com/photo-1599566150163-29194dcaad36?ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
    },
    {
      'id': '2',
      'name': 'Sarah Miller',
      'email': 'sarah.miller@example.com',
      'role': 'Student',
      'photoUrl':
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
    },
    {
      'id': '3',
      'name': 'Prof. David Wilson',
      'email': 'david.wilson@example.com',
      'role': 'Faculty',
      'photoUrl':
          'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
    },
    {
      'id': '4',
      'name': 'Emily Thomas',
      'email': 'emily.thomas@example.com',
      'role': 'Moderator',
      'photoUrl':
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
    },
  ];

  // Mock data for feature flags
  final List<Map<String, dynamic>> _featureFlags = [
    {
      'id': '1',
      'name': 'Live Events',
      'description': 'Enable real-time streaming of events',
      'enabled': false,
    },
    {
      'id': '2',
      'name': 'Anonymous Posts',
      'description': 'Allow users to post anonymously in groups',
      'enabled': true,
    },
    {
      'id': '3',
      'name': 'AI Content Moderation',
      'description': 'Use AI to automatically detect inappropriate content',
      'enabled': true,
    },
    {
      'id': '4',
      'name': 'Group Polls',
      'description': 'Allow creating polls in group discussions',
      'enabled': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Moderation'),
            Tab(text: 'Users'),
            Tab(text: 'Features'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildModerationQueue(),
          _buildUserDirectory(),
          _buildFeatureFlags(),
        ],
      ),
    );
  }

  Widget _buildModerationQueue() {
    return _flaggedContent.isEmpty
        ? const Center(child: Text('No flagged content to review'))
        : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _flaggedContent.length,
          itemBuilder: (context, index) {
            final item = _flaggedContent[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            item['type'].toUpperCase(),
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Reported ${_formatTimeAgo(item['timestamp'])}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Reason: ${item['reason']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(item['content'], style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text(
                      'Reported by: ${item['reportedBy']}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _flaggedContent.removeAt(index);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Content approved and retained'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.green,
                            side: const BorderSide(color: Colors.green),
                          ),
                          child: const Text('Approve'),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _flaggedContent.removeAt(index);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Content rejected and removed'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('Reject'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
  }

  Widget _buildUserDirectory() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search users...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _users.length,
            itemBuilder: (context, index) {
              final user = _users[index];
              final bool isModerator = user['role'] == 'Moderator';

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user['photoUrl']),
                ),
                title: Text(user['name']),
                subtitle: Text('${user['email']} • ${user['role']}'),
                trailing: TextButton(
                  onPressed: () {
                    // Toggle moderator status
                    setState(() {
                      user['role'] = isModerator ? 'Student' : 'Moderator';
                    });
                  },
                  style: TextButton.styleFrom(
                    backgroundColor:
                        isModerator
                            ? Colors.red[50]
                            : AppTheme.primaryColor.withOpacity(0.1),
                  ),
                  child: Text(
                    isModerator ? 'Remove Mod' : 'Make Mod',
                    style: TextStyle(
                      color: isModerator ? Colors.red : AppTheme.primaryColor,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureFlags() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _featureFlags.length,
      itemBuilder: (context, index) {
        final feature = _featureFlags[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: SwitchListTile(
            title: Text(
              feature['name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(feature['description']),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color:
                        feature['enabled']
                            ? Colors.green[50]
                            : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    feature['enabled'] ? 'Enabled' : 'Disabled',
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          feature['enabled']
                              ? Colors.green[700]
                              : Colors.grey[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            value: feature['enabled'],
            activeColor: AppTheme.primaryColor,
            onChanged: (bool value) {
              setState(() {
                feature['enabled'] = value;
              });
            },
          ),
        );
      },
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
