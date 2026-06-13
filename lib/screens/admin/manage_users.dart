import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ManageUsersPage extends StatefulWidget {
  const ManageUsersPage({super.key});

  @override
  State<ManageUsersPage> createState() => _ManageUsersPageState();
}

class _ManageUsersPageState extends State<ManageUsersPage> {
  bool loading = true;
  List<dynamic> users = [];

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String selectedRole = "student";

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    final supabase = Supabase.instance.client;

    final data = await supabase.from('users').select();

    setState(() {
      users = data;
      loading = false;
    });
  }

  Future<void> addUser() async {
    final supabase = Supabase.instance.client;

    await supabase.from('users').insert({
      'name': nameController.text.trim(),
      'email': emailController.text.trim(),
      'password': passwordController.text.trim(),
      'role': selectedRole,
    });

    nameController.clear();
    emailController.clear();
    passwordController.clear();

    loadUsers();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("تم إضافة المستخدم بنجاح")));
  }

  Future<void> deleteUser(String id) async {
    final supabase = Supabase.instance.client;

    await supabase.from('users').delete().eq('id', id);

    loadUsers();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("تم حذف المستخدم")));
  }

  void showAddUserDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("إضافة مستخدم جديد"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "الاسم"),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "البريد"),
                ),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: "كلمة المرور"),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField(
                  value: selectedRole,
                  items: const [
                    DropdownMenuItem(value: "student", child: Text("طالب")),
                    DropdownMenuItem(value: "sheikh", child: Text("شيخ")),
                    DropdownMenuItem(value: "supervisor", child: Text("مشرف")),
                    DropdownMenuItem(value: "admin", child: Text("مدير")),
                  ],
                  onChanged: (value) {
                    setState(() => selectedRole = value.toString());
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("إلغاء"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("إضافة"),
              onPressed: () {
                addUser();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("إدارة المستخدمين"), centerTitle: true),

      floatingActionButton: FloatingActionButton(
        onPressed: showAddUserDialog,
        child: const Icon(Icons.add),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];

                return Card(
                  child: ListTile(
                    title: Text(user['name']),
                    subtitle: Text("${user['email']} — ${user['role']}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => deleteUser(user['id']),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
