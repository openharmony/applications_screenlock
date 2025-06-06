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

import Constants,{NotificationItemData} from '../../common/constants';
import {Log, CheckEmptyUtils, sEventManager, obtainStartAbility} from '@ohos/common'

const TAG = 'NoticeItem-Setting';

/**
 * Setting dialog
 */
@CustomDialog
export default struct SettingDialog {
  private itemData: NotificationItemData | undefined = undefined;
  public controller: CustomDialogController
  public action: () => void = () => {
  };

  build() {
    Column({ space: 4 }) {
      Row({ space: 4 }) {
        if (!CheckEmptyUtils.isEmpty(this.itemData?.smallIcon)) {
          Image(this.itemData?.smallIcon)
            .objectFit(ImageFit.Contain)
            .width($r('app.float.title_image_width'))
            .height($r('app.float.title_image_height'))
            .margin({ left: $r("app.float.title_image_left_margin"), right: $r("app.float.title_image_right_margin") })
        }
        Text(this.itemData?.appName)
          .fontSize($r('app.float.setting_title_fontsize'))
          .fontWeight(500)
      }.width(Constants.SETTING_DIALOG_WITH)
      .margin({ top: $r('app.float.notification_appname_margin_top') })
      .height($r('app.float.title_font_height'))

      Row() {
        Column() {
          Text($r('app.string.closeNotification'))
            .fontSize($r('app.float.setting_cont_fontsize'))
            .fontColor($r('app.color.dialog_font_color'))
            .height($r("app.float.setting_cont_height"))
        }.alignItems(HorizontalAlign.Center)
        .width($r("app.float.setting_cont_width"))
      }
      .width($r("app.float.setting_dialog_width"))
      .alignItems(VerticalAlign.Center)
      .align(Alignment.Center)
      .margin({ top: $r('app.float.close_notification_margin_top') })
      .border({ width: $r('app.float.setting_border_width'), color: Color.White,
        radius: $r('app.float.setting_border_radius') })
      .backgroundColor($r('app.color.dialog_font_back_color'))
      .onClick(() => {
        this.closeNotification.bind(this)
      })

      Row() {
        Column() {
          Text($r('app.string.moreSettings'))
            .fontSize($r('app.float.setting_cont_fontsize'))
            .fontColor($r('app.color.dialog_font_back_color'))
            .height(Constants.SETTING_CONT_HEIGHT)
        }.alignItems(HorizontalAlign.Center)
        .width($r("app.float.setting_cont_width"))
        .align(Alignment.Center)
      }
      .width($r("app.float.setting_dialog_width"))
      .alignItems(VerticalAlign.Center)
      .border({ width: $r('app.float.setting_border_width'), color: Color.White,
        radius: $r('app.float.setting_border_radius') })
      .backgroundColor($r('app.color.action_button_click_color'))
      .onClick(() => {
        this.openAbility.bind(this)
      })

      Row() {
        Column() {
          Text($r('app.string.cancel'))
            .maxLines(Constants.DEFAULT_MAX_LINES)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .fontSize($r('app.float.setting_cont_fontsize'))
            .fontColor($r('app.color.dialog_font_back_color'))
        }.alignItems(HorizontalAlign.Center)
        .width($r("app.float.setting_cont_width"))
      }
      .width($r("app.float.setting_dialog_width"))
      .margin({ top: $r('app.float.notification_cancle_margin_top') })
      .alignItems(VerticalAlign.Center)
      .align(Alignment.Center)
      .border({ width: $r('app.float.setting_border_width'), color: Color.White,
        radius: $r('app.float.setting_border_radius') })
      .backgroundColor($r('app.color.dialog_font_color'))
      .onClick(() => {
        this.closeAbility.bind(this)
      })
    }.height(Constants.SETTING_DIALOG_HEIGHT)
    .width($r("app.float.setting_dialog_Width"))
    .backgroundColor('#FFFFFFFF')
    .border({ width: $r('app.float.setting_border_width'), color: Color.White,
      radius: $r('app.float.notification_border_radius') })
  }

  closeNotification() {
    this.action()
    this.closeAbility()
  }

  openAbility() {
    Log.showDebug(TAG, ` openAbility:showNotificationManagement`)
    sEventManager.publish(obtainStartAbility('com.ohos.systemui', 'com.ohos.systemui.notificationmanagement.MainAbility',
      { 'migrateUri': 'pages/setEnable', 'migrateBundle': this.itemData?.bundleName }))
    this.closeAbility()
  }

  closeAbility() {
    Log.showDebug(TAG, `closeAbility`)
    this.controller.close()
  }
}