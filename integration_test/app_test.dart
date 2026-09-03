import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:manga_library/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Manga Collection E2E Integration Test', () {
    setUp(() async {
      await GetStorage.init();
      await GetStorage().erase();
    });

    testWidgets('Full workflow: Long Press Quick Action, Unified Volume Control, Bulk Actions', (tester) async {
      // 1. Start the app
      app.main();
      await tester.pumpAndSettle();

      // 2. Verify empty state and statistics dashboard
      expect(find.text('COLLECTION STATS'), findsOneWidget);
      expect(find.text('0.0%'), findsOneWidget);
      expect(find.text('ยังไม่มีประวัติการอ่าน'), findsOneWidget);

      // 3. Add first manga: "One Piece" (5 volumes, default all owned)
      final fab = find.byType(FloatingActionButton);
      await tester.tap(fab);
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), 'One Piece');
      await tester.enterText(textFields.at(1), '5');
      await tester.enterText(textFields.at(2), 'Luffy adventure');
      await tester.tap(find.text('ยืนยันเพิ่มเข้าคลังหนังสือ'));
      await tester.pumpAndSettle();

      // 4. Add second manga: "Naruto" (3 volumes)
      await tester.tap(fab);
      await tester.pumpAndSettle();

      final textFields2 = find.byType(TextField);
      await tester.enterText(textFields2.at(0), 'Naruto');
      await tester.enterText(textFields2.at(1), '3');
      await tester.enterText(textFields2.at(2), 'Ninja story');
      await tester.tap(find.text('ยืนยันเพิ่มเข้าคลังหนังสือ'));
      await tester.pumpAndSettle();

      // 5. Navigate to Library tab
      await tester.tap(find.text('LIBRARY'));
      await tester.pumpAndSettle();

      // Verify both are present in Library
      expect(find.text('One Piece'), findsOneWidget);
      expect(find.text('Naruto'), findsOneWidget);

      // 6. Navigate to Naruto details via Single Tap
      await tester.tap(find.text('Naruto'));
      await tester.pumpAndSettle();

      // Verify initial volume count is 3
      expect(find.text('3'), findsWidgets);
      expect(find.text('สะสมแล้ว 3 จาก 3 เล่ม'), findsOneWidget);

      // Test [+] button (increment by 1 -> 4 volumes)
      final plusButton = find.byTooltip('เพิ่ม 1 เล่ม');
      await tester.tap(plusButton);
      await tester.pumpAndSettle();
      expect(find.text('สะสมแล้ว 4 จาก 4 เล่ม'), findsOneWidget);

      // Go back to Library
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // 7. Test Long-Press Quick Action Sheet on Library Screen for Naruto
      final narutoCard = find.text('Naruto');
      expect(narutoCard, findsOneWidget);
      await tester.longPress(narutoCard);
      await tester.pumpAndSettle();

      // Verify quick action sheet is displayed
      expect(find.text('แก้ไขรายละเอียด'), findsOneWidget);
      expect(find.text('ลบเรื่องนี้ออกจากคลัง'), findsOneWidget);

      // Tap "ลบเรื่องนี้ออกจากคลัง"
      await tester.tap(find.text('ลบเรื่องนี้ออกจากคลัง'));
      await tester.pumpAndSettle();

      // Verify confirmation dialog is displayed
      expect(find.text('ยืนยันการลบ'), findsOneWidget);
      expect(find.text('คุณแน่ใจหรือไม่ว่าต้องการลบ "Naruto" ออกจากคลังหนังสือ?'), findsOneWidget);

      // Tap "ลบรายการ" to confirm deletion
      await tester.tap(find.text('ลบรายการ'));
      await tester.pumpAndSettle();

      // Verify Naruto is deleted and One Piece is still displayed on the Library Screen
      expect(find.text('Naruto'), findsNothing);
      expect(find.text('One Piece'), findsOneWidget);

      // 8. Delete One Piece via Long-Press on Library Screen
      await tester.longPress(find.text('One Piece'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('ลบเรื่องนี้ออกจากคลัง'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('ลบรายการ'));
      await tester.pumpAndSettle();

      // Verify library is completely empty
      expect(find.text('One Piece'), findsNothing);
      expect(find.text('ยังไม่มีหนังสือในคลัง'), findsOneWidget);
    });
  });
}
