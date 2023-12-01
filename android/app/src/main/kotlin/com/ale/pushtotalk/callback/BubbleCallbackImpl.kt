package com.ale.pushtotalk.callback

import android.util.Log
import com.ale.infra.manager.room.IRainbowRoom
import com.ale.pushtotalk.interfaces.BubbleCallback
import io.flutter.plugin.common.MethodChannel


class BubbleCallbackImpl : BubbleCallback{
    override fun onBubbleCreated(bubble: IRainbowRoom, result: MethodChannel.Result) {
        val roomInformation = mapOf(
            "id" to bubble.id,
            "name" to bubble.name,
            "creatorId" to bubble.creatorId
        )
        return result.success(roomInformation)
    }
}