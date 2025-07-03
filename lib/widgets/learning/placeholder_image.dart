import 'package:flutter/material.dart';
import 'package:oliyo_app/models/learning_item.dart';

/// 为学习项目创建占位符图片的工具类
class PlaceholderImageWidget extends StatelessWidget {
  final LearningItem item;
  final double size;

  const PlaceholderImageWidget({
    super.key,
    required this.item,
    this.size = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _getCategoryColor(item.category),
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getCategoryColor(item.category),
            _getCategoryColor(item.category).withOpacity(0.7),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getCategoryIcon(item.category),
            size: size * 0.4,
            color: Colors.white,
          ),
          const SizedBox(height: 8),
          Text(
            _getItemEmoji(item.id),
            style: TextStyle(
              fontSize: size * 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(LearningCategory category) {
    switch (category) {
      case LearningCategory.animals:
        return const Color(0xFF4CAF50);
      case LearningCategory.fruits:
        return const Color(0xFFFF9800);
      case LearningCategory.vehicles:
        return const Color(0xFF2196F3);
      case LearningCategory.dailyItems:
        return const Color(0xFF9C27B0);
      case LearningCategory.colors:
        return const Color(0xFFE91E63);
      case LearningCategory.numbers:
        return const Color(0xFF607D8B);
    }
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

  String _getItemEmoji(String itemId) {
    switch (itemId) {
      case 'animal_cat':
        return '🐱';
      case 'animal_dog':
        return '🐶';
      case 'animal_rabbit':
        return '🐰';
      case 'fruit_apple':
        return '🍎';
      case 'fruit_banana':
        return '🍌';
      case 'fruit_orange':
        return '🍊';
      case 'vehicle_car':
        return '🚗';
      case 'vehicle_bus':
        return '🚌';
      default:
        return '📷';
    }
  }
}
