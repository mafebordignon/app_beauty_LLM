import 'package:flutter/material.dart';
import '../models/user_preferences.dart';
import '../services/gemini_service.dart';

class RecommendationScreen extends StatefulWidget{
  const RecommendationScreen({super.key});

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  String? recommendation;
  bool loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final prefs = ModalRoute.of(context)!.settings.arguments as UserPreferences;
    getRoutine(prefs);
  }

  Future<void> getRoutine(UserPreferences prefs) async {
    final result = await GeminiService.getRecommendation(prefs);
    setState(() {
      recommendation = result;
      loading = false;
    });
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rotina personalizada')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Text(
                  recommendation ?? 'Nenhuma recomendação gerada.',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
    ));
  }
}