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
import {ReadConfigFile} from '../../../../../../../../common/src/main/ets/default/ScreenLockCommon'


const FILE_URI = '/data/accounts/account_0/applications/com.ohos.screenlock'
+ '/com.ohos.screenlock/assets/{0}/resources/rawfile/screenlock.json'
const TAG = 'ScreenLock-ScreenlockStyle';


export enum LockStyleMode {
    SlideScreenLock = 1,
    JournalScreenLock = 2,
    CustomScreenLock = 3
}

class ScreenlockStyle {
    private screenMode: LockStyleMode = LockStyleMode.SlideScreenLock

    setMode(mode: LockStyleMode): number {
        Log.showInfo(TAG, 'setMode:${mode}');
        return this.screenMode = mode
    }

    getMode(): number {
        Log.showInfo(TAG, 'getMode');
        return this.screenMode
    }

    readMode(deviceType: string): number{
        Log.showInfo(TAG, `readMode deviceType:${deviceType}`);
        try {
            let modeJson = ReadConfigFile(FILE_URI.replace('{0}', deviceType))
            Log.showInfo(TAG, `ReadConfigFile content:` + JSON.stringify(modeJson));
            this.screenMode = modeJson.mode
        } catch(error) {
            Log.showInfo(TAG, `ReadConfigFile content error: ${error}`);
            this.screenMode = 1
        }
        return this.screenMode
    }
}

let screenlockStyle = new ScreenlockStyle()

export default screenlockStyle as ScreenlockStyle