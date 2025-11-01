

enum EventStatus {
  draft,           // لسه بيكمل Event Creation
  pending,         // في انتظار موافقة Vendors (بعد إرسال Requests)
  approved,        // كل Vendors وافقوا (محتاج دفع)
  partiallyPaid,   // دفع جزء من المبلغ
  confirmed,       // دفع كامل وتأكيد
  cancelled,       // ملغي
  completed,       // انتهى الحدث
}


enum PaymentStatus {
  pending,            // في انتظار الدفع
  partiallyPaid,      // دفع جزئي
  paid,               // تم الدفع كامل
  refunded,           // تم الاسترجاع
}