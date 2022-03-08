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

import Log from '../../../../../../../../../common/src/main/ets/default/Log.ets'
import Constants from '../../common/constants.ets'
import NumkeyBoard from './numkeyBoard.ets'
import ViewModel  from '../../vm/customPSDViewModel.ets'

const TAG = 'ScreenLock-CustomPSD'

@Component
export default struct CustomPSD {
  @State mViewModel: ViewModel = new ViewModel()

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear`)
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisappear`)
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.End }) {
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.End }) {
        Text(this.mViewModel.prompt)
          .fontSize($r('app.float.custompsd_prompt_fontsize'))
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .margin({ bottom: $r('app.float.custompsd_prompt_margin_bottom') })
          .textAlign(TextAlign.Center)
          .textOverflow({ overflow: TextOverflow.None })
          .width($r('app.float.custompsd_prompt_width'))
          .height($r('app.float.custompsd_prompt_height'))

        TextInput({ placeholder: '', text: this.mViewModel.password })
          .type(InputType.Password)
          .maxLength(Constants.PASSWORD_MAX_LEN)
          .fontSize($r('app.float.custompsd_prompt_fontsize'))
          .width($r('app.float.custompsd_input_width'))
          .height($r('app.float.custompsd_input_height'))
          .backgroundColor(Color.White)
          .enterKeyType(EnterKeyType.Done)
          .border({ width: 2, color: Color.Gray, radius: 15 })
          .enabled(false)
          .margin({ bottom: $r('app.float.custompsd_input_margin_bottom') })

        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
          Text($r('app.string.emergency_call'))
            .fontSize($r('app.float.custompsd_prompt_fontsize'))
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
            .textAlign(TextAlign.Center)
            .textOverflow({ overflow: TextOverflow.None })
            .onClick(this.mViewModel.onCallPhone.bind(this.mViewModel))

          Text($r('app.string.done'))
            .fontSize($r('app.float.custompsd_prompt_fontsize'))
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
            .textAlign(TextAlign.Center)
            .textOverflow({ overflow: TextOverflow.None })
            .onClick(() => {
              Log.showInfo(TAG, `onClick`)
              this.mViewModel.onAuthPassword(() => {
                Log.showInfo(TAG, `onClick callback promptText:${JSON.stringify(this.mViewModel.prompt)}`)
              });
            })
        }
        .width(Constants.HALF_CONTAINER_WIDTH)
      }
      .width(Constants.FULL_CONTAINER_WIDTH)
      .height($r('app.float.custompsd_input_area_height'))
      .margin({ bottom: $r('app.float.custompsd_passwdmask_margin_bottom') })

      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.End }) {
        NumkeyBoard({
          onKeypress: (index, callback) => this.mViewModel.onKeyPress(index, callback)
        })
      }
      .width(Constants.FULL_CONTAINER_WIDTH)
      .height($r('app.float.custompsd_key_area_height'))
      .margin({ bottom: $r('app.float.custompsd_key_area_margin_bottom') })
    }
    .width(Constants.FULL_CONTAINER_WIDTH)
  }
}