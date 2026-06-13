import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ManageHalaqatPage extends StatefulWidget {
  const ManageHalaqatPage({super.key});

  @override
  State<ManageHalaqatPage> createState() => _ManageHalaqatPageState();
}

class _ManageHalaqatPageState extends State<ManageHalaqatPage> {
  bool loading = true;
  List<dynamic> halaqat = [];

  final nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadHalaqat();
  }

  Future<void> loadHalaqat() async {
    final supabase = Supabase.instance.client;

    final data = await supabase.from('halaqat').select();

    setState(() {
      halaqat = data;
      loading = false;
    });
  }

  Future<void> addHalaqa() async {
    final supabase = Supabase.instance.client;

    await supabase.from('halaqat').insert({'name': nameController.text.trim()});

    nameController.clear();
    loadHalaqat();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("تم إضافة الحلقة")));
  }

  Future<void> deleteHalaqa(String id) async {
    final supabase = Supabase.instance.client;

    await supabase.from('halaqat').delete().eq('id', id);

    loadHalaqat();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("تم حذف الحلقة")));
  }

  void showAddDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("إضافة حلقة جديدة"),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: "اسم الحلقة"),
          ),
          actions: [
            TextButton(
              child: const Text("إلغاء"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("إضافة"),
              onPressed: () {
                addHalaqa();
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
      appBar: AppBar(title: const Text("إدارة الحلقات"), centerTitle: true),

      floatingActionButton: FloatingActionButton(
        onPressed: showAddDialog,
        child: const Icon(Icons.add),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: halaqat.length,
              itemBuilder: (context, index) {
                final h = halaqat[index];

                return Card(
                  child: ListTile(
                    title: Text(h['name']),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => deleteHalaqa(h['id']),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
