import 'package:flutter/foundation.dart';
import 'item.dart';

class CartModel extends ChangeNotifier {
  final List<Item> _items = []; // private เพื่อไม่ให้ภายนอกแก้ไขตรงๆ ได้

  List<Item> get items => List.unmodifiable(_items);
  int get itemCount => _items.length;
  double get totalValue => _items.fold(0, (sum, i) => sum + i.price);

  void add(Item item) {
    _items.add(item);
    notifyListeners(); // แก้ข้อมูลแล้วต้องแจ้งทุกครั้ง ไม่งั้น UI จะไม่อัปเดต
  }

  void remove(Item item) {
    _items.remove(item);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}