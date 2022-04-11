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

import Log from '../../../../../../../../common/src/main/ets/default/Log'
import DateTimeCommon from '../../../../../../../../common/src/main/ets/default/DateTimeCommon'
import Constants from '../common/constants'
import {ScreenLockStatus} from '../../../../../../../../common/src/main/ets/default/ScreenLockCommon'
import ScreenLockModel from '../model/screenLockModel'

const TAG = 'ScreenLock-DateTimeViewModel'

/**
 * DateTimeViewModel class
 */
export default class DateTimeViewModel {
    timeVal: string = ''
    dateVal: any = {}
    weekVal: any = {}
    setDateTimeHandle: number = -1
    isUsing24hFormat: boolean= false

    ViewModelInit(): void{
        Log.showInfo(TAG, 'ViewModelInit');

        this.setDateTime.bind(this)()
        this.setDateTimeHandle = setInterval(this.setDateTime.bind(this), Constants.INTERVAL);
        Log.showInfo(TAG, 'ViewModelInit end');
    }

    setDateTime() {
        Log.showInfo(TAG, `setDateTime`)
        this.timeVal = DateTimeCommon.getSystemTime(this.isUsing24hFormat)
        this.dateVal = DateTimeCommon.getSystemDate()
        this.weekVal = DateTimeCommon.getSystemWeek()
    }

    stopPolling() {
        Log.showInfo(TAG, `stopPolling start`)
        Log.showInfo(TAG, `stopPolling setDateTimeHandle:${this.setDateTimeHandle}`);
        if (this.setDateTimeHandle > 0) {
            clearInterval(this.setDateTimeHandle)
            this.setDateTimeHandle = -1
            Log.showInfo(TAG, `stopPolling setDateTimeHandle new :${this.setDateTimeHandle}`);
        }
        Log.showInfo(TAG, `stopPolling end`)
    }

    onStatusChange(lockStatus: ScreenLockStatus): void {
        Log.showInfo(TAG, `onStatusChange lockStatus:${lockStatus}`);
        Log.showInfo(TAG, `onStatusChange setDateTimeHandle:${this.setDateTimeHandle}`);
        if (lockStatus == ScreenLockStatus.Locking) {
            if (this.setDateTimeHandle <= 0) {
                this.setDateTimeHandle = setInterval(this.setDateTime.bind(this), Constants.INTERVAL);
                Log.showInfo(TAG, `onStatusChange setDateTimeHandle new:${this.setDateTimeHandle}`);
            }
        } else {
            this.stopPolling();
        }
    }
}
