package com.example.my_friends_location

import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import com.yandex.mapkit.MapKitFactory
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity(){
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        //MapKitFactory.setLocale("RU") // Your preferred language. Not required, defaults to system language
        MapKitFactory.setApiKey("589bedca-d68b-4e5c-8f51-d2a750bf1987") // Your generated API key
        super.configureFlutterEngine(flutterEngine)
    }
}
