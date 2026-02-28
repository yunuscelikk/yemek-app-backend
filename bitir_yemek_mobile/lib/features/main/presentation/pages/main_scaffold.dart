import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../home/data/datasources/businesses_remote_datasource.dart';
import '../../../home/data/repositories/businesses_repository_impl.dart';
import '../../../home/presentation/bloc/home_bloc.dart';
import '../../../home/presentation/bloc/packages_bloc.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../home/presentation/widgets/bottom_nav_bar.dart';
import '../../../profile/data/datasources/profile_remote_datasource.dart';
import '../../../profile/data/repositories/profile_repository_impl.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../orders/data/datasources/orders_remote_datasource.dart';
import '../../../orders/data/repositories/orders_repository_impl.dart';
import '../../../orders/presentation/bloc/orders_bloc.dart';
import '../../../orders/presentation/pages/orders_page.dart';
import '../../../search/presentation/bloc/search_bloc.dart';
import '../../../search/presentation/pages/search_page.dart';

class MainScaffold extends StatefulWidget {
  final double latitude;
  final double longitude;
  final int initialIndex;

  const MainScaffold({
    super.key,
    required this.latitude,
    required this.longitude,
    this.initialIndex = 0,
  });

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Home Blocs
        BlocProvider(
          create: (context) =>
              PackagesBloc(
                repository: BusinessesRepositoryImpl(
                  remoteDataSource: BusinessesRemoteDataSource(
                    dioClient: DioClient(),
                  ),
                ),
              )..add(
                LoadNearbyPackages(
                  latitude: widget.latitude,
                  longitude: widget.longitude,
                ),
              ),
        ),
        BlocProvider(
          create: (context) => HomeBloc(
            repository: BusinessesRepositoryImpl(
              remoteDataSource: BusinessesRemoteDataSource(
                dioClient: DioClient(),
              ),
            ),
          )..add(LoadCategories()),
        ),
        // Search Bloc
        BlocProvider(
          create: (context) => SearchBloc(
            repository: BusinessesRepositoryImpl(
              remoteDataSource: BusinessesRemoteDataSource(
                dioClient: DioClient(),
              ),
            ),
          ),
        ),
        // Orders Bloc
        BlocProvider(
          create: (context) {
            final tokenStorage = SharedPrefsTokenStorage();
            final dioClient = DioClient();
            return OrdersBloc(
              repository: OrdersRepositoryImpl(
                remoteDataSource: OrdersRemoteDataSource(
                  dioClient: dioClient,
                  tokenStorage: tokenStorage,
                ),
              ),
            )..add(const LoadOrders());
          },
        ),
        // Profile Bloc
        BlocProvider(
          create: (context) {
            final tokenStorage = SharedPrefsTokenStorage();
            final dioClient = DioClient();
            return ProfileBloc(
              profileRepository: ProfileRepositoryImpl(
                remoteDataSource: ProfileRemoteDataSource(
                  dioClient: dioClient,
                  tokenStorage: tokenStorage,
                ),
                tokenStorage: tokenStorage,
              ),
            )..add(LoadProfile());
          },
        ),
      ],
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: [
            // 0 - Keşfet (Home)
            HomePage(latitude: widget.latitude, longitude: widget.longitude),
            // 1 - Ara (Search)
            SearchPage(latitude: widget.latitude, longitude: widget.longitude),
            // 2 - Sipariş (Orders)
            OrdersPage(
              onNavigateToHome: () {
                setState(() {
                  _currentIndex = 0;
                });
              },
            ),
            // 3 - Favoriler (Favorites)
            const _PlaceholderScreen(title: 'Favorilerim'),
            // 4 - Profil (Profile)
            ProfilePage(
              onTabSwitch: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ],
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              '$title yakında geliyor',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
