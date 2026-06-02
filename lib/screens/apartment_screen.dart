import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/apartment_viewmodel.dart';
import 'apartment_screen_content.dart';

class ApartmentScreen extends ConsumerWidget {
  const ApartmentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(apartmentFamilyProvider(null));
    final viewModel = ref.read(apartmentFamilyProvider(null).notifier);

    return ApartmentScreenContent(
      state: state,
      viewModel: viewModel,
      sessionId: null,
    );
  }
}
