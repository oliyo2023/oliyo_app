# AI Stop Smoking 戒烟助手应用

一款基于Flutter开发的戒烟辅助应用，帮助用户记录戒烟进程、获取戒烟资讯并与社区互动。

## 项目概述

本应用旨在为有戒烟需求的用户提供全方位的支持，包括戒烟知识、社区互动、个人进度跟踪等功能，帮助用户成功戒烟。

## 功能特点

- **首页**：展示戒烟进度、健康改善指标和每日激励内容
- **新闻**：提供最新戒烟相关资讯和专业知识文章
- **发现**：社区互动功能，用户可以分享戒烟经验和心得
- **个人中心**：用户信息管理、戒烟记录和个人设置
- **用户认证**：支持用户注册和登录功能，保存个人戒烟数据

## 技术栈

- **前端框架**：Flutter (SDK ^3.7.0)
- **状态管理**：GetX (^4.7.2)
- **后端服务**：PocketBase
- **数据存储**：SharedPreferences
- **其他依赖**：
  - logging: ^1.2.0 (日志管理)
  - intl: ^0.18.1 (国际化支持)
  - flutter_widget_from_html_core: ^0.10.5 (HTML渲染)

## 安装说明

### 环境要求

- Flutter SDK ^3.7.0
- Dart SDK 最新版本
- 支持平台：Android、iOS、Windows、macOS、Web

### 安装步骤

1. 克隆项目代码
   ```
   git clone [项目仓库URL]
   cd oliyo_app
   ```

2. 安装依赖
   ```
   flutter pub get
   ```

3. 运行应用
   ```
   flutter run
   ```

## 项目结构

```
/lib
  /bindings      - 依赖注入绑定
  /controllers   - 控制器（GetX）
  /models        - 数据模型
  /pages         - 页面UI组件
  /routes        - 路由管理
  /services      - 服务层（API调用等）
  main.dart      - 应用入口
```

## 贡献指南

1. Fork 项目
2. 创建功能分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'Add some amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 创建Pull Request

## 许可证

[添加许可证信息]

## 联系方式

[添加联系方式]
