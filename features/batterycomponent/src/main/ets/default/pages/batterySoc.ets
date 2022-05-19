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

import Log from '../../../../../../../common/src/main/ets/default/Log'
import StyleConfigurationCommon from '../../../../../../../common/src/main/ets/default/StyleConfiguration'
import deviceInfo from '@ohos.deviceInfo';

const deviceTypeInfo = deviceInfo.deviceType
const TAG = 'BatteryComponent-batterySoc'

@Component
export default struct BatterySoc {
  @StorageLink('batterySoc') batterySoc: number = 100
  @Prop mContentColor: string
  @State styleCommon: any = StyleConfigurationCommon.getCommonStyle()
  private isPhone: boolean= false

  aboutToAppear() {
    Log.showInfo(TAG, 'aboutToAppear Start');
    if (deviceTypeInfo === "phone") {
      this.isPhone = true
    } else {
      this.isPhone = false
    }
  }

  aboutToDisappear() {
    Log.showInfo(TAG, 'aboutToDisappear');
  }

  build() {
    Text(this.batterySoc + '%')
      .fontColor(this.mContentColor)
      .fontSize(this.isPhone ? '12fp' : this.styleCommon.statusBarFontSize)
      .fontWeight(this.isPhone ? FontWeight.Medium : FontWeight.Normal)
  }
}
