/**
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Log from '../../../../../../../../../common/src/main/ets/default/Log.ets'
import Constants from '../../common/constants.ets'
import power from '@ohos.power'

const TAG = 'ScreenLock-Shortcut'
const TAG_Shutdown = 'ScreenLock-Shutdown'
const TAG_Reboot = 'ScreenLock-Reboot'

@Component
export default struct Shortcut {
  private shutdownIcon: Resource = $r("app.media.shutdown")
  private shutdownLabel: Resource = $r("app.string.shutdown")
  private rebootIcon: Resource = $r("app.media.reboot")
  private rebootLabel: Resource = $r("app.string.reboot")

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear`)
  }

  build() {
    Row({ space:'30px' }) {
      ShortcutComponent({
        mIcon: this.shutdownIcon,
        mLabel: this.shutdownLabel,
        mClickEvent: () => this.onShutdownClick()
      })

      ShortcutComponent({
        mIcon: this.rebootIcon,
        mLabel: this.rebootLabel,
        mClickEvent: () => this.onRebootClick()
      })
    }
    .margin({left: '50px'})
  }

  onShutdownClick() {
    Log.showInfo(TAG, `onShutdownClick`)
    power.shutdownDevice("shutdown_device")
    Log.showInfo(TAG, `power shutdown success`)
  }

  onRebootClick() {
    Log.showInfo(TAG, `onRebootClick`)
    power.rebootDevice("reboot_device")
    Log.showInfo(TAG, `power reboot success`)
  }
}

@Component
struct ShortcutComponent {
  private mIcon: Resource
  private mLabel: Resource
  private mClickEvent: Function

  aboutToAppear() {
    Log.showInfo(TAG_Shutdown, `aboutToAppear Start`)
  }

  aboutToDisappear() {
    Log.showInfo(TAG_Shutdown, `aboutToDisAppear`)
  }

  build() {
    Column() {
      Stack() {
        Flex()
          .backgroundColor($r('app.color.shortcut_icon_color'))
          .clip(new Circle({ width: Constants.SHORTCUT_CIRCLE_WIDTH, height: Constants.SHORTCUT_CIRCLE_HEIGHT }))
          .width(Constants.SHORTCUT_CIRCLE_WIDTH)
          .height(Constants.SHORTCUT_CIRCLE_HEIGHT)
        Image(this.mIcon)
          .size({ width: Constants.SHORTCUT_CIRCLE_WIDTH, height: Constants.SHORTCUT_CIRCLE_HEIGHT})
          .objectFit(ImageFit.Contain)
      }

      Column()
        .width(Constants.SHORTCUT_CIRCLE_WIDTH)
        .height(Constants.SHORTCUT_BLOCK_HEIGHT)

      Text(this.mLabel)
        .fontSize(Constants.SHORTCUT_TEXT_SIZE)
        .fontColor($r('app.color.shortcut_text_color'))
        .width(Constants.SHORTCUT_TEXT_WIDTH)
        .height(Constants.SHORTCUT_TEXT_HEIGHT)
    }
    .width(Constants.SHORTCUT_CIRCLE_WIDTH)
    .onClick(this.onItemClick.bind(this))
  }

  onItemClick(event: ClickEvent) {
    Log.showInfo(TAG, `onItemClick`)
    if (this.mClickEvent) {
      this.mClickEvent()
    }
  }
}


