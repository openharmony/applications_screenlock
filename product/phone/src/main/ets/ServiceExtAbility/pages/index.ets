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

import Log from '../../../../../../../common/src/main/ets/default/Log.ets'
import {LockStyleMode} from '../../../../../../../features/screenlock/src/main/ets/com/ohos/model/screenlockStyle.ets'
import ViewModel from '../vm/indexViewModel.ets'
import SlideScreenLock from './slidescreenlock.ets'
import CustomScreenLock from './customscreenlock.ets'
import JournalScreenLock from './journalscreenlock.ets'

const TAG = 'ScreenLock-Entry';

@Entry
@Component
struct Index {
  @State mViewModel: ViewModel = new ViewModel()

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear`)
    this.mViewModel.ViewModelInit()
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisAppear`)
  }

  onPageShow() {
    Log.showInfo(TAG, `onPageShow`)
    this.mViewModel.onPageShow();
  }

  onPageHide() {
    Log.showInfo(TAG, `onPageHide`)
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      if (this.mViewModel.mode == LockStyleMode.SlideScreenLock) {
        // Slide of lock screen
        SlideScreenLock()
      } else if (this.mViewModel.mode == LockStyleMode.JournalScreenLock) {
        // TODO:Journal of lock screen
        JournalScreenLock()
      } else if (this.mViewModel.mode == LockStyleMode.CustomScreenLock) {
        // TODO:Custom lock screen
        CustomScreenLock()
      }
    }
  }
}

