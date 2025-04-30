import 'package:flutter/material.dart';
import '../models/user_preferences.dart';

class UserPreferencesScreen extends StatefulWidget {
  const UserPreferencesScreen({super.key});

  @override
  State<UserPreferencesScreen> createState() => _UserPreferencesScreenState();
} 

class _UserPreferencesScreenState extends State<UserPreferencesScreen> {
  final List<String> skinOption = ['Oleosa', 'Seca', 'Mista', 'Sensível', 'Acneica'];
  final List<String> allergyOption = ['Fragrância', 'Álcool', 'Parabenos'];
  final List <String> makeupOption = ['Natural', 'Dia a Dia', 'Glam', 'Noite'];

  final List<String> selectedSkin = [];
  final List<String> selectedAllergies = [];
  final List<String> selectedMakeup = [];

  void toggleSelection(List<String> list, String value) {
    setState(() {
      list.contains(value) ? list.remove(value) : list.add(value);
    });
  }

  void submit() {
    final preferences = UserPreferences(
      skinTypes: selectedSkin, 
      allergies: selectedAllergies,
      makeupStyles: selectedMakeup,
    );

    Navigator.pushNamed(context, '/recommendation', arguments: preferences);
  }

  Widget buildChips (List<String> option, List <String> selectedList) {
    return Wrap(
      spacing: 8,
      children: option.map((option) {
        final selected = selectedList.contains(option);
        return FilterChip(
          label: Text(option),
          selected: selected,
          onSelected: (_) => toggleSelection(selectedList, option),
          selectedColor: Colors.pinkAccent.shade100,
        );  
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Suas Preferências')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text('Tipo de pele:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            buildChips(skinOption, selectedSkin),
            const SizedBox(height: 16),
            const Text('Alergias:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            buildChips(allergyOption, selectedAllergies),
            const SizedBox(height: 16),
            const Text('Estilo de Maquiagem:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            buildChips(makeupOption, selectedMakeup),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: submit,
              child: const Text('Receber recomendaçoes'),
            ),
          ],
        ),
      ),
    );
  }
}