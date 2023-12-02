import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Recipe extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String description;

  @HiveField(2)
  late List<String> ingredients;

  @HiveField(3)
  late String instructions;
}
