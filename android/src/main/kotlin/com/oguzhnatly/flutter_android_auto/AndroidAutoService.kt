package com.oguzhnatly.flutter_android_auto

import androidx.car.app.CarAppService
import androidx.car.app.validation.HostValidator
import androidx.car.app.Session
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.embedding.engine.FlutterEngineCache;

class AndroidAutoService : CarAppService() {
    companion object {
        /// The Android Auto session that this service is handling.
        var session: AndroidAutoSession? = null
    }

    /// Guarantees the cached engine is alive, replacing any stale entry left
    /// behind by a destroyed engine (an activity-owned engine is destroyed with
    /// the activity, but FlutterEngineCache keeps the dead reference).
    private fun ensureEngine() {
        val engineCache = FlutterEngineCache.getInstance()
        val flutterEngineId = FAAConstants.flutterEngineId

        val cached = engineCache.get(flutterEngineId)
        if (cached != null && cached.dartExecutor.isExecutingDart) return
        if (cached != null) engineCache.remove(flutterEngineId)

        // Create new engine in headless mode
        val flutterEngine = FlutterEngine(this)
        flutterEngine.addEngineLifecycleListener(object : FlutterEngine.EngineLifecycleListener {
            override fun onPreEngineRestart() {}
            override fun onEngineWillDestroy() {
                // Identity check: only evict our own entry, in case it was replaced.
                if (engineCache.get(flutterEngineId) === flutterEngine) {
                    engineCache.remove(flutterEngineId)
                }
            }
        })
        flutterEngine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        )
        // Cache the engine
        engineCache.put(flutterEngineId, flutterEngine)
    }

    override fun onCreate() {
        super.onCreate()
        ensureEngine()
    }

    override fun createHostValidator() = HostValidator.ALLOW_ALL_HOSTS_VALIDATOR

    override fun onCreateSession(): Session {
        // The engine may have died between service creation and this session
        // (e.g. the user swiped the app away and Android Auto reconnected
        // without recreating the service).
        ensureEngine()
        session = AndroidAutoSession()
        return session!!
    }
}
