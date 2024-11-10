package com.ting

import android.content.Context
import android.content.res.Resources
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Color
import android.graphics.PorterDuff
import android.graphics.PorterDuffColorFilter
import android.graphics.drawable.AnimatedVectorDrawable
import android.graphics.drawable.GradientDrawable
import android.os.Handler
import android.os.Looper
import android.view.GestureDetector
import android.view.Gravity
import android.view.LayoutInflater
import android.view.MotionEvent
import android.view.View
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.ProgressBar
import android.widget.TextView
import com.facebook.react.bridge.Arguments.createMap
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.UiThreadUtil.runOnUiThread
import com.facebook.react.bridge.WritableMap
import com.hjq.window.EasyWindow
import java.io.IOException
import java.net.URL
import kotlin.math.abs
import kotlin.math.roundToInt


class TingModule internal constructor(context: ReactApplicationContext) : TingSpec(context) {

  private var context: Context = context
  private val alertWindow = EasyWindow<EasyWindow<*>>(currentActivity)
  private val toastWindow = EasyWindow<EasyWindow<*>>(currentActivity)
  private var toastOptionInit: ReadableMap? = null
  private var alertOptionInit: ReadableMap? = null

  @ReactMethod
  override fun toast(rnOptions: ReadableMap) {
    // get container View
    val options = toastOptionInit?.let { mergeMaps(it, rnOptions) } ?: rnOptions

    val container = getContainerView(R.layout.toast, options, "toast")
    val duration: Int = getDuration(options)

    var toastAnim = R.style.ToastTopAnim
    val position: Int = when (options?.getString("position")) {
      "bottom" -> {
        toastAnim = R.style.ToastBottomAnim
        Gravity.BOTTOM
      }

      else -> {
        Gravity.TOP
      }
    }

    runOnUiThread {
      toastWindow.cancel()
      toastWindow.apply {
        setDuration(duration)
        contentView = container
        setGravity(position)
        setYOffset(48)
        setAnimStyle(toastAnim)
        setOutsideTouchable(true)

        if (options.hasKey("shouldDismissByDrag") && options.getBoolean("shouldDismissByDrag")) {
          // Define dragThreshold in density-independent pixels (dp)
          val dragThresholdDP = 12
          val scale = context.resources.displayMetrics.density
          val dragThreshold = (dragThresholdDP * scale + 0.5f).toInt()

          // Add drag gesture recognizer
          contentView?.let { contentView ->
            val gestureDetector = GestureDetector(context, object : GestureDetector.SimpleOnGestureListener() {
              override fun onScroll(e1: MotionEvent?, e2: MotionEvent, distanceX: Float, distanceY: Float): Boolean {
                // Check if the user scrolls vertically and dismiss the toast window if needed
                if (abs(distanceY) > abs(distanceX)) {
                  if (position == Gravity.TOP && distanceY > dragThreshold) { // Dismiss upward if toast is at the top
                    toastWindow.cancel()
                    return true
                  } else if (position == Gravity.BOTTOM && distanceY < -dragThreshold) { // Dismiss downward if toast is at the bottom
                    toastWindow.cancel()
                    return true
                  }
                }

                return super.onScroll(e1, e2, distanceX, distanceY)
              }
            })

            contentView.setOnTouchListener(fun(_: View, event: MotionEvent): Boolean {
              gestureDetector.onTouchEvent(event)
              return true // Consume the touch event
            })
          }
        }

      }.show()
    }
  }

  @ReactMethod
  override fun alert(rnOptions: ReadableMap) {
    val options = alertOptionInit?.let { mergeMaps(it, rnOptions) } ?: rnOptions

    val container = getContainerView(R.layout.alert, options, "alert")
    val duration: Int = getDuration(options)
    val blurBackdrop: Int =
      if (options.hasKey("blurBackdrop")) options.getInt("blurBackdrop") else 0

    var backdropOpacity: Double =
      if (options.hasKey("backdropOpacity")) options.getDouble("backdropOpacity") else 0.0

    if (backdropOpacity < 0) backdropOpacity = 0.0
    else if (backdropOpacity > 1) backdropOpacity = 1.0

    runOnUiThread {
      alertWindow.cancel()
      alertWindow.apply {
        setDuration(duration)
        contentView = container
        setAnimStyle(R.style.AlertAnim)
        setOutsideTouchable(true)
        setGravity(Gravity.CENTER)
        setBlurBehindRadius(blurBackdrop)
        setBackgroundDimAmount(backdropOpacity.toFloat())
        setOnClickListener(R.id.alert,
          EasyWindow.OnClickListener { alert: EasyWindow<*>, _: LinearLayout? ->
            val shouldDismissByTap =
              if (options.hasKey("shouldDismissByTap")) options.getBoolean("shouldDismissByTap") else true
            if (shouldDismissByTap) alert.cancel()
          })

      }.show()
    }
  }

  @ReactMethod
  override fun dismissAlert() {
    if (alertWindow.isShowing) {
      runOnUiThread {
        alertWindow.cancel()
      }
    }
  }

  @ReactMethod
  override fun setup(options: ReadableMap) {
    val toastOption = options.getMap("toast")
    val alertOption = options.getMap("alert")
    if (toastOption != null) toastOptionInit = toastOption
    if (alertOption != null) alertOptionInit = alertOption

  }

  private fun getDuration(options: ReadableMap): Int {
    return if (options.hasKey("duration")) (options.getDouble("duration") * 1000).toInt() else 3000
  }

  private fun getContainerView(
    view: Int,
    options: ReadableMap,
    contentType: String?
  ): LinearLayout {
    val inflater = LayoutInflater.from(context)
    val container = inflater.inflate(
      view, null
    ) as LinearLayout

    val title = options?.getString("title")
    val titleColor = options?.getString("titleColor")
    val message = options?.getString("message")
    val messageColor = options?.getString("messageColor")
    val progressColor = options?.getString("progressColor")
    val preset = options?.getString("preset")
    val backgroundColor = options?.getString("backgroundColor")
    val borderRadius = if (options.hasKey("borderRadius")) options?.getInt("borderRadius") else null

    // init view
    val messageView: TextView = container.findViewById(R.id.message)
    val titleView: TextView = container.findViewById(R.id.title)
    val iconView: ImageView = container.findViewById(R.id.icon)

    // icon options
    val icon = options?.getMap("icon")
    val iconURI = icon?.getString("uri")

    // set container style
    val background = container.background as GradientDrawable

    if (isNumber(borderRadius)) {
      background.cornerRadius = convertInt2Size(borderRadius).toFloat()
      intArrayOf(Color.BLUE)
    }

    if (backgroundColor != null) {
      val color = intArrayOf(parseColor(backgroundColor), parseColor(backgroundColor))
      background.colors = color
    } else {
      val color = intArrayOf(Color.WHITE, Color.WHITE)
      background.colors = color
    }

    // set title
    titleView.text = title
    if (titleColor != null) titleView.setTextColor(parseColor(titleColor))

    // check message
    if (message == null) {
      messageView.visibility = TextView.GONE
    } else {
      messageView.text = message
    }

    if (messageColor != null) messageView.setTextColor(parseColor(messageColor))

    // Icon by preset
    if (iconURI == null) {
      when (preset) {
        "done" -> {
          loadDoneIcon(iconView)
        }

        "error" -> {
          iconView.setImageResource(R.drawable.error)
        }

        "spinner" -> {
          val progressBar = ProgressBar(context)
          val progressSize: LinearLayout.LayoutParams =
            if (contentType == "toast") LinearLayout.LayoutParams(
              convertInt2Size(24),
              convertInt2Size(24)
            ) else LinearLayout.LayoutParams(
              LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT
            )

          iconView.visibility = ImageView.GONE
          progressBar.id = R.id.loading_spinner
          progressBar.layoutParams = progressSize

          if (progressColor != null) {
            val progressDrawable = progressBar.indeterminateDrawable.mutate()
            progressDrawable.colorFilter = PorterDuffColorFilter(parseColor(progressColor), PorterDuff.Mode.SRC_IN)
            progressBar.indeterminateDrawable = progressDrawable
          }

          container.addView(progressBar, 0)
        }

        "none" -> {
          iconView.visibility = ImageView.GONE
        }

        else -> {
          loadDoneIcon(iconView)
        }
      }
    } else {
      val bitmap = loadBitmapFromUri(iconURI)
      if (bitmap != null) {
        iconView.setImageBitmap(bitmap)
        val iconSize = if (icon?.hasKey("size") == true) icon.getInt("size") else null
        val tintColor = if (icon?.hasKey("tintColor") == true) icon.getString("tintColor") else null

        if (isNumber(iconSize)) {
          val size = convertInt2Size(iconSize)

          iconView.layoutParams.width = size
          iconView.layoutParams.height = size
        }
        if (tintColor != null) {
          val color = parseColor(tintColor)
          iconView.setColorFilter(color, PorterDuff.Mode.SRC_IN)
        }
      } else {
        loadDoneIcon(iconView)
      }
    }

    return container
  }

  override fun getName(): String {
    return NAME
  }

  companion object {
    const val NAME = "Ting"
  }

  private fun loadDoneIcon(iconView: ImageView) {
    iconView.setImageResource(R.drawable.done)
    val avd = iconView.drawable as AnimatedVectorDrawable
    val handler = Handler(Looper.getMainLooper())
    handler.postDelayed({
      avd.start()
    }, 300)
  }
}

fun isNumber(value: Any?): Boolean {
  return value != null && (value is Int || value is Long || value is Float || value is Double)
}

fun parseColor(colorString: String): Int {
  val fallbackColor = Color.BLACK
  // Try parsing color as hex
  if (colorString.startsWith("#")) {
    return Color.parseColor(colorString)
  }

  // Try parsing color as named color
  val namedColor = try {
    Color::class.java.getField(colorString.uppercase()).get(null) as Int
  } catch (e: Exception) {
    null
  }
  if (namedColor != null) {
    return namedColor
  }

  // Try parsing color as RGB or RGBA
  val rgbRegex = Regex("""rgba?\((\d{1,3}), (\d{1,3}), (\d{1,3})(, (\d(\.\d)?))?\)""")
  val rgbMatchResult = rgbRegex.matchEntire(colorString)
  if (rgbMatchResult != null) {
    val red = rgbMatchResult.groups[1]?.value?.toIntOrNull() ?: return fallbackColor
    val green = rgbMatchResult.groups[2]?.value?.toIntOrNull() ?: return fallbackColor
    val blue = rgbMatchResult.groups[3]?.value?.toIntOrNull() ?: return fallbackColor
    val alpha = if (colorString.startsWith("rgb(")) 1.0f else rgbMatchResult.groups[5]?.value?.toFloatOrNull() ?: 1.0f
    return Color.argb((alpha * 255).toInt(), red, green, blue)
  }

  // Return fallback color if parsing fails
  return fallbackColor
}

fun convertInt2Size(number: Int?): Int {
  return (number!! * Resources.getSystem().displayMetrics.density).roundToInt()
}

fun loadBitmapFromUri(imageUri: String): Bitmap? {
  var bitmap: Bitmap? = null
  try {
    val url = URL(imageUri)
    val connection = url.openConnection()
    connection.connect()
    val inputStream = connection.getInputStream()
    bitmap = BitmapFactory.decodeStream(inputStream)
    inputStream.close()
  } catch (e: IOException) {
    e.printStackTrace()
  }
  return bitmap
}

fun mergeMaps(map1: ReadableMap, map2: ReadableMap): WritableMap {
  val mergedMap: WritableMap = createMap()
  mergedMap.merge(map1)
  mergedMap.merge(map2)
  return mergedMap
}
