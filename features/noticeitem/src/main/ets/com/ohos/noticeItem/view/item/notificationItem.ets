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

import { NotificationItemData, NotificationLayout as Layout, ScreenTriggerInfo} from '../../common/constants';
import GeneralItem from './generalItem';
import CustomItem from './customItem';
import {Log} from '@ohos/common'
import ViewModel from '../../viewmodel/ViewModel';
import DevicesDialog from './devicesDialog';
import WantAgent from '@ohos.wantAgent';
import IconListComponent, {getIconListSize} from './iconListComponent';
import ScrollbarManager from '../../common/ScrollbarManager';
import Want from '@ohos.app.ability.Want';

const TAG = 'NoticeItem-NotificationItem';

@Component
export default struct NotificationItem {
  @State mIconAlpha: number = 0;
  @State @Watch('scrollEdge') mEdgeEnd: boolean = false;
  @State itemWidth: string = '100%'
  private itemData: NotificationItemData | undefined = undefined;
  private isSubItem: boolean= false;
  private mScroller: Scroller = new Scroller();

  build() {
    Stack() {
      IconListComponent({ iconAlpha: this.mIconAlpha, itemData: this.itemData })

      Scroll(this.mScroller) {
        Row() {
          FrontItem({ itemData: this.itemData, isSubItem: this.isSubItem })
          IconListComponent({ iconAlpha: 0, itemData: this.itemData })
        }
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .onScroll(() => {
        let accuracy = 0.1
        let newOpacity = this.mScroller.currentOffset().xOffset * 1.0 / getIconListSize()
        let diffs = Math.abs(this.mIconAlpha - newOpacity)
        if (diffs >= accuracy) {
          let finalAlpha = newOpacity < accuracy ? 0 : newOpacity
          finalAlpha = finalAlpha > (1 - accuracy) ? 1 : finalAlpha
          this.mIconAlpha = finalAlpha
        }
      })
      .onScrollEnd(() => {
        this.mEdgeEnd = (this.mEdgeEnd &&
        this.mScroller.currentOffset().xOffset > (getIconListSize() - Layout.SCROLL_THRESHOLD))
        || (!this.mEdgeEnd && this.mScroller.currentOffset().xOffset > Layout.SCROLL_THRESHOLD)
        ScrollbarManager.restoreOtherScroll(this.mScroller);
      })
      .borderRadius(!this.isSubItem ? $r("sys.float.ohos_id_corner_radius_default_l") : 0)
      .clip(!this.isSubItem)
    }.width(this.itemWidth)

  }

  scrollEdge() {
    this.mScroller.scrollEdge(this.mEdgeEnd ? Edge.End : Edge.Start)
  }
}

@Component
struct FrontItem {
  @Consume isClickFrontItem: boolean
  private itemData: NotificationItemData | undefined = undefined;
  private nowWant: Want = {};
  private isSubItem: boolean= false;
  private devicesDialogController: CustomDialogController = new CustomDialogController({
    builder: DevicesDialog({
      action: (deviceID?: string | undefined): void => this.selectedDevice(deviceID)
    }),
    autoCancel: false,
    offset: { dx: 0, dy: 200 }
  });

  build() {
    Column() {
      if (this.itemData?.template) {
        CustomItem({ customItemData: this.itemData, isSubItem: this.isSubItem })
      } else {
        GeneralItem({
          itemData: this.itemData,
          clickAction: (): void => this.showDevicesDialog(),
          isSubItem: this.isSubItem
        })
      }
    }
    .width('100%')
    .borderRadius(!this.isSubItem ? $r("sys.float.ohos_id_corner_radius_default_l") : 0)
    .backgroundColor($r('app.color.notificationitem_background'))
  }

  showDevicesDialog() {
    Log.showDebug(TAG, `showDevicesDialog isDistributed: ${this.itemData?.distributedOption?.isDistributed}`)
    this.isClickFrontItem = true
    if (!this.itemData?.distributedOption?.isDistributed) {
      ViewModel.clickItem(this.itemData);
      return;
    }
    let wantAgent: object = this.itemData?.want;
    if (!!wantAgent) {
      WantAgent.getWant(wantAgent).then((want) => {
        this.nowWant = want
        Log.showDebug(TAG, `showDevicesDialog want: ${JSON.stringify(this.nowWant)}`)
        if (!want?.deviceId) {
          this.devicesDialogController.open()
        } else {
          ViewModel.clickItem(this.itemData);
        }
      })
    } else {
      ViewModel.clickItem(this.itemData);
    }
  }

  selectedDevice(deviceID?: string | undefined) {
    Log.showDebug(TAG, `selectedDevice deviceID:${deviceID}`)
    this.nowWant.deviceId = deviceID;
    let triggerInfo: ScreenTriggerInfo = {
      code: 0,
      want: this.nowWant,
      permission: '',
      extraInfo: {}
    };
    ViewModel.clickDistributionItem(this.itemData, triggerInfo)
  }
}

