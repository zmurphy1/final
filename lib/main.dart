import 'package:final_recipe/recipedetailsscreen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:final_recipe/recipe.dart';

import 'editrecipescreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDirectory =
  await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);

  Hive.registerAdapter(RecipeAdapter());//register adapter
  await Hive.openBox('recipes'); // Open a box for storing Recipe objects

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      home: RecipeList(),
    );
  }
}

class RecipeList extends StatefulWidget {
  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes'),
      ),
      body: FutureBuilder(
        future: Hive.openBox('recipes'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _buildRecipeList();
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddRecipeScreen(),
            ),
          );

          if (result == true) {
            // If result is true, refresh the recipe list
            setState(() {});
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildRecipeList() {
    if (!Hive.isBoxOpen('recipes')) {
      return CircularProgressIndicator();
    }
    final recipesBox = Hive.box('recipes');
    print(recipesBox.length);
    return ListView.builder(
      itemCount: recipesBox.length,
      itemBuilder: (context, index) {
        final recipe = recipesBox.getAt(index) as Recipe;
        return ListTile(
          title: Text(recipe.title),
          subtitle: Text(recipe.description),
          onTap: () {
// Navigate to recipe details or edit page
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Recipe Options'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                          // Navigate to recipe details
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeDetailsScreen(recipe: recipe),
                            ),
                          );
                        },
                        child: Text('View Recipe Details'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
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
                              setState(() {});
                            }
                          });
                        },
                        child: Text('Edit Recipe'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          onLongPress: () {
            // Delete recipe
            recipesBox.deleteAt(index);
            setState(() {}); // Refresh the recipe list after deleting
          },
        );
      },
    );
  }
}

class AddRecipeScreen extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController ingredientsController = TextEditingController();
  final TextEditingController instructionsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Recipe'),
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
                // Save the recipe to the database
                saveRecipe(
                  titleController.text,
                  descriptionController.text,
                  ingredientsController.text,
                  instructionsController.text,
                );
                Navigator.pop(context, true); // Pass true as a result
              },
              child: Text('Save Recipe'),
            ),
          ],
        ),
      ),
    );
  }

  void saveRecipe(String title, String description, String ingredients, String instructions) {
    if (!Hive.isBoxOpen('recipes')) {
      Hive.openBox('recipes');
    }
    final recipesBox = Hive.box('recipes');
    final newRecipe = Recipe()
      ..title = title
      ..description = description
      ..ingredients = ingredients.split(',').map((e) => e.trim()).toList()
      ..instructions = instructions;
    recipesBox.add(newRecipe);
    print(title);
  }
}