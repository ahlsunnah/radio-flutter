package com.ahlsunnah.ahlsunnah.radio.app.flutter

import android.os.Bundle
import com.ahlsunnah.ahlsunnah.radio.app.flutter.player.RadioManager
import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.PluginRegistry.Registrar

class MainActivity : FlutterActivity() {

    lateinit var radioManager: RadioManager

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        MethodChannel(getFlutterView(), "flutter_radio").setMethodCallHandler(
                object : MethodCallHandler {
                    override fun onMethodCall(call: MethodCall, result: Result) {
                        when {
                            call.method.equals("audioStart") -> {
                                startPlayer()
                                result.success(null)
                            }
                            call.method.equals("play") -> {
                                val url: String? = call.argument("url")
                                if (url != null)
                                    radioManager.playOrPause(url)
                                result.success(null)
                            }
                            call.method.equals("pause") -> {
                                val url: String? = call.argument("url")
                                if (url != null)
                                    radioManager.playOrPause(url)
                                result.success(null)
                            }
                            call.method.equals("playOrPause") -> {
                                val url: String? = call.argument("url")
                                if (url != null)
                                    radioManager.playOrPause(url)
                                result.success(null)
                            }
                            call.method.equals("stop") -> {
                                radioManager.stop()
                                result.success(null)
                            }
                            call.method.equals("isPlaying") -> {
                                val play = isPlaying()
                                result.success(play)
                            }
                            else -> result.notImplemented()
                        }
                    }
                })
    }


    private fun startPlayer() {
        radioManager = RadioManager(this@MainActivity)
        radioManager.initPlayer()
    }

    private fun isPlaying(): Boolean {
        return radioManager.isPlaying()
    }
}
