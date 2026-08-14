import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/favorites_model.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  // แยกฟังก์ชันแสดง Dialog ยืนยัน เพื่อให้โค้ดใน build() อ่านง่าย
  void _showClearConfirmDialog(BuildContext context) {
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
              // .read เพราะเป็นคำสั่งครั้งเดียวตอนกดยืนยัน ไม่ต้องการสมัครรับการอัปเดตซ้ำ
              context.read<FavoritesModel>().clear();
              Navigator.of(dialogContext).pop();
            },
            child: const Text('ล้างทั้งหมด', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // .watch เพราะหน้านี้ต้อง rebuild ทุกครั้งที่รายการโปรดเปลี่ยน
    // (ทั้งตอนลบทีละชิ้น และตอนล้างทั้งหมด เพื่อให้ปุ่มล้างหายไปเองเมื่อ list ว่าง)
    final favorites = context.watch<FavoritesModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการโปรดของฉัน'),
        actions: [
          // แสดงปุ่มเฉพาะเมื่อมีรายการโปรดอย่างน้อย 1 รายการ
          if (favorites.itemCount > 0)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: 'ล้างรายการโปรดทั้งหมด',
              onPressed: () => _showClearConfirmDialog(context),
            ),
        ],
      ),
      body: favorites.items.isEmpty
          ? const Center(child: Text('ยังไม่มีสินค้าที่บันทึกไว้'))
          : ListView.builder(
              itemCount: favorites.items.length,
              itemBuilder: (context, index) {
                final item = favorites.items[index];
                return ListTile(
                  title: Text(item.title),
                  subtitle: Text('฿${item.price.toStringAsFixed(0)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => context.read<FavoritesModel>().remove(item),
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: Text('มูลค่ารวม: ฿${favorites.totalValue.toStringAsFixed(0)}'),
      ),
    );
  }
}