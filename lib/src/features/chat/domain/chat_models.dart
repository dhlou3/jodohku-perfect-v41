enum MessageType { text, question, system, meetRequest, meetAccepted }
enum MeetStatus { none, pending, accepted }

class ChatMessage {
  final String id;
  final String senderId;
  final String content;
  final DateTime timestamp;
  final MessageType type;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.content,
    required this.timestamp,
    this.type = MessageType.text,
  });
}

class ChatSession {
  final String id;
  final String memberAId;
  final String memberBId;
  final String? waliId; // PHASE 4: The Guardian Link
  final int currentQuestionIndex; // PHASE 4: 0-30 Taaruf Progress
  final List<ChatMessage> messages;
  final bool isFrozen;
  final MeetStatus meetStatus;

  ChatSession({
    required this.id,
    required this.memberAId,
    required this.memberBId,
    this.waliId,
    this.currentQuestionIndex = 0,
    this.messages = const [],
    this.isFrozen = false,
    this.meetStatus = MeetStatus.none,
  });

  ChatSession copyWith({
    String? waliId,
    int? currentQuestionIndex,
    List<ChatMessage>? messages,
    bool? isFrozen,
    MeetStatus? meetStatus,
  }) {
    return ChatSession(
      id: id,
      memberAId: memberAId,
      memberBId: memberBId,
      waliId: waliId ?? this.waliId,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      messages: messages ?? this.messages,
      isFrozen: isFrozen ?? this.isFrozen,
      meetStatus: meetStatus ?? this.meetStatus,
    );
  }

  factory ChatSession.fromMap(Map<String, dynamic> map, String docId) {
    return ChatSession(
      id: docId,
      memberAId: map['memberA'] ?? '',
      memberBId: map['memberB'] ?? '',
      waliId: map['waliId'],
      currentQuestionIndex: map['currentQuestionIndex'] ?? 0,
      isFrozen: map['isFrozen'] ?? false,
      meetStatus: MeetStatus.values[map['meetStatus'] ?? 0],
      messages: [], // Messages are fetched as subcollection in production
    );
  }
}
