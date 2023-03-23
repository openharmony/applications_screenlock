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

import Log from '../../../../../../common/src/main/ets/default/Log'
import Trace from '../../../../../../common/src/main/ets/default/Trace'
import CommonStyleManager from '../../../../../../common/src/main/ets/default/StyleManager'
import AbilityManager from '../../../../../../common/src/main/ets/default/abilitymanager/abilityManager'
import {LockStyleMode} from '../../../../../../features/screenlock/src/main/ets/com/ohos/model/screenlockStyle'
import ViewModel from '../vm/indexViewModel'
import SlideScreenLock from './slidescreenlock'
import CustomScreenLock from './customscreenlock'
import JournalScreenLock from './journalscreenlock'
import Constants from '../common/constants'
import StyleManager from '../common/StyleManager'
import Router from '@system.router';

const TAG = 'ScreenLock-Entry';

@Entry
@Component
struct Index {
  @State mViewModel: ViewModel = new ViewModel()
  @State pageStatus: number = Constants.STATUS_ABOUT_TO_APPEAR
  @State mHeightPx: number = 48

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear`)
    this.mViewModel.ViewModelInit()
    this.pageStatus = Constants.STATUS_ABOUT_TO_APPEAR
    try {
      CommonStyleManager.setAbilityPageName(TAG)
      let configInfo = AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_STATUS_BAR, 'rect')
      Log.showDebug(TAG, `configMaxWidth${JSON.stringify(configInfo.height)}`)
      this.mHeightPx = configInfo.height
      StyleManager.setStyle()
      this.pageStatus = Constants.STATUS_ABOUT_TO_APPEAR
    } catch (error) {
      Log.showError(TAG, `set status error:` + JSON.stringify(error));
    }
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisAppear`)
    this.pageStatus = Constants.STATUS_ABOUT_TO_DISAPPEAR
    this.mViewModel.ViewModelDestroy()
  }

  onPageShow() {
    Trace.end(Trace.CORE_METHOD_SLEEP_TO_LOCK_SCREEN);
    Trace.end(Trace.CORE_METHOD_SHOW_LOCK_SCREEN);
    Log.showInfo(TAG, `onPageShow`)
    this.pageStatus = Constants.STATUS_ON_PAGE_SHOW
    this.mViewModel.onPageShow();
  }

  onPageHide() {
    Log.showInfo(TAG, `onPageHide`)
    this.pageStatus = Constants.STATUS_ON_PAGE_HIDE
  }

  onBackPress(): boolean {
    let length = parseInt(Router.getLength())
    Log.showDebug(TAG, `onBackPress length: ${length}`)
    if (length > 1) {
      Router.back()
      return false
    }
    return true
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      if (this.mViewModel.mode == LockStyleMode.SlideScreenLock) {
        // Slide of lock screen
        SlideScreenLock({ pageStatus: this.pageStatus, mHeightPx: this.mHeightPx })
      } else if (this.mViewModel.mode == LockStyleMode.JournalScreenLock) {
        JournalScreenLock()
      } else if (this.mViewModel.mode == LockStyleMode.CustomScreenLock) {
        CustomScreenLock()
      }
    }
  }
}

