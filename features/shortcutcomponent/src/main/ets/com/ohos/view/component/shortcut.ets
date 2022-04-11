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

import Log from '../../../../../../../../../common/src/main/ets/default/Log'
import Constants from '../../common/constants'
import ViewModel from '../../vm/shortcutViewModel'
import power from '@ohos.power'

const TAG = 'ScreenLock-Shortcut'

@Component
export default struct Shortcut {
  private viewModel: ViewModel = new ViewModel()
  private shutdownIcon: Resource = $r("app.media.shutdown")
  private shutdownLabel: Resource = $r("app.string.shutdown")
  private rebootIcon: Resource = $r("app.media.reboot")
  private rebootLabel: Resource = $r("app.string.reboot")

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear`)
  }

  build() {
    Row({ space: Constants.SHORTCUT_SPACE }) {
      ShortcutComponent({
        mTag: 'ScreenLock-Shutdown',
        mIcon: this.shutdownIcon,
        mLabel: this.shutdownLabel,
        mClickEvent: () => this.viewModel.onShortcutClick(Constants.CLICK_TYPE_SHUTDOWN)
      })

      ShortcutComponent({
        mTag: 'ScreenLock-Reboot',
        mIcon: this.rebootIcon,
        mLabel: this.rebootLabel,
        mClickEvent: () => this.viewModel.onShortcutClick(Constants.CLICK_TYPE_REBOOT)
      })
    }
    .margin({ left: '50px' })
  }
}

@Component
struct ShortcutComponent {
  private mTag: string
  private mIcon: Resource
  private mLabel: Resource
  private mClickEvent: Function

  aboutToAppear() {
    Log.showInfo(this.mTag, `aboutToAppear Start`)
  }

  aboutToDisappear() {
    Log.showInfo(this.mTag, `aboutToDisAppear`)
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
      Stack() {
        Flex()
          .backgroundColor($r('app.color.shortcut_icon_color'))
          .clip(new Circle({ width: Constants.SHORTCUT_CIRCLE_WIDTH, height: Constants.SHORTCUT_CIRCLE_HEIGHT }))
          .width(Constants.SHORTCUT_CIRCLE_WIDTH)
          .height(Constants.SHORTCUT_CIRCLE_HEIGHT)
        Image(this.mIcon)
          .size({ width: Constants.SHORTCUT_CIRCLE_WIDTH, height: Constants.SHORTCUT_CIRCLE_HEIGHT })
          .objectFit(ImageFit.Contain)
      }

      Text(this.mLabel)
        .fontSize(Constants.SHORTCUT_TEXT_SIZE)
        .fontColor($r('app.color.shortcut_text_color'))
        .margin({ top: $r("app.float.shortcut_block") })
    }
    .onClick(this.onItemClick.bind(this))
  }

  onItemClick(event: ClickEvent) {
    Log.showInfo(TAG, `onItemClick`)
    if (this.mClickEvent) {
      this.mClickEvent()
    }
  }
}


