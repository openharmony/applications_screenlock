/*
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

import Log from '../../../../../../../common/src/main/ets/default/Log.ets'
import StatusBar from '../../../../../../../features/screenlock/src/main/ets/com/ohos/view/component/statusBar.ets'
import DigitalPSD from '../../../../../../../features/screenlock/src/main/ets/com/ohos/view/component/digitalPSD.ets'
import Constants from '../common/constants.ets'

const TAG = 'ScreenLock-DigitalPassword'

@Entry
@Component
export default struct DigitalPassword {
  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear`)
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisappear`)
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Column() {
        StatusBar()
      }
      Column() {
        DigitalPSD()
      }
      .width(Constants.PASSWORD_AREA_WIDTH)
    }
    .width(Constants.FULL_CONTAINER_WIDTH)
    .height(Constants.FULL_CONTAINER_HEIGHT)
    .backgroundColor($r('app.color.page_background'))
  }
}