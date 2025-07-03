/// 儿童识物学习项目模型
class LearningItem {
  final String id;
  final String name;
  final String imagePath;
  final String audioPath;
  final LearningCategory category;
  final String? description;

  const LearningItem({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.audioPath,
    required this.category,
    this.description,
  });

  factory LearningItem.fromJson(Map<String, dynamic> json) {
    return LearningItem(
      id: json['id'] as String,
      name: json['name'] as String,
      imagePath: json['imagePath'] as String,
      audioPath: json['audioPath'] as String,
      category: LearningCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => LearningCategory.animals,
      ),
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'audioPath': audioPath,
      'category': category.name,
      'description': description,
    };
  }
}

/// 学习内容分类
enum LearningCategory {
  animals('动物', 'assets/images/learning/categories/animals.png'),
  fruits('水果', 'assets/images/learning/categories/fruits.png'),
  vehicles('交通工具', 'assets/images/learning/categories/vehicles.png'),
  dailyItems('日用品', 'assets/images/learning/categories/daily_items.png'),
  colors('颜色', 'assets/images/learning/categories/colors.png'),
  numbers('数字', 'assets/images/learning/categories/numbers.png');

  const LearningCategory(this.displayName, this.iconPath);

  final String displayName;
  final String iconPath;
}
