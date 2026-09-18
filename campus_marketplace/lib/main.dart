import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/favorites_model.dart';
import 'home_page.dart';
import 'repositories/item_repository_api.dart'; // เพิ่มบรรทัดนี้

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => FavoritesModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Marketplace',
      debugShowCheckedModeBanner: false,
      home: HomePage(repository: ItemRepositoryApi()), // เปลี่ยนจาก const HomePage()
    );
  }
}