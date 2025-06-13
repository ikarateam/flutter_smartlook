package com.Smartlook.Smartlook.flutter_smartlook

import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.View
import com.cisco.android.bridge.model.BridgeFrameworkInfo
import com.cisco.android.bridge.model.BridgeInterface
import com.cisco.android.bridge.model.BridgeWireframe
import com.cisco.android.common.utils.extensions.toClass
import io.flutter.embedding.android.FlutterView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

class MicroTimer {
    private var startTime: Long = 0L

    fun start() {
        startTime = System.nanoTime()
    }

    fun elapsedMicros(): Long {
        val currentTime = System.nanoTime()
        return (currentTime - startTime) / 1000
    }
}

class FlutterBridge(
    private val methodChannels: HashMap<BinaryMessenger, MethodChannel>,
    override var isRecordingAllowed: Boolean,
) : BridgeInterface {

    private var isDebugMode = false //with false to production
    private val wireframeParser = WireframeDataParser()
    private val classes = listOf(FlutterView::class.java,"io.flutter.plugins.webviewflutter.WebViewHostApiImpl\$WebViewPlatformView".toClass() as? Class<View>,"io.flutter.embedding.android.FlutterImageView".toClass() as? Class<View>)
    fun changeTransitioningState(state: Boolean) {
        isRecordingAllowed = !state
    }

    override fun obtainFrameworkInfo(callback: (BridgeFrameworkInfo?) -> Unit) {
        callback(
            BridgeFrameworkInfo(
                framework = "FLUTTER",
                frameworkPluginVersion = "4.1.25",
                frameworkVersion = "-"
            )
        )
    }

    override fun obtainWireframeRootClasses(): List<Class<out View>> {
        val theClasses = classes.mapNotNull { className -> className }
        return theClasses
    }

    override fun obtainWireframeData(instance: View, callback: (BridgeWireframe?) -> Unit) {
        if (instance !is FlutterView) {
            callback(null)
            return
        }

        val methodChannel = methodChannels[instance.binaryMessenger]

        if (methodChannel == null) {
            callback(null)
            return
        }

        val timer = MicroTimer()
        timer.start()

        Handler(Looper.getMainLooper()).post {
            methodChannel.invokeMethod(
                "getWireframe", "arg", object : MethodChannel.Result {
                    override fun success(result: Any?) {
                        val wireframeMap = result as? HashMap<String, Any>
                        if (wireframeMap == null) {
                            callback(null)
                            return
                        }

                        if (wireframeMap["isTransitioning"] as Boolean? == true) {
                            return
                        }

                        if (isDebugMode) {
                            Log.d("elapsedTime:", "${timer.elapsedMicros()}")
                        }
                        callback(wireframeParser.createBridgeWireframe(instance, wireframeMap))
                    }

                    override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                        Log.d(
                            "SmartlookPlugin",
                            "Error occured on wireframe, please submit a bug. Or check that you have added SmartlookHelperWidget over your MaterialApp"
                        )
                        callback(null)
                    }

                    override fun notImplemented() {
                        Log.d(
                            "SmartlookPlugin",
                            "Wireframe not implemented, please check that Smartlook is implemented. If the log persists after start of the app submit a bug."
                        )
                        callback(null)
                    }
                })
        }
    }

    private fun loadClassAsViewType(className: String): Class<out View>? {
        return try {
            // Attempt to load the class dynamically using reflection
            val clazz = Class.forName(className)

            // Ensure the class is a subclass of View
            if (View::class.java.isAssignableFrom(clazz)) {
                @Suppress("UNCHECKED_CAST")
                Log.d("smartlook_sdk","xxxxx worked")
                clazz as Class<out View>

            } else {
                Log.d("smartlook_sdk","xxxxx no subclass")
                null // The class is not a View subclass
            }
        } catch (e: ClassNotFoundException) {
            Log.d("smartlook_sdk","xxxxx failed ${e.message}")
            e.printStackTrace()
            null // Return null or handle appropriately
        }
        catch (e: Exception) {
            Log.d("smartlook_sdk","xxxxx failed exc${e.message}")
            e.printStackTrace()
            null // Return null or handle appropriately
        }
    }

}