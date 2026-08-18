import 'package:flutter/material.dart';
import 'package:ahime/config/my_config.dart';
//import 'package:responsive_sizer/responsive_sizer.dart';

// Variables pour stocker les valeurs des champs du formulaire
String? _email;
String? _password;

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  // Utilisation d'une clé pour identifier l'état du formulaire
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey, // Clé utilisée pour accéder à l'état du formulaire
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          txtRecherche,
          //const SizedBox(height: 10),
          // txtMdp(),
          // const SizedBox(height: 20),
          // btnSoumettre(context),
          // const SizedBox(height: 20),
          // btnEffacer(),
          // const SizedBox(height: 20),
          // btnLike,
        ],
      ),
    );
  }

  TextFormField txtMdp() => TextFormField(
        decoration: const InputDecoration(
          //labelText: 'Mot de passe',
          fillColor: Colors.green,
          filled: true,
          hintText: 'Entrez votre mot de passe',
          border: OutlineInputBorder(),
        ),
        obscureText: true, // Cacher le texte
        // Validator pour valider le mot de passe
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Le champ mot de passe est obligatoire';
          } else if (value.length < 6) {
            return 'Le mot de passe doit contenir au moins 6 caractères';
          }
          return null;
        },
        onSaved: (value) {
          _password = value;
        },
      );

  ElevatedButton btnEffacer() => ElevatedButton(
        onPressed: () {
          // Effacer les valeurs des champs du formulaire
          _formKey.currentState!.reset();
        },
        child: const Text('Effacer'),
      );

  ElevatedButton btnSoumettre(BuildContext context) => ElevatedButton(
        onPressed: () {
          // Si le formulaire est valide, afficher un message
          if (_formKey.currentState!.validate()) {
            // Sauvegarder les valeurs du formulaire
            _formKey.currentState!.save();

            // Afficher une boîte de dialogue ou faire une action
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Formulaire soumis"),
                  content: Text("Email : $_email\nMot de passe : $_password"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Email: $_email, Password: $_password'),
              ),
            );
          }
        },
        child: const Text('Soumettre'),
      );
}

ElevatedButton btnLike = ElevatedButton.icon(
  icon: const Icon(Icons.thumb_up),
  label: const Text("Like"),
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
  ),
);

TextFormField txtRecherche = TextFormField(
  decoration: InputDecoration(
    fillColor: Colors.white,
    filled: true,
    hintText: 'Rechercher par mot clé',
    suffixIcon: btnSearch(),
    border: myTextFormBorder(),
    enabledBorder: myTextFormBorder(),
  ),
  // Validator pour valider l'email
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Le champ email est obligatoire';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Entrez un email valide';
    }
    return null; // Le champ est valide
  },
  onSaved: (value) {
    _email = value;
  },
);

OutlineInputBorder myTextFormBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(5.0),
    borderSide: BorderSide(
      color: Colors.grey.withValues(alpha: 0.5),
      width: 1.0,
    ),
  );
}

Container btnSearch() => Container(
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: myColorBlue,
        borderRadius: BorderRadius.circular(5),
      ),
      child: IconButton(
        icon: const Icon(
          Icons.search,
          color: Colors.white,
        ),
        onPressed: () {},
      ),
    );
