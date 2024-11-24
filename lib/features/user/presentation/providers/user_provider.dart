import 'package:fast_toon/features/user/domain/entities/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StateProvider<User>((ref) {
  return User(
    email: 'user@example.com',
    nickname: 'User',
    points: 100,
    isPremiumMember: true,
  );
});
