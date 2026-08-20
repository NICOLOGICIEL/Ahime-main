# Flutter engine and plugin embedding already ship their own consumer
# ProGuard rules bundled in their AARs; these cover cases R8 can't infer.

# Keep JS-bridge interfaces used by the WebView plugins (flutter_inappwebview,
# webview_flutter) — methods annotated @JavascriptInterface are called from
# JS by name/reflection, so R8 must not rename or strip them.
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# Dio/Gson-style reflection: keep model classes' field names if any Dio
# response parsing ever relies on reflection instead of manual json.decode.
-keepattributes Signature
-keepattributes *Annotation*
