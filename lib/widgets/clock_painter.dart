import 'dart:math';
import 'package:flutter/material.dart';

class ClockPainter extends CustomPainter {
  final BuildContext context;
  final DateTime dateTime;

  ClockPainter(this.context, this.dateTime);

  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    Offset center = Offset(centerX, centerY);
    double radius = min(centerX, centerY);

    // --- 1. 增加刻度线的长度和粗细 & 2. 使用不同的颜色区分刻度 ---

    // 增加刻度线长度和粗细的示例 (例如，小时刻度)
    double hourTickLength = 15.0; // 增加长度
    double hourTickWidth = 3.0; // 增加粗细
    double minuteTickLength = 8.0; // 分钟刻度长度
    double minuteTickWidth = 1.5; // 分钟刻度粗细

    // 使用不同 Paint 对象来区分颜色和样式
    Paint hourTickPaint =
        Paint()
          ..color =
              Colors
                  .redAccent // 小时刻度使用红色
          ..strokeWidth = hourTickWidth
          ..strokeCap = StrokeCap.round;

    Paint minuteTickPaint =
        Paint()
          ..color =
              Colors
                  .blueGrey // 分钟刻度使用蓝灰色
          ..strokeWidth = minuteTickWidth
          ..strokeCap = StrokeCap.round;

    // 假设有 24 小时和地支刻度

    // --- 绘制刻度 ---
    // 外圈半径，用于绘制刻度线
    double outerRadius = radius - 20; // 留出边距给数字等

    for (int i = 0; i < 60; i++) {
      double angle = (pi / 30) * i; // 每个刻度的角度
      double tickStartRadius;
      Paint currentPaint;

      if (i % 5 == 0) {
        // 小时刻度 (也是地支和可能24小时的位置)
        tickStartRadius = outerRadius - hourTickLength;
        currentPaint = hourTickPaint; // 默认使用小时刻度样式

        // 在这里可以根据 i 的值判断是哪个地支或24小时，并切换 Paint
        // 例如: if (isEarthlyBranch(i)) currentPaint = earthlyBranchTickPaint;
        // 例如: if (isTwentyFourHourMark(i)) currentPaint = twentyFourHourTickPaint;
      } else {
        // 分钟刻度
        tickStartRadius = outerRadius - minuteTickLength;
        currentPaint = minuteTickPaint;
      }

      Offset tickStart = Offset(
        centerX + tickStartRadius * cos(angle - pi / 2),
        centerY + tickStartRadius * sin(angle - pi / 2),
      );
      Offset tickEnd = Offset(
        centerX + outerRadius * cos(angle - pi / 2),
        centerY + outerRadius * sin(angle - pi / 2),
      );
      canvas.drawLine(tickStart, tickEnd, currentPaint);
    }

    // --- 3. 调整刻度数字的字体和大小 ---
    double textRadius = outerRadius - hourTickLength - 15; // 数字绘制的半径
    TextPainter textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    // 调整字体、大小和颜色
    TextStyle textStyle = TextStyle(
      color: Colors.black,
      fontSize: 18.0, // 调整字体大小
      fontWeight: FontWeight.bold, // 调整字体粗细
      // fontFamily: 'YourCustomFont', // 可以指定自定义字体
    );

    // 绘制小时数字 (1-12)
    for (int i = 1; i <= 12; i++) {
      double angle = (pi / 6) * i - pi / 2; // 小时数字的角度
      Offset textOffset = Offset(
        centerX + textRadius * cos(angle),
        centerY + textRadius * sin(angle),
      );

      textPainter.text = TextSpan(text: '$i', style: textStyle);
      textPainter.layout();
      // 调整位置使数字居中
      textPainter.paint(
        canvas,
        textOffset - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }

    // --- 4. 添加更多的装饰元素 ---
    // 示例：在中心添加一个小的装饰圆点
    Paint centerDecorationPaint = Paint()..color = Colors.red;
    canvas.drawCircle(center, 5, centerDecorationPaint);

    // 示例：添加一个内圈装饰线
    Paint innerCirclePaint =
        Paint()
          ..color = Colors.grey.withAlpha((255 * 0.5).round())
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;
    canvas.drawCircle(center, radius * 0.8, innerCirclePaint); // 绘制一个半径为80%的内圈

    // --- 绘制指针等其他元素 (此处省略) ---
    // ... draw hands ...
  }

  @override
  bool shouldRepaint(covariant ClockPainter oldDelegate) {
    // Only repaint if the dateTime has changed
    return oldDelegate.dateTime != dateTime;
  }
}
