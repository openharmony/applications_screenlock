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

import Log from "./Log";
import hiSysEvent from '@ohos.hiSysEvent'

const TAG = 'SystemFaultLogger';
const APP_DOMAIN: string = "SYSTEMUI_APP";
const APP_LOG_NAME: string = "SCREENLOCK_FAULT";

interface LogParam {
  FAULT_ID: string,
  MSG: string
}

export enum FaultID {
  MEMORY = "MEMORY_MONITOR",
  SCREEN_LOCK_MANAGER = "CONNECT_SCREENLOCKMANAGERSERVICE_ABNORMAL",
  ACCOUNT_SYSTEM = "ACCOUNTSYSTEM_CALL_ABNORMAL"
}

export function WriteFaultLog(logParam: LogParam) {
  const sysEventInfo = {
    domain: APP_DOMAIN,
    name: APP_LOG_NAME,
    eventType: hiSysEvent.EventType.FAULT,
    params: logParam
  }
  hiSysEvent.write(sysEventInfo, (err, val) => {
    Log.showInfo(TAG, "fault log params is : " + JSON.stringify(sysEventInfo))
    Log.showInfo(TAG, `write fault log result: ${val}`)
  })
}

export function SysFaultLogger(logParam: LogParam) {
  return function (target: any, propertyKey: string, descriptor: PropertyDescriptor) {
    const originalFunc = descriptor.value;
    descriptor.value = function(...args) {
      try {
        originalFunc.apply(this, args);
      }  catch (err: any) {
        Log.showInfo(TAG, "catch error in execute: " + propertyKey);
        WriteFaultLog(logParam);
      }
    };
  };
}