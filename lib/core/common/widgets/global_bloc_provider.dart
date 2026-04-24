import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../di/init_dependencies.dart';
import '../../cubits/network_cubit.dart';
import '../../../features/home/presentation/cubit/recently_viewed_cubit.dart';
import '../../../features/favorites/presentation/cubit/favorites_cubit.dart';
import '../../../features/cart/presentation/cubit/cart_cubit.dart';

class GlobalBlocProvider extends StatelessWidget {
  final Widget child;

  const GlobalBlocProvider({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => serviceLocator<NetworkCubit>()..checkConnection(),
        ),
        BlocProvider(
          create: (context) =>
              serviceLocator<RecentlyViewedCubit>()..loadProducts(),
        ),
        BlocProvider(
          create: (context) => serviceLocator<FavoritesCubit>(),
        ),
        BlocProvider(
          create: (context) => serviceLocator<CartCubit>(),
        ),
      ],
      child: child,
    );
  }
}
