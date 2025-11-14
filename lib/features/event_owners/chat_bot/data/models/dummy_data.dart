// lib/data/dummy_data.dart

import 'chat_models.dart';

class DummyData {
  /// ============================================
  /// Chat Bot - يساعد الـ User يتنقل في التطبيق
  /// ============================================
  /// الـ Flow: معلومات → تطبيق مباشر

  static final Map<String, ChatQuestion> questions = {
    // ============================================
    // القائمة الرئيسية
    // ============================================
    'start': ChatQuestion(
      id: 'start',
      text: '🎉 مرحباً بك في PlanZ!\n\nتطبيقك الأول لتخطيط الأحداث والحفلات\n\n👇 اختر من فضلك:',
      isStart: true,
      options: [
        ChatOption(
          id: 'attendee_info',
          text: '👥 أنا حضور في حدث',
          nextQuestionId: 'attendee_questions',
          responseText: 'حسناً! سأساعدك تجد كل اللي تحتاجه 🎯',
        ),
        ChatOption(
          id: 'vendor_info',
          text: '🏢 أنا عارض خدمات (Vendor)',
          nextQuestionId: 'vendor_questions',
          responseText: 'ممتاز! سأساعدك تدير خدماتك 💼',
        ),
        ChatOption(
          id: 'organizer_info',
          text: '📅 أنا منظم حدث',
          nextQuestionId: 'organizer_questions',
          responseText: 'تمام! سأساعدك تنظم حدثك 🚀',
        ),
      ],
    ),

    // ============================================
    // مسار الحاضر (Attendee)
    // ============================================
    'attendee_questions': ChatQuestion(
      id: 'attendee_questions',
      text: '✨ الحاضر في الحدث يقدر يعمل إيه؟',
      options: [
        ChatOption(
          id: 'registration_guide',
          text: '✍️ كيف أسجل في حدث؟',
          nextQuestionId: 'attendee_registration',
          responseText: 'الحمد لله! الطريقة سهلة جداً:',
        ),
        ChatOption(
          id: 'payment_guide',
          text: '💳 معلومات الدفع والباقات',
          nextQuestionId: 'attendee_payment',
          responseText: 'تمام! هنا الباقات والأسعار:',
        ),
        ChatOption(
          id: 'ticket_guide',
          text: '🎫 البحث عن تذكرتي',
          nextQuestionId: 'attendee_ticket',
          responseText: 'تذكرتك موجودة فين؟',
        ),
        ChatOption(
          id: 'event_details',
          text: '📋 معلومات الحدث',
          nextQuestionId: 'attendee_event_info',
          responseText: 'اختر نوع المعلومات:',
        ),
      ],
    ),

    // === التسجيل ===
    'attendee_registration': ChatQuestion(
      id: 'attendee_registration',
      text: '''
✍️ خطوات التسجيل السهلة:

📱 الخطوة الأولى:
اضغط "الأحداث" من القائمة السفلية

🔍 الخطوة الثانية:
ابحث عن الحدث اللي بتحضره أو اضغط عليه مباشرة

📋 الخطوة الثالثة:
ملي البيانات:
• اسمك الكامل
• رقم الهاتف
• البريد الإلكتروني
• أي احتياجات خاصة (حساسيات غذائية مثلاً)

💳 الخطوة الرابعة:
اختر باقة وادفع عبر:
• بطاقة ائتمان
• محفظة رقمية
• تحويل بنكي

✅ تمام!
ستحصل على تذكرة رقمية في حسابك
      ''',
      isFinal: true,
      options: [
        ChatOption(
          id: 'registration_start',
          text: '🚀 ابدأ التسجيل الآن',
          nextQuestionId: 'registration_redirect',
          responseText: 'سأحولك للصفحة...',
        ),
        ChatOption(
          id: 'back_attendee',
          text: '🔙 رجوع',
          nextQuestionId: 'attendee_questions',
          responseText: 'تمام! في حاجة تانية؟',
        ),
      ],
    ),

    'registration_redirect': ChatQuestion(
      id: 'registration_redirect',
      text: 'جاري التحويل لقائمة الأحداث...\n\n💡 نصيحة: لما تكمل التسجيل، التذكرة هتطلع هنا "🎫 تذاكري"',
      isFinal: true,
      options: [
        ChatOption(
          id: 'continue',
          text: '✅ فهمت',
          nextQuestionId: 'attendee_questions',
          responseText: 'تمام!',
        ),
      ],
    ),

    // === الدفع والباقات ===
    'attendee_payment': ChatQuestion(
      id: 'attendee_payment',
      text: '''
💰 معلومات الدفع والباقات:

🔹 في الغالب الحدث فيه باقات مختلفة:
• باقة عادية (أساسي): أرخص سعر ✅
• باقة بلس: فيها إضافيات زيادة ⭐
• باقة بريميوم: كل المميزات 👑

💡 الفرق بينهم في المميزات والسعر
(كل حدث فيه باقاته الخاصة)

💳 طرق الدفع:
✅ بطاقة ائتمان / ديبت
✅ محافظ رقمية (أبل، جوجل بيه)
✅ تحويل بنكي

⚠️ ملاحظة مهمة:
• الدفع آمن 100%
• الفلوس ترجع إذا ألغيت التسجيل قبل الحدث
• في خطة استرجاع مبلغ معين
      ''',
      isFinal: true,
      options: [
        ChatOption(
          id: 'payment_problem',
          text: '❌ في مشكلة في الدفع',
          nextQuestionId: 'payment_issues',
          responseText: 'لا مشكلة! شنو المشكلة؟',
        ),
        ChatOption(
          id: 'back_attendee2',
          text: '🔙 رجوع',
          nextQuestionId: 'attendee_questions',
          responseText: 'في شيء آخر؟',
        ),
      ],
    ),

    'payment_issues': ChatQuestion(
      id: 'payment_issues',
      text: '''
🔧 حل مشاكل الدفع:

❌ الدفع فشل؟

✅ جرب:
1. تأكد من الرصيد في البطاقة
2. اتصل بالبنك (قد يكون في حظر أمان)
3. جرب بطاقة ثانية
4. تأكد من رقم البطاقة والتاريخ

اذا ما اشتغلت:
4. احذف بيانات التطبيق وحاول مجدد
5. حدّث التطبيق لأحدث نسخة
6. جرب من متصفح الويب

⚠️ لو الحل ما اشتغل:
📞 تواصل مع الدعم فوراً!
      ''',
      isFinal: true,
      options: [
        ChatOption(
          id: 'contact_support_payment',
          text: '📞 تواصل مع الدعم',
          nextQuestionId: 'support_channels',
          responseText: 'هنا بيانات التواصل:',
        ),
        ChatOption(
          id: 'back_payment',
          text: '🔙 رجوع',
          nextQuestionId: 'attendee_payment',
          responseText: 'تمام',
        ),
      ],
    ),

    // === التذكرة ===
    'attendee_ticket': ChatQuestion(
      id: 'attendee_ticket',
      text: '''
🎫 فين التذكرة؟

هنا الطريقة:

1️⃣ اضغط "🎫 تذاكري"
(من القائمة السفلية أو الملف الشخصي)

2️⃣ هتشوف كل التذاكر اللي عندك

3️⃣ اضغط على التذكرة اللي تبغيها

✅ خلاص! في التذكرة:
• رقم التذكرة
• تفاصيل الحدث
• الحالة (مؤكدة)
• تحميل PDF إذا احتجت

💡 نصائح:
• احفظ الصورة في صورك (الانترنت قد ما يقطع)
• التذكرة رقمية - ما تحتاج طباعة
• في تحويل مباشر للدعم إذا في أي مشكلة
      ''',
      isFinal: true,
      options: [
        ChatOption(
          id: 'ticket_missing',
          text: '❌ ما أشوف التذكرة',
          nextQuestionId: 'ticket_problems',
          responseText: 'الحمد لله! ما تقلق:',
        ),
        ChatOption(
          id: 'back_ticket',
          text: '🔙 رجوع',
          nextQuestionId: 'attendee_questions',
          responseText: 'تمام',
        ),
      ],
    ),

    'ticket_problems': ChatQuestion(
      id: 'ticket_problems',
      text: '''
🔍 حل: التذكرة ما تظهر

✅ حاول بالترتيب:

1. تأكد من البريد الإلكتروني
   (قد تكون الرسالة في Spam)

2. عدّل الصفحة (pull to refresh)

3. سجّل خروج ثم خروج

4. حدّث التطبيق

5. امسح بيانات التطبيق:
   Settings > Apps > PlanZ > Storage > Clear Data

⚠️ لو ما اشتغل:
📧 بلغ الدعم مباشرة مع:
• بريدك الإلكتروني
• رقم الهاتف اللي سجلت فيه
• اسم الحدث

سيعاد لك إرسال التذكرة فوري ⚡
      ''',
      isFinal: true,
      options: [
        ChatOption(
          id: 'contact_ticket_support',
          text: '📞 اتصل بالدعم',
          nextQuestionId: 'support_channels',
          responseText: 'بيانات التواصل هنا:',
        ),
        ChatOption(
          id: 'back_ticket2',
          text: '🔙 رجوع',
          nextQuestionId: 'attendee_ticket',
          responseText: 'تمام',
        ),
      ],
    ),

    // === معلومات الحدث ===
    'attendee_event_info': ChatQuestion(
      id: 'attendee_event_info',
      text: 'اختر نوع المعلومات:',
      options: [
        ChatOption(
          id: 'event_schedule',
          text: '🕐 الجدول الزمني',
          nextQuestionId: 'event_schedule_info',
          responseText: 'الجدول الزمني موجود فين:',
        ),
        ChatOption(
          id: 'event_location',
          text: '📍 الموقع والمكان',
          nextQuestionId: 'event_location_info',
          responseText: 'المكان:',
        ),
        ChatOption(
          id: 'event_speakers',
          text: '🎤 المتحدثين',
          nextQuestionId: 'event_speakers_info',
          responseText: 'المتحدثين:',
        ),
      ],
    ),

    'event_schedule_info': ChatQuestion(
      id: 'event_schedule_info',
      text: '''
🕐 فين الجدول الزمني؟

ادخل على الحدث وهتشوف:
📋 التفاصيل الكاملة للحدث
(أوقات البرنامج، الفعاليات، الأنشطة)

💡 الجدول الزمني في شاشة الحدث مباشرة:
• الوقت والموعد
• الأنشطة الرئيسية
• فترات الراحة

📝 لو ما فيه جدول:
قد يكون المنظم ما حطه بعد
اتصل بالدعم ليطلبوا من المنظم يحط البيانات
      ''',
      isFinal: true,
      options: [
        ChatOption(
          id: 'back_event_info',
          text: '🔙 رجوع',
          nextQuestionId: 'attendee_event_info',
          responseText: 'في شيء آخر؟',
        ),
      ],
    ),

    'event_location_info': ChatQuestion(
      id: 'event_location_info',
      text: '''
📍 معلومات الموقع:

فتح الحدث → هتشوف:
🗺️ الخريطة والعنوان
📌 الموقع بالضبط
🅿️ مواقف السيارات
🚗 وسائل المواصلات

💡 أفضل حاجة:
اضغط على الخريطة → تحويل لـ Google Maps
وتقدر تختار الطريقة اللي تيسر (سيارة، تاكسي، مترو)

⚠️ لو المكان ما واضح:
تواصل مع المنظم من داخل التطبيق
(في خيار "اتصل بالمنظم")
      ''',
      isFinal: true,
      options: [
        ChatOption(
          id: 'back_event_info2',
          text: '🔙 رجوع',
          nextQuestionId: 'attendee_event_info',
          responseText: 'تمام',
        ),
      ],
    ),

    'event_speakers_info': ChatQuestion(
      id: 'event_speakers_info',
      text: '''
🎤 معلومات المتحدثين:

كيف تشوف المتحدثين:

1️⃣ ادخل على الحدث
2️⃣ اتمرر للأسفل
3️⃣ هتشوف "المتحدثين" أو "البرنامج"
4️⃣ اضغط على أي متحدث لتشوف سيرته

📌 لكل متحدث:
• الصورة والاسم
• التخصص والخبرة
• الموضوع اللي هيتكلم فيه
• السوشيال ميديا (إن كانت)

💡 لو ما في متحدثين محددين:
قد يكون الحدث ما فيه متحدثين
أو المنظم ما أضافهم بعد
اتصل بالمنظم للتأكد
      ''',
      isFinal: true,
      options: [
        ChatOption(
          id: 'back_event_info3',
          text: '🔙 رجوع',
          nextQuestionId: 'attendee_event_info',
          responseText: 'تمام',
        ),
      ],
    ),

    // ============================================
    // مسار العارض (Vendor)
    // ============================================
    'vendor_questions': ChatQuestion(
      id: 'vendor_questions',
      text: 'اختر من فضلك:',
      options: [
        ChatOption(
          id: 'vendor_how_to_add',
          text: '➕ كيف أضيف خدماتي؟',
          nextQuestionId: 'vendor_add_service',
          responseText: 'تمام! هنا الطريقة:',
        ),
        ChatOption(
          id: 'vendor_orders',
          text: '📦 الطلبات والتفاصيل',
          nextQuestionId: 'vendor_orders_guide',
          responseText: 'معلومات الطلبات:',
        ),
        ChatOption(
          id: 'vendor_earnings',
          text: '💰 الأرباح والسحب',
          nextQuestionId: 'vendor_earnings_guide',
          responseText: 'معلومات الأرباح:',
        ),
        ChatOption(
          id: 'vendor_support',
          text: '❓ أسئلة وسياسات',
          nextQuestionId: 'vendor_faq',
          responseText: 'الأسئلة الشائعة:',
        ),
      ],
    ),

    'vendor_add_service': ChatQuestion(
      id: 'vendor_add_service',
      text: '''
➕ كيفية إضافة خدمة جديدة:

📱 الخطوات:

1️⃣ اذهب لـ "ملفي الشخصي"
   ← "خدماتي" ← "إضافة خدمة جديدة"

2️⃣ اختر نوع الخدمة:
   (تصوير، موسيقى، طعام، إلخ)

3️⃣ ملي البيانات:
   • اسم الخدمة
   • الوصف (كم مهم!)
   • السعر والعمولة
   • صور من أعمالك (Portfolio)
   • التفاصيل التقنية

4️⃣ اضغط "إرسال للموافقة"

✅ النتيجة:
• الفريق سيراجع الخدمة خلال 24 ساعة
• هتلقى تنبيه لما تتموافق
• تقدر تبدأ تستقبل طلبات!

💡 نصائح:
• اختر وصف واضح جداً
• ركز على المميزات
• حط صور جودة عالية
• الأسعار تكون منطقية ومتنافسة
      ''',
      isFinal: true,
      options: [
        ChatOption(
          id: 'vendor_service_error',
          text: '❌ الخدمة ما اتقبلت',
          nextQuestionId: 'vendor_service_issues',
          responseText: 'قد تكون هناك مشكلة في:',
        ),
        ChatOption(
          id: 'back_vendor',
          text: '🔙 رجوع',
          nextQuestionId: 'vendor_questions',
          responseText: 'في شيء آخر؟',
        ),
      ],
    ),

    'vendor_service_issues': ChatQuestion(
      id: 'vendor_service_issues',
      text: '''
❌ لما الخدمة ما تتقبل:

🔍 الأسباب الشائعة:

1. الصور ما واضحة
   ← استخدم صور عالية الجودة

2. الوصف ناقص أو غير واضح
   ← اشرح الخدمة كويس جداً

3. السعر ما منطقي
   ← تحقق من السعر منطقي

4. الفئة غير مناسبة
   ← اختر الفئة الصح

5. النصوص فيها أخطاء
   ← تفقد التدقيق الإملائي

📝 الحل:
عدّل الخدمة وأعدها إرسال
أو اتصل بالدعم يساعدك
      ''',
      isFinal: true,
      options: [
        ChatOption(
          id: 'contact_vendor_support',
          text: '📞 تواصل مع الدعم',
          nextQuestionId: 'support_channels',
          responseText: 'بيانات التواصل:',
        ),
        ChatOption(
          id: 'back_vendor2',
          text: '🔙 رجوع',
          nextQuestionId: 'vendor_questions',
          responseText: 'تمام',
        ),
      ],
    ),

    'vendor_orders_guide': ChatQuestion(
      id: 'vendor_orders_guide',
      text: '''
📦 إدارة الطلبات:

فين الطلبات؟
"ملفي الشخصي" ← "الطلبات"

🔔 أنواع الطلبات:

📋 قيد الانتظار:
• العميل اختار خدمتك
• بانتظار تأكيدك

✅ مؤكدة:
• أنت وافقت والعميل وافق
• جاهزة للتنفيذ

⏸️ معلقة:
• تحتاج إجراء أو توضيح

❌ ملغاة:
• تم إلغاء الطلب

💡 تفاصيل الطلب:
• اسم العميل ورقمه
• تاريخ الحدث
• المبلغ والدفع
• الملاحظات الخاصة

⚠️ مهم:
• رد على الطلبات بسرعة (أول 24 ساعة)
• لو ما رديت = قد تلغى تلقائياً
• اتواصل مع العميل عبر التطبيق بس
      ''',
      isFinal: true,
      options: [
        ChatOption(
          id: 'back_vendor3',
          text: '🔙 رجوع',
          nextQuestionId: 'vendor_questions',
          responseText: 'تمام',
        ),
      ],
    ),

    'vendor_earnings_guide': ChatQuestion(
      id: 'vendor_earnings_guide',
      text: '''
💰 معلومات الأرباح والسحب:

فين الأرباح؟
"ملفي الشخصي" ← "الأرباح"

📊 الأرقام:

💵 الرصيد المعلق:
• من طلبات جديدة (قيد الانتظار)
• سيتحول رصيد متاح بعد التأكيد

💳 الرصيد المتاح:
• الأموال اللي تقدر تسحب الآن

📈 الإجمالي:
• كل الأرباح من البداية

🔄 كيفية السحب:

1️⃣ اضغط "طلب سحب"

2️⃣ أدخل المبلغ:
   • الحد الأدنى: 100-500 ريال (يختلف)
   • الحد الأقصى: رصيدك كامل

3️⃣ اختر الحساب البنكي
   (لازم تسجل حسابك الأول)

4️⃣ أكمل العملية

✅ النتيجة:
• التحويل يأخذ 2-3 أيام عمل
• ستلقى رسالة تأكيد
• الفلوس تطلع في حسابك مباشرة

⚠️ ملاحظات:
• في عمولة 10% من التطبيق
• ما تخصم مباشرة (من الرصيد)
• مش في رسوم تحويل بنكي (من عندنا)
      ''',
      isFinal: true,
      options: [
        ChatOption(
          id: 'withdrawal_issue',
          text: '❌ في مشكلة في السحب',
          nextQuestionId: 'withdrawal_problems',
          responseText: 'شنو المشكلة؟',
        ),
        ChatOption(
          id: 'back_vendor4',
          text: '🔙 رجوع',
          nextQuestionId: 'vendor_questions',
          responseText: 'تمام',
        ),
      ],
    ),

    'withdrawal_problems': ChatQuestion(
      id: 'withdrawal_problems',
      text: '''
🔧 حل مشاكل السحب:

❌ الرصيد قليل:
✅ الحد الأدنى للسحب حوالي 500 ريال
   حاول تجمع أكثر

❌ البنك ما اشتغل:
✅ تأكد من بيانات الحساب صحيحة
✅ البطاقة ما تكون معطلة
✅ حاول حساب بنك آخر

❌ التحويل اتأخر:
✅ الحد الأقصى 3-5 أيام عمل
✅ البنك قد ياخذ وقت إضافي
✅ شوف الإيميل (قد فيه تنبيهات)

❌ حسابك البنكي مو مسجل:
✅ ادخل "الإعدادات" → "الحسابات البنكية"
✅ أضيف حسابك الصح
✅ تأكد من الـ IBAN صحيح

📞 لو ما اشتغل:
اتصل بالدعم مع:
• رقم الطلب
• الحساب البنكي
• المبلغ
      ''',
      isFinal: true,
      options: [
        ChatOption(
          id: 'contact_withdrawal_support',
          text: '📞 تواصل مع الدعم',
          nextQuestionId: 'support_channels',
          responseText: 'بيانات التواصل:',
        ),
        ChatOption(
          id: 'back_vendor5',
          text: '🔙 رجوع',
          nextQuestionId: 'vendor_questions',
          responseText: 'تمام',
        ),
      ],
    ),

    'vendor_faq': ChatQuestion(
      id: 'vendor_faq',
      text: '''
❓ أسئلة مهمة للبائعين:

Q: كم عمولة المنصة؟
A: 10% من كل طلب

Q: متى أتقاضى المبلغ؟
A: بعد تأكيد الحدث (يمكن قبل يوم منه)

Q: التطبيق يأخذ رسوم دخول؟
A: لا! بس العمولة على الطلبات

Q: التقييمات مهمة؟
A: جداً! تقييم تحت 3.5 قد يعطل خدمتك

Q: ما أكمل الطلب في الوقت، شنو؟
A: احتفظ بالمبلغ = غرامة 20%

Q: أقدر أرفع أسعار بعد الموافقة؟
A: لا، الأسعار ثابتة

Q: الصور والفيديو ضروري؟
A: نعم جداً! من أهم الحاجات

Q: كم خدمة أضيف؟
A: بدون حد أقصى (كم خدمة تبغي)

Q: ما عندي Portfolio (أعمال سابقة)؟
A: ابدأ بصور من أعمالك الحالية
واجمع من كل حدث
      ''',
      isFinal: true,
      options: [
        ChatOption(
          id: 'more_vendor_faq',
          text: '❓ أسئلة أكثر',
          nextQuestionId: 'vendor_faq_more',
          responseText: 'أسئلة إضافية:',
        ),
        ChatOption(
          id: 'back_vendor6',
          text: '🔙 رجوع',
          nextQuestionId: 'vendor_questions',
          responseText: 'تمام',
        ),
      ],
    ),

    'vendor_faq_more': ChatQuestion(
      id: 'vendor_faq_more',
      text: '''
❓ أسئلة إضافية:

Q: مين يتواصل مع الحدث - أنا أو العميل؟
A: أنت بتتواصل مع العميل عبر التطبيق
   لا تعطي رقمك المباشر

Q: الطلب ملغى، أسترجع الفلوس؟
A: في شروط للاسترجاع (تحدد حسب الحالة)

Q: أقدر أرفع خدمة مزدوجة؟
A: نعم! تحت فئة مختلفة

Q: الوصف قصير كفاية أم أشرح أكثر؟
A: شرح تفصيلي أفضل! كلما وضحت، كلما بعتك طلبات

Q: في وقت معين أستقبل طلبات أكثر؟
A: نعم، يوم الجمعة والسبت والعطل

Q: كم وقت التذكرة تظل بدون رد؟
A: أول 24 ساعة أساسي
(بعدين قد تلغى)

Q: أقدر أعطل خدمة مؤقتاً؟
A: نعم، في خيار "إيقاف مؤقت"
      ''',
      isFinal: true,
      options: [
        ChatOption(
          id: 'back_vendor7',
          text: '🔙 رجوع',
          nextQuestionId: 'vendor_questions',
          responseText: 'تمام',
        ),
      ],
    ),

    // ============================================
    // مسار المنظم (Organizer)
    // ============================================
    'organizer_questions': ChatQuestion(
      id: 'organizer_questions',
      text: 'اختر من فضلك:',
      options: [
        ChatOption(
          id: 'organizer_how_to_create',
          text: '🆕 كيف أنشئ حدث جديد؟',
          nextQuestionId: 'organizer_create_guide',
          responseText: 'تمام! سأساعدك تنشئ حدثك:',
        ),
        ChatOption(
          id: 'organizer_manage',
          text: '📊 إدارة الحدث (بعد الإنشاء)',
          nextQuestionId: 'organizer_manage_guide',
          responseText: 'معلومات الإدارة:',
        ),
        ChatOption(
          id: 'organizer_payment',
          text: '💳 الدفع والباقات',
          nextQuestionId: 'organizer_payment_guide',
          responseText: 'معلومات الدفع:',
        ),
        ChatOption(
          id: 'organizer_support',
          text: '❓ أسئلة وسياسات',
          nextQuestionId: 'organizer_faq',
          responseText: 'الأسئلة الشائعة:',
        ),
      ],
    ),

    'organizer_create_guide': ChatQuestion(
      id: 'organizer_create_guide',
      text: '''
🆕 خطوات إنشاء حدث:

📱 من أين أبدأ؟
"ملفي الشخصي" ← "أحداثي" ← "حدث جديد"

📝 البيانات الأساسية:

1️⃣ المعلومات الأولية:
   • اسم الحدث
   • نوع الحدث (زفاف، عيد ميلاد، إلخ)
   • الوصف
   • صورة رئيسية

2️⃣ التاريخ والموقع:
   • التاريخ والوقت
   • المكان والعنوان
   • اختياري: الخريطة

3️⃣ الضيوف:
   • العدد المتوقع
   • نوع التسجيل (مفتوح أم مغلق)

4️⃣ الخدمات:
   • اختر الخدمات (تصوير، طعام، موسيقى، إلخ)
   • لا تقلق، تقدر تغيّر بعدين

5️⃣ النشر:
   • انشر الحدث
   • هيطلع في قائمة الأحداث

✅ الحمد لله!
حدثك جاهز للتسجيل
      ''',
      isFinal: true,
      options: [
        ChatOption(
          id: 'organizer_create_start',
          text: '🚀 ابدأ الآن',
          nextQuestionId: 'create_redirect_organizer',
          responseText: 'سأحولك لصفحة الإنشاء...',
        ),
        ChatOption(
          id: 'back_organizer',
          text: '🔙 رجوع',
          nextQuestionId: 'organizer_questions',
          responseText: 'تمام',
        ),
      ],
    ),

    'create_redirect_organizer': ChatQuestion(
      id: 'create_redirect_organizer',
      text: 'جاري التحويل لصفحة إنشاء الحدث...\n\n💡 نصيحة: بعد الإنشاء روح "أحداثي" لتشوف الحدث وتديره',
      isFinal: true,
      options: [
        ChatOption(
          id: 'continue_org',
          text: '✅ فهمت',
          nextQuestionId: 'organizer_questions',
          responseText: 'تمام!',
        ),
      ],
    ),

    'organizer_manage_guide': ChatQuestion(
      id: 'organizer_manage_guide',
      text: '''
📊 إدارة الحدث:

فين إدارة الحدث؟
"ملفي الشخصي" ← "أحداثي" ← اختر الحدث

🔧 ماذا تقدر تعمل؟

1️⃣ تعديل البيانات:
   اضغط "تعديل" وغيّر:
   • الاسم والوصف
   • التاريخ والموقع
   • الصور والتفاصيل

2️⃣ مراقبة التسجيلات:
   "قائمة الحضور" = عدد من سجلوا

3️⃣ إدارة الخدمات:
   إضيف خدمات جديدة
   أو عدّل الموجودة

4️⃣ التواصل مع الحضور:
   "إرسال رسالة" لكل الحضور
   أو لواحد معين

5️⃣ الإحصائيات:
   تشوف كم واحد سجل
   والإيرادات من الحدث

⚠️ نقاط مهمة:
• تعديلات مهمة؟ بلّغ الحضور فوراً
• لا تلغي الحدث بدون سبب وجيه
• كل الأموال ترجع للحضور إذا ألغيت
      ''',
      isFinal: true,
      options: [
        ChatOption(
          id: 'back_organizer2',
          text: '🔙 رجوع',
          nextQuestionId: 'organizer_questions',
          responseText: 'تمام',
        ),
      ],
    ),

    'organizer_payment_guide': ChatQuestion(
      id: 'organizer_payment_guide',
      text: '''
💳 معلومات الدفع والباقات:

💰 الأموال من الحدث:

أين تروح الفلوس؟
✅ في حسابك (الرصيد) مباشرة

📊 الإيرادات:
• سعر التسجيل × عدد الحاضرين
• ناقص عمولة منصة 10%

💡 مثال:
150 حاضر × 100 ريال = 15,000
ناقص 10% = 13,500 (الصافي ليك)

💳 السحب:
"الأرباح" ← "طلب سحب"
(نفس طريقة البائعين)

⚠️ ملاحظات:
• الفلوس متاحة بعد الحدث
• لا تستطيع سحب قبل انتهاء الحدث
• العمولة 10% من المنصة

💡 نصيحة:
لو في تخفيفات أو عروض خاصة؟
الفلوس تنخفض بالتالي
احسب الميزانية بحذر!
      ''',
      isFinal: true,
      options: [
        ChatOption(
          id: 'back_organizer3',
          text: '🔙 رجوع',
          nextQuestionId: 'organizer_questions',
          responseText: 'تمام',
        ),
      ],
    ),

    'organizer_faq': ChatQuestion(
      id: 'organizer_faq',
      text: '''
❓ أسئلة مهمة للمنظمين:

Q: هل في رسوم لإنشاء حدث؟
A: لا! الحدث مجاني تماماً
   العمولة بتكون من التسجيلات فقط

Q: متى أستقبل الأموال؟
A: بعد الحدث مباشرة
   لما يتأكد الحضور

Q: أقدر أغيّر السعر بعد النشر؟
A: نعم! لكن حذر:
   الحاضرين الحاليين سيكملون بالسعر القديم

Q: كم وقت للموافقة على الحدث؟
A: الحدث ينشر فوراً
   (مافيش مراجعة)

Q: أقدر أحذف الحدث؟
A: نعم، لكن:
   لو في حاضرين = فلوسهم ترجع لهم
   وهيبلغوا بالإلغاء

Q: في خيار نسخ الحدث؟
A: نعم، لإعادة حدث مشابه
   توفر وقتك

Q: كيفية الدعاية والترويج؟
A: شارك الحدث على:
   • فيسبوك وتويتر
   • تطبيقات التواصل
   • الجروبات والقنوات
      ''',
      isFinal: true,
      options: [
        ChatOption(
          id: 'more_organizer_faq',
          text: '❓ أسئلة أكثر',
          nextQuestionId: 'organizer_faq_more',
          responseText: 'أسئلة إضافية:',
        ),
        ChatOption(
          id: 'back_organizer4',
          text: '🔙 رجوع',
          nextQuestionId: 'organizer_questions',
          responseText: 'تمام',
        ),
      ],
    ),

    'organizer_faq_more': ChatQuestion(
      id: 'organizer_faq_more',
      text: '''
❓ أسئلة إضافية:

Q: أقدر أختار الخدمات بعد الإنشاء؟
A: نعم بالطبع! في وقت أي

Q: الحدث ما بينشر ليه؟
A: قد يكون:
   • بيانات ناقصة
   • صورة ما واضحة
   • وصف بـ أخطاء

   حاول مجدداً أو تواصل الدعم

Q: أقدر أخفي الحدث من الناس؟
A: نعم، في خيار "إيقاف مؤقت"
   الحدث لن يظهر في البحث

Q: في حد سجل بالخطأ، أقدر أحذفه؟
A: نعم، في "قائمة الحضور"
   لكن فلوسه ترجع لـ

Q: تقييمات الحدث مهمة؟
A: جداً! من 5 نجوم
   الحضور يقيّمون بعد الحدث

Q: أقدر أضيف متحدثين أو برنامج؟
A: نعم! في قسم "تفاصيل الحدث"
      ''',
      isFinal: true,
      options: [
        ChatOption(
          id: 'back_organizer5',
          text: '🔙 رجوع',
          nextQuestionId: 'organizer_questions',
          responseText: 'تمام',
        ),
      ],
    ),

    // ============================================
    // قنوات التواصل
    // ============================================
    'support_channels': ChatQuestion(
      id: 'support_channels',
      text: '''
📞 طرق التواصل مع الدعم:

☎️ الهاتف:
📱 +966-XX-XXXX-XXXX
(من 9 ص لـ 10 م يومياً)

📧 البريد:
support@planz.com
(رد خلال 24 ساعة)

💬 واتساب:
+966-5X-XXXX-XXXX
(رد فوري من 9 ص لـ 11 م)

📱 التطبيق مباشرة:
"الإعدادات" ← "الدعم"
(فيه خيار للدردشة المباشرة)

🕐 ساعات العمل:
السبت - الخميس: 9 ص - 10 م
الجمعة: 4 م - 10 م

💡 قبل التواصل جهز:
• وصف المشكلة بالتفصيل
• رقم الطلب أو الحدث
• رقمك أو بريدك

⚠️ ملاحظة:
بالتطبيق أسرع الحل!
      ''',
      isFinal: true,
      options: [
        ChatOption(
          id: 'return_home',
          text: '🏠 العودة للرئيسية',
          nextQuestionId: 'start',
          responseText: 'تمام! في شيء آخر؟',
        ),
      ],
    ),
  };

  /// الحصول على السؤال
  static ChatQuestion? getQuestion(String questionId) {
    return questions[questionId];
  }

  /// بدء الدردشة
  static ChatQuestion getStartQuestion() {
    return questions['start']!;
  }
}
