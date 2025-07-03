import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oliyo_app/controllers/learning_controller.dart';
import 'package:oliyo_app/models/learning_item.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LearningController>();

    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text(
                  '选择分类',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Obx(() => Text(
                  controller.selectedCategory?.displayName ?? '全部',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                )),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                // 全部分类按钮
                Obx(() => _CategoryChip(
                  label: '全部',
                  icon: Icons.apps,
                  isSelected: controller.selectedCategory == null,
                  onTap: () => controller.filterByCategory(null),
                  count: controller.allItems.length,
                )),
                
                const SizedBox(width: 12),
                
                // 各个分类按钮
                ...controller.categories.map((category) => Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Obx(() => _CategoryChip(
                    label: category.displayName,
                    icon: _getCategoryIcon(category),
                    isSelected: controller.selectedCategory == category,
                    onTap: () => controller.filterByCategory(category),
                    count: controller.getCategoryItemCount(category),
                  )),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(LearningCategory category) {
    switch (category) {
      case LearningCategory.animals:
        return Icons.pets;
      case LearningCategory.fruits:
        return Icons.apple;
      case LearningCategory.vehicles:
        return Icons.directions_car;
      case LearningCategory.dailyItems:
        return Icons.home;
      case LearningCategory.colors:
        return Icons.palette;
      case LearningCategory.numbers:
        return Icons.numbers;
    }
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final int count;

  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? const Color(0xFF4CAF50) : Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF4CAF50) : Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (count > 0) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF4CAF50) : Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
