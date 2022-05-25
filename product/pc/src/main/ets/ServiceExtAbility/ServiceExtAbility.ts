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

import ServiceExtension from '@ohos.application.ServiceExtensionAbility'
import windowManager from '@ohos.window'
import WindowManagers, { WindowType } from "../../../../../../common/src/main/ets/default/WindowManager";
import display from '@ohos.display'
import Log from '../../../../../../common/src/main/ets/default/Log'
import Constants from '../../../../../../features/screenlock/src/main/ets/com/ohos/common/constants'
import AbilityManager from '../../../../../../common/src/main/ets/default/abilitymanager/abilityManager'
import sTimeManager from '../../../../../../common/src/main/ets/default/TimeManager'

const TAG = "ScreenLock-ServiceExtAbility"

class ServiceExtAbility extends ServiceExtension {
    onCreate(want) {
        Log.showDebug(TAG, 'onCreate, want:' + want.abilityName);
        AbilityManager.setContext(AbilityManager.ABILITY_NAME_SCREEN_LOCK, this.context)
        sTimeManager.init(this.context)
        this.statusBarWindow()
        this.createWindow(Constants.WIN_NAME)
    }

    private createWindow(name: string) {
        Log.showInfo(TAG, `createWindow name:${name}`)
        windowManager.create(this.context, name, 2110).then((win) => {
            Log.showInfo(TAG, "before begin " + name + " window show!")
            win.loadContent("pages/index").then(() => {
                win.show().then(() => {
                    Log.showInfo(TAG, "window show in then!");
                })
            })
        }, (error) => {
            Log.showError(TAG, name + " window createFailed, error.code = " + error.code)
        })
    }

    private async statusBarWindow() {
    	Log.showInfo(TAG, `statusBarWindow`);
        let dis = await display.getDefaultDisplay();
        while (dis === null) {
            await new Promise((resolve)=>{setTimeout(resolve, 1000)});
            dis = await display.getDefaultDisplay();
        }
        Log.showInfo(TAG, `getDefaultDisplay, dis: ${JSON.stringify(dis)}`);
        let rect;
        if (dis.width > dis.height) { // Pad and PC horizontalScreen Mode
            rect = {
                left: 0,
                top: 0,
                width: '100%',
                height: (44 * dis.width) / 1280,
            }
        } else { // Phone verticalScreen Mode
            rect = {
                left: 0,
                top: 0,
                width: '100%',
                height: (44 * dis.width) / 800
            }
        }
        AbilityManager.setAbilityData(AbilityManager.ABILITY_NAME_STATUS_BAR, "rect", rect);
        AbilityManager.setAbilityData(AbilityManager.ABILITY_NAME_STATUS_BAR, "dis", {
            width: dis.width,
            height: dis.height,
        });
    }

    onDestroy() {
        Log.showDebug(TAG, 'api8New onDestroy');
        sTimeManager.release()
    }
}

export default ServiceExtAbility