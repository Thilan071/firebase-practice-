import 'package:flutter/material.dart';
import '../widgets/group_tile.dart';
import '../theme/app_theme.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  // Mock data for groups
  final List<Map<String, dynamic>> _groups = [
    {
      'id': '1',
      'name': 'Tech Club',
      'imageUrl':
          'https://images.unsplash.com/photo-1517430816045-df4b7de11d1d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1350&q=80',
      'isMember': true,
    },
    {
      'id': '2',
      'name': 'Photography Club',
      'imageUrl':
          'https://images.unsplash.com/photo-1554941829-202a0b2403b8?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
      'isMember': false,
    },
    {
      'id': '3',
      'name': 'Student Council',
      'imageUrl':
          'https://images.unsplash.com/photo-1540039155733-5bb30b53aa14?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
      'isMember': true,
    },
    {
      'id': '4',
      'name': 'Debate Society',
      'imageUrl':
          'https://images.unsplash.com/photo-1577563908411-5077b6dc7624?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
      'isMember': false,
    },
    {
      'id': '5',
      'name': 'Chess Club',
      'imageUrl':
          'https://images.unsplash.com/photo-1529699211952-734e80c4d42b?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
      'isMember': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groups'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search groups...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                // TODO: Implement search functionality
              },
            ),
          ),

          // Groups list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: _groups.length,
              separatorBuilder:
                  (context, index) => const Divider(height: 1, indent: 72),
              itemBuilder: (context, index) {
                final group = _groups[index];
                return GroupTile(
                  name: group['name'],
                  imageUrl: group['imageUrl'],
                  isMember: group['isMember'],
                  onTap: () {
                    // TODO: Navigate to group details
                  },
                  onToggleMembership: () {
                    setState(() {
                      group['isMember'] = !group['isMember'];
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          group['isMember']
                              ? 'Joined ${group['name']}'
                              : 'Left ${group['name']}',
                        ),
                        backgroundColor:
                            group['isMember']
                                ? AppTheme.primaryColor
                                : Colors.grey[700],
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to create group screen
        },
        backgroundColor: AppTheme.accentColor,
        heroTag: 'groupsScreenFAB', // Adding unique hero tag
        child: const Icon(Icons.add),
      ),
    );
  }
}
