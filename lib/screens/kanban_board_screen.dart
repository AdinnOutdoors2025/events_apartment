import 'package:apartment_project/utils/helpers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/order_history_model.dart';
import '../theme/app_colors.dart';
import '../utils/snackbar.dart';
import '../viewmodel/order_viewmodel.dart';
import 'kanban_board/deal_card_screen.dart';
import 'kanban_board/details_screen.dart';

class KanbanBoardScreen extends ConsumerStatefulWidget {
  const KanbanBoardScreen({super.key});

  @override
  ConsumerState<KanbanBoardScreen> createState() => _KanbanBoardScreenState();
}

class _KanbanBoardScreenState extends ConsumerState<KanbanBoardScreen> {
  final ScrollController _boardController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  DateTimeRange? selectedDateRange;
  String searchText = "";
  late String selectedStageId;
  PlatformFile? poDocument;
  String additionalNotes = "";
  String? selectedReason;
  String comments = "";
  bool _isAutoScrolling = false;
  DateTime? _lastAutoScroll;
  PlatformFile? statusDocument;
  PlatformFile? voiceDocument;

  final List<KanbanStage> stages = const [
    KanbanStage(id: "1", title: "Enquiry", color: Color(0xff2563EB)),
    KanbanStage(id: "2", title: "Need Analysis", color: Color(0xffF97316)),
    KanbanStage(
      id: "3",
      title: "Proposal & Price Quote",
      color: Color(0xff7C3AED),
    ),
    KanbanStage(
      id: "4",
      title: "Negotiation & Review",
      color: Color(0xffEA580C),
    ),
    KanbanStage(id: "5", title: "Close Won", color: Color(0xff16A34A)),
    KanbanStage(id: "6", title: "Project Code", color: Color(0xff0891B2)),
    KanbanStage(id: "7", title: "Closed Loss", color: Color(0xffDC2626)),
  ];

  @override
  void initState() {
    super.initState();
    selectedStageId = stages.first.id;
  }

  @override
  void dispose() {
    _boardController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<KanbanDeal> _dealsByStage(List<KanbanDeal> deals, String stageId) {
    final query = searchText.trim().toLowerCase();

    return deals.where((deal) {
      final sameStage = deal.stageId == stageId;

      final matchedSearch =
          query.isEmpty ||
          deal.companyName.toLowerCase().contains(query) ||
          deal.apartmentName.toLowerCase().contains(query) ||
          deal.customerName.toLowerCase().contains(query) ||
          deal.eventName.toLowerCase().contains(query);

      return sameStage && matchedSearch;
    }).toList();
  }

  void _autoScrollWhileDragging(Offset globalPosition) {
    if (!_boardController.hasClients) return;

    final screenWidth = MediaQuery.of(context).size.width;

    const edgeThreshold = 80;

    final now = DateTime.now();

    // prevent continuous fast scrolling
    if (_lastAutoScroll != null &&
        now.difference(_lastAutoScroll!).inMilliseconds < 500) {
      return;
    }

    final columnWidth = MediaQuery.of(context).size.width * 0.72 + 12;

    // RIGHT EDGE
    if (globalPosition.dx > screenWidth - edgeThreshold) {
      _scrollToNextColumn(columnWidth);
    }
    // LEFT EDGE
    else if (globalPosition.dx < edgeThreshold) {
      _scrollToPreviousColumn(columnWidth);
    }
  }

  void _scrollToNextColumn(double columnWidth) {
    if (_isAutoScrolling) return;

    _isAutoScrolling = true;
    _lastAutoScroll = DateTime.now();

    final target = (_boardController.offset + columnWidth).clamp(
      0.0,
      _boardController.position.maxScrollExtent,
    );

    _boardController
        .animateTo(
          target,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        )
        .then((_) => _isAutoScrolling = false);
  }

  void _scrollToPreviousColumn(double columnWidth) {
    if (_isAutoScrolling) return;

    _isAutoScrolling = true;
    _lastAutoScroll = DateTime.now();

    final target = (_boardController.offset - columnWidth).clamp(
      0.0,
      _boardController.position.maxScrollExtent,
    );

    _boardController
        .animateTo(
          target,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        )
        .then((_) => _isAutoScrolling = false);
  }

  int _stageCount(List<KanbanDeal> deals, String stageId) {
    return deals.where((deal) => deal.stageId == stageId).length;
  }

  Future<void> _moveDeal(KanbanDeal deal, String newStageId) async {
    final status = int.tryParse(newStageId);

    if (status == null) return;
    final currentStatus = int.tryParse(deal.stageId);

    if (currentStatus == status) {
      return;
    }
    // Any stage -> Close Won
    if (status == 5) {
      await _showCloseWonDialog(deal);
      return;
    }

    // Any stage -> Closed Loss
    if (status == 7) {
      await _showClosedLossDialog(deal);
      return;
    }

    await ref
        .read(orderViewModelProvider.notifier)
        .updateOrderStatus(orderId: deal.id, status: status);
  }

  void _scrollToStage(int index) {
    final columnWidth = MediaQuery.of(context).size.width * 0.72;
    final offset = index * (columnWidth + 12);

    _boardController.animateTo(
      offset,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
    );
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      initialDateRange: selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.red,
              onPrimary: Colors.white,
              onSurface: Color(0xff111827),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDateRange = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    return "${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}";
  }

  void _openDealDetails(KanbanDeal deal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DealDetailsSheet(
          deal: deal,
          stages: stages,
          onMoveStage: _moveDeal,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(orderViewModelProvider);
    final viewModel = ref.read(orderViewModelProvider.notifier);
    final columnWidth = MediaQuery.of(context).size.width * 0.72;
    final deals = state.orderList
        .map((booking) => KanbanDeal.fromBooking(booking))
        .toList();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.white,
        /*  leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),*/
        title: const Text(
          "All orders and sales handling",
          style: TextStyle(
            color: AppColors.red,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          //  _Header(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xffE5E7EB)),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          searchText = value;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: "Search deals...",
                        hintStyle: TextStyle(
                          color: Color(0xff9CA3AF),
                          fontSize: 13,
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: Color(0xff6B7280),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(top: 13),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                _TopIconButton(
                  icon: Icons.calendar_month_outlined,
                  onTap: _pickDateRange,
                ),

                const SizedBox(width: 10),

                _TopIconButton(icon: Icons.filter_alt_outlined, onTap: () {}),
              ],
            ),
          ),
          if (selectedDateRange != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffFFF1F2),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xffFECACA)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: AppColors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "${_formatDate(selectedDateRange!.start)} - ${_formatDate(selectedDateRange!.end)}",
                        style: const TextStyle(
                          color: Color(0xff111827),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDateRange = null;
                          });
                        },
                        child: const Icon(
                          Icons.close_rounded,
                          size: 17,
                          color: AppColors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          const SizedBox(height: 12),
          if (state.isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await viewModel.refreshOrders();
                },
                child: SingleChildScrollView(
                  controller: _boardController,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(stages.length, (index) {
                      final stage = stages[index];
                      final stageDeals = _dealsByStage(deals, stage.id);

                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: SizedBox(
                          width: columnWidth,
                          child: KanbanColumn(
                            stage: stage,
                            deals: stageDeals,
                            onAccept: (KanbanDeal deal) async {
                              await _moveDeal(deal, stage.id);
                            },
                            onTapDeal: _openDealDetails,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          SizedBox(height: 15),

          SizedBox(
            height: 49,
            child: StageChevronStepper(
              stages: stages,
              currentStageId: selectedStageId,
              countBuilder: (stage) => _stageCount(deals, stage.id),
              onTap: (index) => _scrollToStage(index),
            ),
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }

  Future<void> _showCloseWonDialog(KanbanDeal deal) async {
    final commentsController = TextEditingController();

    PlatformFile? poFile;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 12),

                        const Expanded(
                          child: Text(
                            "Move to Close Won",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      "PO Document *",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),

                    const SizedBox(height: 10),

                    InkWell(
                      onTap: () async {
                        final result = await FilePicker.pickFiles();

                        if (result != null) {
                          setState(() {
                            poFile = result.files.first;
                          });
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xffE5E7EB)),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.upload_file),
                            const SizedBox(width: 10),

                            Expanded(
                              child: Text(
                                poFile?.name ?? "Upload PO Document",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      "Comments",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: commentsController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "Add comments...",
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(52),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text("Cancel"),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (poFile == null) {
                                AppToast.showError("Please upload PO document");
                                return;
                              }

                              Navigator.pop(context);

                              await ref
                                  .read(orderViewModelProvider.notifier)
                                  .updateOrderStatus(
                                    orderId: deal.id,
                                    status: 5,
                                    poDocument: poFile,
                                    additionalNotes: commentsController.text,
                                  );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.red,
                              minimumSize: const Size.fromHeight(52),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              "Mark as Close Won",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showClosedLossDialog(KanbanDeal deal) async {
    String? reason;

    final commentsController = TextEditingController();

    final reasons = [
      "Price Too High",
      "Competitor Won",
      "Budget Issue",
      "Customer Cancelled",
      "Other",
    ];

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.white,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 24,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Mark as Closed Loss",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xff111827),
                            ),
                          ),
                          SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              Navigator.pop(dialogContext);
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              child: const Icon(
                                Icons.close,
                                color: Color(0xff6B7280),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      /// Reason Label
                      RichText(
                        text: const TextSpan(
                          text: "Reason for Closed Loss ",
                          style: TextStyle(
                            color: Color(0xff111827),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                          children: [
                            TextSpan(
                              text: "*",
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// Reason Dropdown
                      DropdownButtonFormField<String>(
                        value: reason,
                        decoration: InputDecoration(
                          hintText: "Select Reason",
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xffE5E7EB),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xffE5E7EB),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: AppColors.red,
                              width: 1.5,
                            ),
                          ),
                        ),
                        items: reasons.map((e) {
                          return DropdownMenuItem(value: e, child: Text(e));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            reason = value;
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      /// Comments Label
                      RichText(
                        text: const TextSpan(
                          text: "Comments ",
                          style: TextStyle(
                            color: Color(0xff111827),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                          children: [
                            TextSpan(
                              text: "*",
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// Comments Field
                      TextField(
                        controller: commentsController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: "Enter comments...",
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.all(14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xffE5E7EB),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xffE5E7EB),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: AppColors.red,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      /// Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(dialogContext);
                              },
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size.fromHeight(52),
                                side: const BorderSide(
                                  color: Color(0xffD1D5DB),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Color(0xff374151),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (reason == null) {
                                  AppToast.showError("Please select a reason");
                                  return;
                                }

                                if (commentsController.text.trim().isEmpty) {
                                  AppToast.showError("Please enter comments");
                                  return;
                                }

                                Navigator.pop(dialogContext);

                                await ref
                                    .read(orderViewModelProvider.notifier)
                                    .updateOrderStatus(
                                      orderId: deal.id,
                                      status: 7,
                                      closeLossReason: reason,
                                      additionalNotes: commentsController.text
                                          .trim(),
                                      statusDocument: statusDocument,
                                      voiceDocument: voiceDocument,
                                    );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.red,
                                elevation: 0,
                                minimumSize: const Size.fromHeight(52),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
                                "Mark as Closed Loss",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class StageChevronStepper extends StatelessWidget {
  final List<KanbanStage> stages;
  final String? currentStageId;
  final int Function(KanbanStage stage) countBuilder;
  final void Function(int index) onTap;

  const StageChevronStepper({
    super.key,
    required this.stages,
    required this.currentStageId,
    required this.countBuilder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const double itemWidth = 138;
    const double itemHeight = 43;
    //const double overlap = 15;
    const double gap = 4;

    final totalWidth = stages.isEmpty
        ? 0.0
        : (itemWidth * stages.length) - (gap * (stages.length - 1));

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SizedBox(
        width: totalWidth,
        height: itemHeight,
        child: Stack(
          children: List.generate(stages.length, (index) {
            final stage = stages[index];
            final isSelected = stage.id == currentStageId;

            return Positioned(
              left: index * (itemWidth + gap),
              top: 2,
              child: GestureDetector(
                onTap: () => onTap(index),
                child: StageChevronCard(
                  width: itemWidth,
                  height: itemHeight,
                  number: index + 1,
                  title: stage.title,
                  count: countBuilder(stage),
                  isFirst: index == 0,
                  isLast: index == stages.length - 1,
                  isSelected: isSelected,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class StageChevronCard extends StatelessWidget {
  final double width;
  final double height;
  final int number;
  final String title;
  final int count;
  final bool isFirst;
  final bool isLast;
  final bool isSelected;

  const StageChevronCard({
    super.key,
    required this.width,
    required this.height,
    required this.number,
    required this.title,
    required this.count,
    required this.isFirst,
    required this.isLast,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: StageChevronPainter(
          isFirst: isFirst,
          isLast: isLast,
          isSelected: isSelected,
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: isFirst ? 10 : 20,
            right: isLast ? 10 : 18,
            top: 5,
            bottom: 5,
          ),
          child: Row(
            children: [
              Text(
                "$number",
                style: TextStyle(
                  color: isSelected
                      ? const Color(0xff111827)
                      : const Color(0xff374151),
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isSelected
                        ? const Color(0xff111827)
                        : const Color(0xff1F2937),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              const SizedBox(width: 6),

              Container(
                height: 19,
                constraints: const BoxConstraints(minWidth: 19),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xffE30613),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xffE30613).withOpacity(0.22),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  "$count",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StageChevronPainter extends CustomPainter {
  final bool isFirst;
  final bool isLast;
  final bool isSelected;

  StageChevronPainter({
    required this.isFirst,
    required this.isLast,
    required this.isSelected,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const double arrow = 14;

    final path = Path()
      ..moveTo(0, 0) // left top straight
      ..lineTo(size.width - arrow, 0)
      ..lineTo(size.width, size.height / 2) // right arrow point
      ..lineTo(size.width - arrow, size.height)
      ..lineTo(0, size.height) // left bottom straight
      ..close();

    final fillPaint = Paint()
      ..color = isSelected ? Colors.white : const Color(0xffFAFAFA)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = isSelected ? const Color(0xffAEB7C6) : const Color(0xffD5DBE5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = isSelected ? 1.4 : 1;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(isSelected ? 0.08 : 0.04)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    canvas.drawPath(path.shift(const Offset(0, 1)), shadowPaint);
    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant StageChevronPainter oldDelegate) {
    return oldDelegate.isSelected != isSelected ||
        oldDelegate.isFirst != isFirst ||
        oldDelegate.isLast != isLast;
  }
}

class _TopIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _TopIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xffE5E7EB)),
          ),
          child: Icon(icon, size: 23, color: const Color(0xff374151)),
        ),
      ),
    );
  }
}

class KanbanColumn extends StatelessWidget {
  final KanbanStage stage;
  final List<KanbanDeal> deals;
  final ValueChanged<KanbanDeal> onTapDeal;
  final ValueChanged<KanbanDeal> onAccept;

  const KanbanColumn({
    super.key,
    required this.stage,
    required this.deals,
    required this.onTapDeal,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<KanbanDeal>(
      onAcceptWithDetails: (details) {
        onAccept(details.data);
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          decoration: BoxDecoration(
            //   color: stage.bgColor.withOpacity(0.55),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: stage.color.withOpacity(0.16), width: 1),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        stage.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: stage.color,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Text(
                      "${deals.length} Orders",
                      style: const TextStyle(
                        color: Color(0xff4B5563),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: /*deals.isEmpty
                    ? Center(
                        child: Text(
                          "No orders",
                          style: TextStyle(
                            color: stage.color.withOpacity(0.65),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )
                    :*/ ListView.separated(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
                  itemCount: deals.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final deal = deals[index];

                    return DealCard(
                      deal: deal,
                      stage: stage,
                      onTap: () => onTapDeal(deal),
                      onDragUpdate: (position) {
                        final state = context
                            .findAncestorStateOfType<_KanbanBoardScreenState>();

                        state?._autoScrollWhileDragging(position);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class KanbanStage {
  final String id;
  final String title;
  final Color color;

  const KanbanStage({
    required this.id,
    required this.title,
    required this.color,
  });
}

class KanbanDeal {
  final String id;
  final String orderId;
  final String stageId;
  final String companyName;
  final String apartmentName;
  final String apartmentLocation;
  final String totalUnits;
  final String eventName;
  final String eventDate;
  final String guests;
  //final String setupStyle;
  final String customerName;
  final String phone;
  final String email;
  final String value;
  final String ownerName;
  final String createdAt;
  final String createdBy;
  final List<OrderHistory> orderHistory;

  const KanbanDeal({
    required this.id,
    required this.orderId,
    required this.stageId,
    required this.companyName,
    required this.apartmentName,
    required this.apartmentLocation,
    required this.totalUnits,
    required this.eventName,
    required this.eventDate,
    required this.guests,
    //required this.setupStyle,
    required this.customerName,
    required this.phone,
    required this.email,
    required this.value,
    required this.ownerName,
    required this.createdAt,
    required this.createdBy,
    required this.orderHistory,
  });

  factory KanbanDeal.fromBooking(Booking booking) {
    String formatDate(DateTime? date) {
      if (date == null) return "-";

      const months = [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec",
      ];

      return "${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}";
    }

    final apartment = booking.apartmentDetails;
    final event = booking.eventDetails;
    final customer = booking.customerDetails;

    final firstSchedule =
        booking.dailySchedule != null && booking.dailySchedule!.isNotEmpty
        ? booking.dailySchedule!.first
        : null;

    final locationText = [
      apartment?.location,
      apartment?.city,
    ].where((e) => e != null && e.toString().trim().isNotEmpty).join(", ");

    return KanbanDeal(
      id: booking.id ?? "",
      orderId: booking.orderId ?? "",
      stageId: (booking.orderStatus ?? 1).toString(),
      companyName: customer?.brandOrCompanyName ?? "-",
      apartmentName: apartment?.apartmentName ?? booking.apartmentName ?? "-",
      apartmentLocation: locationText.isEmpty ? "-" : locationText,
      totalUnits: booking.sqfet != null ? "${booking.sqfet} Sq.ft" : "-",
      eventName: event?.eventName ?? booking.eventName ?? "-",
      eventDate: booking.fromDate == null && booking.toDate == null
          ? "-"
          : "${formatDate(booking.fromDate)} - ${formatDate(booking.toDate)}",

      guests: "${booking.promoterCount ?? 0} Promoters",
   /*   setupStyle: booking.additionalNotes?.trim().isNotEmpty == true
          ? booking.additionalNotes!
          : "-",*/
      customerName: customer?.contactPersonName ?? "-",
      phone: customer?.contactPersonPhoneNumber ?? "-",
      email: customer?.email ?? "-",
      value: "₹${booking.totalAmount ?? 0}",
      ownerName: booking.createdBy?.trim().isNotEmpty == true
          ? booking.createdBy!
          : "A",
      createdAt: Helpers().formatDateTime(booking.createdAt.toString()),
      createdBy: booking.createdBy ?? "",
      orderHistory:
          booking.orderHistory?.map((e) {
            return OrderHistory(
              fromStatusText: e.fromStatusText ?? "",
              toStatusText: e.toStatusText ?? "",
              changedBy: e.changedBy ?? "-",
              changedAt: Helpers().formatDateTime(
                e.changedAt?.toString() ?? "",
              ),
              additionalNotes: e.additionalNotes ?? "",
            );
          }).toList() ??
          [],
    );
  }
}

class DetailRow {
  final String label;
  final String value;

  DetailRow(this.label, this.value);
}
