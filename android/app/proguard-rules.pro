# Flutter相关规则
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Flutter embedding相关规则
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.embedding.**

# Google Play Core相关规则
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# PocketBase相关规则
-keep class pocketbase.** { *; }

# 保持应用的主要类
-keep class com.oliyo.oliyo_app.oliyo_app.** { *; }

# 通用规则
-dontwarn javax.annotation.**
-dontwarn org.conscrypt.**
-dontwarn org.bouncycastle.**
-dontwarn org.openjsse.**

# 处理缺失的Google Play Core类
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**

# 保持所有native方法
-keepclasseswithmembernames class * {
    native <methods>;
}
