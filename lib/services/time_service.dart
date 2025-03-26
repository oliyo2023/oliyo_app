import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

class TimeService {
  final _logger = Logger('TimeService');
  final String _apiUrl = 'https://worldtimeapi.org/api/ip'; // 使用基于IP的自动时区检测

  DateTime? _networkTime;
  Duration _offset = Duration.zero;
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    try {
      _logger.info('Fetching network time...');
      final response = await http.get(Uri.parse(_apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final utcTimeString = data['utc_datetime'] as String;
        // 解析不带时区信息的UTC时间字符串
        _networkTime = DateTime.parse(
          utcTimeString.substring(0, 26),
        ); // 移除时区偏移量
        final localTime = DateTime.now();
        // 计算网络UTC时间与本地UTC时间的偏移量
        _offset = _networkTime!.difference(localTime.toUtc());
        _logger.info('Network time fetched successfully. Offset: $_offset');
        _isInitialized = true;
      } else {
        _logger.warning(
          'Failed to fetch network time. Status code: ${response.statusCode}',
        );
        // 如果获取失败，偏移量保持为零
      }
    } catch (e, stackTrace) {
      _logger.severe('Error fetching network time', e, stackTrace);
      // 如果发生异常，偏移量保持为零
    }
  }

  /// 获取校准后的当前时间
  DateTime getCorrectedTime() {
    // 如果未初始化或获取失败，返回本地时间
    if (!_isInitialized || _networkTime == null) {
      return DateTime.now();
    }
    // 返回本地时间加上计算出的偏移量
    return DateTime.now().add(_offset);
  }
}
