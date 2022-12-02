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
import { ScreenLockStatus } from '../../../../../../../../../common/src/main/ets/default/ScreenLockCommon'
import deviceInfo from '@ohos.deviceInfo';
import i18n from '@ohos.i18n';

const DEVICETYPE = deviceInfo.deviceType;
const DEFAULTLANG: string = "zh-Hans";
const TAG = 'ScreenLock-DateTime';


@Component
export default struct DateTime {
  @State mViewModel: ViewModel = new ViewModel()
  @State isShowDate: boolean = true
  @State isPhone: boolean = false
  @State currentLanguage: string = DEFAULTLANG

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear`)
    this.mViewModel.ViewModelInit()
    this.currentLanguage = i18n.getSystemLanguage()
    if (DEVICETYPE == 'phone') {
      this.isPhone = true
    }
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
        .fontWeight(300)
        .fontFamily("Digit")
      if (this.isShowDate) {
        Row() {
          if (this.isPhone) {
            Text($r("app.string.mm_dd", this.mViewModel.dateVal.month, this.mViewModel.dateVal.day))
              .fontSize($r('app.float.date_fontsize'))
              .fontColor($r('app.color.date_time_color'))
          } else {
            Text($r('app.string.yyyy_mm_dd', this.mViewModel.dateVal.year, this.mViewModel.dateVal.month,
              this.mViewModel.dateVal.day))
              .fontSize($r('app.float.date_fontsize'))
              .fontColor($r('app.color.date_time_color'))
          }
          Text(this.mViewModel.weekVal).fontSize($r('app.float.date_fontsize'))
            .fontColor($r('app.color.date_time_color'))
        }.height($r('app.float.date_week_area_height'))

        Row() {
          Text(this.mViewModel.calendarVal.calendarYear + '年' + this.mViewModel.calendarVal.calendarMonth + '月' + this.mViewModel.calendarVal.calendarDay)
            .height($r("app.float.date_lunar_calendar_height"))
            .fontColor(Color.White)
            .fontSize($r("app.float.date_lunar_calendar_fontSize"))
            .margin({ top: 6 })
        }
        .visibility(this.currentLanguage === DEFAULTLANG ? Visibility.Visible : Visibility.None)
      }
    }
    .width(Constants.FULL_CONTAINER_WIDTH)
  }
}