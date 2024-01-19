package com.ale.pushtotalk.interfaces

import android.app.Application
import io.flutter.plugin.common.MethodChannel


interface RainbowService {
    fun createConferenceCall(bubbleId: String, callback: BubbleCallback, result: MethodChannel.Result)
    fun createBubble(name: String, topic: String, callback: BubbleCallback, result: MethodChannel.Result)
    fun login(email: String, password: String, callback: LoginCallback, result: MethodChannel.Result)
    fun logout()
    fun initializeSdk(app: Application, applicationID: String, applicationSecret: String)
    fun isSdkInitialized(): Boolean
    fun isSignedIn(): Boolean
    fun getRainbowUser(): Map<String, String?>
    fun getRainbowBubbles(): MutableList<Map<String, String>>
}