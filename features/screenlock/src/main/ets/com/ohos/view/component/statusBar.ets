/**
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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
import BatteryIcon from '../../../../../../../../../features/batterycomponent/src/main/ets/default/pages/batteryIcon.ets'

const TAG = 'ScreenLock-StatusBar'

@Component
export default struct statusBar {
  @StorageLink('minHeight') minHeight: number = 0

  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.End }) {
      BatteryIcon()
    }
    .width(Constants.FULL_CONTAINER_WIDTH)
    .height(this.minHeight)
  }

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear`)
  }

}