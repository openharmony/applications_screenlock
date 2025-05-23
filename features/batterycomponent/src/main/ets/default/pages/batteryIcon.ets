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

import mBatteryModel from '../batteryModel';
import BatteryPic from './batteryPic'
import BatterySoc from './batterySoc'
import {Log} from '@ohos/common'
import {StatusBarGroupComponentData} from '../../../../../../screenlock/src/main/ets/com/ohos/common/constants'
import StatusBarVM from '../../../../../../screenlock/src/main/ets/com/ohos/vm/StatusBarVM'

const TAG = 'BatteryComponent-batteryIcon'

@Component
export default struct BatteryIcon {
  @StorageLink('batterySoc') batterySoc: number = 100
  @StorageLink('StatusCoefficient') StatusCoefficient: number = 1.0
  private mGroupId: string = ''
  @State mStatusBarGroupComponentData: StatusBarGroupComponentData = new StatusBarGroupComponentData()
  @State componentGap: Resource = $r('app.float.battery_component_gap')
  @State statusBarMarginLeftRight: Resource = $r("app.float.signal_status_margin_Left_right")

  aboutToAppear() {
    this.mStatusBarGroupComponentData = StatusBarVM.getStatusBarGroupComponentData(this.mGroupId)
    mBatteryModel.initBatteryModel();
    Log.showInfo(TAG, 'aboutToAppear');
  }

  aboutToDisappear() {
    Log.showInfo(TAG, 'aboutToDisappear');
  }

  build() {
    Row() {
      Row().width(this.statusBarMarginLeftRight).height('100%')
      BatterySoc({ mContentColor: this.mStatusBarGroupComponentData.contentColor })
      Row().width(this.componentGap).height('100%')
      BatteryPic({ mContentColor: this.mStatusBarGroupComponentData.contentColor })
      Row().width(this.statusBarMarginLeftRight).height('100%')
    }
    .height('100%')
  }
}