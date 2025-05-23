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

import {Log} from '@ohos/common'
import { NotificationItemData, NotificationLayout as Layout } from '../common/constants';
import NotificationItem from './item/notificationItem'
import GroupNotificationItem from './item/groupItem'

const TAG = 'NoticeItem-NotificationListComponent';

export class NotificationLayoutConfig {
  public itemMargin?: number;
}

@Component
export default struct NotificationListComponent {
  @Provide('notificationUpdateSc') private update: number = 0;
  @StorageLink('notificationListSc') notificationList: NotificationItemData[] = []
  private config: NotificationLayoutConfig = {
    itemMargin: Layout.ITEM_MARGIN
  }

  aboutToAppear() {
    Log.showInfo(TAG, `notificationList, aboutToAppear`)
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisAppear`);
  }

  build() {
    List({ space: this.config.itemMargin }) {
      if (this.update && false) {
        ListItem() {
        }
      }
      ForEach(this.notificationList, (item: NotificationItemData[]) => {
        ListItem() {
          if (item.length > 1) {
            GroupNotificationItem({ groupData: item })
          } else {
            NotificationItem({ itemData: item[0] })
          }
        }
      }, (list: NotificationItemData[]) => JSON.stringify(list.map((item) => item?.hashcode)))
    }
    .width($r("app.float.notificationList_width"))
  }
}