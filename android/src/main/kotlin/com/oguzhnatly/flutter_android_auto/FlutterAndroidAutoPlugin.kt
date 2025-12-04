package com.oguzhnatly.flutter_android_auto

import androidx.car.app.CarContext
import androidx.car.app.model.Action
import androidx.car.app.model.CarIcon
import androidx.car.app.model.CarText
import androidx.car.app.model.GridItem
import androidx.car.app.model.ActionStrip
import androidx.car.app.model.GridTemplate
import androidx.car.app.model.ItemList
import androidx.car.app.model.ListTemplate
import androidx.car.app.model.SectionedItemList
import androidx.car.app.model.Row
import androidx.car.app.model.Template
import androidx.car.app.Screen
import androidx.car.app.ScreenManager
import com.oguzhnatly.flutter_android_auto.models.FAAHeaderAction
import com.oguzhnatly.flutter_android_auto.models.FAAHeaderActionType
import com.oguzhnatly.flutter_android_auto.models.grid.FAAGridItem
import com.oguzhnatly.flutter_android_auto.models.grid.FAAGridTemplate
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleEventObserver
import androidx.lifecycle.LifecycleOwner


class FlutterAndroidAutoPlugin : FlutterPlugin, EventChannel.StreamHandler {
    private val pluginScope = CoroutineScope(SupervisorJob() + Dispatchers.Main)

    lateinit var channel: MethodChannel
    lateinit var eventChannel: EventChannel

    companion object {
        var events: EventChannel.EventSink? = null
        var currentTemplate: Template? = null
        var currentScreen: Screen? = null

        fun sendEvent(type: String, data: Map<String, Any>) {
            events?.success(
                mapOf(
                    "type" to type, "data" to data
                )
            )
        }

        fun onAndroidAutoConnectionChange(status: FAAConnectionTypes) {
            sendEvent(
                type = FAAChannelTypes.onAndroidAutoConnectionChange.name,
                data = mapOf("status" to status.name)
            )
        }
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        FAAHelpers.flutterPluginBinding = flutterPluginBinding
        channel = MethodChannel(
            flutterPluginBinding.binaryMessenger,
            FAAHelpers.makeFCPChannelId("")
        )
        eventChannel = EventChannel(
            flutterPluginBinding.binaryMessenger,
            FAAHelpers.makeFCPChannelId("/event")
        )
        setUpHandlers()
    }

    private fun setUpHandlers() {
        channel.setMethodCallHandler { call, result ->
            try {
                when (call.method) {
                    FAAChannelTypes.forceUpdateRootTemplate.name -> forceUpdateRootTemplate(
                        call, result
                    )

                    FAAChannelTypes.setRootTemplate.name -> setRootTemplate(
                        call, result
                    )

                    FAAChannelTypes.pushTemplate.name -> pushTemplate(
                        call, result
                    )

                    FAAChannelTypes.popTemplate.name -> popTemplate(
                        call, result

                    )

                    FAAChannelTypes.popToRootTemplate.name -> popToRootTemplate(
                        call, result
                    )

                    FAAChannelTypes.onListItemSelectedComplete.name
                        -> onListItemSelectedComplete(
                        call, result
                    )

                    FAAChannelTypes.onGridItemSelectedComplete.name
                        -> onGridItemSelectedComplete(
                        call, result
                    )

                    else -> result.notImplemented()
                }
            } catch (e: Exception) {
                e.printStackTrace()
                result.error("Error: $e", null, null)
            }
        }
        eventChannel.setStreamHandler(this)
    }

    private fun forceUpdateRootTemplate(
        call: MethodCall, result: MethodChannel.Result
    ) {
        val carContext = AndroidAutoService.session?.carContext
        if (carContext == null) return;

        currentScreen?.let {
            it.invalidate()
            result.success(true)
        } ?: run {
            result.error(
                "No screen found", "You must set a RootTemplate first", null
            )
        }
    }

    private fun popTemplate(
        call: MethodCall, result: MethodChannel.Result
    ) {
        val carContext = AndroidAutoService.session?.carContext
        if (carContext == null) return;

        val screenManager = carContext.getCarService(ScreenManager::class.java)
        if (screenManager.stackSize > 1) {
            screenManager.pop()
            result.success(true)
        } else {
            result.error("No screens to pop", "You are at root screen", null)
        }
    }

    private fun popToRootTemplate(
        call: MethodCall, result: MethodChannel.Result
    ) {
        val carContext = AndroidAutoService.session?.carContext
        if (carContext == null) return;

        val screenManager = carContext.getCarService(ScreenManager::class.java)
        if (screenManager.stackSize > 1) {
            screenManager.popToRoot()
            result.success(true)
        } else {
            result.error("No screens to pop", "You are at root screen", null)
        }
    }


    private fun onListItemSelectedComplete(
        call: MethodCall, result: MethodChannel.Result
    ) {
        result.success(true)
    }

    private fun onGridItemSelectedComplete(
        call: MethodCall, result: MethodChannel.Result
    ) {
        result.success(true)
    }

    private fun pushTemplate(
        call: MethodCall, result: MethodChannel.Result
    ) {
        val carContext = AndroidAutoService.session?.carContext
        if (carContext == null) return;

        val runtimeType = call.argument<String>("runtimeType") ?: ""
        val data = call.argument<Map<String, Any?>>("template")!!
        val elementId = data["_elementId"] as? String ?: ""

        pluginScope.launch {
            val template = when (runtimeType) {
                "FAAListTemplate" -> getListTemplate(
                    call, result, data
                )

                "FAAGridTemplate" -> getGridTemplate(
                    call, result, data
                )

                else -> null
            }
            if (template == null) {
                result.error(
                    "Unsupported template type",
                    "Template type: $runtimeType is not supported",
                    null
                )
            } else {
                val newScreen = object : Screen(carContext) {
                    override fun onGetTemplate(): Template = template

                    init {
                        lifecycle.addObserver(object : LifecycleEventObserver {
                            override fun onStateChanged(
                                source: LifecycleOwner, event: Lifecycle.Event
                            ) {
                                when (event) {
                                    Lifecycle.Event.ON_DESTROY -> {
                                        sendEvent(
                                            type = FAAChannelTypes.onScreenBackButtonPressed.name,
                                            data = mapOf("elementId" to elementId)
                                        )
                                    }

                                    else -> {}
                                }
                            }
                        })
                    }
                }

                carContext.getCarService(ScreenManager::class.java)
                    .push(newScreen)

                result.success(true)
            }
        }
    }

    private fun setRootTemplate(
        call: MethodCall, result: MethodChannel.Result
    ) {
        val runtimeType = call.argument<String>("runtimeType") ?: ""
        val data = call.argument<Map<String, Any?>>("template")!!

        pluginScope.launch {
            val template = when (runtimeType) {
                "FAAListTemplate" -> getListTemplate(
                    call, result, data, false
                )

                "FAAGridTemplate" -> getGridTemplate(
                    call, result, data, false
                )

                else -> null
            }

            if (template == null) {
                result.error(
                    "Unsupported template type",
                    "Template type: $runtimeType is not supported",
                    null,
                )
            } else {
                currentTemplate = template
                currentScreen?.invalidate()
                result.success(true)
            }
        }
    }

    private suspend fun getListTemplate(
        call: MethodCall,
        result: MethodChannel.Result,
        data: Map<String, Any?>,
        addBackButton: Boolean = true
    ): Template {
        val template = FAAListTemplate.fromJson(data)
        val listTemplateBuilder =
            ListTemplate.Builder().setTitle(template.title)

        if (template.sections.size == 0) {
            listTemplateBuilder.setLoading(true)
        } else {
            listTemplateBuilder.setLoading(false)
            val isSingleList =
                template.sections.size == 1 && template.sections.first().title.isEmpty()

            if (isSingleList) {
                val itemListBuilder = ItemList.Builder()
                val sectionItems = template.sections.first().items
                for (item in sectionItems) {
                    itemListBuilder.addItem(createRowFromItem(item))
                }
                listTemplateBuilder.setSingleList(itemListBuilder.build())
            } else {
                for (section in template.sections) {
                    val itemListBuilder = ItemList.Builder()
                    for (item in section.items) {
                        itemListBuilder.addItem(createRowFromItem(item))
                    }
                    val sectionedItemList = SectionedItemList.create(
                        itemListBuilder.build(), section.title ?: ""
                    )
                    listTemplateBuilder.addSectionedList(sectionedItemList)
                }
            }
        }

        if (addBackButton) {
            listTemplateBuilder.setHeaderAction(Action.BACK)
        }

        return listTemplateBuilder.build()
    }

    // Helper function to create a Row from an FAAListItem, avoiding code duplication
    private suspend fun createRowFromItem(item: FAAListItem): Row {
        val rowBuilder = Row.Builder().setTitle(CarText.create(item.title))

        item.subtitle?.let { rowBuilder.addText(CarText.create(it)) }

        item.imageUrl?.let {
            loadCarImageAsync(it)?.let { carIcon ->
                rowBuilder.setImage(carIcon, Row.IMAGE_TYPE_LARGE)
            }
        }

        if (item.isOnPressListenerActive) {
            rowBuilder.setOnClickListener {
                sendEvent(
                    type = FAAChannelTypes.onListItemSelected.name,
                    data = mapOf("elementId" to item.elementId)
                )
            }
        }
        return rowBuilder.build()
    }

    /**
     * Creates an Android Auto GridTemplate from the Dart AAGridTemplate data.
     *
     * According to Android Auto docs:
     * - Grid items are displayed in a grid layout
     * - Minimum 6 items can be shown (varies by vehicle)
     * - Each item can have an image, title, and optional text
     * - Images default to IMAGE_TYPE_LARGE (can also use IMAGE_TYPE_ICON)
     */
    private suspend fun getGridTemplate(
        call: MethodCall,
        result: MethodChannel.Result,
        data: Map<String, Any?>,
        addBackButton: Boolean = true
    ): Template {
        val template = FAAGridTemplate.fromJson(data)
        val gridTemplateBuilder = GridTemplate.Builder()

        // Set title if provided
        if (template.title.isNotEmpty()) {
            gridTemplateBuilder.setTitle(template.title)
        }

        if (template.items.isEmpty()) {
            gridTemplateBuilder.setLoading(true)
        } else {
            gridTemplateBuilder.setLoading(false)
            val itemListBuilder = ItemList.Builder()

            for (item in template.items) {
                itemListBuilder.addItem(createGridItem(item))
            }

            gridTemplateBuilder.setSingleList(itemListBuilder.build())
        }

        // Handle header action - use template's headerAction or fall back to addBackButton parameter
        val headerAction = template.headerAction
        if (headerAction != null) {
            when (headerAction.type) {
                FAAHeaderActionType.back -> {
                    gridTemplateBuilder.setHeaderAction(Action.BACK)
                }
                FAAHeaderActionType.custom -> {
                    // Custom actions with titles must use ActionStrip, not setHeaderAction
                    // setHeaderAction only allows system actions (BACK, APP_ICON) without custom titles
                    val customActionBuilder = Action.Builder()
                    headerAction.title?.let { customActionBuilder.setTitle(it) }
                    customActionBuilder.setOnClickListener {
                        sendEvent(
                            type = FAAChannelTypes.onHeaderActionPressed.name,
                            data = mapOf("elementId" to headerAction.elementId)
                        )
                    }
                    val actionStrip = ActionStrip.Builder()
                        .addAction(customActionBuilder.build())
                        .build()
                    gridTemplateBuilder.setActionStrip(actionStrip)
                }
            }
        } else if (addBackButton) {
            gridTemplateBuilder.setHeaderAction(Action.BACK)
        }

        return gridTemplateBuilder.build()
    }

    /**
     * Creates an Android Auto GridItem from an FAAGridItem.
     *
     * According to Android Auto docs:
     * - GridItem requires an image (not optional for grid items)
     * - IMAGE_TYPE_LARGE: Images scaled to fit 64x64 dp bounding box
     * - IMAGE_TYPE_ICON: Icons scaled to fit 64x64 dp bounding box
     * - Text is optional secondary content
     * - Cannot set loading state and image at the same time
     */
    private suspend fun createGridItem(item: FAAGridItem): GridItem {
        val gridItemBuilder = GridItem.Builder()

        // Set title
        gridItemBuilder.setTitle(CarText.create(item.title))

        // Set optional text (secondary line)
        item.text?.let {
            gridItemBuilder.setText(CarText.create(it))
        }

        // Set loading state or image (cannot have both)
        if (item.isLoading) {
            gridItemBuilder.setLoading(true)
        } else {
            // Determine image path - use fallback immediately if no valid image provided
            val imagePath = if (!item.image.isNullOrEmpty()) item.image else "assets/question_mark.png"

            // Load the image (either provided or fallback)
            val carIcon = loadCarImageAsync(imagePath)

            // GridItem requires an image - set it
            if (carIcon != null) {
                gridItemBuilder.setImage(carIcon, GridItem.IMAGE_TYPE_LARGE)
            } else {
                // Fallback failed too - use the fallback asset as last resort
                loadCarImageAsync("assets/question_mark.png")?.let {
                    gridItemBuilder.setImage(it, GridItem.IMAGE_TYPE_LARGE)
                }
            }
        }

        // Set click listener if enabled (cannot set click listener when loading)
        if (item.isOnPressListenerActive && item.isEnabled && !item.isLoading) {
            gridItemBuilder.setOnClickListener {
                sendEvent(
                    type = FAAChannelTypes.onGridItemSelected.name,
                    data = mapOf("elementId" to item.elementId)
                )
            }
        }

        return gridItemBuilder.build()
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        FlutterAndroidAutoPlugin.events = events
    }

    override fun onCancel(arguments: Any?) {
        events?.endOfStream()
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
        FAAHelpers.flutterPluginBinding = null
    }
}
