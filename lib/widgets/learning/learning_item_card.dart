import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oliyo_app/controllers/learning_controller.dart';
import 'package:oliyo_app/models/learning_item.dart';
import 'package:oliyo_app/widgets/learning/placeholder_image.dart';

class LearningItemCard extends StatelessWidget {
  final LearningItem item;
  final VoidCallback onTap;

  const LearningItemCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LearningController>();

    return Obx(() {
      final isPlaying = controller.isItemPlaying(item.id);

      return GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color:
                    isPlaying
                        ? const Color(0xFF4CAF50).withOpacity(0.3)
                        : Colors.black.withOpacity(0.1),
                blurRadius: isPlaying ? 12 : 8,
                offset: const Offset(0, 4),
              ),
            ],
            border:
                isPlaying
                    ? Border.all(color: const Color(0xFF4CAF50), width: 2)
                    : null,
          ),
          child: Column(
            children: [
              // 图片区域
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: Stack(
                    children: [
                      // 图片
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: PlaceholderImageWidget(
                            item: item,
                            size: double.infinity,
                          ),
                        ),
                      ),

                      // 播放指示器
                      if (isPlaying)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4CAF50),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.volume_up,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // 文字区域
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isPlaying
                            ? const Color(0xFF4CAF50).withOpacity(0.1)
                            : Colors.grey[50],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color:
                              isPlaying
                                  ? const Color(0xFF4CAF50)
                                  : Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (item.description != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          item.description!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
