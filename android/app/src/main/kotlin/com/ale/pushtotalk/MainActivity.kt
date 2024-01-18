package com.ale.pushtotalk

import android.util.Log
import androidx.annotation.NonNull
import com.ale.pushtotalk.callback.BubbleCallbackImpl
import com.ale.pushtotalk.callback.LoginCallbackImpl
import com.ale.pushtotalk.interfaces.BubbleCallback
import com.ale.pushtotalk.interfaces.LoginCallback
import com.ale.pushtotalk.interfaces.RainbowService
import com.ale.pushtotalk.services.RainbowServiceImpl
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.util.GeneratedPluginRegister
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity(private val rainbowService: RainbowService = RainbowServiceImpl(),
                   private val loginCallback: LoginCallback = LoginCallbackImpl(),
                    private val bubbleCallback: BubbleCallback = BubbleCallbackImpl()
) :
    FlutterActivity() {

    companion object {
        private const val CHANNEL = "flutter.native/helper"
    }

    override fun onDestroy() {
        super.onDestroy()
        rainbowService.logout()
    }

    @ExperimentalStdlibApi
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegister.registerGeneratedPlugins(flutterEngine)
        // TODO - (refactor) move this inside a router
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when {
                call.method.equals("isRainbowSdkInitialized") -> {
                    isRainbowSdkInitialized(result)
                }
                // TODO - adapt this call (it should maybe be modified)
                call.method.equals("login") -> {
                    login(call, result)
                }
                call.method.equals("logout") -> {
                    logout(call, result)
                }
                call.method.equals("getRainbowUser") -> {
                    getRainbowUser(call, result)
                }
                // TODO : Method to create / modify / delete bubbles
                call.method.equals("createBubble") -> {
                    createBubble(call, result)
                }
                call.method.equals("getRainbowBubbles") -> {
                    getRainbowBubbles(call, result)
                }
            }
        }
    }

    private fun createBubble(call: MethodCall, result: MethodChannel.Result) {
        rainbowService.createBubble(call.argument<String>("name")!!, call.argument<String>("topic")!!, bubbleCallback, result)
    }

    private fun isRainbowSdkInitialized(result: MethodChannel.Result) {
        Log.d("RainbowSdk", "isRainbowSdkInitialized: ${rainbowService.isSdkInitialized()}")
        result.success(rainbowService.isSdkInitialized())
    }

    private fun login(call: MethodCall, result: MethodChannel.Result) {
        rainbowService.login(call.argument<String>("email")!!, call.argument<String>("password")!!,
            loginCallback, result
        )
    }

    private fun logout(call: MethodCall, result: MethodChannel.Result) {
        rainbowService.logout()
    }

    private fun getRainbowUser(call: MethodCall, result: MethodChannel.Result) {
        result.success(rainbowService.getRainbowUser());
    }

    private fun getRainbowBubbles(call: MethodCall, result: MethodChannel.Result) {
        result.success(rainbowService.getRainbowBubbles());
    }
}