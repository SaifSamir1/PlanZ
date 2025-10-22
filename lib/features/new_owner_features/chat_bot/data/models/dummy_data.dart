// lib/data/dummy_data.dart
import '../models/chat_models.dart';

class DummyData {
  static final Map<String, ChatQuestion> questions = {
    'start': ChatQuestion(
      id: 'start',
      text: 'مرحباً بك في PlanZ! 👋\nكيف يمكنني مساعدتك اليوم؟',
      isStart: true,
      options: [
        ChatOption(
          id: 'info',
          text: '📅 معلومات الحدث',
          nextQuestionId: 'event_info',
          responseText: 'ممتاز! ما المعلومات التي تريد معرفتها؟',
        ),
        ChatOption(
          id: 'register',
          text: '✍️ التسجيل',
          nextQuestionId: 'registration',
          responseText: 'رائع! سأساعدك في عملية التسجيل',
        ),
        ChatOption(
          id: 'location',
          text: '📍 الموقع والوصول',
          nextQuestionId: 'location_info',
          responseText: 'بالطبع! إليك تفاصيل الموقع',
        ),
        ChatOption(
          id: 'pricing',
          text: '💰 الأسعار',
          nextQuestionId: 'pricing_info',
          responseText: 'ممتاز! دعني أوضح لك تفاصيل التسعير',
        ),
      ],
    ),
    
    'event_info': ChatQuestion(
      id: 'event_info',
      text: 'ما نوع المعلومات التي تريد معرفتها عن الحدث؟',
      options: [
        ChatOption(
          id: 'schedule',
          text: '🕐 الجدول الزمني',
          nextQuestionId: 'schedule_final',
          responseText: 'الحدث يبدأ الساعة 7:00 مساءً ويستمر حتى 11:00 مساءً\n\n• 7:00 - 8:00: استقبال الضيوف\n• 8:00 - 9:30: الفعالية الرئيسية\n• 9:30 - 11:00: شبكة تواصل وتفاعل',
        ),
        ChatOption(
          id: 'speakers',
          text: '🎤 المتحدثين',
          nextQuestionId: 'speakers_final',
          responseText: 'نخبة من أفضل المتحدثين:\n\n• د. أحمد محمد - خبير التسويق الرقمي\n• أ. سارة علي - مؤسسة شركة Tech Solutions\n• م. محمود حسن - مطور تطبيقات',
        ),
        ChatOption(
          id: 'agenda',
          text: '📋 جدول الأعمال',
          nextQuestionId: 'agenda_final',
          responseText: 'جدول أعمال شامل ومتنوع:\n\n• ورش عمل تفاعلية\n• عروض تقديمية ملهمة\n• جلسات أسئلة وأجوبة\n• فرص الشبكة المهنية',
        ),
        ChatOption(
          id: 'back_main',
          text: '🔙 العودة للقائمة الرئيسية',
          nextQuestionId: 'start',
          responseText: 'بالطبع! كيف يمكنني مساعدتك؟',
        ),
      ],
    ),

    'registration': ChatQuestion(
      id: 'registration',
      text: 'اختر نوع التسجيل المناسب لك:',
      options: [
        ChatOption(
          id: 'individual',
          text: '👤 تسجيل فردي',
          nextQuestionId: 'individual_final',
          responseText: 'ممتاز! للتسجيل الفردي:\n\n• املأ النموذج الإلكتروني\n• ادفع الرسوم (150 جنيه)\n• ستصلك رسالة تأكيد خلال 24 ساعة\n\nهل تريد بدء التسجيل الآن؟',
        ),
        ChatOption(
          id: 'group',
          text: '👥 تسجيل جماعي',
          nextQuestionId: 'group_final',
          responseText: 'خيار ممتاز! للتسجيل الجماعي:\n\n• خصم 20% للمجموعات (+5 أشخاص)\n• تسهيلات دفع مرنة\n• مقاعد مضمونة\n\nتواصل معنا لتفاصيل أكثر!',
        ),
        ChatOption(
          id: 'requirements',
          text: '📝 متطلبات التسجيل',
          nextQuestionId: 'requirements_final',
          responseText: 'متطلبات التسجيل بسيطة:\n\n✅ الاسم كاملاً\n✅ رقم الهاتف\n✅ البريد الإلكتروني\n✅ المهنة\n✅ دفع الرسوم',
        ),
        ChatOption(
          id: 'back_main',
          text: '🔙 العودة للقائمة الرئيسية',
          nextQuestionId: 'start',
          responseText: 'بالطبع! كيف يمكنني مساعدتك؟',
        ),
      ],
    ),

    'location_info': ChatQuestion(
      id: 'location_info',
      text: 'تفاصيل الموقع والوصول:',
      options: [
        ChatOption(
          id: 'address',
          text: '🏢 العنوان',
          nextQuestionId: 'address_final',
          responseText: 'العنوان التفصيلي:\n\n🏢 فندق النيل ريتز كارلتون\n📍 1113 كورنيش النيل، القاهرة\n🏛️ الدور الثاني - القاعة الذهبية\n\nمعالم قريبة: كوبري قصر النيل، ميدان التحرير',
        ),
        ChatOption(
          id: 'transport',
          text: '🚗 وسائل المواصلات',
          nextQuestionId: 'transport_final',
          responseText: 'وسائل الوصول المتاحة:\n\n🚗 مواقف مجانية متاحة\n🚕 أوبر/كريم من أي مكان\n🚌 مترو: محطة السادات\n✈️ من المطار: 45 دقيقة بالسيارة',
        ),
        ChatOption(
          id: 'parking',
          text: '🅿️ مواقف السيارات',
          nextQuestionId: 'parking_final',
          responseText: 'مواقف السيارات:\n\n🅿️ مواقف مجانية للحضور\n🔒 مواقف آمنة ومراقبة\n⏰ متاحة من 6:00 ص - 12:00 ص\n📍 مدخل منفصل للمواقف',
        ),
        ChatOption(
          id: 'back_main',
          text: '🔙 العودة للقائمة الرئيسية',
          nextQuestionId: 'start',
          responseText: 'بالطبع! كيف يمكنني مساعدتك؟',
        ),
      ],
    ),

    'pricing_info': ChatQuestion(
      id: 'pricing_info',
      text: 'باقات الأسعار المتاحة:',
      options: [
        ChatOption(
          id: 'standard',
          text: '⭐ الباقة العادية',
          nextQuestionId: 'standard_final',
          responseText: 'الباقة العادية - 150 جنيه:\n\n✅ حضور الفعالية كاملة\n✅ مواد تدريبية\n✅ شهادة حضور\n✅ استراحة قهوة\n✅ شبكة تواصل',
        ),
        ChatOption(
          id: 'vip',
          text: '👑 الباقة المميزة',
          nextQuestionId: 'vip_final',
          responseText: 'الباقة المميزة - 300 جنيه:\n\n✅ كل مميزات الباقة العادية\n✅ مقاعد مميزة في المقدمة\n✅ لقاء خاص مع المتحدثين\n✅ وجبة عشاء فاخرة\n✅ هدايا تذكارية',
        ),
        ChatOption(
          id: 'student',
          text: '🎓 خصم الطلاب',
          nextQuestionId: 'student_final',
          responseText: 'خصم خاص للطلاب - 100 جنيه:\n\n💰 خصم 33% من السعر العادي\n📚 مواد دراسية إضافية\n🎯 ورش مخصصة للطلاب\n📋 مطلوب: كارنيه الجامعة',
        ),
        ChatOption(
          id: 'back_main',
          text: '🔙 العودة للقائمة الرئيسية',
          nextQuestionId: 'start',
          responseText: 'بالطبع! كيف يمكنني مساعدتك؟',
        ),
      ],
    ),
  };

  // الرسائل النهائية
  static final Map<String, ChatQuestion> finalQuestions = {
    'schedule_final': ChatQuestion(
      id: 'schedule_final',
      text: 'هل تحتاج معلومات أخرى عن الحدث؟',
      isFinal: true,
      options: [
        ChatOption(
          id: 'more_info',
          text: '📞 التواصل معنا',
          nextQuestionId: 'contact_final',
          responseText: 'يمكنك التواصل معنا:\n\n📱 هاتف: 01000000000\n📧 إيميل: info@planz.com\n💬 واتساب: 01000000000',
        ),
        ChatOption(
          id: 'register_now',
          text: '✅ التسجيل الآن',
          nextQuestionId: 'register_redirect',
          responseText: 'ممتاز! سيتم تحويلك لصفحة التسجيل...',
        ),
        ChatOption(
          id: 'back_main',
          text: '🔙 القائمة الرئيسية',
          nextQuestionId: 'start',
          responseText: 'بالطبع! كيف يمكنني مساعدتك؟',
        ),
      ],
    ),
    // يمكن إضافة المزيد من الرسائل النهائية حسب الحاجة
  };

  static ChatQuestion? getQuestion(String questionId) {
    return questions[questionId] ?? finalQuestions[questionId];
  }

  static ChatQuestion getStartQuestion() {
    return questions['start']!;
  }
}
