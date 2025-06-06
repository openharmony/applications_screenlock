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

import { NotificationItemData, NotificationLayout as Layout} from '../../common/constants';
import {Log} from '@ohos/common'
import SettingDialog from './settingDialog';
import ConfirmDialog from './confirmDialog'
import ViewModel from '../../viewmodel/ViewModel';

const TAG = 'NoticeItem-IconListComponent';
let iconSize: number = 0;

export class IconData {
  public src?: Resource;
  public callback?: () => void
}

export class NotificationUiConfig {
  public iconSize: number = 0
}

export function getIconListSize(list?: IconData[]) {
  let listSize = list?.length??iconSize;
  return listSize * (Layout.BUTTON_SIZE + 2 * Layout.ICON_MARGIN) + Layout.ICON_MARGIN
}

@Component
export default struct IconListComponent {
  private itemData: NotificationItemData | undefined = undefined;
  private isGroup: boolean= false;
  @Prop iconAlpha: number
  private settingDialogController: CustomDialogController = new CustomDialogController({
    builder: SettingDialog({
      itemData: this.itemData,
      action: (): void => this.confirmDialogController?.open()
    }),
    autoCancel: false,
    offset: { dx: 0, dy: $r('app.float.setting_dialog_dy') },
    customStyle:true
  });
  private confirmDialogController: CustomDialogController = new CustomDialogController({
    builder: ConfirmDialog({
      title: $r('app.string.closeNovice'),
      bundleName: this.itemData?.appName,
      action: (): void => ViewModel?.enableNotification(this.itemData, false)
    }),
    autoCancel: false,
    offset: { dx: 0, dy: $r('app.float.confirm_dialog_dy') },
    customStyle:true
  });
  private iconConfigs: IconData[] = [
    {
      src: $r("app.media.ic_public_settings_filled"),
      callback: () => {
        Log.showDebug(TAG, `click settings hashcode: ${this.itemData?.hashcode}`);
        this.settingDialogController.open()
      }
    }, {
      src: $r("app.media.ic_public_delete_filled"),
      callback: () => {
        if (!this.isGroup) {
          Log.showDebug(TAG, `click delete hashcode: ${this.itemData?.hashcode}`);
          ViewModel.removeNotificationItem(this.itemData, true)
        } else {
          Log.showDebug(TAG, `click delete groupName: ${this.itemData?.groupName}`);
          ViewModel.removeGroupNotification(this.itemData, true)
        }
      }
    }
  ]

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear iconConfigs: ${JSON.stringify(this.iconConfigs)}`)
    iconSize = this.iconConfigs.length;
  }

  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.End, justifyContent: FlexAlign.End }) {
      ForEach(this.iconConfigs, (item: IconData) => {
        Button({ type: ButtonType.Circle, stateEffect: true }) {
          if (item.src) {
            Image(item.src)
              .objectFit(ImageFit.Contain)
              .fillColor($r("sys.color.ohos_id_color_primary_contrary"))
              .width(Layout.ICON_SIZE)
              .height(Layout.ICON_SIZE)
          }
        }
        .width(Layout.BUTTON_SIZE)
        .height(Layout.BUTTON_SIZE)
        .opacity(this.iconAlpha)
        .backgroundColor($r("app.color.button_background"))
        .margin({ left: Layout.ICON_MARGIN, right: Layout.ICON_MARGIN })
        .onClick(() => item.callback && item.callback())
      })
    }
    .margin({ left: Layout.ICON_MARGIN })
  }
}