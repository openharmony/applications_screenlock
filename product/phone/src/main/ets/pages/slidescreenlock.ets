/*
 * Copyright (c) 2021-2022 Huawei Device Co., Ltd.
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

import Log from '../../../../../../common/src/main/ets/default/Log'
import Accounts from '../../../../../../features/screenlock/src/main/ets/com/ohos/view/component/accounts'
import {UserData} from '../../../../../../features/screenlock/src/main/ets/com/ohos/data/userData'
import DateTime from '../../../../../../features/datetimecomponent/src/main/ets/com/ohos/view/component/dateTime'
import LockIcon from '../../../../../../features/screenlock/src/main/ets/com/ohos/view/component/lockIcon'
import Wallpaper from '../../../../../../features/wallpapercomponent/src/main/ets/com/ohos/view/component/wallpaper'
import NotificationListComponent from '../../../../../../features/noticeitem/src/main/ets/com/ohos/noticeItem/view/NotificationListComponent'
import StatusBar from '../../../../../../features/screenlock/src/main/ets/com/ohos/view/component/statusBar'
import Constants from '../common/constants'
import ViewModel from '../vm/slideScreenLockViewModel'

const TAG = 'ScreenLock-SlideScreenlock'

@Component
export default struct SlideScreenlock {
  @State mViewModel: ViewModel = new ViewModel()
  @StorageLink('batteryCharging') @Watch('onCharging') batteryCharging: boolean = false
  @Prop @Watch("onStatusChange") pageStatus: number
  @StorageLink('deviceStatus') @Watch('onDeviceStatusChange') deviceStatus: string = ""
  @StorageLink('isWallpaperShow') isWallpaperShow: boolean = true
  private mHeightPx : number = 48
  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear`)
    this.mViewModel.ViewModelInit()
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisAppear`)
  }

  onPageShow() {
    Log.showInfo(TAG, `onPageShow`)
  }

  onPageHide() {
    Log.showInfo(TAG, `onPageHide`)
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column() {
        Wallpaper()
      }
      .backgroundColor($r('app.color.screenlock_backgroundcolor'))
      .width(Constants.FULL_CONTAINER_WIDTH)
      .height(Constants.FULL_CONTAINER_HEIGHT)
      .scale({
        x: this.mViewModel.backgroundScale,
        y: this.mViewModel.backgroundScale
      })
      .animation({
        duration: this.mViewModel.duration, // animation duration
        curve: Curve.Linear, // animation curve
        delay: 0, // animation delay
        iterations: 1, // times of play
        playMode: PlayMode.Normal // animation mode
      })

      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
        Column() {
          StatusBar()
        }
        .height(this.mHeightPx + 'px' )
        .onAreaChange((e, e2) => {
          Log.showDebug(TAG, `onAreaChange, e: ${JSON.stringify(e)} e2: ${JSON.stringify(e2)}`);
        })
    }

      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
        Column() {
        }
        .height(0)

        Column() {
          Row() {
            Blank()
            Accounts()
          }
          .width(Constants.NOTIFICATION_AREA_WIDTH)
          .height($r("app.float.accounts_area_height"))
        }
        .margin({ top: $r("app.float.accounts_area_margin_top") })

        Column() {
          LockIcon()
        }.height(Constants.P_LOCKICON_AREA_WIDTH)

        Column() {
          DateTime({ isShowDate: true })
        }.height(Constants.P_DATETIME_AREA_WIDTH)
        .margin({ top: $r("app.float.DateTime_margin_top"), bottom: $r("app.float.DateTime_margin_bottom") })

        Column() {
          NotificationListComponent()
        }
        .alignItems(HorizontalAlign.Center)
        .width(Constants.NOTIFICATION_AREA_WIDTH)
      }
      .width(Constants.FULL_CONTAINER_WIDTH)
      .height(Constants.FULL_CONTAINER_HEIGHT)
      .opacity(this.mViewModel.elementAlpha)
      .scale({
        x: this.mViewModel.elementScale,
        y: this.mViewModel.elementScale
      })
      .animation({
        duration: this.mViewModel.duration, // animation duration
        curve: Curve.Linear, // animation curve
        delay: 0, // animation delay
        iterations: 1, // times of play
        playMode: PlayMode.Normal // animation mode
      })
      .onTouch((event) => {
        this.mViewModel.touchEvent(event)
      })
    }
  }

  onCharging(propName: string): void {
    Log.showInfo(TAG, `onCharging ${this.batteryCharging}`)
    this.mViewModel.toggleDisplay(this.batteryCharging);
  }

  onStatusChange(propName: string): void {
    Log.showInfo(TAG, `onStatusChange ${this.pageStatus}`)
    switch (this.pageStatus) {
      case Constants.STATUS_ON_PAGE_SHOW:
        this.mViewModel.onPageShow();
        break;
      default:
    }
  }

  onDeviceStatusChange(propName: string): void{
    Log.showInfo(TAG, `onDeviceStatusChange ${this.deviceStatus}`)
    if (this.deviceStatus == "endScreenOn") {
      if (this.batteryCharging) {
        this.mViewModel.toggleDisplay();
      }
    }
  }
}