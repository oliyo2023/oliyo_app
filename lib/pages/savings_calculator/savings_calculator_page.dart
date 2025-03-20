import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SavingsCalculatorPage extends StatefulWidget {
  const SavingsCalculatorPage({super.key});

  @override
  State<SavingsCalculatorPage> createState() => _SavingsCalculatorPageState();
}

class _SavingsCalculatorPageState extends State<SavingsCalculatorPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dailyCountController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quitDaysController = TextEditingController();

  // 计算结果
  double _totalSavings = 0.0;
  int _totalCigarettes = 0;
  int _healthDaysGained = 0;
  bool _hasCalculated = false;

  @override
  void dispose() {
    _dailyCountController.dispose();
    _priceController.dispose();
    _quitDaysController.dispose();
    super.dispose();
  }

  // 计算节省金额
  void _calculateSavings() {
    if (_formKey.currentState!.validate()) {
      final dailyCount = int.parse(_dailyCountController.text);
      final pricePerPack = double.parse(_priceController.text);
      final quitDays = int.parse(_quitDaysController.text);

      // 计算节省的金额（假设一包20支）
      final cigarettesPerPack = 20;
      final packsPerDay = dailyCount / cigarettesPerPack;
      final dailyCost = packsPerDay * pricePerPack;
      final totalSavings = dailyCost * quitDays;

      // 计算未吸烟的总数量
      final totalCigarettes = dailyCount * quitDays;

      // 计算健康收益（假设每10支烟减少寿命2小时）
      final healthHoursGained = (totalCigarettes / 10) * 2;
      final healthDaysGained = (healthHoursGained / 24).round();

      setState(() {
        _totalSavings = totalSavings;
        _totalCigarettes = totalCigarettes;
        _healthDaysGained = healthDaysGained;
        _hasCalculated = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('资金节约计算'),
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 介绍卡片
              const Card(
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '戒烟省钱计算器',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '计算您戒烟后节省的金钱，以及获得的健康收益。填写以下信息，我们将为您计算详细的节省情况。',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 表单
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 每日吸烟量
                    TextFormField(
                      controller: _dailyCountController,
                      decoration: const InputDecoration(
                        labelText: '每日吸烟量（支）',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.smoking_rooms),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入每日吸烟量';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // 香烟价格
                    TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        labelText: '香烟价格（元/包）',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入香烟价格';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // 戒烟天数
                    TextFormField(
                      controller: _quitDaysController,
                      decoration: const InputDecoration(
                        labelText: '戒烟天数',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入戒烟天数';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // 计算按钮
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _calculateSavings,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9C27B0),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          '计算节省',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 计算结果
              if (_hasCalculated) ...[
                const SizedBox(height: 30),
                const Text(
                  '计算结果',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // 结果卡片
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4CAF50), Color(0xFFA5D6A7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildResultItem(
                          '节省金额',
                          '¥${_totalSavings.toStringAsFixed(2)}',
                          Icons.savings,
                        ),
                        const Divider(color: Colors.white54),
                        _buildResultItem(
                          '未吸烟总数',
                          '$_totalCigarettes 支',
                          Icons.smoke_free,
                        ),
                        const Divider(color: Colors.white54),
                        _buildResultItem(
                          '延长寿命',
                          '$_healthDaysGained 天',
                          Icons.favorite,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                // 分享按钮
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // 分享功能
                      Get.snackbar(
                        '分享成功',
                        '您的戒烟成就已分享到社区',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('分享我的成就'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF9C27B0),
                      side: const BorderSide(color: Color(0xFF9C27B0)),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // 结果项目
  Widget _buildResultItem(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
