
class ChattingController {
  final List<Chat> _chats = [
    Chat(
      user: User(name: 'Role Model'),
      messages: [
        Message(text: 'hey coder', isSent: false),
        Message(text: 'What\'s up?', isSent: false),
        Message(text: 'Wanna hug you babe?', isSent: false),
        Message(text: 'now', isSent: false),
      ],
      unreadCount: 2,
    ),
    Chat(
      user: User(name: 'Luciano'),
      messages: [
        Message(text: 'Hi Alice!'),
        Message(text: 'I\'m doing well, thanks. How about you?', isSent: false),
        Message(
            text:
                'Thank You so much my lovely coding language flutter u never disapoint me'),
      ],
      unreadCount: 0,
    ),
    Chat(
      user: User(name: 'Tamaly'),
      messages: [
        Message(text: 'Hi Alice!'),
        Message(text: 'I\'m doing well, thanks. How about you?'),
        Message(text: 'Never'),
      ],
      unreadCount: 0,
    ),
    Chat(
      user: User(name: 'Maguire'),
      messages: [
        Message(text: 'Hi Alice!'),
        Message(text: 'I\'m doing well, thanks. How about you?'),
        Message(text: 'oy'),
      ],
      unreadCount: 6,
    ),
    Chat(
      user: User(name: 'Wiseman'),
      messages: [
        Message(text: 'Hi Alice!'),
        Message(text: 'I\'m doing well, thanks. How about you?'),
        Message(text: 'coming to early', isSent: false),
      ],
      unreadCount: 0,
    ),
    Chat(
      user: User(name: 'Kahabi'),
      messages: [
        Message(text: 'Hi Alice!'),
        Message(text: 'I\'m doing well, thanks. How about you?'),
        Message(text: 'tcha la mchongo'),
      ],
      unreadCount: 0,
    ),
    Chat(
      user: User(name: 'Mama'),
      messages: [
        Message(text: 'Dogo hujambo', isSent: false),
        Message(text: 'Niko poa habari za huko'),
        Message(
            text: 'fanya mpango uoe kama huwezi kutongoza takusaidia',
            isSent: false),
        Message(
            text: 'ooh dunia inaenda kubaya oa mwanangu kabla ya christmas',
            isSent: false),
      ],
      unreadCount: 0,
    ),
    Chat(
      user: User(name: 'Baba'),
      messages: [
        Message(text: 'Hi Alice!'),
        Message(text: 'I\'m doing well, thanks. How about you?'),
        Message(text: 'dogo unafeli'),
      ],
      unreadCount: 0,
    ),
    Chat(
      user: User(name: 'Harith'),
      messages: [
        Message(text: 'Hi Alice!'),
        Message(text: 'I\'m doing well, thanks. How about you?'),
        Message(text: 'www.shotram.com'),
      ],
      unreadCount: 0,
    ),
    Chat(
      user: User(name: 'Arjati'),
      messages: [
        Message(text: 'Hi Alice!'),
        Message(text: 'I\'m doing well, thanks. How about you?'),
        Message(text: 'shukran'),
      ],
      unreadCount: 0,
    ),
  ];

  List<Chat> get chats => _chats;
  void addMessage(int chatIndex, Message message) {
    _chats[chatIndex].messages.add(message);
    _chats[chatIndex].unreadCount++;
  }

  void markChatAsRead(int chatIndex) {
    _chats[chatIndex].unreadCount = 0;
  }
}

class Chat {
  final User user;
  final List<Message> messages;
  int unreadCount;

  Chat({
    required this.user,
    required this.messages,
    this.unreadCount = 0,
  });
}

class User {
  final String name;

  User({required this.name});
}

class Message {
  final String text;
  final bool isSent;
  Message({required this.text, this.isSent = true});
}


List categories = [
  'New',
  'Chairs',
  'Sofas',
  'Tables',
  'Beds',
  'Doors',
];
