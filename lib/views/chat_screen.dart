import 'package:flutter/material.dart';
import '../widgets/chat_bubble.dart';
import '../theme/app_theme.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Mock data for conversations
  final List<Map<String, dynamic>> _conversations = [
    {
      'id': '1',
      'name': 'Tech Club',
      'isGroup': true,
      'lastMessage': 'Meeting tomorrow at 5PM',
      'unreadCount': 2,
      'imageUrl':
          'https://images.unsplash.com/photo-1517430816045-df4b7de11d1d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1350&q=80',
      'isOnline': false,
    },
    {
      'id': '2',
      'name': 'Sarah Johnson',
      'isGroup': false,
      'lastMessage': 'Did you finish the assignment?',
      'unreadCount': 0,
      'imageUrl':
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
      'isOnline': true,
    },
    {
      'id': '3',
      'name': 'Photography Club',
      'isGroup': true,
      'lastMessage': 'New photo challenge this weekend!',
      'unreadCount': 5,
      'imageUrl':
          'https://images.unsplash.com/photo-1554941829-202a0b2403b8?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
      'isOnline': false,
    },
    {
      'id': '4',
      'name': 'Mike Smith',
      'isGroup': false,
      'lastMessage': 'Are you going to the party?',
      'unreadCount': 1,
      'imageUrl':
          'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      'isOnline': true,
    },
  ];

  // Mock data for messages in active chat
  final List<Map<String, dynamic>> _messages = [
    {
      'id': '1',
      'senderId': 'other1',
      'senderName': 'Sarah Johnson',
      'senderPhotoUrl':
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
      'message': 'Hi there! How are you doing?',
      'timestamp': DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      'imageUrl': null,
    },
    {
      'id': '2',
      'senderId': 'me',
      'senderName': 'Me',
      'senderPhotoUrl': null,
      'message': 'Hey! I\'m good, working on the project.',
      'timestamp': DateTime.now().subtract(
        const Duration(days: 1, hours: 1, minutes: 45),
      ),
      'imageUrl': null,
    },
    {
      'id': '3',
      'senderId': 'other1',
      'senderName': 'Sarah Johnson',
      'senderPhotoUrl':
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
      'message': 'Great! Did you finish the assignment?',
      'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
      'imageUrl': null,
    },
    {
      'id': '4',
      'senderId': 'me',
      'senderName': 'Me',
      'senderPhotoUrl': null,
      'message': 'Almost done. Just need to add some final touches.',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
      'imageUrl': null,
    },
    {
      'id': '5',
      'senderId': 'other1',
      'senderName': 'Sarah Johnson',
      'senderPhotoUrl':
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
      'message': 'Here\'s a screenshot of my work so far:',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 15)),
      'imageUrl':
          'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1350&q=80',
    },
  ];

  bool _isInConversationList = true;
  Map<String, dynamic>? _selectedConversation;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'id': '${_messages.length + 1}',
        'senderId': 'me',
        'senderName': 'Me',
        'senderPhotoUrl': null,
        'message': _messageController.text.trim(),
        'timestamp': DateTime.now(),
        'imageUrl': null,
      });
      _messageController.clear();
    });

    // Scroll to the bottom of the chat
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _openConversation(Map<String, dynamic> conversation) {
    setState(() {
      _selectedConversation = conversation;
      _isInConversationList = false;
    });
  }

  void _goBackToConversationList() {
    setState(() {
      _isInConversationList = true;
      _selectedConversation = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            _isInConversationList
                ? const Text('Chats')
                : Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(
                        _selectedConversation!['imageUrl'],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _selectedConversation!['name'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_selectedConversation!['isOnline'])
                          const Text(
                            'Online',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
        leading:
            _isInConversationList
                ? null
                : IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _goBackToConversationList,
                ),
        actions: [
          if (!_isInConversationList)
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                // TODO: Show chat options
              },
            ),
        ],
      ),
      body:
          _isInConversationList
              ? _buildConversationsList()
              : _buildChatScreen(),
    );
  }

  Widget _buildConversationsList() {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: _conversations.length,
      separatorBuilder:
          (context, index) => const Divider(height: 1, indent: 72),
      itemBuilder: (context, index) {
        final conversation = _conversations[index];
        return ListTile(
          onTap: () => _openConversation(conversation),
          leading: Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(conversation['imageUrl']),
              ),
              if (conversation['isOnline'])
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 12,
                    width: 12,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
            ],
          ),
          title: Text(
            conversation['name'],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            conversation['lastMessage'],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing:
              conversation['unreadCount'] > 0
                  ? Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppTheme.accentColor,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${conversation['unreadCount']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  )
                  : const Text(
                    '10:30 AM',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
        );
      },
    );
  }

  Widget _buildChatScreen() {
    return Column(
      children: [
        // Message list
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              final isMe = message['senderId'] == 'me';

              return ChatBubble(
                message: message['message'],
                isMe: isMe,
                senderName: message['senderName'],
                senderPhotoUrl: message['senderPhotoUrl'],
                timestamp: message['timestamp'],
                imageUrl: message['imageUrl'],
              );
            },
          ),
        ),

        // Message input
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.attach_file),
                color: Colors.grey[600],
                onPressed: () {
                  // TODO: Implement attachment functionality
                },
              ),
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: AppTheme.primaryColor,
                radius: 24,
                child: IconButton(
                  icon: const Icon(Icons.send),
                  color: Colors.white,
                  onPressed: _sendMessage,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
