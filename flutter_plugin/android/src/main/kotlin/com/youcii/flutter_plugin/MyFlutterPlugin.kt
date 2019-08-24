package com.youcii.flutter_plugin

import android.app.Activity
import android.content.Intent
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

/**
 * 插件定义类
 */
class MyFlutterPlugin(private val activity: Activity) : MethodCallHandler {

    companion object {
        /**
         * 供给主项目引用: MyFlutterPlugin.registerWith
         */
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "my_flutter_plugin")
            channel.setMethodCallHandler(MyFlutterPlugin(registrar.activity()))
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "goToOtherApp") {
            result.success("Call Android Success")
            activity.startActivity(activity.packageManager.getLaunchIntentForPackage("com.youcii.mvplearn"))
        } else {
            result.notImplemented()
        }
    }

}
