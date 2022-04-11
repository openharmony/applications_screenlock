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
import ViewModel from '../../vm/dateTimeViewModel'
import Constants from '../../common/constants'
import {ScreenLockStatus} from '../../../../../../../../../common/src/main/ets/default/ScreenLockCommon'

const TAG = 'ScreenLock-DateTime'

@Component
export default struct DateTime {
  @State mViewModel: ViewModel = new ViewModel()
  @Prop isShowDate: boolean

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear`)
    this.mViewModel.ViewModelInit()
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisappear`)
    this.mViewModel.stopPolling()
  }

  build() {
    Column() {
      Text(this.mViewModel.timeVal)
        .fontSize($r('app.float.time_fontsize'))
        .fontColor($r('app.color.date_time_color'))
        .margin({ top: $r('app.float.time_top_margin'), bottom: $r('app.float.time_bottom_margin') })
      if (this.isShowDate) {
        Row() {
          Text($r('app.string.yyyy_mm_dd', this.mViewModel.dateVal.year, this.mViewModel.dateVal.month, this.mViewModel.dateVal.day))
            .fontSize($r('app.float.date_fontsize'))
            .fontColor($r('app.color.date_time_color'))
          Text(this.mViewModel.weekVal).fontSize($r('app.float.date_fontsize'))
            .fontColor($r('app.color.date_time_color'))
        }.height($r('app.float.date_week_area_height'))
      }
    }
    .width(Constants.FULL_CONTAINER_WIDTH)
  }
}