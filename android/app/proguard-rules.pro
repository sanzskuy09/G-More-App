# ======================
# GOOGLE MLKIT SUPPORT
# ======================
-keep class com.google.mlkit.** { *; }
-dontwarn com.google.mlkit.**

# For MLKit internal dependencies (e.g., protobuf, AutoValue)
-keep class com.google.protobuf.** { *; }
-dontwarn com.google.protobuf.**
-keep class com.google.auto.value.** { *; }
-dontwarn com.google.auto.value.**

# ======================
# CAMERA PLUGIN SUPPORT
# ======================
-keep class io.flutter.plugins.camera.** { *; }
-dontwarn io.flutter.plugins.camera.**

# ======================
# FLUTTER CORE SUPPORT
# ======================
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**

# ======================
# KOTLIN COROUTINES (if used)
# ======================
-keep class kotlinx.coroutines.** { *; }
-dontwarn kotlinx.coroutines.**

# ======================
# GENERAL REFLECTION/ANNOTATION SAFETY
# ======================
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes EnclosingMethod

# Keep all @Keep-annotated classes and methods
-keep @androidx.annotation.Keep class * { *; }

# Optional: remove Log debug calls in release
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
}