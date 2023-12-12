import 'package:final_recipe/recipe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditRecipeScreen extends StatefulWidget {
  final Recipe recipe;

  EditRecipeScreen({required this.recipe});

  @override
  _EditRecipeScreenState createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController ingredientsController = TextEditingController();
  final TextEditingController instructionsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set initial values in the controllers
    titleController.text = widget.recipe.title;
    descriptionController.text = widget.recipe.description;
    ingredientsController.text = widget.recipe.ingredients.join(', ');
    instructionsController.text = widget.recipe.instructions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Recipe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recipe Title'),
            TextFormField(
              controller: titleController,
              // Handle the title input
            ),
            SizedBox(height: 16.0),
            Text('Description'),
            TextFormField(
              controller: descriptionController,
              // Handle the description input
            ),
            SizedBox(height: 16.0),
            Text('Ingredients'),
            TextFormField(
              controller: ingredientsController,
              // Handle the ingredients input
            ),
            SizedBox(height: 16.0),
            Text('Instructions'),
            TextFormField(
              controller: instructionsController,
              // Handle the instructions input
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Save the edited recipe to the database
                saveEditedRecipe(
                  widget.recipe,
                  titleController.text,
                  descriptionController.text,
                  ingredientsController.text,
                  instructionsController.text,
                );
                Navigator.pop(context, true); // Pass true as a result
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  void saveEditedRecipe(
      Recipe recipe,
      String title,
      String description,
      String ingredients,
      String instructions,
      ) {
    // Update the existing recipe in the database
    recipe
      ..title = title
      ..description = description
      ..ingredients = ingredients.split(',').map((e) => e.trim()).toList()
      ..instructions = instructions;
    recipe.save(); // Save changes to Hive
  }
}
