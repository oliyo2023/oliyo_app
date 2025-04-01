import 'package:ntp/ntp.dart'; // 使用 ntp 包
import 'package:logging/logging.dart';
import 'package:flutter/foundation.dart'; // 导入 kIsWeb

class TimeService {
  final _logger = Logger('TimeService');

  Duration _offset = Duration.zero;
  bool _isInitialized = false; // 标记NTP获取是否已尝试过（无论成功与否）
  bool _isFetching = false; // 防止并发获取

  // 改为同步方法，立即返回，并在后台启动NTP获取
  void init() {
    // 如果已经在获取或已经尝试过，则不重复启动
    if (_isFetching || _isInitialized) return;

    _isFetching = true; // 标记开始获取
    // 不等待，让其在后台运行
    _fetchNtpTimeInBackground().whenComplete(() {
      _isFetching = false; // 获取完成（无论成功或失败）
    });
  }

  // 新增私有异步方法用于后台获取NTP时间
  Future<void> _fetchNtpTimeInBackground() async {
    // 检查是否在Web平台运行
    if (kIsWeb) {
      _logger.info('Skipping NTP fetch on Web platform.');
      // 在Web上，直接标记为已初始化，使用本地时间
      _isInitialized = true;
      _offset = Duration.zero; // 确保偏移量为零
    } else {
      // 非Web平台，执行NTP获取
      try {
        _logger.info('Fetching NTP time in background...');
        // 获取NTP时间 (NTP.now() 返回的是本地时区的时间)
        final ntpTime = await NTP.now();
        final localTime = DateTime.now();
        // 计算NTP时间与本地时间的偏移量
        _offset = ntpTime.difference(localTime);
        _logger.info('NTP time fetched successfully. Offset: $_offset');
      } catch (e, stackTrace) {
        _logger.severe('Error fetching NTP time', e, stackTrace);
        // 如果发生异常，偏移量保持为零
        _offset = Duration.zero;
      } finally {
        // 标记为已初始化（尝试过），防止 init() 再次触发后台获取
        _isInitialized = true;
      }
    }
  }

  /// 获取校准后的当前时间
  DateTime getCorrectedTime() {
    // 如果尚未初始化（即后台任务未完成或失败），返回本地时间
    if (!_isInitialized) {
      // 可以选择在这里再次触发 init()，但这可能导致重复调用
      // 或者简单返回本地时间，等待后台任务完成
      return DateTime.now();
    }
    // 返回本地时间加上计算出的偏移量
    return DateTime.now().add(_offset);
  }
}
