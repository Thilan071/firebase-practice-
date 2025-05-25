import 'package:flutter/material.dart';
import '../widgets/event_card.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['All', 'My Groups', 'Featured'];

  // Mock data for events
  final List<Map<String, dynamic>> _events = [
    {
      'id': '1',
      'title': 'End of Semester Party',
      'groupName': 'Student Council',
      'imageUrl':
          'https://images.unsplash.com/photo-1540039155733-5bb30b53aa14?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
      'date': DateTime.now().add(const Duration(days: 3)),
    },
    {
      'id': '2',
      'title': 'Mobile App Development Workshop',
      'groupName': 'Tech Club',
      'imageUrl':
          'https://images.unsplash.com/photo-1551739440-5dd934d3a94a?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
      'date': DateTime.now().add(const Duration(days: 1)),
    },
    {
      'id': '3',
      'title': 'Campus Photography Exhibition',
      'groupName': 'Photography Club',
      'imageUrl':
          'https://images.unsplash.com/photo-1554941829-202a0b2403b8?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
      'date': DateTime.now().add(const Duration(days: 7)),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CampusConnect'),
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
          // Filter tabs
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedFilterIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFilterIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? AppTheme.primaryColor
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color:
                            isSelected
                                ? AppTheme.primaryColor
                                : Colors.grey[300]!,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _filters[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[700],
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Event list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 80),
              itemCount: _events.length,
              itemBuilder: (context, index) {
                final event = _events[index];
                return EventCard(
                  title: event['title'],
                  groupName: event['groupName'],
                  imageUrl: event['imageUrl'],
                  date: event['date'],
                  onTap: () {
                    // TODO: Navigate to event details
                  },
                  onRsvp: () {
                    // TODO: Handle RSVP
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('RSVP\'d to ${event['title']}'),
                        backgroundColor: AppTheme.accentColor,
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
          // TODO: Navigate to create event screen
        },
        backgroundColor: AppTheme.accentColor,
        heroTag: 'homeScreenFAB', // Adding unique hero tag
        child: const Icon(Icons.add),
      ),
    );
  }
}
