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
import Log from '../../../../../../../../common/src/main/ets/default/Log.ets'
import ScreenLockMar from '@ohos.screenlock';
import windowManager  from '@ohos.window'
import Constants from '../common/constants.ets'
import UserIDM  from '@ohos.useridm'
import UserAuth from '@ohos.userauth'
import PinAuth from '@ohos.pinauth'
import util from '@ohos.util';

const TAG = 'ScreenLock-ScreenLockModel';

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

export default class ScreenLockModel {
  static UserIdentityManager = new UserIDM.UserIdentityManager();
  static UserAuthManager = new UserAuth.UserAuth();
  static PINAuthManager = new PinAuth.PINAuth();

  static eventListener(typeName: string, callback) {
    Log.showInfo(TAG, `eventListener:typeName ${typeName}`);
    ScreenLockMar.on(typeName, (err, data) => {
      Log.showInfo(TAG, `eventListener:callback err:${JSON.stringify(err)}  data:${JSON.stringify(data)}`);
      callback(data);
    })
  }

  static sendScreenLockEvent(typeName: string, typeNo: number, callback) {
    Log.showInfo(TAG, `sendScreenLockEvent: typeName ${typeName} typeNo  ${typeNo} `);
    ScreenLockMar.sendScreenLockEvent(typeName, typeNo, (err, data) => {
      Log.showInfo(TAG, `sendScreenLockEvent:callback err:${JSON.stringify(err)}  data:${JSON.stringify(data)}`);
      callback(err, data);
    })
  }

  static showScreenLockWindow(callback) {
    Log.showInfo(TAG, 'showScreenLockWindow');
    windowManager.find(Constants.WIN_NAME).then((win) => {
      Log.showInfo(TAG, 'find window finish');
      win.show().then(() => {
        Log.showInfo(TAG, `window show`);
        callback();
      })
    })
  }

  static hiddenScreenLockWindow(callback) {
    Log.showInfo(TAG, 'hiddenScreenLockWindow');
    windowManager.find(Constants.WIN_NAME).then((win) => {
      Log.showInfo(TAG, 'find window finish');
      win.hide().then(() => {
        Log.showInfo(TAG, `window hide`);
        callback();
      })
    })
  }

  static openIDMSession(callback) {
    Log.showInfo(TAG, 'openIDMSession');
    ScreenLockModel.UserIdentityManager.openSession().then((credentialId) => {
      Log.showInfo(TAG, `openIDMSession credentialId:${credentialId}`);
      callback(credentialId);
    }).catch((error) => {
      Log.showInfo(TAG, `openIDMSession error:${JSON.stringify(error)}`);
    })
  }

  static closeIDMSession() {
    Log.showInfo(TAG, 'closeIDMSession');
    ScreenLockModel.UserIdentityManager.closeSession();
  }

  static authUser(userId: number, challenge, callback) {
    Log.showInfo(TAG, `authUser param: userId ${userId} challenge ${challenge}`);
    ScreenLockModel.UserAuthManager.authUser(userId, challenge, AuthType.PIN,
      AuthTurstLevel.ATL4, {
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

  static getAuthProperty(authType, keyArray, callback) {
    Log.showInfo(TAG, `getAuthProperty param: authType ${authType} keyArray ${keyArray}`);
    let request = {
      'authType': authType,
      'keys': keyArray
    }
    ScreenLockModel.UserAuthManager.getProperty(request).then((properties) => {
      Log.showInfo(TAG, `getAuthProperty properties ${JSON.stringify(properties)}`);
      callback(properties)
    })
  }

  static registerPWDInputer(passType, password): Promise<void> {
    Log.showInfo(TAG, `registerPWDInputer`);
    return new Promise(function (resolve, reject) {
      let result = ScreenLockModel.registerInputer(passType, password);
      if (!result) {
        Log.showInfo(TAG, `registerPWDInputer again`);
        ScreenLockModel.unregisterInputer();
        ScreenLockModel.registerInputer(passType, password);
      }
      if (result) {
        resolve();
      } else {
        reject();
      }
    })
  }

  static registerInputer(passType, password): boolean {
    Log.showInfo(TAG, `registerInputer`);
    let result = ScreenLockModel.PINAuthManager.registerInputer({
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

  static unregisterInputer() {
    Log.showInfo(TAG, `unregisterInputer`);
    ScreenLockModel.PINAuthManager.unregisterInputer();
  }
}
