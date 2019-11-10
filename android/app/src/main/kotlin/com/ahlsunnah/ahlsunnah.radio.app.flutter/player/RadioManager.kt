package com.ahlsunnah.ahlsunnah.radio.app.flutter.player

import android.content.Context
class RadioManager(private val context: Context) {

    private var instance: RadioManager? = null

    private var service = RadioService(context)

    private var serviceBound = false

    fun initPlayer() {
        service.onCreate()
    }

    fun playOrPause(streamUrl: String) {
        service.playOrPause(streamUrl)
    }

    fun stop() = service.stop()

    fun isPlaying(): Boolean {
        return service.isPlaying()
    }
}
