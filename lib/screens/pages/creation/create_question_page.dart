import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateQuestionPage extends StatefulWidget {
  const CreateQuestionPage({Key? key}) : super(key: key);

  @override
  State<CreateQuestionPage> createState() => _CreateQuestionPageState();
}

class _CreateQuestionPageState extends State<CreateQuestionPage> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _themeNameController = TextEditingController();
  final _themeDescController = TextEditingController();
  bool _isCorrect = false;
  String? _selectedThemeId;
  bool _isCreatingNewTheme = false;

  Future<void> _submitQuestion() async {
    if (_formKey.currentState!.validate()) {
      try {
        String themeId = _selectedThemeId ?? '';

        if (_isCreatingNewTheme) {
          final themeDoc = await FirebaseFirestore.instance.collection('themes').add({
            'name': _themeNameController.text,
            'description': _themeDescController.text,
          });
          themeId = themeDoc.id;

          // Réinitialiser la création de nouveau thème
          setState(() {
            _isCreatingNewTheme = false;
            _themeNameController.clear();
            _themeDescController.clear();
          });
        }

        await FirebaseFirestore.instance.collection('questions').add({
          'questionText': _questionController.text,
          'isCorrect': _isCorrect,
          'link': _imageUrlController.text,
          'themeId': themeId,
        });

        // Réinitialiser le formulaire pour une nouvelle question
        _questionController.clear();
        _imageUrlController.clear();
        setState(() {
          _isCorrect = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Question ajoutée avec succès!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvelle Question'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Terminer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SwitchListTile(
                title: const Text('Créer un nouveau thème'),
                value: _isCreatingNewTheme,
                onChanged: (value) {
                  setState(() {
                    _isCreatingNewTheme = value;
                    _selectedThemeId = null;
                  });
                },
              ),
              const SizedBox(height: 16),
              if (_isCreatingNewTheme) ...[
                TextFormField(
                  controller: _themeNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nom du thème',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                  value?.isEmpty ?? true ? 'Champ requis' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _themeDescController,
                  decoration: const InputDecoration(
                    labelText: 'Description du thème',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                  validator: (value) =>
                  value?.isEmpty ?? true ? 'Champ requis' : null,
                ),
              ] else
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('themes')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }

                    final themes = snapshot.data!.docs;

                    return DropdownButtonFormField<String>(
                      value: _selectedThemeId,
                      hint: const Text('Sélectionner un thème'),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: themes.map((theme) {
                        return DropdownMenuItem(
                          value: theme.id,
                          child: Text(theme.get('name')),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedThemeId = value;
                        });
                      },
                      validator: (value) =>
                      value == null ? 'Sélectionnez un thème' : null,
                    );
                  },
                ),
              const SizedBox(height: 24),
              const Text('Question:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _questionController,
                decoration: const InputDecoration(
                  hintText: 'Entrez votre question',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value?.isEmpty ?? true ? 'Champ requis' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'URL de l\'image',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value?.isEmpty ?? true ? 'Champ requis' : null,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('La réponse est-elle vraie?'),
                value: _isCorrect,
                onChanged: (bool value) {
                  setState(() {
                    _isCorrect = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _submitQuestion,
                  child: const Text('Ajouter la question'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _questionController.dispose();
    _imageUrlController.dispose();
    _themeNameController.dispose();
    _themeDescController.dispose();
    super.dispose();
  }
}
