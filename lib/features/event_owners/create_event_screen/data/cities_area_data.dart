


final List<String> cities = [
  'Cairo',
  'Giza',
  'Alexandria',
  'Sharm El Sheikh',
  'Hurghada',
  'Luxor',
  'Aswan',
  'Marsa Alam',
  'Port Said',
  'Suez',
  'Ismailia',
  'Mansoura',
  'Tanta',
  'Assiut',
  'Fayoum',
  'Minya',
  'Sohag',
  'Qena',
  'Dahab',
  'El Gouna',
  'New Cairo',
  '6th of October City',
  'Sheikh Zayed City',
  'Madinaty',
  'Rehab City',
  'Nasr City', // يُمكن اعتبارها مدينة فرعية كبيرة
  'Heliopolis',
];

final Map<String, List<String>> areas = {
  // القاهرة
  'Cairo': [
    'Nasr City',
    'Heliopolis',
    'Maadi',
    'Zamalek',
    'Downtown',
    'Garden City',
    'Mohandessin',
    'Dokki',
    'Agouza',
    'Manial',
    'Sayeda Zeinab',
    'Islamic Cairo',
    'Old Cairo',
    'Mokattam',
    'Abbassiya',
    'Ain Shams',
    'Shubra',
    'Rod El Farag',
    'Imbaba',
    'Bulaq',
  ],

  // الجيزة
  'Giza': [
    '6th October',
    'Sheikh Zayed',
    'Dokki',
    'Mohandessin',
    'Faisal',
    'Pyramids',
    'Haram',
    'Bulaq El Dakrur',
    'Omraneya',
    'Kerdasa',
    'Saqqara Road',
  ],

  // الإسكندرية
  'Alexandria': [
    'Miami',
    'Smouha',
    'Stanley',
    'Sidi Gaber',
    'San Stefano',
    'Roushdy',
    'Glim',
    'Montaza',
    'Abu Qir',
    'Al Agamy',
    'Borg El Arab',
    'Mandara',
    'Loranh',
    'Sidi Bishr',
    'Cleopatra',
    'Camp Chezar',
    'Sporting',
  ],

  // شرم الشيخ
  'Sharm El Sheikh': [
    'Naama Bay',
    'Sharks Bay',
    'Hadaba',
    'Old Market',
    'Nabq Bay',
    'Ras Um Sid',
    'Delta Sharm',
    'Coral Bay',
    'El Fanar',
    'Tower Bay',
  ],

  // الغردقة
  'Hurghada': [
    'Sakkala',
    'Dahar',
    'Marina',
    'El Gouna (nearby)',
    'Sekalla',
    'Arabiya',
    'Intercontinental',
    'Mubarak 2',
    'Kawthar',
    'Ahya',
    'Makadi Bay (nearby)',
    'Sahl Hasheesh (nearby)',
  ],

  // الأقصر
  'Luxor': [
    'East Bank',
    'West Bank',
    'Karnak',
    'Luxor Temple Area',
    'Corniche',
    'Medinet Habu',
    'Valley of the Kings',
    'Valley of the Queens',
    'Ramesseum',
    'Television Street',
  ],

  // أسوان
  'Aswan': [
    'City Center',
    'Nile Corniche',
    'East Bank',
    'West Bank',
    'Nubian Village',
    'Elephantine Island',
    'Philae Temple Area',
    'Souk',
    'Kitchener Island',
  ],

  // مرسى علم
  'Marsa Alam': [
    'Port Ghalib',
    'Abu Dabbab',
    'El Quseir (nearby)',
    'Marsa Mubarak',
    'Sharm El Luli',
    'Wadi Gemal',
    'Samadai Reef',
  ],

  // بورسعيد
  'Port Said': [
    'Port Fouad',
    'Al Manakh',
    'Al Arab',
    'Al Dawahy',
    'Al Sharq',
    'Al Zohour',
    'Port Said Corniche',
  ],

  // السويس
  'Suez': [
    'Arbaeen',
    'Faisal',
    'Ganayen',
    'Salam',
    'Port Tawfiq',
    'Suez Canal Area',
  ],

  // الإسماعيلية
  'Ismailia': [
    'Downtown',
    'Sheikh Zayed',
    'Al Temsah',
    'Al Fardous',
    'Sultan Hussein',
    'Lake Timsah',
  ],

  // المنصورة
  'Mansoura': [
    'Downtown',
    'Talkha',
    'Sandoub',
    'Mit Khamis',
    'El Geish Street',
    'University Area',
  ],

  // طنطا
  'Tanta': [
    'Downtown',
    'Seberbay',
    'El Mahalla Road',
    'University Zone',
    'Sayed Badawi',
  ],

  // أسيوط
  'Assiut': [
    'Downtown',
    'West Assiut',
    'University Area',
    'El Walidiya',
    'El Qusiya (nearby)',
  ],

  // الفيوم
  'Fayoum': [
    'City Center',
    'Qaroun Lake',
    'Tunis Village',
    'Wadi El Rayan',
    'Kom Oshim',
  ],

  // المنيا
  'Minya': [
    'Downtown',
    'New Minya',
    'Mallawi',
    'Beni Mazar',
    'Samalut',
  ],

  // سوهاج
  'Sohag': [
    'Downtown',
    'Akhmim',
    'Tahta',
    'Girga',
    'New Sohag',
  ],

  // قنا
  'Qena': [
    'Downtown',
    'Dendera',
    'Qift',
    'Naqada',
    'Esna (nearby)',
  ],

  // دهب
  'Dahab': [
    'Assalah',
    'Mashraba',
    'Lagoon',
    'Lighthouse',
    'Eel Garden',
    'Blue Hole',
  ],

  // الجونة
  'El Gouna': [
    'Downtown',
    'Marina',
    'Golf Area',
    'Hill Villas',
    'Mangroovy',
    'Abu Tig Marina',
  ],

  // القاهرة الجديدة
  'New Cairo': [
    '5th Settlement',
    '1st Settlement',
    '3rd Settlement',
    'Rehab City',
    'Madinaty',
    'Katameya Heights',
    'El Banafseg',
    'West Golf',
    'American University Area',
    '90th Street',
  ],

  // مدينة 6 أكتوبر
  '6th of October City': [
    'West Somid',
    'Dreamland',
    'October Gardens',
    'El Hosary',
    'El Sheikh Zayed Gate',
    'Mall of Arabia Area',
    'Industrial Zone',
  ],

  // الشيخ زايد
  'Sheikh Zayed City': [
    'Beverly Hills',
    'Westown',
    'Allegria',
    'Green Belt',
    'El Karma',
    'Arkan Plaza',
  ],

  // مدينتي
  'Madinaty': [
    'South Park',
    'Central Park',
    'Golf Area',
    'Open Air Mall',
    'Clubhouse',
  ],

  // الرحاب
  'Rehab City': [
    'Phase 1',
    'Phase 2',
    'Phase 3',
    'Phase 4',
    'Phase 5',
    'Al Rehab Mall',
  ],

  // مدينة نصر
  'Nasr City': [
    '1st Zone',
    '7th Zone',
    '8th Zone',
    '10th Zone',
    'Abbas El Akkad',
    'Makram Ebeid',
    'Roxy',
    'El Tayaran',
  ],

  // مصر الجديدة
  'Heliopolis': [
    'Korba',
    'Merghany',
    'Hegaz',
    'Ard El Golf',
    'Sheraton',
    'Almaza',
    'Roxy Square',
    'Triumph',
  ],
};