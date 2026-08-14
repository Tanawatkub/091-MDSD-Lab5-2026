# notes.md — โจทย์ที่ 3 (Riverpod trial)

## โจทย์ที่ 1: Search Box

**ตัดสินใจ**: คำค้นหา (`_searchQuery`) เป็น **Ephemeral State** เหมือนกับฝั่ง Provider

**เหตุผล**: ค่านี้มีความหมายเฉพาะภายในหน้า `HomePage` เท่านั้น ไม่เกี่ยวข้องกับ
`favoritesProvider` และไม่มีหน้าจออื่น (`FavoritesPage`) ต้องรู้ค่าคำค้นหานี้เลย
จึงเก็บด้วย `setState` ภายใน `ConsumerStatefulWidget` ธรรมดา ไม่จำเป็นต้องสร้าง
Riverpod provider ใหม่สำหรับ state ที่ขอบเขตแคบขนาดนี้ — แม้แอปทั้งแอปจะใช้
Riverpod เป็นเครื่องมือหลัก แต่หลักการเลือกเครื่องมือตามขอบเขตของข้อมูลยังใช้
เหมือนเดิมทุกประการ

**จุดต่างจากฝั่ง Provider**: ต้องเปลี่ยน `HomePage` จาก `ConsumerWidget`
(เทียบเท่า `StatelessWidget`) เป็น `ConsumerStatefulWidget` (เทียบเท่า
`StatefulWidget`) เพื่อให้มีที่เก็บ Ephemeral State ได้ — คู่เทียบเดียวกับที่เคย
สรุปไว้ใน Checkpoint 4.2

## โจทย์ที่ 2: ปุ่มล้างรายการโปรดทั้งหมด

**การใช้ `ref.watch` vs `ref.read`** (เทียบเท่า `context.watch`/`context.read`):

- ใช้ `ref.watch(favoritesProvider)` ที่ระดับบนของ `build()` ใน `FavoritesPage`
  เพื่อให้หน้านี้ rebuild ทุกครั้งที่ list เปลี่ยน — จำเป็นเพื่อเช็คเงื่อนไข
  `savedItems.isNotEmpty` แบบ real-time ว่าจะแสดงปุ่มล้างหรือไม่

- ใช้ `ref.read(favoritesProvider.notifier).clear()` ตอนกดปุ่มยืนยันใน Dialog
  เพราะเป็นคำสั่งที่ยิงครั้งเดียว ไม่ต้องการ subscribe รับการอัปเดตซ้ำ

**เมธอด `clear()` ที่ต้องเพิ่มเอง**: ต่างจากฝั่ง Provider ที่ `FavoritesModel`
มี `clear()` เตรียมไว้ให้แล้วตั้งแต่ต้น ฝั่ง Riverpod (`FavoritesNotifier`) ยังไม่มี
เมธอดนี้ ต้องเพิ่มเองโดยใช้หลักการเดียวกับ `add()`/`remove()` คือแทนที่ state
ด้วยก้อนใหม่ทั้งหมด: `void clear() => state = [];`

**เงื่อนไขการแสดงปุ่ม**: ใช้ `if (savedItems.isNotEmpty)` ครอบ `IconButton`
ใน `actions` ของ `AppBar` เหมือนหลักการเดียวกับฝั่ง Provider