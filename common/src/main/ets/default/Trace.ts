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

import byTrace from "@ohos.bytrace";
import Log from "./Log";

export default class Trace {
  static readonly CORE_METHOD_UNLOCK_SCREEN = "unlockScreen"
  static readonly CORE_METHOD_CALL_ACCOUNT_SYSTEM = "callAccountSubsystem";
  static readonly CORE_METHOD_PASS_ACCOUNT_SYSTEM_RESULT = "passingAccountSubsystemResult";
  static readonly CORE_METHOD_HIDE_PSD_PAGE = "hidePsdPage";
  static readonly CORE_METHOD_SHOW_LOCK_SCREEN = "showLockScreen";
  static readonly CORE_METHOD_SLEEP_TO_LOCK_SCREEN = "sleepToLockScreen"

  private static readonly TRACE_TAG = 'ScreenLock:Trace';
  private static readonly RECORD_TRACE = true;
  private static readonly TRACE_LIMIT = 2000;

  private static readonly TRACE_BASE_INDEX = 10020;

  private static init() {
    Log.showInfo(this.TRACE_TAG, 'init trace parameters');
    globalThis.taskIdMap = new Map<string, number>();
    globalThis.traceIndex = Trace.TRACE_BASE_INDEX;
  }

  /**
    * start trace method
    *
    * @param {string} methodName - methodName for tracing
    */
  static start(methodName: string) {
    if (!Trace.RECORD_TRACE) return;
    if (typeof globalThis.taskIdMap === 'undefined' || typeof globalThis.traceIndex === 'undefined') {
      Trace.init();
    }
    let taskId = globalThis.taskIdMap.get(methodName);
    if (taskId == undefined) {
      taskId = globalThis.traceIndex;
      globalThis.traceIndex++;
      globalThis.taskIdMap.set(methodName, taskId);
    }
    Log.showInfo(this.TRACE_TAG, `start trace ${taskId} for ${methodName}`);
    byTrace.startTrace(this.TRACE_TAG + methodName, taskId, Trace.TRACE_LIMIT);
  }

  /**
    * stop trace method
    *
    * @param {string} methodName - methodName for tracing
    */
  static end(methodName: string) {
    if (!Trace.RECORD_TRACE) return;
    if (typeof globalThis.taskIdMap === 'undefined') {
      return;
    }
    const taskId = globalThis.taskIdMap.get(methodName);
    if (taskId == undefined) {
      Log.showError(this.TRACE_TAG, `fail to end trace name ${methodName}`);
      return;
    }
    Log.showInfo(this.TRACE_TAG, `end trace ${taskId} for ${methodName}`);
    byTrace.finishTrace(this.TRACE_TAG + methodName, taskId);
  }
}
