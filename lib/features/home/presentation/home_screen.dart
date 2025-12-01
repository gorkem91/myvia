
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:image_picker/image_picker.dart';

import 'home_controller.dart'; 
import '../../auth/presentation/auth_controller.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  File? _selectedImage;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
     
    }
  }

  @override
  Widget build(BuildContext context) {
    final aiState = ref.watch(homeControllerProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vision AI'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Çıkış Yap [Logout]',
            onPressed: () {
              ref.read(authControllerProvider.notifier).signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(_selectedImage!, fit: BoxFit.contain),
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.photo_library_outlined, size: 64, color: Colors.grey.shade400),
                            const SizedBox(height: 8),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                                children: const [
                                  TextSpan(text: 'Görsel Seçiniz '),
                                  TextSpan(text: '[Select Image]', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              const SizedBox(height: 24),
              
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: pickImage,
                        icon: const Icon(Icons.image),
                        label: const Text('Görsel Seç [Select]'),
                        style: OutlinedButton.styleFrom(
                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        )
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: (_selectedImage != null && !aiState.isLoading)
                            ? () {
                                
                                ref.read(homeControllerProvider.notifier).analyze(_selectedImage!);
                              }
                            : null,
                        icon: aiState.isLoading
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Icon(Icons.auto_awesome),
                        label: Text(
                            aiState.isLoading 
                            ? 'Analiz Ediliyor... [Analyzing...]' 
                            : 'Analiz Et [Analyze]',
                            style: const TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 200), 
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                     BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                  ]
                ),
                child: aiState.when(
                  data: (data) {
                    if (data == null) {
                      return Center(
                        child: Text(
                          'Sonuç alanı [Result Area]', 
                          style: TextStyle(color: Colors.grey.shade500)
                        )
                      );
                    }
                    return MarkdownBody(data: data!);
                  },
                  error: (err, stack) => Center(
                    child: Text('Hata: ${err.toString()} [Error]', style: const TextStyle(color: Colors.red)),
                  ),
                  loading: () => const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Colors.deepPurple),
                        SizedBox(height: 8),
                        Text('Yapay Zeka Düşünüyor... [AI is thinking...]')
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}