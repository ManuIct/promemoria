import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../providers.dart';

class BannerPermesso extends ConsumerWidget {
  const BannerPermesso({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref){
    final permesso = ref.watch(permessoProvider).value ?? true;
    if (permesso) return const SizedBox.shrink();

    return MaterialBanner(
      leading: const Icon(Icons.notifications_off_outlined),
      content: const Text('Le notifiche sono disattivate: i promemoria si salvano, ma non suoneranno',
      ),
      actions: [
        TextButton(
          onPressed: openAppSettings,
          child: const Text('Apri impostazioni'),
          ),
      ],
    );
  }
}