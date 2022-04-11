/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import osAccount from '@ohos.account.osAccount'
import commonEvent from '@ohos.commonEvent';
import util from '@ohos.util';
import {Callback} from 'basic';
import Log from '../../../../../../../../common/src/main/ets/default/Log'
import {UserData} from '../data/userData'

const TAG = "ScreenLock-AccountsModel"
const TYPE_ADMIN = 0;
const TYPE_NORMAL = 1;
const TYPE_GUEST = 2;

export enum AuthType {
    //Authentication type pin.
    PIN = 1,
    //Authentication type face.
    FACE = 2
}

export enum AuthSubType {
    //Authentication sub type six number pin.
    PIN_SIX = 10000,
    //Authentication sub type self defined number pin.
    PIN_NUMBER = 10001,
    //Authentication sub type mixed number pin.
    PIN_MIXED = 10002,
    //Authentication sub type 2D face.
    FACE_2D = 20000,
    //Authentication sub type 3D face.
    FACE_3D = 20001
}

export enum AuthTurstLevel {
    //Authentication result trusted level 1.
    ATL1 = 10000,
    //Authentication result trusted level 2.
    ATL2 = 20000,
    //Authentication result trusted level 3.
    ATL3 = 30000,
    //Authentication result trusted level 4.
    ATL4 = 40000
}

export enum GetPropertyType {
    //Authentication remain times.
    AUTH_SUB_TYPE = 1,
    //Authentication remain times.
    REMAIN_TIMES = 2,
    //Authentication remain times.
    FREEZING_TIME = 3
}

export enum ResultCode {
    //success
    SUCCESS = 0,
    //fails
    FAIL = 1,
}

let mCurrentUserId: number = 100

export default class AccountsModel {
    userAuthManager = new osAccount.UserAuth();
    pinAuthManager = new osAccount.PINAuth();

    modelInit() {
        Log.showInfo(TAG, "start ModelInit")
        Log.showInfo(TAG, "start ModelInit finish")
    }

    eventListener(typeName: "activate" | "activating", name: string, callback: Callback<void>) {
        Log.showInfo(TAG, `eventListener:typeName ${typeName}`);
        osAccount.getAccountManager().on(typeName, name, (userId: number) => {
            Log.showInfo(TAG, `on ${typeName} callback userId = ${userId}`)
            mCurrentUserId = userId
            callback()
        })
    }

    eventCancelListener(typeName: "activate" | "activating", name: string) {
        Log.showInfo(TAG, `eventCancleListener:typeName ${typeName}`);
        osAccount.getAccountManager().off(typeName, name)
    }

    updateAllUsers() {
        this.clearAllUsers()
        // add later to avoid list not refresh
        setTimeout(() => {
            this.addAllUsers()
        }, 100);
    }

    private clearAllUsers() {
        AppStorage.SetOrCreate('userList', []);
    }

    private addAllUsers() {
        Log.showInfo(TAG, "start getAllUsers")
        let tempLink = AppStorage.SetAndLink('userList', []);
        let accountList = tempLink.get();
        let accountMap = new Map();
        Log.showInfo(TAG, "start query")
        osAccount.getAccountManager().queryAllCreatedOsAccounts().then((list) => {
            Log.showInfo(TAG, "start sort")
            list.sort(this.sortAccount.bind(this));
            for (const user of list) {
                Log.showInfo(TAG, "start get user" + JSON.stringify(user))
                if (user.isActived) {
                    mCurrentUserId = user.localId
                }
                let userData: UserData = {
                    userId: user.localId,
                    userName: user.localName,
                    userIconPath: ""
                }
                accountList.push(userData)
                accountMap.set(user.localId, userData)
                osAccount.getAccountManager().getOsAccountProfilePhoto(user.localId).then((path) => {
                    Log.showInfo(TAG, "start get photo:" + path)
                    accountMap.get(user.localId).userIconPath = path
                })
            }
        })
    }

    private sortAccount(info1, info2): number {
        if (info1.isActived || info2.isActived) {
            return info1.isActived ? -1 : 1;
        } else if (info1.type.ADMIN == TYPE_ADMIN || info2.type.ADMIN == TYPE_ADMIN) {
            return info1.type.ADMIN == TYPE_ADMIN ? -1 : 1;
        } else if (info1.type.GUEST == TYPE_GUEST || info2.type.GUEST == TYPE_GUEST) {
            return info1.type.GUEST == TYPE_GUEST ? 1 : -1;
        } else {
            return info2.localId - info1.localId;
        }
    }

    onUserSwitch(userId: number) {
        Log.showInfo(TAG, "onUserSwitch:" + userId)
        osAccount.getAccountManager().activateOsAccount(userId).then(() => {
            Log.showInfo(TAG, "activateOsAccount")
        })
        Log.showInfo(TAG, "onUserSwitch:" + userId + "finish")
    }

    authUser(challenge, authType: AuthType, authLevel: number, callback) {
        Log.showInfo(TAG, `authUser param: userId ${mCurrentUserId} challenge ${challenge}`);
        this.userAuthManager.authUser(mCurrentUserId, challenge, authType, authLevel, {
            onResult: (result, extraInfo) => {
                Log.showInfo(TAG, `authUser UserAuthManager.authUser onResult`);
                callback(result, extraInfo);
            },
            onAcquireInfo: (moduleId, acquire, extraInfo) => {
                Log.showInfo(TAG, `authUser UserAuthManager.authUser onAcquireInfo`);
            }
        }
        )
    }

    getAuthProperty(authType, callback) {
        Log.showInfo(TAG, `getAuthProperty param: authType ${authType}`);
        let keyArray = [GetPropertyType.AUTH_SUB_TYPE, GetPropertyType.REMAIN_TIMES, GetPropertyType.FREEZING_TIME]
        let request = {
            'authType': authType,
            'keys': keyArray
        }
        this.userAuthManager.getProperty(request).then((properties) => {
            Log.showInfo(TAG, `getAuthProperty properties ${JSON.stringify(properties)}`);
            callback(properties)
        })
    }

    registerPWDInputer(password: string): Promise<void> {
        Log.showInfo(TAG, `registerPWDInputer`);
        let result = this.registerInputer(password);
        if (result) {
            return Promise.resolve();
        } else {
            return Promise.reject();
        }
    }

    private registerInputer(password: string): boolean {
        Log.showInfo(TAG, `registerInputer`);
        let result = this.pinAuthManager.registerInputer({
            onGetData: (passType, inputData) => {
                Log.showInfo(TAG, `registerInputer onSetData passType:${passType}`);
                let textEncoder = new util.TextEncoder();
                let uint8PW = textEncoder.encode(password);
                Log.showInfo(TAG, `registerInputer onSetData call`);
                inputData.onSetData(passType, uint8PW);
            }
        })
        Log.showInfo(TAG, `registerInputer result:${result} `);
        return result;
    }

    unregisterInputer() {
        Log.showInfo(TAG, `unregisterInputer`);
        this.pinAuthManager.unregisterInputer();
    }

    modelFinish() {
        Log.showInfo(TAG, "start modelFinish")
    }

    isActivateAccount(callback: Callback<boolean>) {
        Log.showInfo(TAG, `isActivateAccount userId:${mCurrentUserId}`)
        osAccount.getAccountManager().isOsAccountActived(mCurrentUserId).then((isActivate) => {
            Log.showInfo(TAG, `isActivateAccount userId:${mCurrentUserId} result: ${isActivate}`)
            callback(isActivate)
        })
    }
}