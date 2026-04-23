import 'package:flutter_riverpod/flutter_riverpod.dart';

class Icebreaker {
  final String id;
  final String text;
  final String category; // e.g., 'Faith', 'Family', 'Career', 'Hobbies'

  Icebreaker({required this.id, required this.text, required this.category});
}

class IcebreakerService {
  final List<Icebreaker> _library = [
    Icebreaker(id: '1', text: 'What is your favorite mosque in Malaysia for Friday prayers?', category: 'Faith'),
    Icebreaker(id: '2', text: 'How do you balance your career goals with your faith?', category: 'Career'),
    Icebreaker(id: '3', text: 'What is your favorite family Halal tradition during Hari Raya?', category: 'Family'),
    Icebreaker(id: '4', text: 'If you could travel to any Muslim-majority country, where would you go first?', category: 'Travel'),
    Icebreaker(id: '5', text: 'What are some "deal-breakers" for you when it comes to religious practice?', category: 'Faith'),
    Icebreaker(id: '6', text: 'How do you like to spend your Friday mornings?', category: 'Hobbies'),
  ];

  List<Icebreaker> getIcebreakers() => _library;
  
  List<Icebreaker> getByCategory(String category) => 
      _library.where((i) => i.category == category).toList();
}

final icebreakerServiceProvider = Provider((ref) => IcebreakerService());
