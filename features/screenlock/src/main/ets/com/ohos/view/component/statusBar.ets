/**
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

import Log from '../../../../../../../../../common/src/main/ets/default/Log'
import ViewModel from '../../vm/StatusBarVM'
import Constants from '../../common/constants'
import BatteryIcon from '../../../../../../../../../features/batterycomponent/src/main/ets/default/pages/batteryIcon.ets'
import ClockIcon from '../../../../../../../../../features/clockcomponent/src/main/ets/default/pages/clockIcon.ets'
import WifiIcon from '../../../../../../../../../features/wificomponent/src/main/ets/default/pages/wifiIcon.ets'
import SignalIcon from '../../../../../../../../../features/signalcomponent/src/main/ets/default/pages/signalIcon'

const TAG = 'ScreenLock-StatusBar'

@Component
export default struct statusBar {
  build() {
    Row(){
      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
        SignalIcon()
        WifiIcon()
      }.width(Constants.HALF_CONTAINER_WIDTH)
      .height(Constants.FULL_CONTAINER_HEIGHT)
      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.End }) {
        BatteryIcon()
        ClockIcon()
      }.width(Constants.HALF_CONTAINER_WIDTH)
      .height(Constants.FULL_CONTAINER_HEIGHT)
    }.width(Constants.FULL_CONTAINER_WIDTH)
    .height(Constants.FULL_CONTAINER_HEIGHT)
  }

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear`)
  }

}