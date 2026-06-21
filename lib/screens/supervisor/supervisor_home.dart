import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:attendance_app/main.dart';

class SupervisorHome extends StatefulWidget {
  const SupervisorHome({super.key});

  @override
  State<SupervisorHome> createState() => _SupervisorHomeState();
}

class _SupervisorHomeState extends State<SupervisorHome> {
  final SupabaseClient supabase = Supabase.instance.client;

  // حقول إدخال بيانات الشيخ
  final List<String> nationalitiesList = [
  "سعودي / Saudi", "يمني / Yemeni", "مصري / Egyptian", "باكستاني / Pakistani", 
  "أفغاني / Afghan", "ألباني / Albanian", "جزائري / Algerian", "أمريكي / American", 
  "أندوراني / Andorran", "أنغولي / Angolan", "أرجنتيني / Argentine", "أرميني / Armenian", 
  "أسترالي / Australian", "نمساوي / Austrian", "أذربيجاني / Azerbaijani", "بحريني / Bahraini", 
  "بنجلاديشي / Bangladeshi", "بربادي / Barbadian", "بلجيكي / Belgian", "بليزي / Belizean", 
  "بنيني / Beninese", "بوتاني / Bhutanese", "بوليفي / Bolivian", "بوسني / Bosnian", 
  "بوتسواني / Botswanan", "برازيلي / Brazilian", "بريطاني / British", "بروناي / Bruneian", 
  "بلغاري / Bulgarian", "بوركيني / Burkinabe", "بوروندي / Burundian", "كمبودي / Cambodian", 
  "كاميروني / Cameroonian", "كندي / Canadian", "تشادي / Chadian", "تشيلي / Chilean", 
  "صيني / Chinese", "كولومبي / Colombian", "كوموري / Comoran", "كونغولي / Congolese", 
  "كوستاريكي / Costa Rican", "كرواتي / Croatian", "كوبي / Cuban", "قبرصي / Cypriot", 
  "تشيكي / Czech", "دنماركي / Danish", "جيبوتي / Djiboutian", "دومينيكاني / Dominican", 
  "هولندي / Dutch", "إكوادوري / Ecuadorian", "إماراتي / Emirati", "إريتري / Eritrean", 
  "إستوني / Estonian", "إثيوبي / Ethiopian", "فيجي / Fijian", "فنلندي / Finnish", 
  "فرنسي / French", "جابوني / Gabonese", "جامبي / Gambian", "جورجي / Georgian", 
  "ألماني / German", "غاني / Ghanaian", "يوناني / Greek", "غواتيمالي / Guatemalan", 
  "غيني / Guinean", "هايتي / Haitian", "هندوراسي / Honduran", "مجري / Hungarian", 
  "آيسلندي / Icelandic", "هندي / Indian", "إندونيسي / Indonesian", "إيراني / Iranian", 
  "عراقي / Iraqi", "أيرلندي / Irish", "إيطالي / Italian", "عاجي / Ivorian", 
  "جامايكي / Jamaican", "ياباني / Japanese", "أردني / Jordanian", "كازاخستاني / Kazakhstani", 
  "كيني / Kenyan", "كويتي / Kuwaiti", "قرغيزي / Kyrgyz", "لاوسي / Laotian", 
  "لاتفي / Latvian", "لبناني / Lebanese", "ليبيري / Liberian", "ليبي / Libyan", 
  "ليتواني / Lithuanian", "لوكسمبورغي / Luxembourgish", "مقدوني / Macedonian", 
  "مدغشقري / Malagasy", "مالاوي / Malawian", "ماليزي / Malaysian", "مالديفي / Maldivian", 
  "مالي / Malian", "مالطي / Maltese", "موريتاني / Mauritanian", "موريشيوسي / Mauritian", 
  "مكسيكي / Mexican", "مولدوفي / Moldovan", "موناكي / Monacan", "منغولي / Mongolian", 
  "مغربي / Moroccan", "موزمبيقي / Mozambican", "ناميبي / Namibian", "نيبالي / Nepalese", 
  "نيوزيلندي / New Zealander", "نيكاراغوي / Nicaraguan", "نيجري / Nigerien", 
  "نيجيري / Nigerian", "كوري / Korean", "نرويجي / Norwegian", "عماني / Omani", 
  "فلسطيني / Palestinian", "بنصفي / Panamanian", "باراغواياني / Paraguayan", 
  "بيروفي / Peruvian", "فلبيني / Filipino", "بولندي / Polish", "برتغالي / Portuguese", 
  "قطري / Qatari", "روماني / Romanian", "روسي / Russian", "رواندي / Rwandan", 
  "ساموائي / Samoan", "سان ماريني / San Marinese", "سوداني / Sudanese", "سنغالي / Senegalese", 
  "صربي / Serbian", "سيراليوني / Sierra Leonean", "سنغافوري / Singaporean", 
  "سلوفاكي / Slovak", "سلوفيني / Slovenian", "صومالي / Somali", "جنوب أفريقي / South African", 
  "إسباني / Spanish", "سريلانكي / Sri Lankan", "سويدي / Swedish", "سويسري / Swiss", 
  "سوري / Syrian", "تايواني / Taiwanese", "طاجيكي / Tajik", "تنزاني / Tanzanian", 
  "تايلاندي / Thai", "توغولي / Togolese", "تونسي / Tunisian", "تركي / Turkish", 
  "تركمانستاني / Turkmen", "أوغندي / Ugandan", "أوكراني / Ukrainian", "أوروغواياني / Uruguayan", 
  "أوزبكي / Uzbek", "فنزويلي / Venezuelan", "فيتنامي / Vietnamese", "زيمبابوي / Zimbabwean"
];
  final TextEditingController _sheikhNameController = TextEditingController();
  final TextEditingController _sheikhPhoneController = TextEditingController();
  final TextEditingController _sheikhMosqueController = TextEditingController();
  final TextEditingController _sheikhHalagaNameController = TextEditingController();
  final TextEditingController _sheikhNationalityController = TextEditingController();

  // حقول إدخال بيانات الطالب
  final TextEditingController _studentNameController = TextEditingController();
  final TextEditingController _studentPhoneController = TextEditingController();
  final TextEditingController _studentNationalityController = TextEditingController();
  final TextEditingController _studentIdController = TextEditingController(); // رقم الهوية
  String? _selectedIdentityType; // نوع الهوية المضاف حديثاً (هوية، إقامة، جواز)
  String? _selectedStudentStatus; // حالة الطالب المضافة حديثاً (فعال، غير فعال، مفصول، معلق)
  String? _selectedSheikhIdForStudent;
  String? _selectedHalagaIdForStudent;

  // حقول إدخال بيانات الحلقة
  final TextEditingController _halagaNameController = TextEditingController();
  final TextEditingController _halagaNumberController = TextEditingController();
  final TextEditingController _halagaSupervisorController = TextEditingController();
  String? _selectedSheikhIdForHalaga;

  // حقول إدخال بيانات المسجد الجديد
  final TextEditingController _mosqueNameController = TextEditingController();
  final TextEditingController _mosqueLocationController = TextEditingController();
  final TextEditingController _mosqueCityController = TextEditingController();
  final TextEditingController _mosqueDistrictController = TextEditingController();
  final TextEditingController _mosqueImamController = TextEditingController();

  // قوائم جلب البيانات من المخدم لقوائم الاختيار
  List<Map<String, dynamic>> _sheikhsList = [];
  List<Map<String, dynamic>> _halagasList = [];

  // خيارات القوائم المنسدلة لطلب الزبون
  final List<String> _identityTypes = ["هوية", "إقامة", "جواز"];
  final List<String> _studentStatuses = ["فعال", "غير فعال", "مفصول", "معلق"];

  @override
  void initState() {
    super.initState();
    _loadDropdownData();
  }

  // دالة جلب البيانات لتغذية القوائم المنسدلة
  Future<void> _loadDropdownData() async {
    try {
      final sheikhsData = await supabase.from('sheikhs').select('id, name');
      final halagasData = await supabase.from('halagas').select('id, name');

      setState(() {
        _sheikhsList = List<Map<String, dynamic>>.from(sheikhsData);
        _halagasList = List<Map<String, dynamic>>.from(halagasData);
      });
    } catch (e) {
      if (!e.toString().contains("PGRST205")) { // تجاهل خطأ عدم وجود بيانات في الجدول
        _showSnackBar("خطأ في تحديث القوائم: $e", isError: true);
      }
    }
  }

  // 1. حفظ بيانات الشيخ كاملة
  Future<void> _addSheikh() async {
    if (_sheikhNameController.text.trim().isEmpty) return;
    try {
      await supabase.from('sheikhs').insert({
        'name': _sheikhNameController.text.trim(),
        'phone': _sheikhPhoneController.text.trim(),
        'mosque': _sheikhMosqueController.text.trim(),
        'halaga_name': _sheikhHalagaNameController.text.trim(),
        'nationality': _sheikhNationalityController.text.trim(),
      });
      _sheikhNameController.clear();
      _sheikhPhoneController.clear();
      _sheikhMosqueController.clear();
      _sheikhHalagaNameController.clear();
      _sheikhNationalityController.clear();
      _loadDropdownData();
      _showSnackBar("تم إضافة الشيخ بكافة بياناته بنجاح");
    } catch (e) {
      _showSnackBar("خطأ أثناء إضافة الشيخ: $e", isError: true);
    }
  }

  // 2. حفظ بيانات الطالب كاملة وتضمين الحقول الجديدة لطلب الزبون
  Future<void> _addStudent() async {
    if (_studentNameController.text.trim().isEmpty || _studentIdController.text.trim().isEmpty || _selectedIdentityType == null) {
      _showSnackBar("الرجاء تعبئة اسم الطالب، ورقم الهوية، ونوع الهوية إجبارياً", isError: true);
      return;
    }
    // شرط الزبون: الطالب إلزامي يرتبط بحلقة وإلا لا يحفظ
    if (_selectedHalagaIdForStudent == null) {
      _showSnackBar("خطأ: الطالب إلزامي يرتبط بحلقة برقم معتمد، لا يمكن الحفظ!", isError: true);
      return;
    }

    try {
      await supabase.from('students').insert({
        'name': _studentNameController.text.trim(),
        'phone': _studentPhoneController.text.trim(),
        'nationality': _studentNationalityController.text.trim(),
        'national_id': _studentIdController.text.trim(), // حفظ رقم الهوية فريداً
        'identity_type': _selectedIdentityType, // حفظ نوع الهوية (هوية، إقامة، جواز)
        'status': _selectedStudentStatus ?? "غير فعال", // الحالة المختارة أو الافتراضية "غير فعال" تلقائياً
        'sheikh_id': _selectedSheikhIdForStudent,
        'halaga_id': _selectedHalagaIdForStudent,
      });
      _studentNameController.clear();
      _studentPhoneController.clear();
      _studentNationalityController.clear();
      _studentIdController.clear();
      setState(() {
        _selectedIdentityType = null;
        _selectedStudentStatus = null;
        _selectedSheikhIdForStudent = null;
        _selectedHalagaIdForStudent = null;
      });
      _showSnackBar("تم إضافة الطالب بنجاح وحالته الافتراضية (غير فعال)");
    } catch (e) {
      _showSnackBar("خطأ أثناء إضافة الطالب (تأكد من عدم تكرار الهوية): $e", isError: true);
    }
  }

  // 3. حفظ بيانات الحلقة كاملة وربطها بالشيخ المسؤول
  Future<void> _addHalaga() async {
    if (_halagaNameController.text.trim().isEmpty || _selectedSheikhIdForHalaga == null) {
      _showSnackBar("الرجاء إدخال اسم الحلقة واختيار الشيخ التابع لها", isError: true);
      return;
    }
    try {
      await supabase.from('halagas').insert({
        'name': _halagaNameController.text.trim(),
        'number': _halagaNumberController.text.trim(),
        'supervisor_name': _halagaSupervisorController.text.trim(),
        'sheikh_id': _selectedSheikhIdForHalaga,
      });
      _halagaNameController.clear();
      _halagaNumberController.clear();
      _halagaSupervisorController.clear();
      setState(() {
        _selectedSheikhIdForHalaga = null;
      });
      _loadDropdownData();
      _showSnackBar("تم إضافة الحلقة وتوثيق بياناتها بنجاح");
    } catch (e) {
      _showSnackBar("خطأ أثناء إضافة الحلقة: $e", isError: true);
    }
  }
  // 4. حفظ بيانات المسجد الجديد
  Future<void> _addMosque() async {
    if (_mosqueNameController.text.trim().isEmpty) {
      _showSnackBar("الرجاء إدخال اسم المسجد على الأقل", isError: true);
      return;
    }
    try {
      await supabase.from('mosques').insert({
        'name': _mosqueNameController.text.trim(),
        'location_url': _mosqueLocationController.text.trim(),
        'city': _mosqueCityController.text.trim(),
        'district': _mosqueDistrictController.text.trim(),
        'imam_name': _mosqueImamController.text.trim(),
      });
      _mosqueNameController.clear();
      _mosqueLocationController.clear();
      _mosqueCityController.clear();
      _mosqueDistrictController.clear();
      _mosqueImamController.clear();
      _showSnackBar("تم إضافة المسجد الجديد بنجاح");
    } catch (e) {
      _showSnackBar("خطأ أثناء إضافة المسجد: $e", isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textDirection: TextDirection.rtl),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }
@override
  Widget build(BuildContext context) {
    // 1. جلب حالة الثيم المظلم أو الفاتح تلقائياً
    final theme = Theme.of(context);
    
    // 2. المحافظة على المتغير الأصلي لكي تختفي كل الأخطاء بالأسفل
    final Color primaryColor = theme.primaryColor;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // خلفية فخمة تتغير تلقائياً
      appBar: AppBar(
        title: const Text("لوحة المشرفين المسؤولين"),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 0,
        // 👇 هنا تم إضافة زر الشمس والقمر المضيء بشكل سليم
        actions: [
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeNotifier,
            builder: (_, currentMode, __) {
              return IconButton(
                icon: Icon(
                  currentMode == ThemeMode.dark
                      ? Icons.wb_sunny_rounded // شمس في الوضع الداكن
                      : Icons.nightlight_round, // قمر في الوضع الفاتح
                  color: currentMode == ThemeMode.dark ? Colors.amber : Colors.blueGrey,
                ),
                onPressed: () {
                  // التبديل بين الوضعين فوراً عند الضغط
                  themeNotifier.value = currentMode == ThemeMode.dark
                      ? ThemeMode.light
                      : ThemeMode.dark;
                },
              );
            },
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // شريط التاريخ والبحث العلوي الثابت بنفس التنسيق والألوان والتاريخ التلقائي المتغير
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_today, color: primaryColor, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            "التاريخ اليوم: ${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}", 
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      TextButton.icon(
                        onPressed: _loadDropdownData,
                        icon: const Icon(Icons.refresh),
                        label: const Text("تحديث البيانات"),
                        style: TextButton.styleFrom(foregroundColor: primaryColor),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // بوكس 1: إضافة شيخ جديد
              _buildExpandableSectionCard(
                title: "إضافة شيخ جديد",
                icon: Icons.person_add_alt_1,
                primaryColor: primaryColor,
                children: [
                  _buildTextField(_sheikhNameController, "اسم الشيخ الثنائي أو الثلاثي *"),
                  _buildTextField(_sheikhPhoneController, "رقم جوال الشيخ", isNumber: true),
                  _buildTextField(_sheikhMosqueController, "المسجد التابع للشيخ"),
                  _buildTextField(_sheikhHalagaNameController, "اسم حلقة الشيخ الحالية"),
                  Padding(
  padding: const EdgeInsets.symmetric(vertical: 8.0),
  child: DropdownButtonFormField<String>(
    decoration: InputDecoration(
      labelText: "جنسية الشيخ",
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      filled: true,
      fillColor: Colors.grey[100],
    ),
    isExpanded: true,
    hint: const Text("اختر الجنسية"),
    items: nationalitiesList.map((String nationality) {
      return DropdownMenuItem<String>(
        value: nationality,
        child: Text(nationality),
      );
    }).toList(),
    onChanged: (String? newValue) {
      setState(() {
        _sheikhNationalityController.text = newValue ?? "";
      });
    },
  ),
),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(45),
                    ),
                    onPressed: _addSheikh,
                    child: const Text("حفظ بيانات الشيخ في القاعدة"),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // بوكس 2: إضافة طالب جديد المضاف إليه الحقول المطلوبة للزبون
              _buildExpandableSectionCard(
                title: "إضافة طالب جديد",
                icon: Icons.person_add_alt_1,
                primaryColor: primaryColor,
                children: [
                  _buildTextField(_studentNameController, "اسم الطالب الكامل *"),
                  _buildTextField(_studentIdController, "رقم هوية الطالب *", isNumber: true),
                  
                  // 1. حقل نوع الهوية الجديد المنسدل لطلب الزبون
                  DropdownButtonFormField<String>(
                    value: _selectedIdentityType,
                    hint: const Text("اختر نوع الهوية *"),
                    items: _identityTypes.map((type) {
                      return DropdownMenuItem<String>(value: type, child: Text(type));
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedIdentityType = val),
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  
                  _buildTextField(_studentPhoneController, "رقم جوال الطالب", isNumber: true),
                 Padding(
  padding: const EdgeInsets.symmetric(vertical: 8.0),
  child: DropdownButtonFormField<String>(
    decoration: InputDecoration(
      labelText: "جنسية الطالب",
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      filled: true,
      fillColor: Colors.grey[100],
    ),
    isExpanded: true,
    hint: const Text("اختر الجنسية"),
    items: nationalitiesList.map((String nationality) {
      return DropdownMenuItem<String>(
        value: nationality,
        child: Text(nationality),
      );
    }).toList(),
    onChanged: (String? newValue) {
      setState(() {
        _studentNationalityController.text = newValue ?? "";
      });
    },
  ),
),
                  const SizedBox(height: 12),
                  
                  DropdownButtonFormField<String>(
                    value: _selectedSheikhIdForStudent,
                    hint: const Text("اختر الشيخ التابع له الطالب"),
                    items: _sheikhsList.map((sheikh) {
                      return DropdownMenuItem<String>(
                        value: sheikh['id'].toString(),
                        child: Text(sheikh['name']),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedSheikhIdForStudent = val),
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  
                  DropdownButtonFormField<String>(
                    value: _selectedHalagaIdForStudent,
                    hint: const Text("اختر حلقة الطالب المناسبة (إلزامي) *"),
                    items: _halagasList.map((halaga) {
                      return DropdownMenuItem<String>(
                        value: halaga['id'].toString(),
                        child: Text(halaga['name']),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedHalagaIdForStudent = val),
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),

                  // 2. حقل حالة الطالب الجديد المنسدل لطلب الزبون
                  DropdownButtonFormField<String>(
                    value: _selectedStudentStatus ?? "غير فعال", // يبدأ تلقائياً وبشكل افتراضي بـ غير فعال
                    hint: const Text("حالة الطالب *"),
                    items: _studentStatuses.map((status) {
                      return DropdownMenuItem<String>(value: status, child: Text(status));
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedStudentStatus = val),
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(45),
                    ),
                    onPressed: _addStudent,
                    child: const Text("إضافة الطالب وتعميده فوراً"),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // بوكس 3: إضافة حلقة جديدة
              _buildExpandableSectionCard(
                title: "إضافة حلقة جديدة",
                icon: Icons.group_add,
                primaryColor: primaryColor,
                children: [
                  _buildTextField(_halagaNameController, "اسم الحلقة الجديد *"),
                  _buildTextField(_halagaNumberController, "رقم الحلقة المعتمد", isNumber: true),
                  _buildTextField(_halagaSupervisorController, "اسم مشرف الحلقة"),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _selectedSheikhIdForHalaga,
                    hint: const Text("اختر الشيخ التابع للحلقة"),
                    items: _sheikhsList.map((sheikh) {
                      return DropdownMenuItem<String>(
                        value: sheikh['id'].toString(),
                        child: Text(sheikh['name']),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedSheikhIdForHalaga = val),
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(45),
                    ),
                    onPressed: _addHalaga,
                    child: const Text("حفظ الحلقة ببياناتها في القاعدة"),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // بوكس 4: إضافة مسجد جديد
              _buildExpandableSectionCard(
                title: "إضافة مسجد جديد",
                icon: Icons.app_registration,
                primaryColor: primaryColor,
                children: [
                  _buildTextField(_mosqueNameController, "اسم المسجد *"),
                  _buildTextField(_mosqueLocationController, "موقع المسجد (رابط الخريطة إن وجد)"),
                  _buildTextField(_mosqueCityController, "المدينة"),
                  _buildTextField(_mosqueDistrictController, "الحي"),
                  _buildTextField(_mosqueImamController, "إمام المسجد"),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(45),
                    ),
                    onPressed: _addMosque,
                    child: const Text("حفظ بيانات المسجد في القاعدة"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildExpandableSectionCard({
    required String title,
    required IconData icon,
    required Color primaryColor,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: Icon(icon, color: primaryColor),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),
        ),
        iconColor: primaryColor,
        collapsedIconColor: primaryColor,
        childrenPadding: const EdgeInsets.all(16.0),
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}