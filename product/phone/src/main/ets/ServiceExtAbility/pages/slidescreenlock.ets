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
import Accounts from '../../../../../../../features/screenlock/src/main/ets/com/ohos/view/component/accounts.ets'
import DateTime from '../../../../../../../features/screenlock/src/main/ets/com/ohos/view/component/dateTime.ets'
import LockIcon from '../../../../../../../features/screenlock/src/main/ets/com/ohos/view/component/lockIcon.ets'
import Wallpaper from '../../../../../../../features/screenlock/src/main/ets/com/ohos/view/component/wallpaper.ets'
import NotificationListComponent from '../../../../../../../features/noticeitem/src/main/ets/com/ohos/noticeItem/view/NotificationListComponent.ets'
import StatusBar from '../../../../../../../features/screenlock/src/main/ets/com/ohos/view/component/statusBar.ets'
import Constants from '../common/constants.ets'
import ViewModel from '../vm/slideScreenLockViewModel.ets'

const TAG = 'ScreenLock-SlideScreenlock'

@Entry
@Component
export default struct SlideScreenlock {
  @State mViewModel: ViewModel = new ViewModel()

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear`)
    this.mViewModel.ViewModelInit()
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column() {
        Wallpaper()
      }
      .width(Constants.FULL_CONTAINER_WIDTH)
      .height(Constants.FULL_CONTAINER_HEIGHT)

      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
        Column() {
          StatusBar()
        }

        Column() {
          LockIcon()
        }.height(Constants.LOCKICON_AREA_WIDTH)

        Column() {
          DateTime()
        }.height(Constants.DATETIME_AREA_WIDTH)

        Column() {
          Stack({ alignContent: Alignment.TopStart }) {
            NotificationListComponent()
          }
        }
        .width(Constants.NOTIFICATION_AREA_WIDTH)
        //        .height(Constants.NOTIFICATION_AREA_HEIGHT)
      }
      .width(Constants.FULL_CONTAINER_WIDTH)
      .height(Constants.FULL_CONTAINER_HEIGHT)
      .onTouch((event) => {
        this.mViewModel.touchEvent(event)
      })
    }
  }
}