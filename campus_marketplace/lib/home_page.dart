import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/item.dart';
import 'models/favorites_model.dart';
import 'widgets/item_list_section.dart';
import 'favorites_page.dart';

class HomePage extends StatefulWidget {
  // ต้องเปลี่ยนกลับเป็น StatefulWidget เพราะตอนนี้มี Ephemeral State (คำค้นหา) ที่ต้องเก็บไว้เอง
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // คำค้นหาเป็น Ephemeral State: มีแค่หน้านี้หน้าเดียวที่ต้องรู้ค่านี้
  // ไม่มีหน้าจออื่นในแอปต้องอ่านค่านี้ จึงใช้ setState ธรรมดาพอ ไม่ต้องใช้ Provider
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // กรอง catalog ด้วยคำค้นหา โดยไม่สนตัวพิมพ์เล็ก-ใหญ่
    final filteredCatalog = catalog
        .where((item) =>
            item.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Marketplace'),
        actions: [
          IconButton(
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.favorite),
                Text(' ${context.watch<FavoritesModel>().itemCount}'),
              ],
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FavoritesPage()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'ค้นหาสินค้า...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // setState แค่ในหน้านี้ ไม่กระทบ widget อื่นนอกทรีของ HomePage
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: ItemListSection(catalog: filteredCatalog),
          ),
        ],
      ),
    );
  }
}