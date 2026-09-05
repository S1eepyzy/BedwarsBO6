# =====================================================================
# BedWarsBO6 · ProGuard 混淆规则（在 mvn package 的 shade 之后执行）
# 策略：开启 收缩(shrink) + 混淆(obfuscate)，关闭 优化(optimize)。
#       只混淆 com.bwbo6.** 自身代码；
#       Bukkit 反射入口(plugin.yml main / @EventHandler / 命令接口)
#       与打进 jar 的第三方库(JDBC/Redis) 全部保留原名。
# =====================================================================

# ---- 基础属性：保留注解(EventHandler)、泛型签名、行号(便于排障) ----
-keepattributes Exceptions,InnerClasses,EnclosingMethod,Signature,Deprecated,SourceFile,LineNumberTable,*Annotation*

# 不做字节码优化（游戏插件求稳，只做收缩+改名混淆）
-dontoptimize

# 静默重复定义提示（shade fat jar 内的第三方库会与自动加入的 libraryjars 重复，
# 产生海量 "Note: duplicate definition of library class" 刷屏，无实际影响）
-dontnote

# ---- 静默外部引用 ----
# 第三方库引用到的"可选实现类"（打包时未包含，如 slf4j 的 org.slf4j.impl.* binder、
# JDBC 驱动内部可选依赖等）。它们位于被完整保留的第三方代码里，运行时按需加载，
# 缺失与否不影响已打包代码——与原样 shade jar 行为一致，故整体忽略 unresolved 告警。
-dontwarn
-dontwarn net.md_5.**
-dontwarn javax.**
-dontwarn com.google.errorprone.**
-dontwarn org.checkerframework.**
-dontwarn **module-info

# ============ 1. 插件入口（Bukkit 反射加载） ============
# plugin.yml 的 main: com.bwbo6.BedWarsBO6
# 需要保留：public 无参构造（Bukkit 反射实例化）、
#           public onEnable/onDisable（须保持对 JavaPlugin 的重写）。
-keep public class com.bwbo6.BedWarsBO6 {
    public <init>();
    public protected *;
}

# ============ 2. 事件监听（Bukkit 反射扫描 @EventHandler） ============
-keepclasseswithmembers class com.bwbo6.** {
    @org.bukkit.event.EventHandler <methods>;
}

# ============ 3. 命令执行器 / Tab 补全（框架按接口签名调用） ============
-keepclasseswithmembers class com.bwbo6.** {
    public boolean onCommand(org.bukkit.command.CommandSender,
                             org.bukkit.command.Command,
                             java.lang.String,
                             java.lang.String[]);
    public java.util.List onTabComplete(org.bukkit.command.CommandSender,
                                        org.bukkit.command.Command,
                                        java.lang.String,
                                        java.lang.String[]);
}

# ============ 4. 打进 jar 的第三方依赖：完整保留 ============
# （JDBC 通过 ServiceLoader/Class.forName 加载驱动，反射类名不可乱）
-keep class org.sqlite.** { *; }
-keep class org.slf4j.** { *; }
-keep class redis.clients.** { *; }
-keep class org.apache.commons.** { *; }
-keep class com.mysql.** { *; }
-keep class com.google.** { *; }
