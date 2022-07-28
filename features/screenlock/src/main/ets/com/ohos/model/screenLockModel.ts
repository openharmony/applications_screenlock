// @ts-nocheck
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
import {SysFaultLogger, FaultID} from '../../../../../../../../common/src/main/ets/default/SysFaultLogger'
import ScreenLockMar from '@ohos.screenlock';
import windowManager  from '@ohos.window'
import Constants from '../common/constants'
import { Callback } from 'basic';

const TAG = 'ScreenLock-ScreenLockModel';

export default class ScreenLockModel {
    @SysFaultLogger({FAULT_ID: FaultID.SCREEN_LOCK_MANAGER, MSG: "call func on failed"})
    eventListener(typeName: string, callback: Callback<void>) {
        Log.showDebug(TAG, `eventListener:typeName ${typeName}`);
        switch (typeName) {
            case "endScreenOn":
            case "unlockScreen":
                ScreenLockMar.on(typeName, () => {
                    Log.showInfo(TAG, `eventListener:callback`);
                    callback();
                })
                break;
            case "beginSleep":
                ScreenLockMar.on(typeName, (userId: number) => {
                    Log.showInfo(TAG, `eventListener:callback userId:${userId}`);
                    callback();
                })
                break;
            case "systemReady":
                ScreenLockMar.on(typeName, (err, data) => {
                    Log.showInfo(TAG, `eventListener:callback err: ${JSON.stringify(err)},
                        data:${JSON.stringify(data)}`);
                    callback();
                })
            break;
            default:
                Log.showError(TAG, `eventListener:typeName ${typeName}`)
        }
    }

    eventCancelListener(typeName: string) {
        Log.showDebug(TAG, `eventCancleListener:typeName ${typeName}`);
        // As off has some problem and there is no case to cancel, do nothing
    }

    @SysFaultLogger({FAULT_ID: FaultID.SCREEN_LOCK_MANAGER, MSG: "call func sendScreenLockEvent failed"})
    sendScreenLockEvent(typeName: string, typeNo: number, callback) {
        Log.showInfo(TAG, `sendScreenLockEvent: typeName ${typeName} typeNo  ${typeNo} `);
        ScreenLockMar.sendScreenLockEvent(typeName, typeNo, (err, data) => {
            callback(err, data);
        })
    }

    showScreenLockWindow(callback: Callback<void>) {
        windowManager.find(Constants.WIN_NAME).then((win) => {
            win.show().then(() => {
                Log.showInfo(TAG, `window show`);
                callback();
            })
        })
    }

    hiddenScreenLockWindow(callback: Callback<void>) {
        Trace.end(Trace.CORE_METHOD_PASS_ACCOUNT_SYSTEM_RESULT);
        windowManager.find(Constants.WIN_NAME).then((win) => {
            Trace.start(Trace.CORE_METHOD_HIDE_PSD_PAGE);
            win.hide().then(() => {
                Log.showInfo(TAG, `window hide`);
                callback();
            })
        })
    }
}
