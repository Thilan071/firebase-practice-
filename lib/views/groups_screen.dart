import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/group_tile.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  final AuthService _authService = AuthService();
  String _searchQuery = '';
  String? _errorMessage;
  List<DocumentSnapshot>? _groups;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Check if user is authenticated
    if (_authService.currentUser != null) {
      _loadGroups();
    } else {
      setState(() {
        _errorMessage = 'Please log in to view groups';
        _isLoading = false;
      });
    }
  }

  void _loadGroups() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Print Firebase connection details for debugging
      print('Firebase settings: ${FirebaseFirestore.instance.settings.host}');
      print('Current User ID: ${_authService.currentUser?.uid}');

      // Verify the groups collection exists
      print('Attempting to query groups collection...');

      // Get all documents from the groups collection
      final snapshot =
          await FirebaseFirestore.instance.collection('groups').get();

      print('Query completed. Results: ${snapshot.size} documents');

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          _groups = snapshot.docs;
          _isLoading = false;
        });
        // Print the data for debugging
        print('Groups found: ${snapshot.docs.length}');
        for (var doc in snapshot.docs) {
          final data = doc.data();
          final members = data['members'] ?? [];
          print(
            'Group ID: ${doc.id}, Name: ${data['name']}, Members count: ${members.length}',
          );
          print('Group data: $data');
        }
      } else {
        print(
          'No groups found - attempting to create a test group automatically',
        );

        // Create a test group automatically
        try {
          await _createTestGroupDirectly();
          setState(() {
            _errorMessage = 'Created a test group - try refreshing';
            _isLoading = false;
          });
        } catch (e) {
          setState(() {
            _errorMessage =
                'No groups found and couldn\'t create test group: $e';
            _isLoading = false;
          });
          print('Failed to create test group: $e');
        }
      }
    } catch (e) {
      print('Error loading groups: $e');
      setState(() {
        _errorMessage = 'Error loading groups: $e';
        _isLoading = false;
      });

      // Check specific Firestore error codes
      if (e is FirebaseException) {
        if (e.code == 'permission-denied') {
          print('Permission denied error! Check your Firestore security rules');
          setState(() {
            _errorMessage = 'Permission denied: Check Firebase security rules';
          });
        }
      }
    }
  }

  // Get current user ID
  String? get _currentUserId => _authService.currentUser?.uid;
  // Try to load a specific group
  void _tryLoadSpecificGroup() async {
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('groups')
              .doc('TxkiznfXWzAAdrnVwKDz')
              .get();

      print('Specific group exists: ${doc.exists}');
      if (doc.exists) {
        print('Specific group data: ${doc.data()}');
      }
    } catch (e) {
      print('Error loading specific group: $e');
    }
  }

  // Create a test group directly (for auto-creation)
  Future<void> _createTestGroupDirectly() async {
    print('Creating test group directly...');

    // Create with auto-generated ID
    final docRef = FirebaseFirestore.instance.collection('groups').doc();

    await docRef.set({
      'name': 'Test Group ${DateTime.now().millisecondsSinceEpoch}',
      'imageUrl':
          'https://images.unsplash.com/photo-1529699211952-734e80c4d42b',
      'members': _currentUserId != null ? [_currentUserId] : [],
      'createdAt': Timestamp.now(),
    });

    print('Test group created with ID: ${docRef.id}');
  }

  // Check if the current user is a member of the group
  bool _isMemberOfGroup(Map<String, dynamic> groupData) {
    if (_currentUserId == null || !groupData.containsKey('members')) {
      return false;
    }

    final members = groupData['members'] as List?;
    if (members == null) return false;

    return members.contains(_currentUserId);
  } // Create a test group in Firestore (for debugging)

  void _createTestGroup() async {
    try {
      // Print Firebase connection details for debugging
      print('Firebase settings: ${FirebaseFirestore.instance.settings.host}');
      print('Current user ID: $_currentUserId');

      // Create a new document with auto-generated ID instead of hardcoded ID
      final docRef =
          FirebaseFirestore.instance
              .collection('groups')
              .doc(); // Let Firestore generate an ID

      print('Creating test group with ID: ${docRef.id}');

      // Create the test group
      await docRef.set({
        'name': 'Test Group ${DateTime.now().millisecondsSinceEpoch}',
        'imageUrl':
            'https://images.unsplash.com/photo-1529699211952-734e80c4d42b',
        'members': _currentUserId != null ? [_currentUserId] : [],
        'createdAt': Timestamp.now(),
      });

      print('Test group created successfully');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Test group created successfully'),
          backgroundColor: Colors.green,
        ),
      );

      // Reload the groups
      _loadGroups();
    } catch (e) {
      print('Error creating test group: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating test group: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groups'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              if (_authService.currentUser != null) {
                _loadGroups();
                _tryLoadSpecificGroup(); // Try to load specific group for debugging
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please log in first'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
          // Add a button to create a test group (for debugging with emulator)
          IconButton(
            icon: const Icon(Icons.add_circle),
            onPressed: () {
              _createTestGroup();
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
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Authentication check
          if (_authService.currentUser == null)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'You need to be logged in to view groups',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: const Text('Go to Login'),
                    ),
                  ],
                ),
              ),
            )
          else if (_isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (_errorMessage != null)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _loadGroups();
                      },
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            )
          else if (_groups == null || _groups!.isEmpty)
            const Expanded(child: Center(child: Text('No groups available')))
          else
            // Groups from Firestore
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: _groups!.length,
                separatorBuilder:
                    (context, index) => const Divider(height: 1, indent: 72),
                itemBuilder: (context, index) {
                  final doc = _groups![index];
                  final data = doc.data() as Map<String, dynamic>;

                  final name = data['name'] as String? ?? 'Unnamed Group';

                  // Filter by search query
                  if (_searchQuery.isNotEmpty &&
                      !name.toLowerCase().contains(
                        _searchQuery.toLowerCase(),
                      )) {
                    return const SizedBox.shrink();
                  }

                  final imageUrl = data['imageUrl'] as String? ?? '';
                  final isMember = _isMemberOfGroup(data);

                  return GroupTile(
                    name: name,
                    imageUrl: imageUrl,
                    isMember: isMember,
                    onTap: () {
                      // TODO: Navigate to group details
                    },
                    onToggleMembership: () {
                      if (_currentUserId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'You need to be logged in to join a group',
                            ),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }

                      // Toggle membership status in Firestore
                      final groupRef = FirebaseFirestore.instance
                          .collection('groups')
                          .doc(doc.id);

                      if (isMember) {
                        // Remove user from group members
                        groupRef
                            .update({
                              'members': FieldValue.arrayRemove([
                                _currentUserId,
                              ]),
                            })
                            .catchError((error) {
                              print('Error removing member: $error');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: $error'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            });
                      } else {
                        // Add user to group members
                        groupRef
                            .update({
                              'members': FieldValue.arrayUnion([
                                _currentUserId,
                              ]),
                            })
                            .catchError((error) {
                              print('Error adding member: $error');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: $error'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            });
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isMember ? 'Left $name' : 'Joined $name',
                          ),
                          backgroundColor:
                              !isMember
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
