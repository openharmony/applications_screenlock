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
import {ScreenLockStatus} from '../../../../../../../../common/src/main/ets/default/ScreenLockCommon.ets'

const TAG = 'ScreenLock-LockIconViewModel'

export default class LockIconViewModel {
  cutMessage: any= {}
  iconPath: any= {}

  ViewModelInit(): void{
    Log.showInfo(TAG, `ViewModelInit`);
    this.iconPath = $r('app.media.ic_public_lock_filled');
    this.cutMessage = $r('app.string.lock_prompt')
  }

  onStatusChange(lockStatus: ScreenLockStatus): void {
    Log.showInfo(TAG, `onStatusChange lockStatus:${lockStatus}`);
    switch (lockStatus) {
      case ScreenLockStatus.Locking:
        this.iconPath = $r('app.media.ic_public_lock_filled');
        this.cutMessage = $r('app.string.lock_prompt')
        break;
      case ScreenLockStatus.Unlock:
        this.iconPath = $r('app.media.ic_public_unlock_filled');
        this.cutMessage = $r('app.string.unlock_prompt')
        break;
      default:
        this.iconPath = $r('app.media.ic_public_lock_filled');
        this.cutMessage = $r('app.string.lock_prompt')
        break;
    }
  }
}