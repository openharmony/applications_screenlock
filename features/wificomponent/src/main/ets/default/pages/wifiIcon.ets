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

import Constants from '../common/constants'
import mWifiModel from '../wifiModel'
import Log from '../../../../../../../common/src/main/ets/default/Log'
import StyleConfigurationCommon from '../../../../../../../common/src/main/ets/default/StyleConfiguration'
import StyleConfiguration from '../common/StyleConfiguration'
import {StatusBarGroupComponentData
} from '../../../../../../screenlock/src/main/ets/com/ohos/common/constants'
import StatusBarVM from '../../../../../../screenlock/src/main/ets/com/ohos/vm/StatusBarVM'

const TAG = 'WifiComponent-WifiIcon'

@Component
export default struct WifiIcon {
  @StorageLink('wifiInfo') wifiInfo: number = Constants.DEFAULT_WIFI_INFO
  @StorageLink('wifiStatus') wifiStatus: boolean = Constants.DEFAULT_WIFI_STATUS
  private mGroupId: string = ''
  @State mStatusBarGroupComponentData: StatusBarGroupComponentData = new StatusBarGroupComponentData()
  @State statusBarMarginLeftRight: Resource = $r("app.float.signal_status_margin_Left_right")
  @State statusBarWifiWidth: Resource = $r('app.float.status_bar_wifi_width')
  @State statusBarWifiHeight: Resource = $r('app.float.status_bar_wifi_height')

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear`)
    this.mStatusBarGroupComponentData = StatusBarVM.getStatusBarGroupComponentData(this.mGroupId)
    mWifiModel.initWifiModel()
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisappear`)
  }

  build() {
    Row() {
      if (this.wifiStatus) {
        Row().width(this.statusBarMarginLeftRight).height('100%')
        Image(this.getImage(this.wifiInfo))
          .objectFit(ImageFit.Contain)
          .width(this.statusBarWifiWidth)
          .height(this.statusBarWifiHeight)
          .fillColor(this.mStatusBarGroupComponentData.contentColor)
        Row().width(this.statusBarMarginLeftRight).height('100%')
      }
    }
    .height('100%')
  }

  private getImage(wifiInfo: number) {
    Log.showInfo(TAG, `getImage, wifiInfo: ${JSON.stringify(wifiInfo)}`)
    let wifiImage;
    switch (wifiInfo) {
      case Constants.WIFI_SIGNAL_NO:
        wifiImage = $r('app.media.ic_statusbar_wifi_no');
        break;
      case Constants.WIFI_SIGNAL_LOW:
        wifiImage = $r('app.media.ic_statusbar_wifi_1');
        break;
      case Constants.WIFI_SIGNAL_MID:
        wifiImage = $r('app.media.ic_statusbar_wifi_2');
        break;
      case Constants.WIFI_SIGNAL_HIGH:
        wifiImage = $r('app.media.ic_statusbar_wifi_3');
        break;
      case Constants.WIFI_SIGNAL_FULL:
        wifiImage = $r('app.media.ic_statusbar_wifi_full');
        break;
      default:
        wifiImage = $r('app.media.ic_statusbar_wifi_no');
        break;
    }
    return wifiImage;
  }
}
