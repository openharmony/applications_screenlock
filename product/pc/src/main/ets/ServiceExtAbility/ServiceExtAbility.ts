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
import WindowManagers, { WindowType } from "../../../../../../common/src/main/ets/default/WindowManager";
import display from '@ohos.display'
import Log from '../../../../../../common/src/main/ets/default/Log'
import Constants from '../../../../../../features/screenlock/src/main/ets/com/ohos/common/constants'
import AbilityManager from '../../../../../../common/src/main/ets/default/abilitymanager/abilityManager'
import sTimeManager from '../../../../../../common/src/main/ets/default/TimeManager'
import inputMethod from '@ohos.inputMethod'

const TAG = "ScreenLock-ServiceExtAbility"
const AUTO_ROTATION_RETRICTED: number = 8

class ServiceExtAbility extends ServiceExtension {
    private direction :number;


    onCreate(want) {
        Log.showInfo(TAG, 'onCreate, want:' + want.abilityName);
        AbilityManager.setContext(AbilityManager.ABILITY_NAME_SCREEN_LOCK, this.context)
        sTimeManager.init(this.context)

        display.on("change", (id) => {
            Log.showInfo(TAG, "screenlock display change, data: " + JSON.stringify(id))
            display.getAllDisplay().then(async (arrayDisplay) => {
                Log.showInfo(TAG, "getAllDisplay : " + JSON.stringify(arrayDisplay))
                for (let display of arrayDisplay) {
                    Log.showInfo(TAG, "getAllDisplay start : " + JSON.stringify(display));
                    if (id == display.id) {
                        if (display.width > display.height) {
                            this.direction = 1;
                        } else {
                            this.direction = 2;
                        }
                        Log.showInfo(TAG, "direction change : " + this.direction)
                        AppStorage.SetOrCreate('screenlockdirection', this.direction)
                        this.resetWindow(display.width,display.height)
                        let inputMethodController = inputMethod.getController();
                        Log.showInfo(TAG, "inputMethodController: "+inputMethodController)
                        inputMethodController.hideSoftKeyboard().then(() => {
                            Log.showInfo(TAG, "Succeeded in hiding softKeyboard")
                        }).catch((err) => {
                            Log.showError(TAG, "failed to hideSoftKeyboard: " + JSON.stringify(err));
                        });
                    }
                }
            })
        })
        this.statusBarWindow()
        this.createWindow(Constants.WIN_NAME)
    }
    private async resetWindow(width: number,height:number) {
        Log.showInfo(TAG, "resetWindow width: " + width +",height:"+height)
        let window = await windowManager.find(Constants.WIN_NAME);
        Log.showInfo(TAG, "screenlock window : " + JSON.stringify(window));
        await  window.resetSize(width,height)
    }

    private createWindow(name: string) {
        Log.showDebug(TAG, `createWindow name:${name}`)
        windowManager.create(this.context, name, 2110).then((win) => {
            Log.showInfo(TAG, "before begin " + name + " window show!")
            win.setPreferredOrientation(AUTO_ROTATION_RETRICTED, (err) => {
                if (err.code) {
                    Log.showError(TAG, "failed to set window Orientation: " + JSON.stringify(err));
                }
                Log.showInfo(TAG, "succeed to set window Orientation");
            })
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
        Log.showDebug(TAG, `statusBarWindow`);
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
            this.direction =1
        } else { // Phone verticalScreen Mode
            rect = {
                left: 0,
                top: 0,
                width: '100%',
                height: (44 * dis.width) / 800
            }
            this.direction =2
        };
        AppStorage.SetOrCreate('screenlockdirection', this.direction);
        AbilityManager.setAbilityData(AbilityManager.ABILITY_NAME_STATUS_BAR, "rect", rect);
        AbilityManager.setAbilityData(AbilityManager.ABILITY_NAME_STATUS_BAR, "dis", {
            width: dis.width,
            height: dis.height,
        });
    }

    onDestroy() {
        Log.showInfo(TAG, 'api8New onDestroy');
        sTimeManager.release()
    }
}

export default ServiceExtAbility