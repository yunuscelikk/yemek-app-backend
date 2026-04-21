import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/theme.dart';
import '../bloc/owner_orders_bloc.dart';
import '../widgets/owner_order_tile.dart';
import 'verify_order_page.dart';

class OwnerOrdersPage extends StatefulWidget {
  final String businessId;

  const OwnerOrdersPage({super.key, required this.businessId});

  @override
  State<OwnerOrdersPage> createState() => _OwnerOrdersPageState();
}

class _OwnerOrdersPageState extends State<OwnerOrdersPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final TabController _tabController;

  static const _tabs = [
    _TabInfo(label: 'Bekleyen', status: 'pending'),
    _TabInfo(label: 'Onaylı', status: 'confirmed'),
    _TabInfo(label: 'Teslim', status: 'picked_up'),
    _TabInfo(label: 'İptal', status: 'cancelled'),
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _loadForTab(_tabController.index);
      }
    });
    _loadForTab(0);
  }

  void _loadForTab(int index) {
    context.read<OwnerOrdersBloc>().add(
      LoadBusinessOrders(
        businessId: widget.businessId,
        status: _tabs[index].status,
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Siparişler'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: false,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: AppTypography.bodySmall.copyWith(
            fontWeight: FontWeight.w600,
          ),
          tabs: _tabs.map((t) => Tab(text: t.label)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabs
            .map(
              (t) => _OrdersList(
                businessId: widget.businessId,
                status: t.status,
                onTabActivate: () => _loadForTab(_tabs.indexOf(t)),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _TabInfo {
  final String label;
  final String status;

  const _TabInfo({required this.label, required this.status});
}

class _OrdersList extends StatelessWidget {
  final String businessId;
  final String status;
  final VoidCallback onTabActivate;

  const _OrdersList({
    required this.businessId,
    required this.status,
    required this.onTabActivate,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OwnerOrdersBloc, OwnerOrdersState>(
      buildWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType ||
          (current is OwnerOrdersLoaded && current.status == status),
      builder: (context, state) {
        // If the current loaded state is for a different status, show loading
        if (state is OwnerOrdersLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        if (state is OwnerOrdersError) {
          return _ErrorView(
            message: state.message,
            onRetry: () => context.read<OwnerOrdersBloc>().add(
              LoadBusinessOrders(businessId: businessId, status: status),
            ),
          );
        }
        if (state is OwnerOrdersLoaded && state.status == status) {
          if (state.orders.isEmpty) {
            return _EmptyView(status: status);
          }
          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              context.read<OwnerOrdersBloc>().add(
                LoadBusinessOrders(businessId: businessId, status: status),
              );
              await context.read<OwnerOrdersBloc>().stream.firstWhere(
                (s) => s is OwnerOrdersLoaded || s is OwnerOrdersError,
              );
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              itemCount: state.orders.length,
              itemBuilder: (ctx, i) {
                final order = state.orders[i];
                return OwnerOrderTile(
                  order: order,
                  onVerifyTap: order.canVerify
                      ? () => _openVerify(ctx, businessId, order.pickupCode)
                      : null,
                );
              },
            ),
          );
        }
        // State doesn't match this tab; show nothing (tab hasn't been viewed yet)
        return const SizedBox.shrink();
      },
    );
  }

  Future<void> _openVerify(
    BuildContext context,
    String businessId,
    String prefillCode,
  ) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) =>
            VerifyOrderPage(businessId: businessId, prefillCode: prefillCode),
      ),
    );
    if (result == true && context.mounted) {
      context.read<OwnerOrdersBloc>().add(
        LoadBusinessOrders(businessId: businessId, status: status),
      );
    }
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.error),
          const SizedBox(height: AppSpacing.md),
          Text(message, style: AppTypography.bodyMedium),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Tekrar Dene'),
          ),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  final String status;

  const _EmptyView({required this.status});

  @override
  Widget build(BuildContext context) {
    final labels = {
      'pending': 'bekleyen',
      'confirmed': 'onaylı',
      'picked_up': 'teslim alınan',
      'cancelled': 'iptal edilen',
    };
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inbox_outlined, size: 56, color: AppColors.textHint),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Henüz ${labels[status] ?? ''} sipariş yok',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
