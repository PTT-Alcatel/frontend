package com.ale.pushtotalk.services

import android.app.Application
import android.util.Log
import com.ale.infra.manager.room.CreateRoomBody
import com.ale.infra.manager.room.IRainbowRoom
import com.ale.infra.rest.listeners.RainbowError
import com.ale.infra.rest.listeners.RainbowListener
import com.ale.infra.rest.room.RoomRepository
import com.ale.listener.SigninResponseListener
import com.ale.listener.SignoutResponseListener
import com.ale.pushtotalk.interfaces.BubbleCallback
import com.ale.pushtotalk.interfaces.LoginCallback
import com.ale.pushtotalk.interfaces.RainbowService
import com.ale.rainbow.RBLog
import com.ale.rainbowsdk.RainbowSdk
import io.flutter.plugin.common.MethodChannel
import org.tinylog.Level


class RainbowServiceImpl: RainbowService {

    private var isConnected: Boolean = false

    override fun login(email: String, password: String, callback: LoginCallback, result: MethodChannel.Result) {
    RainbowSdk.instance().connection().signin(
        email,
        password,
        "sandbox.openrainbow.com",
        object : SigninResponseListener() {
            override fun onRequestFailed(
                errorCode: RainbowSdk.ErrorCode,
                err: RainbowError<Unit>
            ) {
                Log.d("Rainbow - Init connection", "onRequestFailed: $errorCode - $err")
                isConnected = false
                callback.onLoginError(errorCode, err, result)
            }

            override fun onSigninSucceeded() {
                Log.d("Rainbow - Init connection", "onSigninSucceeded: Connected - ${RainbowSdk.instance().connection().isSignedIn}")
                isConnected = true
                callback.onLoginSuccess(this@RainbowServiceImpl, result)
            }
        })
}

    override fun logout() {
        RainbowSdk.instance().connection().signout(object : SignoutResponseListener() {
            override fun onSignoutSucceeded() {
                isConnected = false
                Log.d("Rainbow - Init connection", "onSignoutSucceeded: Disconnected - ${RainbowSdk.instance().connection().isSignedIn}")
            }
        })
    }


    override fun initializeSdk(app: Application, applicationID: String, applicationSecret: String) {
        RainbowSdk.instance().initialize(app, applicationID, applicationSecret)
        RBLog.setLevel(Level.WARN)
        Log.d("RainbowSdk", "SDK Instance: ${RainbowSdk.instance()}")
        RainbowSdk.instance().push().activate(app)
    }

    override fun isSdkInitialized(): Boolean {
        return RainbowSdk.instance().isInitialized
    }

    override fun isSignedIn(): Boolean {
        // TODO - (refactor) make it the right way with instance
        return isConnected
    }

    override fun getRainbowUser(): Map<String, String?> {
        val user = RainbowSdk.instance().myProfile().getConnectedUser()

        return mapOf(
            "id" to user?.id,
            "firstName" to user?.firstName,
            "lastName" to user?.lastName,
            "companyName" to user?.companyName,
            "email" to user?.getMainEmailAddress(),
            "jobTitle" to user?.jobTitle,
        )
    }

    override fun createBubble(
        name: String,
        topic: String,
        callback: BubbleCallback,
        result: MethodChannel.Result
    ) {
        RainbowSdk.instance().bubbles().createBubble(
            CreateRoomBody.Builder()
                .name(name)
                .topic(topic).build(),
            object : RainbowListener<IRainbowRoom, RoomRepository.CreateRoomError> {
                override fun onSuccess(bubble: IRainbowRoom) {
                    callback.onBubbleCreated(bubble, result)
                }

                override fun onError(error: RainbowError<RoomRepository.CreateRoomError>) {
                    callback.onBubbleCreationError(result)
                }
            })
    }
    override fun getRainbowBubbles(): MutableList<Map<String, String>> {
        val rainbowBubbles = RainbowSdk.instance().bubbles().getAllBubbles()
        val parsedBubbles = mutableListOf<Map<String, String>>()

        for (room in rainbowBubbles.items) {
            val bubble = mapOf(
                "id" to room.id,
                "name" to room.name,
                "topic" to room.topic,
                "creatorId" to room.creatorId
            )
            parsedBubbles.add(bubble)
        }
        return parsedBubbles
    }
}