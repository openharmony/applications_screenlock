import router from '@ohos.router'
import Constants from '../common/constants'
import StatusBar from '../../../../../../features/screenlock/src/main/ets/com/ohos/view/component/statusBar'
import AbilityManager from '../../../../../../common/src/main/ets/default/abilitymanager/abilityManager'
import call from '@ohos.telephony.call';
import Log from '../../../../../../common/src/main/ets/default/Log'

const COPS_AND_ROBBERS = '110';
const MEDICAL_FIRST_AID = '120';
const FIRE_ALARM = '119';
const TAG = 'ScreenLock-EmergencyCall';

@Styles function card() {
  .width('80%')
  .height(70)
  .padding(10)
  .backgroundColor(Color.Gray)
  .borderRadius(10)
}

@Entry
@Component
export struct EmergencyCall {
  @State mHeightPx: number = 48;

  aboutToAppear() {
    let configInfo = AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_STATUS_BAR, 'rect');
    this.mHeightPx = configInfo.height;
  }

  dialEmergencyCall(phone: string) {
    call.dialCall(phone, (err) => {
      if (err) {
        Log.showError(TAG, `dialCall fail, err->${JSON.stringify(err)}`);
      } else {
        Log.showInfo(TAG, `dialCall success`);
      }
    });
  }

  @Builder CallButtonBuilder(phone: string, name: ResourceStr) {
    Flex({justifyContent:FlexAlign.SpaceBetween,alignItems:ItemAlign.Center}) {
      Flex({direction:FlexDirection.Column,justifyContent:FlexAlign.SpaceBetween,alignItems:ItemAlign.Start}) {
        Text(phone)
          .fontSize(25)
          .fontColor($r('app.color.lock_ic_color'))
          .fontWeight(FontWeight.Medium)
        Text(name)
          .fontSize(15)
          .fontColor($r('app.color.lock_ic_color'))
      }
      Image($r('app.media.ic_call_filled_normal'))
        .objectFit(ImageFit.Contain)
        .width(30)
        .height(30)
        .fillColor($r('app.color.lock_ic_color'))
    }
    .margin({bottom:10})
    .card()
    .onClick(() => {
      switch (phone) {
        case COPS_AND_ROBBERS:
          this.dialEmergencyCall(COPS_AND_ROBBERS)
          break;
        case MEDICAL_FIRST_AID:
          this.dialEmergencyCall(MEDICAL_FIRST_AID)
          break;
        case FIRE_ALARM:
          this.dialEmergencyCall(FIRE_ALARM)
          break;
      }
    })
  }

  build() {
    Stack() {
      Image($r('app.media.bg')).width(Constants.FULL_CONTAINER_WIDTH)
        .height(Constants.FULL_CONTAINER_HEIGHT)
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
        Column() {
          StatusBar()
        }.height(this.mHeightPx + 'px')

        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceEvenly }) {
          Text($r('app.string.emergency_calls_only'))
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.lock_ic_color'))
          Column() {
            this.CallButtonBuilder(COPS_AND_ROBBERS,$r('app.string.cops_and_robbers'))
            this.CallButtonBuilder(MEDICAL_FIRST_AID,$r('app.string.medical_first_aid'))
            this.CallButtonBuilder(FIRE_ALARM,$r('app.string.fire_alarm'))
          }
          Text($r('app.string.cancel'))
            .width(50)
            .height(35)
            .textAlign(TextAlign.Center)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Medium)
            .fontSize($r('app.float.digitalpsd_prompt_fontsize'))
            .onClick(() => {
              router.back()
            })
        }
        .width(Constants.FULL_CONTAINER_WIDTH)
        .height(Constants.FULL_CONTAINER_HEIGHT)
      }
      .width(Constants.FULL_CONTAINER_WIDTH)
      .height(Constants.FULL_CONTAINER_HEIGHT)
    }
    .backgroundColor($r('app.color.page_background'))
  }
}