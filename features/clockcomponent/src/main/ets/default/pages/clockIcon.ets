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

import {StatusBarGroupComponentData} from '../../../../../../screenlock/src/main/ets/com/ohos/common/constants'
import StatusBarVM from '../../../../../../screenlock/src/main/ets/com/ohos/vm/StatusBarVM'
import {Log, TimeEventArgs, TIME_CHANGE_EVENT, sEventManager, unsubscribe, sTimeManager} from '@ohos/common'

const TAG = 'ClockComponent-clockIcon';

@Component
export default struct ClockIcon {
  @State mTime: string = '16:01'
  private mGroupId: string = ''
  @State mStatusBarGroupComponentData: StatusBarGroupComponentData = new StatusBarGroupComponentData()
  @State statusBarClockMaxWidth: Resource = $r('app.float.status_bar_clock_width')
  @State statusBarMarginLeftRight: Resource = $r("app.float.signal_status_margin_Left_right")
  @State statusBarFontSize: Resource = $r("app.float.signal_fontSize")
  unSubscriber?: unsubscribe;

  aboutToAppear() {
    Log.showInfo(TAG, 'aboutToAppear');
    this.mStatusBarGroupComponentData = StatusBarVM.getStatusBarGroupComponentData(this.mGroupId)
    this.unSubscriber = sEventManager.subscribe(TIME_CHANGE_EVENT, (args: TimeEventArgs) => {
      this.mTime = sTimeManager.formatTime(args.date);
    });
    this.mTime = sTimeManager.formatTime(new Date());
  }

  aboutToDisappear() {
    Log.showInfo(TAG, 'aboutToDisappear');
    this.unSubscriber && this.unSubscriber();
    this.unSubscriber = undefined;
  }

  build() {
    Row() {
      Row().width(this.statusBarMarginLeftRight).height('100%')
      Text(this.mTime)
        .fontColor(this.mStatusBarGroupComponentData.contentColor)
        .fontSize(this.statusBarFontSize)
        .width(this.statusBarClockMaxWidth)
        .fontWeight(FontWeight.Medium)
        .margin({ left: $r("app.float.status_bar_clock_margin") })
      Row().width(this.statusBarMarginLeftRight).height('100%')
    }
  }
}