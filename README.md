# Oliyo App

一个综合性的Flutter应用，专注于学习和生活方式管理。

## 功能特性

### 🎓 学习模块
- 多类别学习内容（动物、水果、交通工具等）
- 音频播放支持
- 交互式学习体验
- 进度跟踪

### 🚭 戒烟助手
- 戒烟计划制定
- 节省金额计算
- 健康数据记录
- 社区支持

### 🕐 时钟功能
- 中国传统时钟显示
- 农历日期显示
- 实时时间同步

### 👥 社区功能
- 用户交流
- 消息系统
- 新闻资讯

## 技术栈

- **框架**: Flutter 3.19+
- **状态管理**: GetX
- **后端服务**: PocketBase
- **本地存储**: SharedPreferences
- **音频播放**: audioplayers
- **网络请求**: http
- **国际化**: intl

## 项目结构

```
lib/
├── bindings/          # GetX绑定
├── constants/         # 应用常量
├── controllers/       # 控制器
├── models/           # 数据模型
├── pages/            # 页面
├── routes/           # 路由配置
├── services/         # 服务层
├── utils/            # 工具类
├── widgets/          # 自定义组件
└── main.dart         # 应用入口
```

## 开发环境要求

- Flutter SDK: 3.19.0 或更高版本
- Dart SDK: 3.7.0 或更高版本
- Android Studio / VS Code
- Android SDK (API 21+)
- iOS开发需要Xcode (macOS)

## 安装和运行

1. **克隆项目**
   ```bash
   git clone <repository-url>
   cd oliyo_app
   ```

2. **安装依赖**
   ```bash
   flutter pub get
   ```

3. **运行项目**
   ```bash
   # 调试模式
   flutter run
   
   # 发布模式
   flutter run --release
   ```

## 构建发布版本

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 代码质量

项目使用以下工具确保代码质量：

- **flutter_lints**: 代码规范检查
- **flutter analyze**: 静态代码分析
- **单元测试**: 使用flutter_test和mockito

运行代码分析：
```bash
flutter analyze
```

运行测试：
```bash
flutter test
```

## 配置说明

### 环境配置
- 修改 `lib/constants/app_constants.dart` 中的API地址
- 配置PocketBase服务地址

### 图标和启动画面
- 图标配置在 `pubspec.yaml` 的 `flutter_launcher_icons` 部分
- 启动画面配置在 `pubspec.yaml` 的 `flutter_native_splash` 部分

## 开发规范

### 代码风格
- 使用单引号
- 优先使用const构造函数
- 避免不必要的容器
- 使用有意义的变量名

### 文件命名
- 使用小写字母和下划线
- 页面文件以 `_page.dart` 结尾
- 控制器文件以 `_controller.dart` 结尾
- 服务文件以 `_service.dart` 结尾

### 注释规范
- 公共API必须有文档注释
- 复杂逻辑需要行内注释
- 使用中文注释

## 性能优化

### 已实现的优化
- 图片懒加载
- 列表分页加载
- 网络请求重试机制
- 本地缓存策略

### 建议的优化
- 使用 `const` 构造函数
- 避免在build方法中创建对象
- 合理使用 `ListView.builder`
- 图片压缩和缓存

## 错误处理

项目实现了完善的错误处理机制：

- 网络请求重试
- 用户友好的错误提示
- 日志记录
- 异常捕获

## 测试

### 单元测试
```bash
flutter test
```

### 集成测试
```bash
flutter drive --target=test_driver/app.dart
```

## 部署

### Android
1. 生成签名密钥
2. 配置 `android/app/build.gradle`
3. 运行 `flutter build apk --release`

### iOS
1. 配置证书和描述文件
2. 运行 `flutter build ios --release`
3. 使用Xcode上传到App Store

## 贡献指南

1. Fork项目
2. 创建功能分支
3. 提交更改
4. 推送到分支
5. 创建Pull Request

## 许可证

本项目采用MIT许可证。

## 联系方式

如有问题或建议，请通过以下方式联系：

- 邮箱: [your-email@example.com]
- 项目Issues: [GitHub Issues]

## 更新日志

### v1.0.0
- 初始版本发布
- 基础功能实现
- 学习模块
- 戒烟助手
- 时钟功能
- 社区功能
