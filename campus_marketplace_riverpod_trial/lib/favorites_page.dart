import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'favorites_notifier.dart';

// ใช้ ConsumerWidget เทียบเท่า StatelessWidget ฝั่ง Provider แต่รับ ref เข้ามาด้วย
class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  void _showClearConfirmDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('ล้างรายการโปรดทั้งหมด?'),
        content: const Text('การกระทำนี้จะลบสินค้าที่บันทึกไว้ทั้งหมด และไม่สามารถย้อนกลับได้'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () {
              // ref.read(...notifier) เพราะเป็นคำสั่งครั้งเดียวตอนกดยืนยัน เทียบเท่า context.read
              ref.read(favoritesProvider.notifier).clear();
              Navigator.of(dialogContext).pop();
            },
            child: const Text('ล้างทั้งหมด', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch เพราะหน้านี้ต้อง rebuild ทุกครั้งที่รายการโปรดเปลี่ยน เทียบเท่า context.watch
    final savedItems = ref.watch(favoritesProvider);
    final totalValue = ref.watch(favoritesProvider.notifier).totalValue;

    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการโปรดของฉัน'),
        actions: [
          // แสดงปุ่มเฉพาะเมื่อมีรายการโปรดอย่างน้อย 1 รายการ
          if (savedItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: 'ล้างรายการโปรดทั้งหมด',
              onPressed: () => _showClearConfirmDialog(context, ref),
            ),
        ],
      ),
      body: savedItems.isEmpty
          ? const Center(child: Text('ยังไม่มีสินค้าที่บันทึกไว้'))
          : ListView.builder(
              itemCount: savedItems.length,
              itemBuilder: (context, index) {
                final item = savedItems[index];
                return ListTile(
                  title: Text(item.title),
                  subtitle: Text('฿${item.price.toStringAsFixed(0)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => ref.read(favoritesProvider.notifier).remove(item),
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: Text('มูลค่ารวม: ฿${totalValue.toStringAsFixed(0)}'),
      ),
    );
  }
}