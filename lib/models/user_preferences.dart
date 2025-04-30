class UserPreferences {
  List<String> skinTypes;
  List<String> allergies;
  List<String> makeupStyles;

  UserPreferences({
    required this.skinTypes,
    required this.allergies,
    required this.makeupStyles,
  });

  @override
  String toString() {
    return 'Tipo de pele: ${skinTypes.join(', ')}\n'
            'Alergias: ${allergies.join(', ')}\n'
            'Estilo de maquiagem: ${makeupStyles.join(', ')}';
  }
}