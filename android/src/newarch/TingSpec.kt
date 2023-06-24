package com.ting

import com.facebook.react.bridge.ReactApplicationContext

abstract class TingSpec internal constructor(context: ReactApplicationContext) :
  NativeTingSpec(context) {
}
