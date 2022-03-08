/**
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

import Log from '../../../../../../../../../common/src/main/ets/default/Log.ets'
import ViewModel from '../../vm/batterySocViewModel.ets'
import Constants from '../../common/constants.ets'

const TAG = 'ScreenLock-BatterySoc'

@Component
export default struct BatterySoc {
  @State mViewModel: ViewModel = new ViewModel()

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear`)
    this.mViewModel.ViewModelInit()
  }

  build() {
    Text(this.mViewModel.batterySocStr)
      .fontSize($r('app.float.batterysoc_fontsize'))
      .fontColor($r('app.color.batterysoc_text_color'))
  }
}