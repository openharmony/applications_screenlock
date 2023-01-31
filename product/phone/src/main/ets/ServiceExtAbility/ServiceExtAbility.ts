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

import ServiceExtension from '@ohos.app.ability.ServiceExtensionAbility'
import windowManager from '@ohos.window'
import display from '@ohos.display'
import Log from '../../../../../../common/src/main/ets/default/Log'
import Constants from '../../../../../../features/screenlock/src/main/ets/com/ohos/common/constants'
import AbilityManager from '../../../../../../common/src/main/ets/default/abilitymanager/abilityManager'
import sTimeManager from '../../../../../../common/src/main/ets/default/TimeManager'

const TAG = "ScreenLock-ServiceExtAbility"

class ServiceExtAbility extends ServiceExtension {
    onCreate(want) {
        Log.showInfo(TAG, 'onCreate, want:' + want.abilityName);
        AbilityManager.setContext(AbilityManager.ABILITY_NAME_SCREEN_LOCK, this.context)
        sTimeManager.init(this.context)
        this.statusBarWindow()
        this.createWindow(Constants.WIN_NAME)
    }

    private createWindow(name: string) {
        Log.showDebug(TAG, `createWindow name:${name}`)
        windowManager.create(this.context, name, 2110).then((win) => {
            win.loadContent("pages/index").then(() => {
                Log.showInfo(TAG, name + " window loadContent in then! ")
                win.show().then(() => {
                    Log.showInfo(TAG, "then begin " + name + " window show in then! ");
                })
            })
        }, (error) => {
            Log.showError(TAG, name + " window createFailed, error.code = " + error.code)
        })
    }

    private async statusBarWindow() {
        let dis = await display.getDefaultDisplay();
        Log.showDebug(TAG, `api8New onCreate, dis: ${JSON.stringify(dis)}`);
        let rect;
        if (dis.width > dis.height) { // Pad、PC horizontalScreen Mode
            rect = {
                left: 0,
                top: 0,
                width: '100%',
                height: (48 * dis.width) / 1280,
            }
        } else { // Phone verticalScreen Mode
            rect = {
                left: 0,
                top: 0,
                width: '100%',
                height: (48 * dis.width) / 720
            }
        }
        AbilityManager.setAbilityData(AbilityManager.ABILITY_NAME_STATUS_BAR, "rect", rect);
        AbilityManager.setAbilityData(AbilityManager.ABILITY_NAME_STATUS_BAR, "dis", {
            width: dis.width,
            height: dis.height,
        });
        Log.showInfo(TAG, `createWindow success.`);
    }

    onDestroy() {
        Log.showInfo(TAG, 'api8New onDestroy');
        sTimeManager.release()

    }
}

export default ServiceExtAbility