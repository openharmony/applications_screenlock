/**
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

import featureAbility from '@ohos.ability.featureAbility'
import commonEvent from '@ohos.commonEvent';
import settings from '@ohos.settingsnapi';
import Log from '../../../../../../../../common/src/main/ets/default/Log'
import DateTimeCommon from '../../../../../../../../common/src/main/ets/default/DateTimeCommon'
import sTimeManager, {TimeEventArgs, TIME_CHANGE_EVENT,
}  from '../../../../../../../../common/src/main/ets/default/TimeManager';
import EventManager, {unsubscribe} from '../../../../../../../../common/src/main/ets/default/event/EventManager'

const TAG = 'ScreenLock-DateTimeViewModel'

let mCommonEventSubscribeInfo = {
    events: [
        commonEvent.Support.COMMON_EVENT_TIME_CHANGED,
        commonEvent.Support.COMMON_EVENT_TIMEZONE_CHANGED,
        commonEvent.Support.COMMON_EVENT_TIME_TICK
    ]
};

let mEventSubscriber

/**
 * DateTimeViewModel class
 */
export default class DateTimeViewModel {
    timeVal: string = ''
    dateVal: any = {}
    weekVal: any = {}
    unSubscriber?: unsubscribe;

    ViewModelInit(): void{
        Log.showInfo(TAG, 'ViewModelInit');

        this.setDateTime.bind(this)()
        commonEvent.createSubscriber(mCommonEventSubscribeInfo, this.createSubscriberCallBack.bind(this));
        this.unSubscriber = EventManager.subscribe(TIME_CHANGE_EVENT, (args: TimeEventArgs) => {
            this.setDateTime()
        });
        Log.showInfo(TAG, 'ViewModelInit end');
    }

    private setDateTime() {
        Log.showInfo(TAG, `setDateTime`)
        this.timeVal = sTimeManager.formatTime(new Date())
        this.dateVal = DateTimeCommon.getSystemDate()
        this.weekVal = DateTimeCommon.getSystemWeek()
    }

    private createSubscriberCallBack(err, data) {
        Log.showInfo(TAG, "start createSubscriberCallBack " + JSON.stringify(data))
        mEventSubscriber = data
        commonEvent.subscribe(data, this.setDateTime.bind(this));
        Log.showInfo(TAG, "start createSubscriberCallBack finish")
    }

    stopPolling() {
        Log.showInfo(TAG, `stopPolling start`)
        commonEvent.unsubscribe(mEventSubscriber);
        this.unSubscriber && this.unSubscriber();
        this.unSubscriber = undefined;
        Log.showInfo(TAG, `stopPolling end`)
    }
}
