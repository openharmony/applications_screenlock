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

import Constants from '../../common/constants';
import {Log} from '@ohos/common'
import DistributionManager from '../../model/NotificationDistributionManager';
import DeviceManager from '@ohos.distributedDeviceManager';

const TAG = 'NoticeItem-DevicesDialog';


/**
 * Devices dialog
 */
@CustomDialog
export default struct DevicesDialog {
  private deviceInfoList: Array<DeviceManager.DeviceBasicInfo> | null = null;
  public controller: CustomDialogController
  public action: (deviceID: string | undefined) => void = () => {
  };

  build() {
    Column({ space: 30 }) {
      Row() {
        Text($r('app.float.confirm_title_fontsize'))
          .fontSize($r('app.float.confirm_title_fontsize'))
          .fontWeight(FontWeight.Bold)
      }.width(Constants.SETTING_DIALOG_WITH)
      .margin({ top: 20 })

      Column() {
        List() {
          ForEach(this.deviceInfoList, (item: DeviceManager.DeviceBasicInfo) => {
            ListItem() {
              Row() {
                Column() {
                  Text(item?.deviceName)
                    .fontSize($r('app.float.setting_cont_fontsize'))
                    .fontColor($r('app.color.dialog_font_color'))
                    .height(Constants.SETTING_CONT_HEIGHT)

                }.alignItems(HorizontalAlign.Center)
                .width(Constants.FULL_CONTAINER_WIDTH)
              }
              .width(Constants.SETTING_DIALOG_WITH)
              .alignItems(VerticalAlign.Center)
              .align(Alignment.Center)
              .border({ width: $r('app.float.setting_border_width'), color: Color.White,
                radius: $r('app.float.setting_border_radius') })
              .backgroundColor($r('app.color.dialog_font_back_color'))
              .onClick(() => {
                this.action(item?.deviceId);
                this.controller.close();
              })
            }
          })
        }
        .divider({
          strokeWidth: 1,
          color: $r('app.color.device_divider_color'),
          startMargin: $r('app.float.device_divider_margin_l'),
          endMargin: $r('app.float.device_divider_margin_r')
        })
        .width('100%')
        .height('100%')
        .visibility(Visibility.Visible)
        .zIndex(0)
        .border({ width: $r('app.float.device_border_width'), color: Color.White,
          radius: $r('app.float.device_border_radius') })
        .backgroundColor(Color.White)
      }
    }.height(Constants.CONFIRM_DIALOG_HEIGHT)

  }

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear`)
    this.deviceInfoList = DistributionManager.getInstance()?.getTrustedDeviceListSync();
    Log.showDebug(TAG, `aboutToAppear deviceInfoList size: ${this.deviceInfoList?.length}`)
  }
}
