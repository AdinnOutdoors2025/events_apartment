import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'apartment_viewmodel.dart';
import 'upload_viewmodel.dart';

class BottomNavState {
  final int currentIndex;
  final List<int> tabHistory;

  BottomNavState({required this.currentIndex, required this.tabHistory});

  BottomNavState copyWith({int? currentIndex, List<int>? tabHistory}) {
    return BottomNavState(
      currentIndex: currentIndex ?? this.currentIndex,
      tabHistory: tabHistory ?? this.tabHistory,
    );
  }
}

class BottomNavNotifier extends AutoDisposeNotifier<BottomNavState> {
  @override
  BottomNavState build() {
    return BottomNavState(currentIndex: 0, tabHistory: [0]);
  }

  Future<void> changeIndex(int index, WidgetRef ref) async {
    if (state.currentIndex == index) return;

    final updatedHistory = List<int>.from(state.tabHistory);
    updatedHistory.remove(index);
    updatedHistory.add(index);

    state = state.copyWith(currentIndex: index, tabHistory: updatedHistory);

    if (index == 1) {
      ref.read(apartmentFamilyProvider(null).notifier).clearSessionFilter();
      await ref.read(apartmentFamilyProvider(null).notifier).getApartments();
    }
    if (index == 3) {
      await ref.read(uploadViewModelProvider.notifier).getRecentUploads();
    }
  }

  bool handleBack() {
    if (state.tabHistory.length > 1) {
      final updatedHistory = List<int>.from(state.tabHistory);
      updatedHistory.removeLast();
      state = state.copyWith(
        currentIndex: updatedHistory.last,
        tabHistory: updatedHistory,
      );
      return false;
    }
    return true;
  }

  void goToPreviousTab() {
    if (state.tabHistory.length > 1) {
      final updatedHistory = List<int>.from(state.tabHistory);
      updatedHistory.removeLast();
      state = state.copyWith(
        currentIndex: updatedHistory.last,
        tabHistory: updatedHistory,
      );
    }
  }
}
/*
class BottomNavNotifier extends Notifier<BottomNavState> {
  @override
  BottomNavState build() {
    return BottomNavState(currentIndex: 0, tabHistory: [0]);
  }

  void changeIndex(int index) {
    if (state.currentIndex == index) return;

    final updatedHistory = List<int>.from(state.tabHistory);

    updatedHistory.remove(index);
    updatedHistory.add(index);

    state = state.copyWith(currentIndex: index, tabHistory: updatedHistory);
  }

  bool handleBack() {
    if (state.tabHistory.length > 1) {
      final updatedHistory = List<int>.from(state.tabHistory);

      updatedHistory.removeLast();

      state = state.copyWith(
        currentIndex: updatedHistory.last,
        tabHistory: updatedHistory,
      );

      return false;
    }

    return true;
  }
}
*/

final bottomNavProvider =
    NotifierProvider.autoDispose<BottomNavNotifier, BottomNavState>(
      BottomNavNotifier.new,
    );
/*final bottomNavProvider = NotifierProvider<BottomNavNotifier, BottomNavState>(
  BottomNavNotifier.new,
);*/
