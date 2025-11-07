// lib/data/dummy_data.dart

import '../models/chat_models.dart';

class DummyData {
  static final Map<String, ChatQuestion> questions = {
    'start': ChatQuestion(
      id: 'start',
      text:
          '🎉 مرحباً بك في PlanZ!\n\nهذا المساعد مصمم لمساعدتك في إدارة الفعاليات والخدمات والتواصل داخل التطبيق.\n\n👇 اختر من فضلك الدور الذي تريد المساعدة به:',
      isStart: true,
      options: [
        ChatOption(
          id: 'attendee_info',
          text: '👥 أنا مدعو (Attendee)',
          nextQuestionId: 'attendee_questions',
          responseText: 'حسناً — سأساعدك في متابعة الدعوات وتفاصيل الفعالية.',
        ),
        ChatOption(
          id: 'vendor_info',
          text: '🏢 مزوِّد خدمات (Vendor)',
          nextQuestionId: 'vendor_questions',
          responseText: 'ممتاز — سأساعدك في إدارة الخدمات والطلبات والإيرادات.',
        ),
        ChatOption(
          id: 'organizer_info',
          text: '📅 منظّم فعالية (Event Owner)',
          nextQuestionId: 'organizer_questions',
          responseText: 'تمام — سأرشدك إلى إنشاء الحدث وإدارة الدعوات والتواصل مع Vendors.',
        ),
        ChatOption(
          id: 'app_owner_info',
          text: '🔑 مالك التطبيق (App Owner)',
          nextQuestionId: 'app_owner_questions',
          responseText: 'حسنًا — ستجد أدوات لإدارة النظام والإحصائيات والإشعارات.',
        ),
        ChatOption(
          id: 'support_info',
          text: '🛠️ الدعم الفني',
          nextQuestionId: 'support_channels',
          responseText: 'سأعرض لك طرق التواصل وإرشادات الحلول السريعة.',
        ),
      ],
    ),

    'attendee_questions': ChatQuestion(
      id: 'attendee_questions',
      text:
          '✨ بصفتك مدعوًا (Attendee)، يمكنك متابعة الدعوات ومعرفة تفاصيل الفعالية والتحديثات.\n\nما الذي ترغب بالاطلاع عليه؟',
      options: [
        ChatOption(
          id: 'invitations_view',
          text: '📨 عرض الدعوات (Invitations)',
          nextQuestionId: 'attendee_invitations',
          responseText: 'سأعرض لك قائمة الدعوات والخيارات المتاحة.',
        ),
        ChatOption(
          id: 'event_info',
          text: '📋 تفاصيل الفعالية (Event Details)',
          nextQuestionId: 'attendee_event_info',
          responseText: 'سأعرض معلومات الفعالية وبيانات التواصل مع المنظّم إن أمكن.',
        ),
        ChatOption(
          id: 'attendee_notifications',
          text: '🔔 الإشعارات (Notifications)',
          nextQuestionId: 'attendee_notifications',
          responseText: 'سأحولك إلى شاشة الإشعارات لعرض آخر التنبيهات.',
        ),
        ChatOption(
          id: 'attendee_support',
          text: '🛠️ مساعدة / تواصل مع الدعم',
          nextQuestionId: 'support_channels',
          responseText: 'أوجهك إلى قنوات الدعم الرسمية.',
        ),
        ChatOption(
          id: 'back_home_attendee',
          text: '🔙 العودة للرئيسية',
          nextQuestionId: 'start',
          responseText: 'تم الرجوع إلى القائمة الرئيسية.',
        ),
      ],
    ),

    'attendee_invitations': ChatQuestion(
      id: 'attendee_invitations',
      text:
          '📨 الدعوات (Invitations):\n\nيمكنك عرض جميع الدعوات المرسلة إليك من منظّمي الفعاليات في صفحة "Invitations" داخل الحساب.\nفي كل دعوة ستجد حالة الدعوة (مقبولة / مرفوضة / بانتظار) وخيارات للرد أو عرض تفاصيل الحدث.',
      isFinal: true,
      options: [
        ChatOption(
          id: 'open_invitations',
          text: '🔎 افتح قائمة الدعوات',
          nextQuestionId: 'invitations_redirect',
          responseText: 'سأفتح صفحة الدعوات الآن.',
          route: '/invitation'
        ),
        ChatOption(
          id: 'back_attendee_invitations',
          text: '🔙 رجوع',
          nextQuestionId: 'attendee_questions',
          responseText: 'تمام، هل تود معلومات أخرى؟',
        ),
      ],
    ),

    'invitations_redirect': ChatQuestion(
      id: 'invitations_redirect',
      text:
          '⏳ جارٍ التحويل إلى صفحة Invitations...\n\n💡 تلميح: يمكنك الرد على الدعوة أو عرض تفاصيل المكان والوقت من داخل كل بطاقة دعوة.',
      isFinal: true,
      options: [
        ChatOption(
          id: 'invitations_done',
          text: '✅ فهمت',
          nextQuestionId: 'attendee_questions',
          responseText: 'حسناً، هل أساعدك في شيء آخر؟',
        ),
      ],
    ),

    'attendee_event_info': ChatQuestion(
      id: 'attendee_event_info',
      text:
          '📋 معلومات الفعالية (Event Details):\n\nتحتوي صفحة كل فعالية على: التاريخ والوقت، الموقع مع إمكانية فتح الخريطة، وصف الحدث، وأسماء مزوّدي الخدمة المشاركين إن وُجدوا. كما تجد اسم الشخص المنظّم ووسائل التواصل إن كانت متاحة.',
      isFinal: true,
      options: [
        ChatOption(
          id: 'open_event_details',
          text: '🔎 افتح تفاصيل الفعالية',
          nextQuestionId: 'event_details_redirect',
          responseText: 'سأعرض تفاصيل الفعالية الآن.',
        ),
        ChatOption(
          id: 'back_attendee_event_info',
          text: '🔙 رجوع',
          nextQuestionId: 'attendee_questions',
          responseText: 'هل تحتاج إلى شيء آخر؟',
        ),
      ],
    ),

    'event_details_redirect': ChatQuestion(
      id: 'event_details_redirect',
      text:
          '⏳ جاري فتح تفاصيل الفعالية...\n\n💡 تذكير: الحضور في PlanZ يتم عن طريق دعوات من منظّم الفعالية، ولا يمكن التسجيل العام إلا إذا فتح المنظّم التسجيل.',
      isFinal: true,
      options: [
        ChatOption(
          id: 'event_details_done',
          text: '✅ فهمت',
          nextQuestionId: 'attendee_questions',
          responseText: 'حسناً، هل أفتح لك صفحة الدعوات الآن؟',
        ),
      ],
    ),

    'attendee_notifications': ChatQuestion(
      id: 'attendee_notifications',
      text:
          '🔔 الإشعارات (Notifications):\n\nستصلك إشعارات عند أي تعديل في الفعالية أو عند إرسال تذكير قبل الموعد، كما يصلك إشعار عند أي رسالة من المنظّم أو عند تغيير مكان أو توقيت الحدث.',
      isFinal: true,
      options: [
        ChatOption(
          id: 'open_notifications_attendee',
          text: 'افتح الإشعارات',
          nextQuestionId: 'notifications_redirect',
          responseText: 'سأفتح شاشة الإشعارات.',
          route: '/notifications'
        ),
        ChatOption(
          id: 'back_attendee_notifications',
          text: '🔙 رجوع',
          nextQuestionId: 'attendee_questions',
          responseText: 'تمام.',
        ),
      ],
    ),

    'notifications_redirect': ChatQuestion(
      id: 'notifications_redirect',
      text:
          '⏳ جارٍ التحويل إلى Notifications...\n\n📍 يمكنك متابعة الإشعارات الخاصة بالدعوات والتذكيرات والتحديثات من هذه الشاشة.',
      isFinal: true,
      options: [
        ChatOption(
          id: 'notifications_done',
          text: '✅ تم',
          nextQuestionId: 'attendee_questions',
          responseText: 'هل أستعرض لك شيئًا آخر؟',
        ),
      ],
    ),

    'vendor_questions': ChatQuestion(
      id: 'vendor_questions',
      text:
          '🏢 بصفتك Vendor، يمكنك إضافة خدمات، استقبال طلبات من منظّمي الفعاليات، وإدارة الأرباح.\nما الذي تود فعله الآن؟',
      options: [
        ChatOption(
          id: 'vendor_how_to_add',
          text: '➕ كيف أضيف خدمة جديدة؟',
          nextQuestionId: 'vendor_add_service',
          responseText: 'سأرشدك لخطوات إضافة الخدمة.',
        ),
        ChatOption(
          id: 'vendor_orders',
          text: '📦 إدارة الطلبات والطلبات الواردة',
          nextQuestionId: 'vendor_orders_guide',
          responseText: 'أعرض لك طريقة إدارة الطلبات خطوة بخطوة.',
        ),
        ChatOption(
          id: 'vendor_earnings',
          text: '💰 الأرباح والسحب',
          nextQuestionId: 'vendor_earnings_guide',
          responseText: 'معلومات حول كيفية سحب أرباحك.',
        ),
        ChatOption(
          id: 'vendor_support',
          text: '❓ أسئلة وسياسات (FAQ)',
          nextQuestionId: 'vendor_faq',
          responseText: 'أسئلة وإجابات شائعة للبائعين.',
        ),
        ChatOption(
          id: 'back_to_start_vendor',
          text: '🔙 العودة للرئيسية',
          nextQuestionId: 'start',
          responseText: 'تم الرجوع للرئيسية.',
        ),
      ],
    ),

    'vendor_add_service': ChatQuestion(
      id: 'vendor_add_service',
      text:
          '➕ إضافة خدمة جديدة:\n\n1️⃣ انتقل إلى “Profile” → “My Services” → “Add Service”.\n2️⃣ أضف اسم الخدمة، وصفًا واضحًا، موقع العمل (إن لزم)، والأسعار.\n3️⃣ أرفق صورًا عالية الجودة وأمثلة أعمال إن وُجدت.\n4️⃣ اضغط على “Send for approval”.\n\n✅ يتم مراجعة الخدمة من الفريق، وستتلقى إشعارًا عند الموافقة.',
      isFinal: true,
      options: [
        ChatOption(
          id: 'vendor_add_confirm',
          text: 'افتح صفحة الخدمات',
          nextQuestionId: 'vendor_services_redirect',
          responseText: 'سأفتح صفحة الخدمات الآن.',
          route: '/add_paackage'
        ),
        ChatOption(
          id: 'back_vendor_add',
          text: '🔙 رجوع',
          nextQuestionId: 'vendor_questions',
          responseText: 'هل تحتاج شرحًا إضافيًا؟',
        ),
      ],
    ),

    'vendor_services_redirect': ChatQuestion(
      id: 'vendor_services_redirect',
      text:
          '⏳ جارٍ التحويل إلى My Services...\n\n📌 تذكّر: وصف الخدمة الجيد والصور الواضحة تزيد من فرص قبول وظهور الخدمة.',
      isFinal: true,
      options: [
        ChatOption(
          id: 'vendor_services_done',
          text: '✅ فهمت',
          nextQuestionId: 'vendor_questions',
          responseText: 'هل تريد مساعدة في تسعير الخدمة؟',
        ),
      ],
    ),

    'vendor_orders_guide': ChatQuestion(
      id: 'vendor_orders_guide',
      text:
          '📦 إدارة الطلبات:\n\n1️⃣ اذهب إلى Profile → Requests.\n2️⃣ اطلع على التفاصيل (اسم المنظّم – تاريخ الحدث – متطلبات الخدمة).\n3️⃣ اختر Accept أو Reject. عند القبول يُرسل إشعار للمنظّم، وعند الرفض يُرفق سبب.\n\n⚠️ نصيحة: حاول الرد خلال 24 ساعة لتجنب الإلغاء التلقائي.',
      isFinal: true,
      options: [
        ChatOption(
          id: 'vendor_orders_open',
          text: 'افتح صفحة الطلبات',
          nextQuestionId: 'vendor_orders_redirect',
          responseText: 'أفتح صفحة الطلبات الآن.',
          route: '/vendor_requests'
        ),
        ChatOption(
          id: 'back_vendor_orders',
          text: '🔙 رجوع',
          nextQuestionId: 'vendor_questions',
          responseText: 'تمام.',
        ),
      ],
    ),

    'vendor_orders_redirect': ChatQuestion(
      id: 'vendor_orders_redirect',
      text:
          '⏳ جارٍ التحويل إلى Requests...\n\n📍 عند قبول الطلب ستستلم تفاصيل التواصل مع المنظّم داخل التطبيق.',
      isFinal: true,
      options: [
        ChatOption(
          id: 'vendor_orders_done',
          text: '✅ تم',
          nextQuestionId: 'vendor_questions',
          responseText: 'هل تود معرفة المزيد عن إدارة الطلب؟',
        ),
      ],
    ),

    'vendor_earnings_guide': ChatQuestion(
      id: 'vendor_earnings_guide',
      text:
          '💰 الأرباح والسحب:\n\n• تظهر الأرباح في Profile → Finances.\n• الرصيد المعلق يتحوّل إلى رصيد متاح بعد تأكيد الحدث.\n• للسحب: اختر Withdraw، حدّد المبلغ، ثم طريقة التحويل المسجلة.\n\n⏳ مدة التحويل عادة 2–3 أيام عمل بعد تنفيذ السحب.\n⚠️ تذكّر أن هنالك عمولة منصة تُطبّق كما هو موضح في الشروط.',
      isFinal: true,
      options: [
        ChatOption(
          id: 'vendor_withdraw_open',
          text: 'افتح صفحة الأرباح',
          nextQuestionId: 'vendor_finances_redirect',
          responseText: 'سأفتح صفحة الأرباح الآن.',
          route: '/vendor_financial'
        ),
        ChatOption(
          id: 'back_vendor_earnings',
          text: '🔙 رجوع',
          nextQuestionId: 'vendor_questions',
          responseText: 'هل تحتاج مزيد توضيح؟',
        ),
      ],
    ),

    'vendor_finances_redirect': ChatQuestion(
      id: 'vendor_finances_redirect',
      text:
          '⏳ جارٍ التحويل إلى Finances...\n\n📌 تأكد من تسجيل الحساب البنكي (IBAN) بشكل صحيح لتسريع عملية السحب.',
      isFinal: true,
      options: [
        ChatOption(
          id: 'vendor_finances_done',
          text: '✅ فهمت',
          nextQuestionId: 'vendor_questions',
          responseText: 'هل أساعدك في شيء آخر؟',
        ),
      ],
    ),

    'vendor_faq': ChatQuestion(
      id: 'vendor_faq',
      text:
          '❓ أسئلة شائعة للبائعين:\n\nQ: كم عمولة المنصة؟\nA: العمولة موضّحة في شروط الاستخدام (تختلف حسب السياسة الحالية).\n\nQ: كم وقت الرد على الطلب؟\nA: يُنصح بالرد خلال 24 ساعة.\n\nQ: هل يمكن تعديل سعر الخدمة بعد الموافقة؟\nA: لا يفضّل تعديل السعر بعد قبول الطلب دون تنسيق مع المنظّم.\n\nQ: ما المعايير لقبول الخدمة؟\nA: الصور الواضحة، وصف دقيق، وسعر منطقي يساهمون في القبول والظهور.',
      isFinal: true,
      options: [
        ChatOption(
          id: 'vendor_faq_more',
          text: 'الأسئلة الأكثر',
          nextQuestionId: 'vendor_faq_more',
          responseText: 'إليك مزيد من الأسئلة الشائعة.',
        ),
        ChatOption(
          id: 'back_vendor_faq',
          text: '🔙 رجوع',
          nextQuestionId: 'vendor_questions',
          responseText: 'تمام.',
        ),
      ],
    ),

    'vendor_faq_more': ChatQuestion(
      id: 'vendor_faq_more',
      text:
          '❓ أسئلة إضافية:\n\n• تواصل مع العميل يجب أن يتم عبر منصة PlanZ حفاظًا على الخصوصية.\n• يمكن تعطيل الخدمة مؤقتًا عبر خيار “Pause”.\n• تجنّب مشاركة معلومات دفع شخصية خارج النظام.',
      isFinal: true,
      options: [
        ChatOption(
          id: 'back_vendor_faq_more',
          text: '🔙 رجوع',
          nextQuestionId: 'vendor_questions',
          responseText: 'تمام.',
        ),
      ],
    ),

    'organizer_questions': ChatQuestion(
      id: 'organizer_questions',
      text:
          '📅 بصفتك منظّم فعالية، يمكنك إنشاء الأحداث، إدارة الدعوات، ربط Vendors، وإرسال الإشعارات للحضور.\nكيف أستطيع مساعدتك؟',
      options: [
        ChatOption(
          id: 'organizer_how_to_create',
          text: '🆕 كيفية إنشاء فعالية جديدة؟',
          nextQuestionId: 'organizer_create_guide',
          responseText: 'أرشدك لخطوات إنشاء الفعالية.',
        ),
        ChatOption(
          id: 'organizer_manage',
          text: '📊 إدارة الفعالية بعد الإنشاء',
          nextQuestionId: 'organizer_manage_guide',
          responseText: 'أعرض لك أدوات الإدارة المتاحة.',
        ),
        ChatOption(
          id: 'organizer_payment',
          text: '💳 إعدادات الإيرادات والسحب',
          nextQuestionId: 'organizer_payment_guide',
          responseText: 'معلومات حول الإيرادات وطلبات السحب.',
        ),
        ChatOption(
          id: 'organizer_support',
          text: '❓ أسئلة وسياسات',
          nextQuestionId: 'organizer_faq',
          responseText: 'إجابات على الأسئلة الشائعة للمنظّمين.',
        ),
        ChatOption(
          id: 'back_to_start_organizer',
          text: '🔙 العودة للرئيسية',
          nextQuestionId: 'start',
          responseText: 'تم الرجوع للرئيسية.',
        ),
      ],
    ),

    'organizer_create_guide': ChatQuestion(
      id: 'organizer_create_guide',
      text:
          '🆕 خطوات إنشاء فعالية:\n\n1️⃣ اذهب إلى Dashboard → My Events → Create Event.\n2️⃣ أدخل المعلومات الأساسية: الاسم – الوصف – التاريخ – الوقت – المكان.\n3️⃣ حدّد إعدادات الحضور: دعوات خاصة أو تسجيل عام (تحديد ما إذا كانت الدعوة مطلوبة).\n4️⃣ أضف Vendors إن رغبت وارفق صورة بانر.\n5️⃣ اضغط Publish أو Save كمسوّدة.\n\n✅ بعد إنشاء الحدث يمكنك إرسال دعوات مباشرة للمشاركين وإدارة استجاباتهم.',
      isFinal: true,
      options: [
        ChatOption(
          id: 'organizer_create_start',
          text: '🚀 ابدأ الآن',
          nextQuestionId: 'create_redirect_organizer',
          responseText: 'سأحوّلك لصفحة إنشاء الحدث.',
          route: '/create_event'

        ),
        ChatOption(
          id: 'back_organizer_create',
          text: '🔙 رجوع',
          nextQuestionId: 'organizer_questions',
          responseText: 'هل تحتاج مساعدة إضافية؟',
        ),
      ],
    ),

    'create_redirect_organizer': ChatQuestion(
      id: 'create_redirect_organizer',
      text:
          '⏳ جاري التحويل إلى صفحة إنشاء الحدث...\n\n💡 تذكير: إن اخترت وضع الدعوات كخاصة (invitation-only) فسيتلقى الحضور دعوات مباشرة عبر التطبيق.',
      isFinal: true,
      options: [
        ChatOption(
          id: 'continue_org',
          text: '✅ فهمت',
          nextQuestionId: 'organizer_questions',
          responseText: 'هل ترغب رابط لخطوات مفصّلة؟',
        ),
      ],
    ),

    'organizer_manage_guide': ChatQuestion(
      id: 'organizer_manage_guide',
      text:
          '📊 إدارة الفعالية:\n\n• من Dashboard → My Events اختر الفعالية.\n• يمكنك تعديل البيانات الأساسية أو تحديث المكان أو الوقت.\n• إدارة الدعوات: عرض المستجيبين وإرسال تذكيرات.\n• إدارة Vendors: مراجعة الطلبات والموافقات.\n\n⚠️ ملاحظة: عند تعديل بيانات مهمة (مثل التاريخ أو المكان) سيُرسل إشعار تلقائيًا إلى المدعوين.',
      isFinal: true,
      options: [
        ChatOption(
          id: 'back_organizer_manage',
          text: '🔙 رجوع',
          nextQuestionId: 'organizer_questions',
          responseText: 'هل تود فتح صفحة إدارة الفعالية الآن؟',
        ),
      ],
    ),

    'organizer_payment_guide': ChatQuestion(
      id: 'organizer_payment_guide',
      text:
          '💳 الإيرادات والسحب:\n\n• الإيرادات تظهر في Dashboard → Finances.\n• الإيراد الصافي = إجمالي المبيعات ناقص عمولة المنصة.\n• للسحب: استخدم خيار Withdraw وحدد الحساب البنكي المسجّل.\n\n⏳ عادةً تستغرق عمليات السحب بضعة أيام عمل حسب البنك وسياسة المنصة.',
      isFinal: true,
      options: [
        ChatOption(
          id: 'back_organizer_payment',
          text: '🔙 رجوع',
          nextQuestionId: 'organizer_questions',
          responseText: 'هل تحتاج شرحًا لخطوات السحب؟',
        ),
      ],
    ),

    'organizer_faq': ChatQuestion(
      id: 'organizer_faq',
      text:
          '❓ أسئلة للمنظّمين:\n\nQ: هل يمكن جعل الحدث خاصًا (دعوات فقط)؟\nA: نعم، يمكنك اختيار invitation-only عند الإنشاء.\n\nQ: هل يتلقى الحضور إشعارًا عند تعديل الحدث؟\nA: نعم، يتم إرسال إشعار تلقائيًا عند تغيير معلومات هامة.\n\nQ: كيف أضيف Vendor للفعالية؟\nA: من صفحة الفعالية اختر Vendors ثم أرسل عرض التعاون أو الموافقة على الطلبات الواردة.',
      isFinal: true,
      options: [
        ChatOption(
          id: 'more_organizer_faq',
          text: 'المزيد من الأسئلة',
          nextQuestionId: 'organizer_faq_more',
          responseText: 'إليك مزيد من الأسئلة الشائعة.',
        ),
        ChatOption(
          id: 'back_organizer_faq',
          text: '🔙 رجوع',
          nextQuestionId: 'organizer_questions',
          responseText: 'تم الرجوع.',
        ),
      ],
    ),

    'organizer_faq_more': ChatQuestion(
      id: 'organizer_faq_more',
      text:
          '❓ أسئلة إضافية:\n\n• عند إلغاء فعالية لديها مدعوين سيتم إعلامهم وسيتم تطبيق سياسات الاسترجاع وفقًا لشروط الحدث.\n• يمكنك نسخ حدث موجود لإعادة استخدام الإعدادات.\n• تأكد من تحديث معلومات الدفع والحساب البنكي قبل طلب السحب.',
      isFinal: true,
      options: [
        ChatOption(
          id: 'back_organizer_faq_more',
          text: '🔙 رجوع',
          nextQuestionId: 'organizer_questions',
          responseText: 'هل أساعدك في شيء آخر؟',
        ),
      ],
    ),

    'support_channels': ChatQuestion(
      id: 'support_channels',
      text:
          '📞 قنوات التواصل مع الدعم:\n\n📧 البريد الإلكتروني: support@planz.com (الرد خلال 24 ساعة)\n☎️ الهاتف: +966-XX-XXXX-XXXX (ساعات العمل مذكورة في التطبيق)\n💬 الدردشة داخل التطبيق: Dashboard → الدعم\n\n💡 قبل التواصل جهز: وصف المشكلة، اسم المستخدم، ورقم الحدث إن وُجد.',
      isFinal: true,
      options: [
        ChatOption(
          id: 'return_home',
          text: '🏠 العودة للرئيسية',
          nextQuestionId: 'start',
          responseText: 'تم الرجوع إلى القائمة الرئيسية.',
          route: '/chat_bot'
        ),
      ],
    ),

    'app_owner_questions': ChatQuestion(
      id: 'app_owner_questions',
      text:
          '🔑 بصفتك App Owner، لديك صلاحيات لإدارة المستخدمين، مراجعة الإحصائيات، وإرسال إشعارات عامة.\nما الذي تريد تنفيذه الآن؟',
      options: [
        ChatOption(
          id: 'manage_users',
          text: '👥 إدارة المستخدمين',
          nextQuestionId: 'manage_users',
          responseText: 'أدلك على شاشة إدارة المستخدمين.',
        ),
        ChatOption(
          id: 'analytics',
          text: '📊 الإحصائيات والتقارير',
          nextQuestionId: 'analytics',
          responseText: 'أعرض لك طرق الوصول للتقارير.',
        ),
        ChatOption(
          id: 'send_notifications',
          text: '🔔 إرسال إشعارات عامة',
          nextQuestionId: 'send_notifications',
          responseText: 'أرشدك لصفحة إرسال الإشعارات.',
        ),
        ChatOption(
          id: 'back_app_owner',
          text: '🔙 الرجوع للرئيسية',
          nextQuestionId: 'start',
          responseText: 'تم الرجوع.',
          route: '/chat_bot'
        ),
      ],
    ),

    'manage_users': ChatQuestion(
      id: 'manage_users',
      text:
          '👥 إدارة المستخدمين:\n\nمن Dashboard → Users يمكنك البحث عن حسابات المستخدمين، تعديل الأدوار، وتعطيل أو حذف حسابات وفقًا للسياسات.\nهل ترغب فتح صفحة المستخدمين الآن؟',
      isFinal: true,
      options: [
        ChatOption(
          id: 'open_users',
          text: 'افتح صفحة Users',
          nextQuestionId: 'users_redirect',
          responseText: 'سأفتح صفحة المستخدمين الآن.',
          // route: '/users_screen'
        ),
        ChatOption(
          id: 'back_manage_users',
          text: '🔙 رجوع',
          nextQuestionId: 'app_owner_questions',
          responseText: 'هل تحتاج أي إجراء إضافي؟',
        ),
      ],
    ),

    'users_redirect': ChatQuestion(
      id: 'users_redirect',
      text:
          '⏳ جارٍ التحويل إلى Users...\n\n📍 تأكد من صلاحياتك قبل إجراء تغييرات على الحسابات الحساسة.',
      isFinal: true,
      options: [
        ChatOption(
          id: 'users_done',
          text: '✅ تم',
          nextQuestionId: 'app_owner_questions',
          responseText: 'هل تود خطوات لإجراء تعديل محدد؟',
        ),
      ],
    ),

    'analytics': ChatQuestion(
      id: 'analytics',
      text:
          '📊 الوصول للتقارير:\n\nمن Dashboard → Analytics يمكنك مشاهدة إحصائيات عن الفعاليات، أعداد الدعوات، أداء Vendors، وإيرادات المنصة. كما يمكنك تصدير تقارير حسب الفترة الزمنية.',
      isFinal: true,
      options: [
        ChatOption(
          id: 'open_analytics',
          text: 'افتح Analytics',
          nextQuestionId: 'analytics_redirect',
          responseText: 'جارٍ فتح لوحة الإحصائيات.',
          route: '/owner_overview'
        ),
        ChatOption(
          id: 'back_analytics',
          text: '🔙 رجوع',
          nextQuestionId: 'app_owner_questions',
          responseText: 'هل ترغب تقريرًا محددًا؟',
        ),
      ],
    ),

    'analytics_redirect': ChatQuestion(
      id: 'analytics_redirect',
      text:
          '⏳ جارٍ التحويل إلى Analytics...\n\n📍 استخدم الفلاتر لعرض البيانات حسب التاريخ أو الفعالية أو الدور.',
      isFinal: true,
      options: [
        ChatOption(
          id: 'analytics_done',
          text: '✅ فهمت',
          nextQuestionId: 'app_owner_questions',
          responseText: 'هل أساعدك بتقرير جاهز؟',
        ),
      ],
    ),

    'send_notifications': ChatQuestion(
      id: 'send_notifications',
      text:
          '🔔 إرسال إشعارات:\n\nمن Dashboard → Notifications يمكنك إرسال إشعار عام أو مخصص لفئة محددة من المستخدمين (Organizers, Vendors, Attendees).\nاختر الفئة، اكتب النص، ثم اضغط Send.',
      isFinal: true,
      options: [
        ChatOption(
          id: 'open_notifications_app_owner',
          text: 'افتح Notifications',
          nextQuestionId: 'notifications_redirect_app_owner',
          responseText: 'سأفتح لوحة الإشعارات الآن.',
          // route: '/notifications'
        ),
        ChatOption(
          id: 'back_send_notifications',
          text: '🔙 رجوع',
          nextQuestionId: 'app_owner_questions',
          responseText: 'هل تريد مساعدة في صيغة الإشعار؟',
        ),
      ],
    ),

    'notifications_redirect_app_owner': ChatQuestion(
      id: 'notifications_redirect_app_owner',
      text:
          '⏳ جارٍ التحويل إلى Notifications...\n\n📌 تذكير: عند إرسال إشعار إلى Attendees سيصل كتنبيه داخل التطبيق وفقًا لإعدادات الإشعارات لديهم.',
      isFinal: true,
      options: [
        ChatOption(
          id: 'notifications_app_owner_done',
          text: '✅ تم',
          nextQuestionId: 'app_owner_questions',
          responseText: 'هل ترغب إرسال إشعار تجريبي الآن؟',
        ),
      ],
    ),
  };

  static ChatQuestion? getQuestion(String questionId) {
    return questions[questionId];
  }

  static ChatQuestion getStartQuestion() {
    return questions['start']!;
  }
}
