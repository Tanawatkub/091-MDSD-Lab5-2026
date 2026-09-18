import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/item.dart';
import '../models/cart_model.dart';

class ItemCard extends StatelessWidget {
  final Item item;

  const ItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartModel>();
    final alreadyInCart = cart.items.any((i) => i.id == item.id);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: SizedBox(
          width: 56,
          height: 56,
          child: Image.network(
            item.imageUrl,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.broken_image_outlined, color: Colors.grey);
            },
          ),
        ),
        title: Text(item.title),
        subtitle: Text('฿${item.price.toStringAsFixed(0)}'),
        trailing: ElevatedButton.icon(
          onPressed: alreadyInCart
              ? null
              : () {
                  context.read<CartModel>().add(item);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('เพิ่ม ${item.title} ลงตะกร้าแล้ว')),
                  );
                },
          icon: Icon(
            alreadyInCart ? Icons.check_circle_outline : Icons.add_shopping_cart,
            size: 18,
          ),
          label: Text(alreadyInCart ? 'อยู่ในตะกร้าแล้ว' : 'เพิ่มลงตะกร้า'),
        ),
      ),
    );
  }
}