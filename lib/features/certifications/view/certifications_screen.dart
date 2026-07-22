import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/certification_filter_provider.dart';
import '../widgets/label_type_filter_tile.dart';
import '../widgets/certification_card.dart';
import '../widgets/certification_detail_sheet.dart';

class CertificationsScreen extends ConsumerWidget {
  const CertificationsScreen({super.key});

  static const backgroundColor = Color(0xFFF5F4EF);
  static const darkGreen = Color(0xFF0B2B13);

  static const labelTypes = [
    {'key': 'fair_trade', 'icon': Icons.handshake_outlined, 'label': 'Fair Trade Certified'},
    {'key': 'energy_star', 'icon': Icons.bolt_outlined, 'label': 'Energy Star Rated'},
    {'key': 'organic_bio', 'icon': Icons.eco_outlined, 'label': 'Certified Organic / Bio'},
    {'key': 'cruelty_free', 'icon': Icons.pets_outlined, 'label': 'Cruelty-Free / Biodegradable'},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredCerts = ref.watch(filteredCertificationListProvider);
    final selectedTypes = ref.watch(certificationFilterControllerProvider);
    final filterController = ref.read(certificationFilterControllerProvider.notifier);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Certifications Guide',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: darkGreen,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Master the language of sustainability. Decode the world's most trusted green labels.",
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'FILTER GUIDE BY LABEL TYPE',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  GestureDetector(
                    onTap: filterController.clearAll,
                    child: const Text(
                      'Clear All',
                      style: TextStyle(
                        fontSize: 13,
                        color: darkGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...labelTypes.map((type) {
                final key = type['key'] as String;
                return LabelTypeFilterTile(
                  icon: type['icon'] as IconData,
                  label: type['label'] as String,
                  checked: selectedTypes.contains(key),
                  onTap: () => filterController.toggle(key),
                );
              }),
              const SizedBox(height: 24),

              const Text(
                'ECO-LABEL INTERACTIVE LIBRARY',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),

              filteredCerts.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, _) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: Text('Something went wrong: $error')),
                ),
                data: (certs) {
                  if (certs.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(child: Text('No certifications found.')),
                    );
                  }
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: certs.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.78,
                    ),
                    itemBuilder: (context, index) {
                      final cert = certs[index];
                      return CertificationCard(
                        certification: cert,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => CertificationDetailSheet(certification: cert),
                          );
                        },
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}