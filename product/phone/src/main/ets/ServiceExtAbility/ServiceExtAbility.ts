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

import ServiceExtension from '@ohos.application.ServiceExtensionAbility'
import windowManager from '@ohos.window'
import display from '@ohos.display'
import Log from '../../../../../../common/src/main/ets/default/Log.ets'
import Constants from '../../../../../../features/screenlock/src/main/ets/com/ohos/common/constants.ets'

const TAG = "ScreenLock-ServiceExtAbility"

class ServiceExtAbility extends ServiceExtension {
    onCreate(want) {
        Log.showInfo(TAG, 'onCreate, want:' + want.abilityName);
        display.getDefaultDisplay().then(dis => {
            this.createWindow(Constants.WIN_NAME, dis.width, dis.height)
        })
    }

    private createWindow(name: string, width: number, height: number) {
        Log.showInfo(TAG, `createWindow name:${name}`)
        windowManager.create(this.context, name, 2110).then((win) => {
            Log.showInfo(TAG, "before begin " + name + " window show!")
            win.resetSize(width, height).then(() => {
                Log.showInfo(TAG, name + " window resetSize in then! ")
                win.loadContent("pages/index").then(() => {
                    Log.showInfo(TAG, name + " window loadContent in then! ")
                    win.setFullScreen(true).then(() => {
                        Log.showInfo(TAG, name + "  window setFullScreen in then! ")
                        win.show().then(() => {
                            Log.showInfo(TAG, "then begin " + name + " window show in then! ");
                        })
                    })
                })
            })
        }, (error) => {
            Log.showInfo(TAG, name + " window createFailed, error.code = " + error.code)
        })
        Log.showInfo(TAG, name + " after window create")
    }

    onDestroy() {
        Log.showInfo(TAG, 'api8New onDestroy');
    }
}

export default ServiceExtAbility