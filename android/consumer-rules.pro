-keepclassmembers class io.flutter.embedding.android.FlutterView {
    private io.flutter.embedding.engine.FlutterEngine flutterEngine;
}

-keepclassmembers class io.flutter.embedding.engine.FlutterEngine {
    private io.flutter.plugin.platform.PlatformViewsController platformViewsController;
}

-keepclassmembers class io.flutter.plugin.platform.PlatformViewsController {
    private *** platformViews;
}