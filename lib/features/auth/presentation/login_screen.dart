import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_controller.dart'; 

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ref.read(authControllerProvider.notifier).signIn(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
    }
  }

  String _getDisplayErrorMessage(Object error) {
    String rawMessage = error.toString();
    if (error is FirebaseAuthException) {
      return 'Giriş Hatası [Error]: ${error.code}';
    } else if (rawMessage.contains(']')) {
        rawMessage = rawMessage.split(']').last.trim();
    }
    return 'Hata [Error]: $rawMessage';
  }


  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    ref.listen<AsyncValue<User?>>(authControllerProvider, (previous, next) {
      if (next.hasError) {
        final message = _getDisplayErrorMessage(next.error!);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message, style: const TextStyle(color: Colors.white)),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      } else if (next.value != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Giriş Başarılı [Login Successful]!'), backgroundColor: Colors.green),
        );
      }
    });

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.flash_on, size: 80, color: Colors.deepPurple),
                const SizedBox(height: 16),
                
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                    children: const [
                      TextSpan(text: 'Vision AI Giriş '),
                      TextSpan(
                        text: '[Login]',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal), 
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 48),

                // E-posta 
                TextFormField(
                  controller: emailController,
                  validator: (value) => value == null || value.isEmpty ? 'Email alanı zorunludur [required].' : null,
                  decoration: const InputDecoration(
                    labelText: 'E-posta [Email]',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                
                // Şifre 
                TextFormField(
                  controller: passwordController,
                  validator: (value) => value == null || value.isEmpty ? 'Şifre alanı zorunludur [required].' : null,
                  decoration: const InputDecoration(
                    labelText: 'Şifre [Password]',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 32),
                
                // Giriş 
                SizedBox(
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: authState.isLoading ? null : _submit,
                    icon: authState.isLoading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.login),
                    label: Text(
                      authState.isLoading ? 'Giriş Yapılıyor... [Logging in...]' : 'Giriş Yap [Login]',
                      style: const TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                // Kayıt Ol 
                TextButton(
                  onPressed: authState.isLoading ? null : () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Kayıt Ekranına yönlendiriliyor [Navigating to Sign Up]...'), duration: Duration(seconds: 1)),
                    );
                  },
                  child: const Text('Hesabın yok mu? Kayıt Ol [Sign Up]', style: TextStyle(color: Colors.deepPurple)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}