import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/apartment_viewmodel.dart';
import 'apartment_screen_content.dart';

class UploadApartmentScreen extends ConsumerWidget {
  final String sessionId;
  final String filename;

  const UploadApartmentScreen({super.key, required this.sessionId,required this.filename,});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(apartmentFamilyProvider(sessionId));
    final viewModel = ref.read(apartmentFamilyProvider(sessionId).notifier);

    return ApartmentScreenContent(
      state: state,
      viewModel: viewModel,
      sessionId: sessionId,
      filename: filename,
    );
  }
}
