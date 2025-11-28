import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../data/auth_repository.dart'; 

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<User?>>((ref) {
  return AuthController(ref.watch(authRepositoryProvider));
});


class AuthController extends StateNotifier<AsyncValue<User?>> {
  final AuthRepository _authRepository;

  AuthController(this._authRepository) : super(const AsyncValue.data(null)) {
    
    _authRepository.authStateChanges.listen((user) {
      state = AsyncValue.data(user);
    });
  }

  
  Future<void> signUp(String email, String password) async {
    state = const AsyncValue.loading(); 
    try {
     
      await _authRepository.signUp(email, password);
      
    } catch (e, st) {
      state = AsyncValue.error(e, st); 
    }
  }

  
  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await _authRepository.signIn(email, password);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  
  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}