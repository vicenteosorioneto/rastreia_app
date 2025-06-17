import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/models/tracked_object.dart';
import '../../../../core/providers/tracked_object_provider.dart';
import '../../../../core/providers/auth_provider.dart';

class AddObjectDialog extends StatefulWidget {
  final TrackedObject? object;

  const AddObjectDialog({super.key, this.object});

  @override
  State<AddObjectDialog> createState() => _AddObjectDialogState();
}

class _AddObjectDialogState extends State<AddObjectDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late String _status;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.object?.name ?? '');
    _descriptionController = TextEditingController(
      text: widget.object?.description ?? '',
    );
    _locationController = TextEditingController(
      text: widget.object?.location ?? '',
    );
    _status = widget.object?.status ?? 'Ativo';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final userId = context.read<AuthProvider>().currentUser?.uid;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      if (widget.object == null) {
        // Criar novo objeto
        await context.read<TrackedObjectProvider>().createObject(
          name: _nameController.text,
          description: _descriptionController.text,
          location: _locationController.text,
          userId: userId,
        );
      } else {
        // Atualizar objeto existente
        final updatedObject = TrackedObject(
          id: widget.object!.id,
          name: _nameController.text,
          description: _descriptionController.text,
          location: _locationController.text,
          status: _status,
          userId: userId,
          createdAt: widget.object!.createdAt,
        );
        await context.read<TrackedObjectProvider>().updateObject(updatedObject);
      }

      if (!mounted) return;

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.object == null
                ? 'Objeto adicionado com sucesso!'
                : 'Objeto atualizado com sucesso!',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !_isLoading,
      child: AlertDialog(
        title: Text(
          widget.object == null ? 'Adicionar Objeto' : 'Editar Objeto',
        ),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um nome';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira uma descrição';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Localização',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira uma localização';
                    }
                    return null;
                  },
                ),
                if (widget.object != null) ...[
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _status,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Ativo', child: Text('Ativo')),
                      DropdownMenuItem(
                        value: 'Inativo',
                        child: Text('Inativo'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _status = value);
                      }
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: _isLoading ? null : _submitForm,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(widget.object == null ? 'Adicionar' : 'Salvar'),
          ),
        ],
      ),
    );
  }
}
