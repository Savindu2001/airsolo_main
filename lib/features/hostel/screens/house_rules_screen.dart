import 'package:airsolo/features/hostel/controllers/house_rules_controllers.dart';
import 'package:airsolo/features/hostel/models/house_rules.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

class HouseRulesScreen extends StatelessWidget {
  const HouseRulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = HouseRulesController.instance;
    controller.fetchRules();

    return Scaffold(
      appBar: AppBar(
        title: const Text('House Rules'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.fetchRules(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Obx(() {
          if (controller.isLoading.value) {
            return _buildLoadingShimmer();
          }

          if (controller.error.value.isNotEmpty) {
            return _buildErrorView(controller);
          }

          if (controller.rules.isEmpty) {
            return _buildEmptyState();
          }

          return _buildRulesList(controller);
        }),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            height: 80,
          ),
        );
      },
    );
  }

  Widget _buildErrorView(HouseRulesController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            controller.error.value,
            style: Get.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => controller.fetchRules(isRetry: true),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.list_alt, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'No house rules available',
            style: Get.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later or contact support',
            style: Get.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildRulesList(HouseRulesController controller) {
    return RefreshIndicator(
      onRefresh: () async => controller.fetchRules(),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: controller.rules.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final rule = controller.rules[index];
          return _buildRuleCard(rule);
        },
      ),
    );
  }

  Widget _buildRuleCard(HouseRule rule) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Theme.of(Get.context!).primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.rule,
                    size: 20,
                    color: Theme.of(Get.context!).primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (rule.hostelId != null || rule.roomId != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            _getRuleScope(rule),
                            style: Theme.of(Get.context!)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: Colors.grey,
                                ),
                          ),
                        ),
                      Text(
                        rule.rule,
                        style: Theme.of(Get.context!).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (rule.createdAt != rule.updatedAt)
                  Text(
                    'Updated ${_formatDate(rule.updatedAt)}',
                    style: Theme.of(Get.context!)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: Colors.grey),
                  )
                else
                  Text(
                    'Created ${_formatDate(rule.createdAt)}',
                    style: Theme.of(Get.context!)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: Colors.grey),
                  ),
                Text(
                  'ID: ${rule.id}',
                  style: Theme.of(Get.context!)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getRuleScope(HouseRule rule) {
    if (rule.roomId != null) return 'Room-specific rule';
    if (rule.hostelId != null) return 'Hostel-wide rule';
    return 'General rule';
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, y').format(date);
  }
}