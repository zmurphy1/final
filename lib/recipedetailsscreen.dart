import 'package:final_recipe/recipe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'editrecipescreen.dart';

class RecipeDetailsScreen extends StatelessWidget {
  final Recipe recipe;

  RecipeDetailsScreen({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditRecipeScreen(recipe: recipe),
                ),
              ).then((result) {
                // Handle result if needed
                if (result == true) {
                  // If result is true, refresh the recipe list
                  Navigator.pop(context, true);
                }
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${recipe.title}'),
            Text('Description: ${recipe.description}'),
            Text('Ingredients: ${recipe.ingredients.join(', ')}'),
            Text('Instructions: ${recipe.instructions}'),
          ],
        ),
      ),
    );
  }
}
