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

import Trace from '../../../../../../../../common/src/main/ets/default/Trace'
import Log from '../../../../../../../../common/src/main/ets/default/Log'
import Constants from '../common/constants'
import BaseViewModel, {service, AuthType, AuthSubType} from './baseViewModel'
import {Callback} from 'basic';

const TAG = 'ScreenLock-CustomPSDViewModel'

export default class CustomPSDViewModel extends BaseViewModel {
    passwordArr: any[] = [];
    numKeyboard: any[] = Constants.NUMKEY_BOARD;

    constructor() {
        super();
    }

    ViewModelInit(): void{
        Log.showDebug(TAG, 'ViewModelInit');
        super.ViewModelInit();
    }

    onKeyPress(index, callback) {
        Log.showInfo(TAG, `onKeyPress start param: ${index}`)
        let keyValue = this.numKeyboard[index].value;
        if (keyValue >= 0 && !this.inhibitInput) {
            if (this.passwordArr.length < Constants.PASSWORD_MAX_LEN) {
                this.passwordArr.push(keyValue);
                this.numKeyboard[11].row1 = $r('app.string.delete');
                this.numKeyboard[11].value = Constants.DEL_PWD;
                this.updateStorage(callback);
            }
        } else if (keyValue == Constants.DEL_PWD) {
            this.passwordArr.pop()
            if (this.passwordArr.length == 0) {
                this.numKeyboard[11].row1 = $r('app.string.back');
                this.numKeyboard[11].value = Constants.GO_BACK;
            }
            this.updateStorage(callback);
        } else if (keyValue == Constants.GO_BACK) {
            AppStorage.SetOrCreate('slidestatus', false);
            service.goBack();
        } else if (keyValue == Constants.CALL_PHONE) {
        }
    }

    onCallPhone() {
        Log.showInfo(TAG, 'onCallPhone');
    }

    onAuthPassword(callback: Callback<void>) {
        Log.showInfo(TAG, `onAuthPassword`);
        if (this.passwordArr.length == 0 || this.inhibitInput) {
            this.updateStorage(callback);
            return;
        }
        Trace.start(Trace.CORE_METHOD_UNLOCK_SCREEN);
        Trace.start(Trace.CORE_METHOD_CALL_ACCOUNT_SYSTEM);
        service.authUser(AuthSubType.PIN_MIXED, this.passwordArr, (result, extraInfo) => {
            this.clearPassword();
            if (result == 0) {
                //unlock the screen
                service.unlocking();
            } else {
                //Clear the entered password
                super.changePrompt(extraInfo.remainTimes, extraInfo.freezingTime, callback);
            }
        });
    }

    clearPassword() {
        Log.showInfo(TAG, `clearPassword`)
        this.passwordArr = [];
        this.numKeyboard[11].row1 = $r('app.string.back');
        this.numKeyboard[11].value = Constants.GO_BACK;
        this.updateStorage(() => {
        })
    }

    updateStorage(callback) {
        Log.showInfo(TAG, `updateStorage child`)
        //refresh  the page
        AppStorage.SetOrCreate('passwordArr', this.passwordArr);
        AppStorage.SetOrCreate('numKeyboard', this.numKeyboard);
        super.updateStorage(callback)
    }
}
