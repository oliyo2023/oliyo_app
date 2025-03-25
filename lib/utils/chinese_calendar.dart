class ChineseCalendar {
  static const List<String> heavenlyStems = [
    '甲',
    '乙',
    '丙',
    '丁',
    '戊',
    '己',
    '庚',
    '辛',
    '壬',
    '癸',
  ];

  static const List<String> earthlyBranches = [
    '子',
    '丑',
    '寅',
    '卯',
    '辰',
    '巳',
    '午',
    '未',
    '申',
    '酉',
    '戌',
    '亥',
  ];

  static String getGanzhiYear(DateTime date) {
    int year = date.year;
    int offset = (year - 4) % 60;
    return '${heavenlyStems[offset % 10]}${earthlyBranches[offset % 12]}';
  }

  static String getGanzhiMonth(DateTime date) {
    int year = date.year;
    int month = date.month;

    // 简化计算，实际需要完整农历算法
    int offset = (year * 12 + month + 3) % 60;
    return '${heavenlyStems[offset % 10]}${earthlyBranches[offset % 12]}';
  }

  static String getGanzhiDay(DateTime date) {
    // 简化计算，实际需要完整农历算法
    int offset = (date.difference(DateTime(1900, 1, 1)).inDays + 10) % 60;
    return '${heavenlyStems[offset % 10]}${earthlyBranches[offset % 12]}';
  }

  static String getFullGanzhiDate(DateTime date) {
    return '${getGanzhiYear(date)}年 ${getGanzhiMonth(date)}月 ${getGanzhiDay(date)}日';
  }
}
