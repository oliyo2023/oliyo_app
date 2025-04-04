// test/pages/clock/clock_page_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:oliyo_app/pages/clock/clock_page.dart'; // 调整为你的项目路径
import 'package:oliyo_app/services/time_service.dart'; // 调整为你的项目路径
import 'package:oliyo_app/utils/chinese_calendar.dart'; // 调整为你的项目路径

// 使用 build_runner 生成 Mock 类: flutter pub run build_runner build --delete-conflicting-outputs
@GenerateMocks([TimeService])
import 'clock_page_test.mocks.dart'; // 生成的 Mock 文件

void main() {
  // 使用 MockTimeService 的实例
  late MockTimeService mockTimeService;

  // 设置固定的测试时间
  final fixedTime = DateTime(2024, 7, 15, 10, 30, 0); // 例如：2024年7月15日 10:30:00

  setUp(() {
    // 在每个测试之前创建新的 Mock 实例
    mockTimeService = MockTimeService();

    // Mock getCorrectedTime 方法，使其返回固定时间
    // 注意：TimeService 的 getCorrectedTime 是同步方法
    when(mockTimeService.getCorrectedTime()).thenReturn(fixedTime);

    // 清除之前的 GetX 绑定并注入 Mock 实例
    // 确保在测试环境中 TimeService 被正确替换
    Get.reset(); // 重置 GetX 状态
    Get.put<TimeService>(mockTimeService); // 注入 MockTimeService
  });

  tearDown(() {
    Get.reset(); // 每个测试后重置 GetX
  });

  testWidgets('ClockPage displays initial time and date correctly', (
    WidgetTester tester,
  ) async {
    // 构建 ClockPage Widget
    await tester.pumpWidget(const GetMaterialApp(home: ClockPage()));

    // 等待一帧以确保状态更新
    await tester.pump();

    // 验证 AppBar 标题
    expect(find.text('中国时辰时钟(24小时制)'), findsOneWidget);

    // 验证日期显示
    expect(find.text('2024年7月15日'), findsOneWidget);

    // 验证时间显示 (HH:mm:ss)
    expect(find.text('10:30:00'), findsOneWidget);

    // 验证干支纪年显示
    // 需要根据 fixedTime 计算预期的干支字符串
    final expectedGanzhi = ChineseCalendar.getFullGanzhiDate(fixedTime);
    expect(find.text(expectedGanzhi), findsOneWidget);

    // 验证 ClockPainter 是否存在
    // 使用更精确的查找器来定位 ClockPainter 对应的 CustomPaint
    final clockPainterFinder = find.byWidgetPredicate(
      (Widget widget) =>
          widget is CustomPaint && widget.painter is ClockPainter,
    );
    expect(clockPainterFinder, findsOneWidget);

    // 验证获取到的 painter 确实是 ClockPainter
    final customPaint = tester.widget<CustomPaint>(clockPainterFinder);
    expect(customPaint.painter, isA<ClockPainter>());
  });

  testWidgets('ClockPage updates time when timer ticks', (
    WidgetTester tester,
  ) async {
    // 设置初始时间
    var currentTime = DateTime(2024, 7, 15, 10, 30, 0);
    when(mockTimeService.getCorrectedTime()).thenReturn(currentTime);

    await tester.pumpWidget(const GetMaterialApp(home: ClockPage()));
    await tester.pump(); // 初始渲染

    // 验证初始时间
    expect(find.text('10:30:00'), findsOneWidget);

    // 模拟时间流逝（例如，1秒后）
    final nextTime = DateTime(2024, 7, 15, 10, 30, 1);
    when(mockTimeService.getCorrectedTime()).thenReturn(nextTime);

    // 触发定时器回调（ClockPage 内部使用 Timer.periodic(1 second)）
    // pump 方法可以模拟时间的流逝
    await tester.pump(const Duration(seconds: 1));

    // 验证时间是否更新
    expect(find.text('10:30:00'), findsNothing); // 旧时间消失
    expect(find.text('10:30:01'), findsOneWidget); // 新时间出现

    // 验证日期和干支是否仍然正确（如果时间变化未跨天/时辰）
    expect(find.text('2024年7月15日'), findsOneWidget);
    final expectedGanzhi = ChineseCalendar.getFullGanzhiDate(nextTime);
    expect(find.text(expectedGanzhi), findsOneWidget);
  });

  // 可以添加更多测试用例，例如测试跨天、跨时辰的情况
}
