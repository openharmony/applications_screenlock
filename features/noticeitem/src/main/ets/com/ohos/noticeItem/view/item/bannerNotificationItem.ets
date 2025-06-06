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

import {Log, AbilityManager, sWindowManager, WindowType} from '@ohos/common'
import Constants, {NotificationLayout as Layout} from '../../common/constants';
import ViewModel from '../../viewmodel/ViewModel';
import CustomItem from './customItem';
import titleItem from './titleItem';
import basicItem from './basicItem';
import longItem from './longItem';
import multiItem from './multiItem';
import pictureItem from './pictureItem';
import ActionComponent from './actionComponent';
import DevicesDialog from './devicesDialog';
import WantAgent from '@ohos.wantAgent';

const TAG = 'NoticeItem-BannerNotificationItem'
const INTERVAL = 5 * 1000

@Component
export default struct BannerNotificationItem {
  @State want : any = {};
  @Link distributedDeviceName: string;
  @Link mBannerNoticeCnt: number;
  @Link mLastActionTime: number;
  @Link needExpand: boolean;
  @Link isExpand: boolean;
  @State mCloseEnableFlg: boolean = false;
  private nowWant: any;
  private onBannerNoticeHide: () => void
  private devicesDialogController: CustomDialogController = new CustomDialogController({
    builder: DevicesDialog({
      action: (deviceID) => this.selectedDevice(deviceID)
    }),
    autoCancel: false,
    offset: { dx: 0, dy: 200 }
  });

  mInterval: number = INTERVAL;
  mDefaultBannerRect: any;
  expandPaddingBottom: number = Layout.EXPAND_PADDING_BOTTOM;

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear Start`)
    this.mCloseEnableFlg = false;
    this.mDefaultBannerRect = AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_BANNER_NOTICE, 'bannerRect');
    setTimeout(() => {
      this.hideWindowForTimeout();
    }, this.mInterval);
    Log.showInfo(TAG, `aboutToAppear End`)
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisAppear`)
  }

  build() {
    Column() {
      if (this.mBannerNoticeCnt > 0) {
        if (this.want.template) {
          CustomItem({ customItemData: this.want, isSubItem: false })
        } else {
          Row() {
            Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
              Row() {
                titleItem({
                  notificationSmallIcon: this.want.smallIcon,
                  notificationName: this.want.appName,
                  notificationTime: this.want.time,
                  isExpand: $isExpand,
                  needExpand: this.needExpand,
                  distributedDeviceName: this.distributedDeviceName,
                  isSubItem: false,
                  clickTitleAction: () => this.refreshLastActionTime()
                })
              }
              Row() {
                Image($r('app.media.ic_close'))
                  .objectFit(ImageFit.Contain)
                  .width(Layout.TITLE_IMAGE_SIZE)
                  .height(Layout.TITLE_IMAGE_SIZE)
                  .margin({ left: Layout.ICON_MARGIN })
                  .visibility(this.mCloseEnableFlg ? Visibility.Visible : Visibility.None)
                  .onClick(this.clickCloseIcon.bind(this))
              }
            }
            .margin({ left: 12, right: 12 })
            .height(Layout.TITLE_HEIGHT)
          }
          Row() {
            ContentComponent({
              isExpand: this.isExpand,
              itemData: this.want
            });
            if (this.isExpand && this.want.actionButtons.length) {
              ActionComponent({ itemData: this.want })
            } else {
              Blank()
                .height(Layout.ITEM_MARGIN)
            }
          }
          .padding({
            bottom: $r('app.float.item_paddingbottom')
          })
          .onClick(this.showDevicesDialog.bind(this))
          .onAreaChange((e, e2) => {
            Log.showDebug(TAG, `onAreaChange, e: ${JSON.stringify(e)} e2: ${JSON.stringify(e2)}`);
            let heightEx = parseInt(e['height']);
            let heightCur = parseInt(e2['height']);
            let heightWin = parseInt(this.mDefaultBannerRect['height']);
            if (this.isExpand) {
              heightWin = heightWin + (heightCur - heightEx) + this.expandPaddingBottom;
            }
            let bannerRect = {
              top: this.mDefaultBannerRect['top'],
              left: this.mDefaultBannerRect['left'],
              width: this.mDefaultBannerRect['width'],
              height: heightWin
            };
            sWindowManager.resetSizeWindow(WindowType.BANNER_NOTICE, bannerRect);
            sWindowManager.showWindow(WindowType.BANNER_NOTICE);
          })
        }
      } else {
        Row() {
          Blank()
        }
      }
    }
    .width('100%')
    .height('100%')
    .borderRadius($r("sys.float.ohos_id_corner_radius_default_l"))
    .backgroundColor($r('app.color.notificationitem_background'))
    .clip(true)
    .onHover((isHover) => {
      this.mCloseEnableFlg = isHover;
    })
  }

  isCreateNewNotification(notificationCount:number):boolean{
    Log.showDebug(TAG, `isCreateNewNotification, notificationCount: ${notificationCount}`);
    return true;
  }

  hideWindowForTimeout() {
    Log.showDebug(TAG, `check need hide window or not.`)
    if ((new Date()).getTime() - this.mLastActionTime >= this.mInterval) {
      if (this.mCloseEnableFlg) {
        this.mLastActionTime = (new Date()).getTime();
        setTimeout(() => {
          this.hideWindowForTimeout();
        }, this.mInterval);
        return;
      }
      this.onBannerNoticeHide();
    } else {
      setTimeout(() => {
        this.hideWindowForTimeout();
      }, this.mInterval);
    }
  }

  clickCloseIcon() {
    Log.showDebug(TAG, 'clickCloseIcon');
    this.onBannerNoticeHide();
  }

  showDevicesDialog() {
    Log.showDebug(TAG, `showDevicesDialog`)
    if (!this.want?.distributedOption?.isDistributed) {
      ViewModel.clickItem(this.want);
      this.onBannerNoticeHide();
      return;
    }
    let wantAgent = this.want?.want;
    if (!!wantAgent) {
      WantAgent.getWant(wantAgent).then((wantData) => {
        this.nowWant = wantData
        if (!wantData?.deviceId) {
          this.devicesDialogController.open();
        } else{
          ViewModel.clickItem(this.want);
        }
        this.onBannerNoticeHide();
      })
    }
  }

  selectedDevice(deviceID) {
    Log.showDebug(TAG, `selectedDevice deviceID:${deviceID}`)
    this.nowWant.deviceId = deviceID;
    let triggerInfo = {
      code: 0,
      want: this.nowWant,
      permission: '',
      extraInfo: {}
    };
    ViewModel.clickDistributionItem(this.want, triggerInfo)
  }

  refreshLastActionTime() {
    this.mLastActionTime = (new Date()).getTime();
    setTimeout(() => {
      this.hideWindowForTimeout();
    }, this.mInterval);
  }

}

@Component
struct ContentComponent {
  @Prop isExpand: boolean;
  itemData: any;

  aboutToAppear() {
    Log.showDebug(TAG, `NotificationItemData: ${JSON.stringify(this.itemData)}`)
  }

  build() {
    Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      Row() {
        if (this.itemData.contentType === Constants.NOTIFICATION_TYPE_BASIC) {
          basicItem({
            itemData: this.itemData
          });
        }
        if (this.itemData.contentType === Constants.NOTIFICATION_TYPE_LONG) {
          longItem({
            itemData: this.itemData,
            isExpand: this.isExpand
          });
        }
        if (this.itemData.contentType === Constants.NOTIFICATION_TYPE_MULTILINE) {
          multiItem({
            itemData: this.itemData,
            isExpand: this.isExpand
          });
        }
        if (this.itemData.contentType === Constants.NOTIFICATION_TYPE_PICTURE) {
          pictureItem({
            itemData: this.itemData,
            isExpand: this.isExpand
          });
        }
      }.flexGrow(1)

      if (this.itemData.picture) {
        Image(this.itemData.picture)
          .objectFit(ImageFit.Contain)
          .width(Layout.NOTIFICATION_PIC_SIZE)
          .height(Layout.NOTIFICATION_PIC_SIZE)
      }
    }.margin({ left: Layout.ITEM_MARGIN, right: Layout.ITEM_MARGIN })
  }
}