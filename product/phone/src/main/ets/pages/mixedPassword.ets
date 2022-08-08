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

import Trace from '../../../../../../common/src/main/ets/default/Trace'
import Log from '../../../../../../common/src/main/ets/default/Log'
import CommonStyleManager from '../../../../../../common/src/main/ets/default/StyleManager'
import AbilityManager from '../../../../../../common/src/main/ets/default/abilitymanager/abilityManager'
import StatusBar from '../../../../../../features/screenlock/src/main/ets/com/ohos/view/component/statusBar'
import MixedPSD from '../../../../../../features/screenlock/src/main/ets/com/ohos/view/component/mixedPSD'
import Constants from '../common/constants'
import StyleManager from '../common/StyleManager'

const TAG = 'ScreenLock-MixedPassword'

@Entry
@Component
export default struct MixedPassword {
  @State mHeightPx: number = 48

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear`)
    CommonStyleManager.setAbilityPageName(TAG)
    let configInfo = AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_STATUS_BAR, 'rect')
    Log.showDebug(TAG, `configMaxWidth${JSON.stringify(configInfo.height)}`)
    this.mHeightPx = configInfo.height
    StyleManager.setStyle()
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisappear`)
  }

  onPageShow() {
    Log.showInfo(TAG, `onPageShow`)
  }

  onPageHide() {
    Trace.end(Trace.CORE_METHOD_HIDE_PSD_PAGE);
    Trace.end(Trace.CORE_METHOD_UNLOCK_SCREEN);
    Log.showInfo(TAG, `onPageHide`)
  }

  build() {
    Stack(){
      Image($r("app.media.bg"))
        .width(Constants.FULL_CONTAINER_WIDTH)
        .height(Constants.FULL_CONTAINER_HEIGHT)
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
        Column() {
          StatusBar()
        }
        .height(this.mHeightPx + 'px' )

        Column() {
          MixedPSD()
        }
        .width(Constants.PASSWORD_AREA_WIDTH)
      }
      .width(Constants.FULL_CONTAINER_WIDTH)
      .height(Constants.FULL_CONTAINER_HEIGHT)
    }
    .backgroundColor($r('app.color.page_background'))
  }
}