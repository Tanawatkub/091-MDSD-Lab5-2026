import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'item.dart';
import 'favorites_notifier.dart';
import 'favorites_page.dart';

void main() {
  // ครอบแอปทั้งหมดด้วย ProviderScope เพียงครั้งเดียวที่จุดเริ่มต้น เทียบเท่า ChangeNotifierProvider
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => const MaterialApp(
        debugShowCheckedModeBanner: false, // ปิดริบบิ้น DEBUG มุมขวาบน ไม่ให้บังไอคอนหัวใจใน AppBar
        home: HomePage(),
      );
}

// ต้องเปลี่ยนจาก ConsumerWidget เป็น ConsumerStatefulWidget เพราะตอนนี้มี Ephemeral State
// (คำค้นหา) ที่ต้องเก็บไว้ในตัวเอง คู่เทียบกับฝั่ง Provider คือ StatelessWidget -> StatefulWidget
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  // คำค้นหาเป็น Ephemeral State: มีแค่หน้านี้หน้าเดียวที่ต้องรู้ค่านี้
  // ไม่เกี่ยวกับ favoritesProvider เลย จึงใช้ setState ธรรมดา ไม่ต้องผ่าน Riverpod
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // ref.watch อ่านค่าปัจจุบันและสมัครรับการอัปเดตอัตโนมัติ เทียบเท่า context.watch
    final savedItems = ref.watch(favoritesProvider);

    // กรอง catalog ด้วยคำค้นหา โดยไม่สนตัวพิมพ์เล็ก-ใหญ่
    final filteredCatalog = catalog
        .where((item) =>
            item.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Marketplace (Riverpod)'),
        actions: [
          IconButton(
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.favorite),
                Text(' ${savedItems.length}'),
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
                // setState แค่ในหน้านี้ ไม่กระทบ favoritesProvider หรือหน้าอื่นเลย
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView(
              children: filteredCatalog.map((item) {
                final alreadySaved = savedItems.any((i) => i.id == item.id);
                return ListTile(
                  title: Text(item.title),
                  subtitle: Text('฿${item.price.toStringAsFixed(0)}'),
                  trailing: ElevatedButton(
                    // ref.read(...notifier) ใช้เรียกแก้ไขค่า เทียบเท่า context.read
                    onPressed: alreadySaved
                        ? null
                        : () => ref.read(favoritesProvider.notifier).add(item),
                    child: Text(alreadySaved ? '❤️ บันทึกแล้ว' : 'บันทึก'),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}