import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/models/stolen_item.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';

class CitizenRegisterPage extends StatefulWidget {
  const CitizenRegisterPage({Key? key}) : super(key: key);

  @override
  State<CitizenRegisterPage> createState() => _CitizenRegisterPageState();
}

class _CitizenRegisterPageState extends State<CitizenRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _tipoController = TextEditingController();
  final _marcaController = TextEditingController();
  final _modeloController = TextEditingController();
  final _numeroSerieController = TextEditingController();
  final _localRouboController = TextEditingController();
  final _boController = TextEditingController();
  DateTime? _dataRoubo;
  List<String> _fotos = [];
  bool _isLoading = false;

  Future<void> _selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (data != null) {
      setState(() => _dataRoubo = data);
    }
  }

  Future<void> _adicionarFoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _fotos.add(image.path);
      });
    }
  }

  Future<void> _registrarObjeto() async {
    if (!_formKey.currentState!.validate()) return;
    if (_dataRoubo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione a data do roubo'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // TODO: Implementar a lógica de salvar no backend
      await Future.delayed(const Duration(seconds: 2)); // Simulação

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Objeto registrado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao registrar objeto. Tente novamente.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Objeto Roubado'),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: _tituloController,
                label: 'Título',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _descricaoController,
                label: 'Descrição detalhada',
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _tipoController,
                      label: 'Tipo do objeto',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: _marcaController,
                      label: 'Marca',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _modeloController,
                      label: 'Modelo',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: _numeroSerieController,
                      label: 'Número de Série',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(
                  _dataRoubo == null
                      ? 'Selecionar data do roubo'
                      : 'Data: ${_dataRoubo!.day}/${_dataRoubo!.month}/${_dataRoubo!.year}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _selecionarData,
                tileColor: Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _localRouboController,
                label: 'Local do roubo',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _boController,
                label: 'Número do Boletim de Ocorrência',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _adicionarFoto,
                icon: const Icon(Icons.photo_camera),
                label: const Text('Adicionar Fotos'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
              if (_fotos.isNotEmpty) ...[
                const SizedBox(height: 16),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _fotos.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Stack(
                          children: [
                            Image.asset(
                              _fotos[index],
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              right: 0,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _fotos.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(height: 24),
              CustomButton(
                onPressed: _isLoading ? null : _registrarObjeto,
                text: _isLoading ? 'Registrando...' : 'Registrar Objeto',
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    _tipoController.dispose();
    _marcaController.dispose();
    _modeloController.dispose();
    _numeroSerieController.dispose();
    _localRouboController.dispose();
    _boController.dispose();
    super.dispose();
  }
}
