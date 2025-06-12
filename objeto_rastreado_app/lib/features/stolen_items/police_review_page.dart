import 'package:flutter/material.dart';
import '../../core/models/stolen_item.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_button.dart';

class PoliceReviewPage extends StatefulWidget {
  final StolenItem item;

  const PoliceReviewPage({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  State<PoliceReviewPage> createState() => _PoliceReviewPageState();
}

class _PoliceReviewPageState extends State<PoliceReviewPage> {
  final _observacaoController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _observacaoController.text = widget.item.observacaoPolicial ?? '';
  }

  Future<void> _atualizarStatus(ItemStatus novoStatus) async {
    setState(() => _isLoading = true);

    try {
      // TODO: Implementar a lógica de atualização no backend
      await Future.delayed(const Duration(seconds: 1)); // Simulação

      widget.item.atualizarStatus(
        novoStatus,
        observacao: _observacaoController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Status atualizado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao atualizar status. Tente novamente.'),
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
        title: const Text('Análise do Objeto'),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInfoCard(
              'Informações do Objeto',
              [
                _buildInfoRow('Título', widget.item.titulo),
                _buildInfoRow('Tipo', widget.item.tipo),
                _buildInfoRow('Marca', widget.item.marca),
                _buildInfoRow('Modelo', widget.item.modelo),
                _buildInfoRow('Número de Série', widget.item.numeroSerie),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              'Detalhes do Roubo',
              [
                _buildInfoRow('Data',
                    '${widget.item.dataRoubo.day}/${widget.item.dataRoubo.month}/${widget.item.dataRoubo.year}'),
                _buildInfoRow('Local', widget.item.localRoubo),
                _buildInfoRow('B.O.', widget.item.boletimOcorrencia),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              'Descrição',
              [Text(widget.item.descricao)],
            ),
            if (widget.item.fotos.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildInfoCard(
                'Fotos',
                [
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.item.fotos.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Image.network(
                            widget.item.fotos[index],
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            _buildInfoCard(
              'Status Atual',
              [
                Text(
                  widget.item.status.toString().split('.').last,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _observacaoController,
              decoration: const InputDecoration(
                labelText: 'Observações da Polícia',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onPressed: _isLoading
                        ? null
                        : () => _atualizarStatus(ItemStatus.emAnalise),
                    text: 'Em Análise',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomButton(
                    onPressed: _isLoading
                        ? null
                        : () => _atualizarStatus(ItemStatus.encontrado),
                    text: 'Encontrado',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onPressed: _isLoading
                        ? null
                        : () => _atualizarStatus(ItemStatus.recuperado),
                    text: 'Recuperado',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomButton(
                    onPressed: _isLoading
                        ? null
                        : () => _atualizarStatus(ItemStatus.arquivado),
                    text: 'Arquivar',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _observacaoController.dispose();
    super.dispose();
  }
}
