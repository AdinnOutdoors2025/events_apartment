import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class KanbanBoardScreen extends StatefulWidget {
  const KanbanBoardScreen({super.key});

  @override
  State<KanbanBoardScreen> createState() => _KanbanBoardScreenState();
}

class _KanbanBoardScreenState extends State<KanbanBoardScreen> {
  final ScrollController _boardController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  DateTimeRange? selectedDateRange;
  String searchText = "";

  final List<KanbanStage> stages = const [
    KanbanStage(
      id: "enquiry",
      title: "Enquiry",
      color: Color(0xff2563EB),
      bgColor: Color(0xffEFF6FF),
      // icon: Icons.chat_bubble_outline_rounded,
    ),
    KanbanStage(
      id: "need_analysis",
      title: "Need Analysis",
      color: Color(0xffF97316),
      bgColor: Color(0xffFFF7ED),
      //  icon: Icons.search_rounded,
    ),
    KanbanStage(
      id: "proposal",
      title: "Proposal & Price Quote",
      color: Color(0xff7C3AED),
      bgColor: Color(0xffF5F3FF),
      //  icon: Icons.receipt_long_rounded,
    ),
    KanbanStage(
      id: "negotiation",
      title: "Negotiation & Review",
      color: Color(0xffEA580C),
      bgColor: Color(0xffFFF1F2),
      // icon: Icons.handshake_outlined,
    ),
    KanbanStage(
      id: "close_won",
      title: "Close Won",
      color: Color(0xff16A34A),
      bgColor: Color(0xffECFDF5),
      //  icon: Icons.check_circle_outline_rounded,
    ),
    KanbanStage(
      id: "closed_loss",
      title: "Closed Loss",
      color: Color(0xffDC2626),
      bgColor: Color(0xffFEF2F2),
      // icon: Icons.cancel_outlined,
    ),
  ];

  late List<KanbanDeal> deals;

  @override
  void initState() {
    super.initState();

    deals = [
      KanbanDeal(
        id: "ENQ-2025-001",
        stageId: "enquiry",
        companyName: "ABC Pvt. Ltd.",
        apartmentName: "Sunrise Apartments",
        apartmentLocation: "Whitefield, Bengaluru",
        apartmentType: "3 BHK",
        totalUnits: "120",
        eventName: "Annual Day",
        eventDate: "24 May 2025",
        eventTime: "6:00 PM - 10:00 PM",
        guests: "60 Guests",
        setupStyle: "Cocktail",
        customerName: "Rahul Sharma",
        phone: "+91 98765 43210",
        email: "rahul.sharma@email.com",
        value: "₹50,000",
        ownerName: "Neha",
      ),
      KanbanDeal(
        id: "ENQ-2025-002",
        stageId: "enquiry",
        companyName: "Sunrise Events",
        apartmentName: "Greenfield Residency",
        apartmentLocation: "Kondapur, Hyderabad",
        apartmentType: "2 BHK",
        totalUnits: "90",
        eventName: "Corporate Party",
        eventDate: "31 May 2025",
        eventTime: "5:00 PM - 8:00 PM",
        guests: "45 Guests",
        setupStyle: "Stall Setup",
        customerName: "Arun Kumar",
        phone: "+91 91234 56789",
        email: "arun@email.com",
        value: "₹80,000",
        ownerName: "Ravi",
      ),
      KanbanDeal(
        id: "NA-2025-003",
        stageId: "need_analysis",
        companyName: "Bright Future",
        apartmentName: "Maple Heights",
        apartmentLocation: "Madhapur, Hyderabad",
        apartmentType: "Premium",
        totalUnits: "180",
        eventName: "Family Day",
        eventDate: "02 Jun 2025",
        eventTime: "10:00 AM - 1:00 PM",
        guests: "80 Guests",
        setupStyle: "Open Area",
        customerName: "Priya Menon",
        phone: "+91 99887 76655",
        email: "priya@email.com",
        value: "₹60,000",
        ownerName: "Amit",
      ),
      KanbanDeal(
        id: "NA-2025-004",
        stageId: "need_analysis",
        companyName: "Green Field Events",
        apartmentName: "Lake View Residency",
        apartmentLocation: "Gachibowli, Hyderabad",
        apartmentType: "Luxury",
        totalUnits: "220",
        eventName: "Conference",
        eventDate: "05 Jun 2025",
        eventTime: "4:00 PM - 7:00 PM",
        guests: "100 Guests",
        setupStyle: "Stage + Seating",
        customerName: "Vikram Singh",
        phone: "+91 90123 45678",
        email: "vikram@email.com",
        value: "₹90,000",
        ownerName: "Kiran",
      ),
      KanbanDeal(
        id: "PRO-2025-005",
        stageId: "proposal",
        companyName: "Skyline Events",
        apartmentName: "Orchid Heights",
        apartmentLocation: "Banjara Hills, Hyderabad",
        apartmentType: "Premium",
        totalUnits: "150",
        eventName: "Wedding",
        eventDate: "12 Jun 2025",
        eventTime: "6:00 PM - 11:00 PM",
        guests: "250 Guests",
        setupStyle: "Stage + Dinner",
        customerName: "Riya Sharma",
        phone: "+91 87654 32109",
        email: "riya@email.com",
        value: "₹2,50,000",
        ownerName: "Meera",
      ),
      KanbanDeal(
        id: "NEG-2025-006",
        stageId: "negotiation",
        companyName: "Blue Bells Pvt. Ltd.",
        apartmentName: "Silver Springs",
        apartmentLocation: "Powai, Mumbai",
        apartmentType: "Corporate",
        totalUnits: "300",
        eventName: "Seminar",
        eventDate: "18 Jun 2025",
        eventTime: "9:00 AM - 12:00 PM",
        guests: "70 Guests",
        setupStyle: "Indoor Hall",
        customerName: "Rohit Mehra",
        phone: "+91 76543 21098",
        email: "rohit@email.com",
        value: "₹75,000",
        ownerName: "Sana",
      ),
      KanbanDeal(
        id: "WON-2025-007",
        stageId: "close_won",
        companyName: "Tech Solutions",
        apartmentName: "Palm Grove Apartments",
        apartmentLocation: "Hitech City, Hyderabad",
        apartmentType: "Gated Community",
        totalUnits: "400",
        eventName: "Annual Meet",
        eventDate: "20 Jun 2025",
        eventTime: "5:00 PM - 9:00 PM",
        guests: "150 Guests",
        setupStyle: "Premium Booth",
        customerName: "Ananya Verma",
        phone: "+91 88776 65544",
        email: "ananya@email.com",
        value: "₹3,00,000",
        ownerName: "John",
      ),
      KanbanDeal(
        id: "LOSS-2025-008",
        stageId: "closed_loss",
        companyName: "Future Corp.",
        apartmentName: "Victory Towers",
        apartmentLocation: "Chennai, Tamil Nadu",
        apartmentType: "Standard",
        totalUnits: "75",
        eventName: "Roadshow",
        eventDate: "25 Jun 2025",
        eventTime: "11:00 AM - 3:00 PM",
        guests: "50 Guests",
        setupStyle: "Outdoor Stall",
        customerName: "Karthik Raj",
        phone: "+91 90909 80808",
        email: "karthik@email.com",
        value: "₹70,000",
        ownerName: "Divya",
      ),
    ];
  }

  @override
  void dispose() {
    _boardController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<KanbanDeal> _dealsByStage(String stageId) {
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

  int _stageCount(String stageId) {
    return deals.where((deal) => deal.stageId == stageId).length;
  }

  void _moveDeal(String dealId, String newStageId) {
    setState(() {
      deals = deals.map((deal) {
        if (deal.id == dealId) {
          return deal.copyWith(stageId: newStageId);
        }
        return deal;
      }).toList();
    });
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
    final columnWidth = MediaQuery.of(context).size.width * 0.72;

    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            _Header(),

            /* Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
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
*/
            Expanded(
              child: SingleChildScrollView(
                controller: _boardController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(stages.length, (index) {
                    final stage = stages[index];
                    final stageDeals = _dealsByStage(stage.id);

                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: SizedBox(
                        width: columnWidth,
                        child: KanbanColumn(
                          stage: stage,
                          deals: stageDeals,
                          onAcceptDeal: (deal) {
                            _moveDeal(deal.id, stage.id);
                          },
                          onTapDeal: _openDealDetails,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            SizedBox(height: 15),
            SizedBox(
              height: 65,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: stages.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final stage = stages[index];
                  return GestureDetector(
                    onTap: () => _scrollToStage(index),
                    child: StageTabCard(
                      stage: stage,
                      count: _stageCount(stage.id),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
      // bottomNavigationBar: const KanbanBottomNav(),
      /*floatingActionButton: FloatingActionButton(
        backgroundColor: primaryRed,
        shape: const CircleBorder(),
        onPressed: () {},
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,*/
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: Row(
        children: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back)),
          const Expanded(
            child: Center(
              child: Text(
                "Kanban Board",
                style: TextStyle(
                  color: Color(0xff111827),
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert_rounded),
          ),
        ],
      ),
    );
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

class StageTabCard extends StatelessWidget {
  final KanbanStage stage;
  final int count;

  const StageTabCard({super.key, required this.stage, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: stage.bgColor,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: stage.color.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          //   Icon(stage.icon, size: 17, color: stage.color),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stage.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: stage.color,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    height: 1.05,
                  ),
                ),
                const Spacer(),
                Text(
                  "$count",
                  style: TextStyle(
                    color: stage.color,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class KanbanColumn extends StatelessWidget {
  final KanbanStage stage;
  final List<KanbanDeal> deals;
  final ValueChanged<KanbanDeal> onAcceptDeal;
  final ValueChanged<KanbanDeal> onTapDeal;

  const KanbanColumn({
    super.key,
    required this.stage,
    required this.deals,
    required this.onAcceptDeal,
    required this.onTapDeal,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<KanbanDeal>(
      onWillAccept: (deal) {
        return deal != null && deal.stageId != stage.id;
      },
      onAccept: onAcceptDeal,
      builder: (context, candidateData, rejectedData) {
        final isDraggingOver = candidateData.isNotEmpty;

        return Container(
          decoration: BoxDecoration(
            color: stage.bgColor.withOpacity(0.55),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDraggingOver
                  ? stage.color
                  : stage.color.withOpacity(0.16),
              width: isDraggingOver ? 1.4 : 1,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
                child: Row(
                  children: [
                    Text(
                      stage.title,
                      style: TextStyle(
                        color: stage.color,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "${deals.length} Deals",
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
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
                  itemCount: deals.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    /*if (index == deals.length) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );*/ /*Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDraggingOver
                                ? stage.color
                                : const Color(0xffE5E7EB),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            isDraggingOver ? "Drop here" : "+ Add Deal",
                            style: TextStyle(
                              color: isDraggingOver
                                  ? stage.color
                                  : const Color(0xff6B7280),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      );*/
                    /*}*/

                    final deal = deals[index];

                    return LongPressDraggable<KanbanDeal>(
                      data: deal,
                      feedback: Material(
                        color: Colors.transparent,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.62,
                          child: DealCard(
                            deal: deal,
                            stage: stage,
                            isDragging: true,
                            onTap: () {},
                          ),
                        ),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.35,
                        child: DealCard(
                          deal: deal,
                          stage: stage,
                          onTap: () => onTapDeal(deal),
                        ),
                      ),
                      child: DealCard(
                        deal: deal,
                        stage: stage,
                        onTap: () => onTapDeal(deal),
                      ),
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

class DealCard extends StatelessWidget {
  final KanbanDeal deal;
  final KanbanStage stage;
  final VoidCallback onTap;
  final bool isDragging;

  const DealCard({
    super.key,
    required this.deal,
    required this.stage,
    required this.onTap,
    this.isDragging = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: isDragging ? 12 : 0,
      shadowColor: Colors.black.withOpacity(0.12),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xffE5E7EB)),
            boxShadow: [
              if (!isDragging)
                BoxShadow(
                  color: Colors.black.withOpacity(0.035),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                      color: stage.bgColor,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Icon(
                      Icons.apartment_rounded,
                      color: stage.color,
                      size: 23,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      deal.companyName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xff111827),
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.more_vert_rounded,
                    size: 18,
                    color: Color(0xff6B7280),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Text(
                deal.eventName,
                style: const TextStyle(
                  color: Color(0xff374151),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  const Icon(
                    Icons.currency_rupee_rounded,
                    size: 14,
                    color: Color(0xff6B7280),
                  ),
                  Text(
                    deal.value.replaceAll("₹", ""),
                    style: const TextStyle(
                      color: Color(0xff111827),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: stage.bgColor,
                    child: Text(
                      deal.ownerName.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        color: stage.color,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
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
  }
}

class DealDetailsSheet extends StatelessWidget {
  final KanbanDeal deal;
  final List<KanbanStage> stages;
  final void Function(String dealId, String newStageId) onMoveStage;

  const DealDetailsSheet({
    super.key,
    required this.deal,
    required this.stages,
    required this.onMoveStage,
  });

  KanbanStage get currentStage {
    return stages.firstWhere((stage) => stage.id == deal.stageId);
  }

  void _openMoveStageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 4,
                  width: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xffD1D5DB),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    const Text(
                      "Move Deal To",
                      style: TextStyle(
                        color: Color(0xff111827),
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(sheetContext),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                ...stages.map((stage) {
                  final isCurrent = stage.id == deal.stageId;

                  return GestureDetector(
                    onTap: isCurrent
                        ? null
                        : () {
                            onMoveStage(deal.id, stage.id);
                            Navigator.pop(sheetContext);
                            Navigator.pop(context);
                          },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? stage.bgColor
                            : const Color(0xffFFFFFF),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isCurrent
                              ? stage.color.withOpacity(0.4)
                              : const Color(0xffE5E7EB),
                        ),
                      ),
                      child: Row(
                        children: [
                          /*Container(
                            height: 36,
                            width: 36,
                            decoration: BoxDecoration(
                              color: stage.bgColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              stage.icon,
                              color: stage.color,
                              size: 20,
                            ),
                          ),*/
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              stage.title,
                              style: const TextStyle(
                                color: Color(0xff111827),
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          if (isCurrent)
                            Text(
                              "Current",
                              style: TextStyle(
                                color: stage.color,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            )
                          else
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 15,
                              color: Color(0xff9CA3AF),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final stage = currentStage;

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.55,
      maxChildSize: 0.96,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xffFAFAFA),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                height: 4,
                width: 44,
                decoration: BoxDecoration(
                  color: const Color(0xffD1D5DB),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          "Deal Details",
                          style: TextStyle(
                            color: Color(0xff111827),
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.more_vert_rounded),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xffE5E7EB)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 54,
                            width: 54,
                            decoration: BoxDecoration(
                              color: stage.bgColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.apartment_rounded,
                              color: stage.color,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 13),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  deal.companyName,
                                  style: const TextStyle(
                                    color: Color(0xff111827),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  deal.apartmentName,
                                  style: const TextStyle(
                                    color: Color(0xff6B7280),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: stage.bgColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    stage.title,
                                    style: TextStyle(
                                      color: stage.color,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    DetailsSection(
                      icon: Icons.apartment_rounded,
                      iconColor: stage.color,
                      title: "Apartment Details",
                      rows: [
                        DetailRow("Apartment Name", deal.apartmentName),
                        DetailRow("Location", deal.apartmentLocation),
                        DetailRow("Type", deal.apartmentType),
                        DetailRow("Total Units", deal.totalUnits),
                      ],
                    ),

                    const SizedBox(height: 12),

                    DetailsSection(
                      icon: Icons.calendar_month_outlined,
                      iconColor: const Color(0xffF97316),
                      title: "Event Details",
                      rows: [
                        DetailRow("Event Type", deal.eventName),
                        DetailRow("Event Date", deal.eventDate),
                        DetailRow("Time", deal.eventTime),
                        DetailRow("Expected Guests", deal.guests),
                        DetailRow("Setup Style", deal.setupStyle),
                        DetailRow("Expected Value", deal.value),
                      ],
                    ),

                    const SizedBox(height: 12),

                    DetailsSection(
                      icon: Icons.person_outline_rounded,
                      iconColor: const Color(0xff2563EB),
                      title: "Customer Details",
                      rows: [
                        DetailRow("Customer Name", deal.customerName),
                        DetailRow("Phone", deal.phone),
                        DetailRow("Email", deal.email),
                        DetailRow("Company", deal.companyName),
                      ],
                    ),

                    const SizedBox(height: 12),

                    OptionalItemCard(
                      icon: Icons.mic_none_rounded,
                      color: const Color(0xff7C3AED),
                      title: "Voice Text",
                      subtitle: "Record voice note",
                    ),

                    const SizedBox(height: 10),

                    OptionalItemCard(
                      icon: Icons.notes_rounded,
                      color: const Color(0xffF97316),
                      title: "Notes",
                      subtitle: "Add notes about this deal",
                    ),

                    const SizedBox(height: 10),

                    OptionalItemCard(
                      icon: Icons.attach_file_rounded,
                      color: const Color(0xff16A34A),
                      title: "File Upload",
                      subtitle: "Upload PDF, JPG, PNG files",
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey.shade200)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        label: const Text("Edit"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xffE30613),
                          side: const BorderSide(color: Color(0xffE30613)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _openMoveStageSheet(context),
                        icon: const Icon(Icons.swap_horiz_rounded, size: 18),
                        label: const Text("Move Stage"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffE30613),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DetailsSection extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final List<DetailRow> rows;

  const DetailsSection({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xffE5E7EB)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 34,
                width: 34,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xff111827),
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_up_rounded,
                color: Color(0xff6B7280),
              ),
            ],
          ),

          const SizedBox(height: 14),

          ...rows.map((row) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      row.label,
                      style: const TextStyle(
                        color: Color(0xff6B7280),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      row.value,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Color(0xff111827),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class OptionalItemCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const OptionalItemCard({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            height: 34,
            width: 34,
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 19),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: title,
                    style: const TextStyle(
                      color: Color(0xff111827),
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(
                    text: "  (Optional)\n",
                    style: TextStyle(
                      color: Color(0xff9CA3AF),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: subtitle,
                    style: const TextStyle(
                      color: Color(0xff6B7280),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 15,
            color: Color(0xff9CA3AF),
          ),
        ],
      ),
    );
  }
}

class KanbanStage {
  final String id;
  final String title;
  final Color color;
  final Color bgColor;

  //final IconData icon;

  const KanbanStage({
    required this.id,
    required this.title,
    required this.color,
    required this.bgColor,
    // required this.icon,
  });
}

class KanbanDeal {
  final String id;
  final String stageId;
  final String companyName;
  final String apartmentName;
  final String apartmentLocation;
  final String apartmentType;
  final String totalUnits;
  final String eventName;
  final String eventDate;
  final String eventTime;
  final String guests;
  final String setupStyle;
  final String customerName;
  final String phone;
  final String email;
  final String value;
  final String ownerName;

  const KanbanDeal({
    required this.id,
    required this.stageId,
    required this.companyName,
    required this.apartmentName,
    required this.apartmentLocation,
    required this.apartmentType,
    required this.totalUnits,
    required this.eventName,
    required this.eventDate,
    required this.eventTime,
    required this.guests,
    required this.setupStyle,
    required this.customerName,
    required this.phone,
    required this.email,
    required this.value,
    required this.ownerName,
  });

  KanbanDeal copyWith({String? stageId}) {
    return KanbanDeal(
      id: id,
      stageId: stageId ?? this.stageId,
      companyName: companyName,
      apartmentName: apartmentName,
      apartmentLocation: apartmentLocation,
      apartmentType: apartmentType,
      totalUnits: totalUnits,
      eventName: eventName,
      eventDate: eventDate,
      eventTime: eventTime,
      guests: guests,
      setupStyle: setupStyle,
      customerName: customerName,
      phone: phone,
      email: email,
      value: value,
      ownerName: ownerName,
    );
  }
}

class DetailRow {
  final String label;
  final String value;

  DetailRow(this.label, this.value);
}
