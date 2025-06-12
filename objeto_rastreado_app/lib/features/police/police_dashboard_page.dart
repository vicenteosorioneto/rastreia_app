import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/stolen_item.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/rastreia_logo.dart';

class PoliceDashboardPage extends StatefulWidget {
  const PoliceDashboardPage({Key? key}) : super(key: key);

  @override
  State<PoliceDashboardPage> createState() => _PoliceDashboardPageState();
}

class _PoliceDashboardPageState extends State<PoliceDashboardPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Todos';
  final List<String> _filters = [
    'Todos',
    'Pendentes',
    'Em Análise',
    'Encontrados',
    'Recuperados'
  ];

  // Lista de itens roubados (simulada por enquanto)
  final List<StolenItem> _items = [
    StolenItem(
      id: '1',
      userId: 'user1',
      titulo: 'iPhone 13 Pro - Preto',
      descricao: 'iPhone roubado na zona sul',
      tipo: 'Smartphone',
      marca: 'Apple',
      modelo: 'iPhone 13 Pro',
      numeroSerie: '123456789',
      fotos: [],
      dataRoubo: DateTime.now().subtract(const Duration(days: 2)),
      localRoubo: 'Zona Sul',
      boletimOcorrencia: '2024/0123',
      status: ItemStatus.registrado,
    ),
    StolenItem(
      id: '2',
      userId: 'user2',
      titulo: 'Notebook Dell XPS',
      descricao: 'Notebook roubado no centro',
      tipo: 'Notebook',
      marca: 'Dell',
      modelo: 'XPS 15',
      numeroSerie: '987654321',
      fotos: [],
      dataRoubo: DateTime.now().subtract(const Duration(days: 1)),
      localRoubo: 'Centro',
      boletimOcorrencia: '2024/0124',
      status: ItemStatus.emAnalise,
    ),
    StolenItem(
      id: '3',
      userId: 'user3',
      titulo: 'Honda CB 500F',
      descricao: 'Moto roubada na zona norte',
      tipo: 'Moto',
      marca: 'Honda',
      modelo: 'CB 500F',
      numeroSerie: '456789123',
      fotos: [],
      dataRoubo: DateTime.now().subtract(const Duration(days: 3)),
      localRoubo: 'Zona Norte',
      boletimOcorrencia: '2024/0125',
      status: ItemStatus.encontrado,
    ),
    StolenItem(
      id: '4',
      userId: 'user4',
      titulo: 'Apple Watch Series 7',
      descricao: 'Relógio roubado no shopping',
      tipo: 'Smartwatch',
      marca: 'Apple',
      modelo: 'Watch Series 7',
      numeroSerie: '789123456',
      fotos: [],
      dataRoubo: DateTime.now().subtract(const Duration(days: 4)),
      localRoubo: 'Shopping',
      boletimOcorrencia: '2024/0126',
      status: ItemStatus.recuperado,
    ),
  ];

  // Lista filtrada de itens
  List<StolenItem> get _filteredItems {
    if (_selectedFilter == 'Todos') {
      return _items;
    }

    final statusMap = {
      'Pendentes': ItemStatus.registrado,
      'Em Análise': ItemStatus.emAnalise,
      'Encontrados': ItemStatus.encontrado,
      'Recuperados': ItemStatus.recuperado,
    };

    final selectedStatus = statusMap[_selectedFilter];
    if (selectedStatus == null) return _items;

    return _items.where((item) => item.status == selectedStatus).toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const RastreiaLogo(size: 24),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await authProvider.logout();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'Dashboard'),
            Tab(icon: Icon(Icons.search), text: 'Busca Avançada'),
            Tab(icon: Icon(Icons.map), text: 'Mapa de Ocorrências'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDashboardTab(),
          _buildSearchTab(),
          _buildMapTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Em breve: Escaneamento de objetos por número de série'),
            ),
          );
        },
        child: const Icon(Icons.qr_code_scanner),
      ),
    );
  }

  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatisticsCards(),
          const SizedBox(height: 24),
          _buildRecentActivities(),
          const SizedBox(height: 24),
          _buildPendingCases(),
        ],
      ),
    );
  }

  Widget _buildStatisticsCards() {
    // Calcular estatísticas baseadas nos itens
    final totalCases = _items.length;
    final recoveredCases =
        _items.where((item) => item.status == ItemStatus.recuperado).length;
    final pendingCases =
        _items.where((item) => item.status == ItemStatus.registrado).length;
    final successRate = totalCases > 0
        ? (recoveredCases / totalCases * 100).toStringAsFixed(0)
        : '0';

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildStatCard(
          'Casos Ativos',
          totalCases.toString(),
          Icons.cases_outlined,
          Colors.blue,
        ),
        _buildStatCard(
          'Recuperados',
          recoveredCases.toString(),
          Icons.check_circle_outline,
          Colors.green,
        ),
        _buildStatCard(
          'Pendentes',
          pendingCases.toString(),
          Icons.pending_actions,
          Colors.orange,
        ),
        _buildStatCard(
          'Taxa de Sucesso',
          '$successRate%',
          Icons.trending_up,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Atividades Recentes',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _filteredItems.length.clamp(0, 5),
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final item = _filteredItems[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: Icon(
                    _getActivityIcon(item.status),
                    color: AppColors.primary,
                  ),
                ),
                title: Text(item.titulo),
                subtitle: Text(_getActivityDescription(item)),
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 16),
                  onPressed: () {
                    // TODO: Navegar para detalhes do item
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  IconData _getActivityIcon(ItemStatus status) {
    switch (status) {
      case ItemStatus.registrado:
        return Icons.new_releases;
      case ItemStatus.emAnalise:
        return Icons.search;
      case ItemStatus.encontrado:
        return Icons.location_on;
      case ItemStatus.recuperado:
        return Icons.check_circle;
      case ItemStatus.arquivado:
        return Icons.archive;
    }
  }

  String _getActivityDescription(StolenItem item) {
    final status = item.status.toString().split('.').last;
    final timeAgo = _getTimeAgo(item.dataCriacao);
    return '$status • $timeAgo • B.O.: ${item.boletimOcorrencia}';
  }

  String _getTimeAgo(DateTime date) {
    final difference = DateTime.now().difference(date);
    if (difference.inDays > 0) {
      return 'Há ${difference.inDays} dias';
    } else if (difference.inHours > 0) {
      return 'Há ${difference.inHours} horas';
    } else {
      return 'Há ${difference.inMinutes} minutos';
    }
  }

  Widget _buildPendingCases() {
    final pendingItems =
        _items.where((item) => item.status == ItemStatus.registrado).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Casos Pendentes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedFilter = 'Pendentes';
                  _tabController.animateTo(1); // Mudar para a aba de busca
                });
              },
              child: const Text('Ver todos'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: pendingItems.length.clamp(0, 3),
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final item = pendingItems[index];
              return ListTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getItemIcon(item.tipo),
                    color: AppColors.primary,
                  ),
                ),
                title: Text(item.titulo),
                subtitle: Text(
                    'B.O.: ${item.boletimOcorrencia} • ${item.localRoubo}'),
                trailing: _buildPriorityCapsule(index),
              );
            },
          ),
        ),
      ],
    );
  }

  IconData _getItemIcon(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'smartphone':
        return Icons.phone_android;
      case 'notebook':
        return Icons.laptop;
      case 'moto':
        return Icons.two_wheeler;
      case 'smartwatch':
        return Icons.watch;
      default:
        return Icons.devices_other;
    }
  }

  Widget _buildPriorityCapsule(int index) {
    Color color;
    String text;

    switch (index) {
      case 0:
        color = Colors.red;
        text = 'ALTA';
        break;
      case 1:
        color = Colors.orange;
        text = 'MÉDIA';
        break;
      default:
        color = Colors.yellow.shade700;
        text = 'BAIXA';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSearchTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar por número de série, B.O., local...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filters.map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: isSelected,
                    label: Text(filter),
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: Icon(
                        _getItemIcon(item.tipo),
                        color: AppColors.primary,
                      ),
                    ),
                    title: Text(item.titulo),
                    subtitle: Text(
                        '${item.status.toString().split('.').last} • ${item.localRoubo} • B.O.: ${item.boletimOcorrencia}'),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapTab() {
    return const Center(
      child: Text('Em breve: Mapa de Ocorrências'),
    );
  }
}
