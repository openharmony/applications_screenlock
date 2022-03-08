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
import Log from '../../../../../../../../common/src/main/ets/default/Log.ets';
import ScreenLockModel, {AuthType, AuthSubType, GetPropertyType} from './screenLockModel';
import {ScreenLockStatus} from '../../../../../../../../common/src/main/ets/default/ScreenLockCommon.ets';
import Router from '@system.router';

const TAG = 'ScreenLock-ScreenLockService';
const URI_DIGITALPASSWORD = 'pages/digitalPassword'
const URI_MIXEDPASSWORD = 'pages/mixedPassword'
const URI_CUSTOMPASSWORD = 'pages/customPassword'


//Event type name
const EVENT_BEGIN_WAKEUP: string = 'beginWakeUp' //设备将要唤醒
const EVENT_END_WAKEUP: string = 'endWakeUp' //设备唤醒
const EVENT_BEGIN_SCREENON: string = 'beginScreenOn' //开始亮屏
const EVENT_END_SCREENON: string = 'endScreenOn' //设备亮屏
const EVENT_BEGIN_SCREENOFF: string = 'beginScreenOff' //开始灭屏
const EVENT_END_SCREENOFF: string = 'endScreenOff' //设备灭屏
const EVENT_UNLOCK_SCREEN: string = 'unlockScreen' //请求屏幕解锁
const EVENT_BEGIN_EXITANIMATION: string = 'beginExitAnimation' //动画结束
const EVENT_BEGIN_SLEEP: string = 'beginSleep' //	设备将要休眠
const EVENT_END_SLEEP: string = 'endSleep' //设备休眠
const EVENT_CHANGE_USER: string = 'changeUser' //切换用户
const EVENT_SCREENLOCK_ENABLE: string = 'screenlockEnabled' //锁屏锁屏应用是否可用

const UNLOCK_SCREEN_RESULT: string = 'unlockScreenResult' //请求解锁
const SCREENLOCK_DRAW_DONE: string = 'screenDrawDone' //	解锁界面绘制完成
const CHALLENGE_INT = 0

const MAIN_USER = 100

export enum UnlockResult {
  Success = 0,
  Fail = 1,
  Cancel = 2
}

export {AuthSubType};

export class ScreenLockService {
  init() {
    Log.showInfo(TAG, 'init');
    this.lockScreen();
    this.monitorEvents();
  }

  monitorEvents() {
    Log.showInfo(TAG, 'registered events start');

    //设备将要唤醒
    ScreenLockModel.eventListener(EVENT_BEGIN_WAKEUP, (data) => {
      Log.showInfo(TAG, `EVENT_BEGIN_WAKEUP event data:${JSON.stringify(data)}`);
      this.lockScreen();
    })

    //设备唤醒
    ScreenLockModel.eventListener(EVENT_END_WAKEUP, (data) => {
      Log.showInfo(TAG, `EVENT_END_WAKEUP event data:${JSON.stringify(data)}`);
      this.lockScreen();
    })

    //开始亮屏
    ScreenLockModel.eventListener(EVENT_BEGIN_SCREENON, (data) => {
      Log.showInfo(TAG, `EVENT_BEGIN_SCREENON event data:${JSON.stringify(data)}`);
      this.lockScreen();
    })

    //设备亮屏
    ScreenLockModel.eventListener(EVENT_END_SCREENON, (data) => {
      Log.showInfo(TAG, `EVENT_END_SCREENON event data:${JSON.stringify(data)}`);
      this.lockScreen();
    })

    //设备将要休眠
    ScreenLockModel.eventListener(EVENT_BEGIN_SLEEP, (data) => {
      Log.showInfo(TAG, `EVENT_BEGIN_SLEEP event data:${JSON.stringify(data)}`);
      this.lockScreen();
    })

    //设备休眠
    ScreenLockModel.eventListener(EVENT_END_SLEEP, (data) => {
      Log.showInfo(TAG, `EVENT_END_SLEEP event data:${JSON.stringify(data)}`);
      this.lockScreen();
    })

    //设备灭屏
    ScreenLockModel.eventListener(EVENT_END_SCREENOFF, (data) => {
      Log.showInfo(TAG, `EVENT_END_SCREENOFF event data:${JSON.stringify(data)}`);
      this.lockScreen();
    })

    //切换用户
    ScreenLockModel.eventListener(EVENT_CHANGE_USER, (data) => {
      Log.showInfo(TAG, `EVENT_CHANGE_USER event data:${JSON.stringify(data)}`);
      this.lockScreen();
    })

    //接收到屏幕解锁请求
    ScreenLockModel.eventListener(EVENT_UNLOCK_SCREEN, (data) => {
      Log.showInfo(TAG, `EVENT_UNLOCK_SCREEN event data:${JSON.stringify(data)}`);
      this.unlockScreen();
    });

    Log.showInfo(TAG, 'registered events end');
  }

  lockScreen() {
    Log.showInfo(TAG, `lockScreen`);
    let status = AppStorage.Link('lockStatus')
    Log.showInfo(TAG, `lockScreen lockStatus.get:${status?.get()}`);
    let length = Router.getLength()
    Log.showInfo(TAG, `Router.getLength: ${length}`)
    for (let index = 1;index < length; index++) {
      Log.showInfo(TAG, `back to index`);
      Router.back();
    }
    if (!!status && status.get() == ScreenLockStatus.Locking) {
      Log.showInfo(TAG, `lockScreen return`);
      return;
    }
    //set the lockStatus to 'locking'
    AppStorage.SetOrCreate('lockStatus', ScreenLockStatus.Locking);
    //lock the screen
    ScreenLockModel.showScreenLockWindow(() => {
      Log.showInfo(TAG, `showScreenLockWindow finish`);
    });
  }

  unlockScreen() {
    Log.showInfo(TAG, `unlockScreen`);
    ScreenLockModel.getAuthProperty(AuthType.PIN, [GetPropertyType.AUTH_SUB_TYPE, GetPropertyType.REMAIN_TIMES,
    GetPropertyType.FREEZING_TIME], (properties) => {
      Log.showInfo(TAG, `unlockScreen：AUTH_SUB_TYPE:${properties.authSubType}`);
      switch (properties.authSubType) {
        case AuthSubType.PIN_SIX:
          Log.showInfo(TAG, `unlockScreen Router.push:digitalPassword`);
          Router.push({ uri: URI_DIGITALPASSWORD });
          break;
        case AuthSubType.PIN_MIXED:
          Log.showInfo(TAG, `unlockScreen Router.push:mixedPassword`);
          Router.push({ uri: URI_MIXEDPASSWORD });
          break;
        case AuthSubType.PIN_NUMBER:
          Log.showInfo(TAG, `unlockScreen Router.push:customPassword`);
          Router.push({ uri: URI_CUSTOMPASSWORD });
          break;
        default:
          Log.showInfo(TAG, `unlock the screen`);
          this.unlocking();
      }
    });
  }

  unlocking() {
    Log.showInfo(TAG, `unlocking`);
    let status = AppStorage.Link('lockStatus')
    Log.showInfo(TAG, `unlocking lockStatus:${JSON.stringify(status?.get())}`);
    if (!!status && status.get() == ScreenLockStatus.Unlock) {
      Log.showInfo(TAG, `unlocking return`);
      return;
    }
    //set the lockStatus to 'Unlock'
    AppStorage.SetOrCreate('lockStatus', ScreenLockStatus.Unlock);
    //unlock the screen
    ScreenLockModel.hiddenScreenLockWindow(() => {
      Log.showInfo(TAG, `hiddenScreenLockWindow finish`);
      //notify the base service that the unlock is completed
      this.notifyScreenResult(UnlockResult.Success);
    });
  }

  notifyScreenResult(result: UnlockResult) {
    Log.showInfo(TAG, `notifyScreenResult`);
    ScreenLockModel.sendScreenLockEvent(UNLOCK_SCREEN_RESULT, result, (error, data) => {
      Log.showInfo(TAG, `notifyScreenResult: error:${JSON.stringify(error)} data:${JSON.stringify(data)}`);
    });
  }

  notifyDrawDone() {
    Log.showInfo(TAG, `notifyDrawDone`);
    //notify the base service that the screen is loaded
    ScreenLockModel.sendScreenLockEvent(SCREENLOCK_DRAW_DONE, 0, (error, result) => {
      Log.showInfo(TAG, `notifyDrawDone:  error:${JSON.stringify(error)} result:${JSON.stringify(result)}`);
    });
  }

  authUser(authSubType: AuthSubType, passwordData: number[] | string, callback): void {
    Log.showInfo(TAG, `authUser  authSubType:${authSubType}`);
    let password: string = '';
    if (typeof passwordData == 'string') {
      password = passwordData;
    } else {
      password = passwordData.join('');
    }
    ScreenLockModel.registerPWDInputer(authSubType, password).then(() => {
      Log.showInfo(TAG, `registerPWDInputer success`);
      let userIdLink = AppStorage.Link('userId');
      ScreenLockModel.authUser(userIdLink?.get() ?? MAIN_USER, CHALLENGE_INT, (result, extraInfo) => {
        Log.showInfo(TAG, `authUser  callback:${result} extraInfo:${JSON.stringify(extraInfo)}`);
        ScreenLockModel.unregisterInputer();
        callback(result, extraInfo);
      })
    }).catch(() => {
      Log.showInfo(TAG, `registerPWDInputer fails`);
    })
  }

  goBack() {
    Log.showInfo(TAG, `goBack`);
    Router.back();
    ScreenLockModel.unregisterInputer();
  }
}


let screenLockService = new ScreenLockService();

export default screenLockService as ScreenLockService;