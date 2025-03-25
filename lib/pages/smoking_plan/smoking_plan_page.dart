import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SmokingPlanPage extends StatefulWidget {
  const SmokingPlanPage({super.key});

  @override
  State<SmokingPlanPage> createState() => _SmokingPlanPageState();
}

class _SmokingPlanPageState extends State<SmokingPlanPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dailyCountController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _smokingYearsController = TextEditingController();

  String _selectedPlan = '逐步减少';
  final List<String> _planTypes = ['逐步减少', '冷火鸡戒烟', '尼古丁替代疗法'];

  @override
  void dispose() {
    _dailyCountController.dispose();
    _priceController.dispose();
    _smokingYearsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('制定戒烟计划'),
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 介绍文字
              const Card(
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '个性化戒烟计划',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '根据您的吸烟习惯和个人情况，我们将为您制定一个科学的戒烟计划。请填写以下信息，帮助我们更好地了解您的情况。',
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

                    // 吸烟年限
                    TextFormField(
                      controller: _smokingYearsController,
                      decoration: const InputDecoration(
                        labelText: '吸烟年限',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入吸烟年限';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // 戒烟方式选择
                    const Text(
                      '选择戒烟方式：',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // 戒烟方式选项
                    ...List.generate(
                      _planTypes.length,
                      (index) => RadioListTile<String>(
                        title: Text(_planTypes[index]),
                        value: _planTypes[index],
                        groupValue: _selectedPlan,
                        activeColor: const Color(0xFF9C27B0),
                        onChanged: (value) {
                          setState(() {
                            _selectedPlan = value!;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 生成计划按钮
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // 处理表单提交
                            _showPlanDialog();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9C27B0),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          '生成戒烟计划',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 显示计划对话框
  void _showPlanDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('您的个性化戒烟计划'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('根据您提供的信息，我们为您制定了以下戒烟计划：'),
                  const SizedBox(height: 16),
                  Text('戒烟方式：$_selectedPlan'),
                  const SizedBox(height: 8),
                  const Text('第一周：减少25%的吸烟量'),
                  const SizedBox(height: 4),
                  const Text('第二周：减少50%的吸烟量'),
                  const SizedBox(height: 4),
                  const Text('第三周：减少75%的吸烟量'),
                  const SizedBox(height: 4),
                  const Text('第四周：完全戒烟'),
                  const SizedBox(height: 16),
                  const Text('建议：'),
                  const SizedBox(height: 8),
                  const Text('• 每天记录您的吸烟欲望和应对方法'),
                  const SizedBox(height: 4),
                  const Text('• 避免与吸烟相关的场景和触发因素'),
                  const SizedBox(height: 4),
                  const Text('• 寻求家人和朋友的支持'),
                  const SizedBox(height: 4),
                  const Text('• 使用应用程序的提醒功能，帮助您坚持计划'),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('关闭'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Get.snackbar(
                    '成功',
                    '您的戒烟计划已保存',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                },
                child: const Text('保存计划'),
              ),
            ],
          ),
    );
  }
}
