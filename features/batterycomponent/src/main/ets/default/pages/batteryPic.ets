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
import Log from '../../../../../../../common/src/main/ets/default/Log'
import StyleConfiguration from '../common/StyleConfiguration'

const TAG = 'BatteryComponent-batteryPic'

@Component
export default
struct BatteryPic {
  @StorageLink('batterySoc') batterySoc: number = 100
  @StorageLink('batteryCharging') batteryCharging : boolean = false
  @State mContentColor: string = "#FFFFFFFF"
  @State picBodyWidth: Resource = $r('app.float.battery_component_pic_body_width')
  @State picBodyHeight: Resource = $r('app.float.battery_component_pic_body_height')
  @State picBodyBorderWidth: Resource = $r('app.float.battery_component_pic_body_border_width')
  @State picBorderRadius: Resource = $r('app.float.battery_component_pic_border_radius')
  @State picBodyPadding: Resource = $r('app.float.battery_component_pic_body_padding')
  @State picGap: Resource = $r('app.float.battery_component_pic_gap')
  @State picHeadWidth: Resource = $r('app.float.battery_component_pic_head_width')
  @State picHeadHeight: Resource = $r('app.float.battery_component_pic_head_height')
  @State picHeadBorderRadius: Resource = $r('app.float.battery_component_pic_head_radius')
  @State picChargingColor: Resource = $r('app.color.battery_component_pic_charging_color')
  @State picLevelLowColor: Resource = $r('app.color.battery_component_pic_level_low_color')

  aboutToAppear(){
    Log.showInfo(TAG,'aboutToAppear Start');
  }

  aboutToDisappear(){
    Log.showInfo(TAG,'aboutToDisappear');
  }

  build() {

    Row() {
      Row() {
        Row() {

        }
        .height('100%')
        .width((this.batterySoc < 100 ? this.batterySoc: 100) + '%')
        .backgroundColor(this.getBatteryColor(this.batterySoc, this.batteryCharging))
      }
      .width(this.picBodyWidth)
      .height(this.picBodyHeight)
      .backgroundColor($r('app.color.battery_background'))
      .border({ width: this.picBodyBorderWidth,
        color: this.mContentColor,
        radius: this.picBorderRadius,
        style: BorderStyle.Solid })
      .padding(this.picBodyPadding)

      Row() {

      }
      .width(this.picGap)
      .height(1)

      Row() {

      }
      .width(this.picHeadWidth)
      .height(this.picHeadHeight)
      .backgroundColor(this.mContentColor)
      .borderRadius(this.picHeadBorderRadius)
    }
  }

  private getBatteryColor(val, charging) {
    Log.showDebug(TAG, `getBatteryColor, val: ${ val }  charging: ${ charging } `);
    if (charging) {
      return this.picChargingColor;
    } else if (val <= Constants.BATTERY_LEVEL_LOW) {
      return this.picLevelLowColor;
    } else {
      return this.mContentColor;
    }
  }
}
