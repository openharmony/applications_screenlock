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

import Log from '../../../../../../../../common/src/main/ets/default/Log'
import Constants from '../common/constants'
import service, {UnlockResult, AuthType, AuthSubType} from '../model/screenLockService'

const TAG = 'ScreenLock-BaseViewModel'
const MINUTE_NM = '分钟'
const SECOND_NM = "秒"
const TRY_AGAIN = "后重试"

export {service, UnlockResult, AuthType, AuthSubType}

export default class BaseViewModel {
    prompt: Resource | string;
    inhibitInput: boolean = false;
    countdownHandle: number = -1;
    freezingMillisecond: number = 0;

    constructor() {
        this.ViewModelInit()
    }

    ViewModelInit(): void{
        Log.showInfo(TAG, 'ViewModelInit');
        this.prompt = $r('app.string.input');
    }

    countdown(callback) {
        Log.showInfo(TAG, `countdown`)
        let promptText: Resource | string = '';
        this.freezingMillisecond -= Constants.INTERVAL;
        Log.showInfo(TAG, `countdown freezingMillisecond:${this.freezingMillisecond}`)
        if (this.freezingMillisecond > 0) {
            promptText = this.getFreezingTimeNm();
            promptText += TRY_AGAIN;
        } else {
            Log.showInfo(TAG, `countdown clearInterval`)
            clearInterval(this.countdownHandle)
            this.countdownHandle = -1
            this.inhibitInput = false
            promptText = $r('app.string.input');
        }
        Log.showInfo(TAG, `countdown promptText:${promptText}`)
        this.prompt = promptText;
        this.updateStorage(callback)
    }

    changePrompt(remainTimes, freezingTime, callback) {
        Log.showInfo(TAG, `changePrompt remainTimes:${remainTimes} freezingTime:${freezingTime}`)
        let promptText: Resource | string = $r('app.string.incorrect');
        this.freezingMillisecond = freezingTime

        if (0 < remainTimes && remainTimes <= 2) {
            if (!!this.freezingMillisecond && this.freezingMillisecond != 0) {
                promptText = $r('app.string.incorrect_promp_freezing', remainTimes, this.getFreezingTimeNm());
            } else {
                promptText = $r('app.string.incorrect_promp_times', remainTimes);
            }
        } else if (0 == remainTimes) {
            if (!!this.freezingMillisecond && this.freezingMillisecond != 0) {
                this.inhibitInput = true
                promptText = $r('app.string.input_promp', this.getFreezingTimeNm());
                this.countdownHandle = setInterval(this.countdown.bind(this), Constants.INTERVAL, callback);
            }
        }
        this.prompt = promptText;
        this.updateStorage(callback)
        //notify the base service that the unlock is fail
        service.notifyScreenResult(UnlockResult.Fail);
        Log.showInfo(TAG, `changePrompt end`)
    }

    getFreezingTimeNm(): string {
        Log.showInfo(TAG, `getFreezingTimeNm start`)
        let minute = Math.floor(this.freezingMillisecond / (60 * 1000));
        Log.showInfo(TAG, `getFreezingTimeNm minute:${minute}`)
        let second = Math.round((this.freezingMillisecond % (60 * 1000)) / 1000);
        Log.showInfo(TAG, `getFreezingTimeNm second:${second}`)
        let timeName = '';
        if (minute != 0) {
            timeName += minute + MINUTE_NM
        }
        if (second != 0) {
            timeName += second + SECOND_NM
        }
        Log.showInfo(TAG, `getFreezingTimeNm end`)
        return timeName;
    }

    updateStorage(callback) {
        Log.showInfo(TAG, `updateStorage`)
        callback()
    }

    checkFreezingTime(authType, callback?) {
        let callBackFun = Function;
        if (callback) callBackFun = callback;
        service.getAuthProperty(authType, (properties) => {
            if (properties.freezingTime > 0) {
                this.inhibitInput = true
                //Clear the entered password
                this.changePrompt(properties.remainTimes, properties.freezingTime, callBackFun)
            }
        })
    }
}
