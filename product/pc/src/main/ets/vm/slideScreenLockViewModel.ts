/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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

import Log from '../../../../../../common/src/main/ets/default/Log';
import ScreenLockService from '../../../../../../features/screenlock/src/main/ets/com/ohos/model/screenLockService'
import Constants from '../common/constants'
import {Callback} from 'basic';

const TAG = 'ScreenLock-SlideScreenLockViewModel'
//Height of notification area.
const NOTIFICATION_MAXHEIGHT = 500
const SLIDING_LENGTH = 244
const DELAY_TIME = 3 * 1000

export default class SlideScreenLockViewModel {
    startX: number = 0
    startY: number = 0
    moveX: number = 0
    moveY: number = 0
    slidingLength: number = 0
    elementAlpha: number = 1
    elementScale: number = 1
    backgroundScale: number = 1.1
    duration: number= 250
    toggleShow: boolean = false

    ViewModelInit(): void{
        Log.showDebug(TAG, `ViewModelInit`);
        ScreenLockService.setUnlockAnimation((callback: Callback<void>) => {
            this.elementAlpha = 0
            this.elementScale = 0.85
            this.backgroundScale = 1
            setTimeout(() => {
                callback()
                this.elementAlpha = 1
                this.elementScale = 1
                this.backgroundScale = 1.1
            }, 250);
        })
        this.slidingLength = SLIDING_LENGTH
    }

    unlockScreen(): void{
        ScreenLockService.unlockScreen()
    }

    touchEvent(event: TouchEvent) {
        Log.showInfo(TAG, `Touch Event ${event.type} at Point ${event.touches[0].x}, ${event.touches[0].y}`)
        if (event.type == Constants.TOUCHTYPE_DOWN) {
            this.startX = event.touches[0].screenX
            this.startY = event.touches[0].screenY
        } else if (event.type == Constants.TOUCHTYPE_MOVE) {
            this.moveX = event.touches[0].screenX - this.startX
            this.moveY = event.touches[0].screenY - this.startY
        } else if (event.type == Constants.TOUCHTYPE_UP) {
            Log.showInfo(TAG, `Touch Event slidingLength: ${this.slidingLength}`)
            if (Math.abs(this.moveY) > this.slidingLength) {
                this.unlockScreen()
            }
            this.moveX = 0
            this.moveY = 0
        }

        event.stopPropagation();
    }

    toggleDisplay(batteryCharging?) {
        Log.showInfo(TAG, `toggleDisplay charging:${batteryCharging}`);
        this.toggleShow = true;
        setTimeout(() => {
            this.toggleShow = false;
            Log.showInfo(TAG, `toggleDisplay setTimeout: ${this.toggleShow}`);
        }, DELAY_TIME);
    }

    onPageShow(): void {
        this.elementAlpha = 1
        this.elementScale = 1
        this.backgroundScale = 1.1
        AppStorage.SetOrCreate('slidestatus', false);
    }
}