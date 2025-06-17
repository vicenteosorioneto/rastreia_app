import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/models/tracked_object.dart';
import '../../../../core/providers/tracked_object_provider.dart';
import '../widgets/add_object_dialog.dart';
import '../widgets/tracked_object_card.dart';

class TrackedObjectsScreen extends StatefulWidget {
  const TrackedObjectsScreen({super.key});

  @override
  State<TrackedObjectsScreen> createState() => _TrackedObjectsScreenState();
}

class _TrackedObjectsScreenState extends State<TrackedObjectsScreen> {
  String _selectedStatus = 'Todos';

  @override
  void initState() {
    super.initState();
    _loadObjects();
  }

  Future<void> _loadObjects() async {
    try {
      if (_selectedStatus == 'Todos') {
        await context.read<TrackedObjectProvider>().loadAllObjects();
      } else {
        await context.read<TrackedObjectProvider>().loadObjectsByStatus(
              _selectedStatus,
            );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar objetos: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _showAddObjectDialog() async {
    await showDialog(
      context: context,
      builder: (context) => const AddObjectDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Objetos Rastreados',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadObjects,
            tooltip: 'Atualizar',
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1976D2), Color(0xFF64B5F6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: kToolbarHeight + 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.15),
                  labelText: 'Filtrar por status',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                dropdownColor: Colors.white,
                items: const [
                  DropdownMenuItem(value: 'Todos', child: Text('Todos')),
                  DropdownMenuItem(value: 'Ativo', child: Text('Ativo')),
                  DropdownMenuItem(value: 'Inativo', child: Text('Inativo')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedStatus = value);
                    _loadObjects();
                  }
                },
              ),
            ),
            Expanded(
              child: Consumer<TrackedObjectProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(
                        child: CircularProgressIndicator(color: Colors.white));
                  }

                  if (provider.error != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Erro: ${provider.error}',
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF1976D2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _loadObjects,
                            child: const Text('Tentar novamente'),
                          ),
                        ],
                      ),
                    );
                  }

                  final objects = provider.objects;
                  if (objects.isEmpty) {
                    return const Center(
                      child: Text('Nenhum objeto encontrado',
                          style: TextStyle(color: Colors.white)),
                    );
                  }

                  return RefreshIndicator(
                    color: Color(0xFF1976D2),
                    onRefresh: _loadObjects,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: objects.length,
                      itemBuilder: (context, index) {
                        final object = objects[index];
                        return TrackedObjectCard(object: object);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF1976D2),
        elevation: 6,
        onPressed: _showAddObjectDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
