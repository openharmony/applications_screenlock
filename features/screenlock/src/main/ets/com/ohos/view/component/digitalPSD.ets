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
import ViewModel from '../../vm/digitalPSDViewModel.ets'

const TAG = 'ScreenLock-DigitalPSD'

@Component
export default struct DigitalPSD {
  @State mViewModel: ViewModel = new ViewModel()
  @StorageLink('passwdMaskArr') passwdMaskArr: any[]  = this.mViewModel.passwdMaskArr

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
          .fontSize($r('app.float.digitalpsd_prompt_fontsize'))
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .margin({ bottom: $r('app.float.digitalpsd_prompt_margin_bottom') })
          .textAlign(TextAlign.Center)
          .textOverflow({ overflow: TextOverflow.None })
          .width($r('app.float.digitalpsd_prompt_width'))
          .height($r('app.float.digitalpsd_prompt_height'))

        Grid() {
          ForEach(this.passwdMaskArr, (item) => {
            GridItem() {
              Column()
                .backgroundColor(item)
                .clip(new Circle({ width: Constants.DIGITALPSD_IC_DIAMETER, height: Constants.DIGITALPSD_IC_DIAMETER }))
                .width(Constants.DIGITALPSD_IC_DIAMETER)
                .height(Constants.DIGITALPSD_IC_DIAMETER)
                .border({ width: 2, color: $r('app.color.circle_background'), radius: 45 })
                .alignItems(HorizontalAlign.Center)
            }
          })
        }
        .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr')
        .width($r('app.float.digitalpsd_passwdmask_width'))
        .height($r('app.float.digitalpsd_passwdmask_height'))
        .margin(0)
      }
      .margin({ bottom: $r('app.float.digitalpsd_passwdmask_margin_bottom') })
      .width(Constants.FULL_CONTAINER_WIDTH)
      .height( $r('app.float.digitalpsd_input_area_height'))
      .flexShrink(1)

      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.End }) {
        NumkeyBoard({
          onKeypress: (index, callback) => this.mViewModel.onKeyPress(index, callback)
        })
      }
      .width(Constants.FULL_CONTAINER_WIDTH)
      .height($r('app.float.digitalpsd_key_area_height'))
      .margin({ bottom: $r('app.float.digitalpsd_key_area_margin_bottom') })
      .flexShrink(0)
    }
    .width(Constants.FULL_CONTAINER_WIDTH)
  }
}