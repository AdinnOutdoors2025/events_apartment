import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/get_list_model.dart';
import '../theme/app_colors.dart';

class ApartmentDetailsScreen extends ConsumerWidget {
  final Apartment apartment;

  const ApartmentDetailsScreen({super.key, required this.apartment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.white,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back, color: Colors.black),
          ),
          title: Text(
            "Apartment Details",
            style: TextStyle(color: AppColors.red, fontWeight: FontWeight.w500),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ApartmentImagePlaceholder(),

                    const SizedBox(height: 5),

                    const _ApartmentTabs(),

                    //  const SizedBox(height: 24),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Expanded(
                child: TabBarView(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      child: _OverviewTab(apartment: apartment),
                    ),

                    SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      child: OwnerContactCard(apartment: apartment),
                    ),

                    SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      child: PaymentInfoCard(apartment: apartment),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ApartmentTabs extends StatelessWidget {
  const _ApartmentTabs();

  @override
  Widget build(BuildContext context) {
    return const TabBar(
      indicatorColor: AppColors.red,
      indicatorWeight: 3,
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: AppColors.red,
      unselectedLabelColor: AppColors.textGrey,
      labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
      unselectedLabelStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      tabs: [
        Tab(text: 'Overview'),
        Tab(text: 'Owner'),
        Tab(text: 'Payment'),
      ],
    );
  }
}

class _OverviewTab extends StatelessWidget {
  final Apartment apartment;

  const _OverviewTab({required this.apartment});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          apartment.apartmentName ?? '-',
          style: const TextStyle(
            color: AppColors.textGrey,
            fontSize: 22,
            fontWeight: FontWeight.w900,
            height: 1.1,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          '${apartment.location ?? '-'}, ${apartment.city ?? '-'}',
          style: const TextStyle(
            color: AppColors.textGrey,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 15),

        DetailsInfoCard(
          rows: [
            DetailRowData(
              icon: Icons.groups_2_outlined,
              title: 'Total Residences',
              value: '${apartment.residencyCount ?? '-'}',
            ),
            DetailRowData(
              icon: Icons.trip_origin_rounded,
              title: 'TG Value',
              value:
                  '${apartment.fromTGValues ?? '-'} - ${apartment.toTGValues ?? '-'}',
            ),

            DetailRowData(
              icon: Icons.star_border_rounded,
              title: 'Rating',
              value: apartment.rating ?? '-',
            ),
            DetailRowData(
              icon: Icons.group_outlined,
              title: 'Approx People Count',
              value: '${apartment.approxPeopleCount ?? '-'}',
            ),
            DetailRowData(
              icon: Icons.currency_rupee_rounded,
              title: 'Apartment Rent / Day',
              value: '₹${apartment.perDayRent ?? '-'}',
              valueColor: Colors.green,
            ),
          ],
        ),
      ],
    );
  }
}

class ApartmentImagePlaceholder extends StatelessWidget {
  const ApartmentImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xffF5F6FB),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xffECEEF5)),
      ),
      child: Center(
        child: Icon(
          Icons.apartment_rounded,
          size: 96,
          color: AppColors.textGrey,
        ),
      ),
    );
  }
}

class DetailRowData {
  final IconData icon;
  final String title;
  final String value;
  final Color? valueColor;

  const DetailRowData({
    required this.icon,
    required this.title,
    required this.value,
    this.valueColor,
  });
}

class DetailsInfoCard extends StatelessWidget {
  final List<DetailRowData> rows;

  const DetailsInfoCard({super.key, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(rows.length, (index) {
        final item = rows[index];
        final isLast = index == rows.length - 1;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                children: [
                  Icon(item.icon, color: AppColors.red, size: 22),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Text(
                      item.title,
                      style: const TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  //   const SizedBox(width: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      item.value,
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: item.valueColor ?? Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                ],
              ),
            ),

            /*   if (!isLast)
              Divider(
                height: 1,
                thickness: 1,
                color: AppColors.border.withOpacity(0.7),
              ),*/
          ],
        );
      }),
    );
  }
}

class OwnerContactCard extends StatelessWidget {
  final Apartment apartment;

  const OwnerContactCard({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.055),
              blurRadius: 22,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Authorized Contact',
              style: TextStyle(
                color: AppColors.textGrey,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: const BoxDecoration(
                    color: Color(0xffEEF0F8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Color(0xffA5ABBC),
                    size: 30,
                  ),
                ),

                const SizedBox(width: 18),

                Expanded(
                  child: Text(
                    apartment.contactPersonName ?? '-',
                    style: const TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                _ActionButton(
                  icon: Icons.call_rounded,
                  onTap: () {
                    // Call action
                  },
                ),

                const SizedBox(width: 10),

                _ActionButton(
                  icon: Icons.chat_bubble_rounded,
                  onTap: () {
                    // Message action
                  },
                ),
              ],
            ),

            const SizedBox(height: 26),

            Row(
              children: [
                const Icon(
                  Icons.phone_outlined,
                  color: AppColors.red,
                  size: 24,
                ),

                const SizedBox(width: 16),

                Text(
                  apartment.contactPersonPhone ?? '-',
                  style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.035),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(icon, color: AppColors.red, size: 20),
        ),
      ),
    );
  }
}

class PaymentInfoCard extends StatelessWidget {
  final Apartment apartment;

  const PaymentInfoCard({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    return DetailsInfoCard(
      rows: [
        DetailRowData(
          icon: Icons.account_balance_outlined,
          title: 'Bank Name',
          value: dashIfEmpty(apartment.bankDetails?.bankName),
        ),
        DetailRowData(
          icon: Icons.person_outline_rounded,
          title: 'Account Holder Name',
          value: dashIfEmpty(apartment.bankDetails?.accountName),
        ),
        DetailRowData(
          icon: Icons.credit_card_rounded,
          title: 'Account Number',
          value: dashIfEmpty(apartment.bankDetails?.accountNumber),
        ),
        DetailRowData(
          icon: Icons.verified_user_outlined,
          title: 'IFSC Code',
          value: dashIfEmpty(apartment.bankDetails?.ifscCode),
        ),
        DetailRowData(
          icon: Icons.send_outlined,
          title: 'UPI ID',
          value: dashIfEmpty(apartment.bankDetails?.upiId),
        ),
      ],
    );
  }

  String dashIfEmpty(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '-';
    }
    return value.trim();
  }
}
