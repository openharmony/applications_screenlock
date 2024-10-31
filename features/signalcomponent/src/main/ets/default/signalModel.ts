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

import commonEvent from "@ohos.commonEvent";
import Radio from '@ohos.telephony.radio';
import Sim from '@ohos.telephony.sim';
import Observer from '@ohos.telephony.observer';
import Log from "../../../../../../common/src/main/ets/default/Log";
import Constants from './common/constants';

const TAG = 'SignalStatus-SignalModel';

let isInitObserver = false;
let commonEventData = null;

var mLevelLink;
var mTypeLink;
var mStateLink;

export class SignalModel {
  constructor() {
    mLevelLink = AppStorage.SetAndLink("cellularLevel_screenLock", Constants.CELLULAR_NO_SIM_CARD);
    mTypeLink = AppStorage.SetAndLink("cellularType_screenLock", Constants.RADIO_TECHNOLOGY_UNKNOWN);
    mStateLink = AppStorage.SetAndLink("networkState_screenLock", Constants.NET_NULL);
    this.addSubscriberListener();
  }

  initSignalModel() {
    Log.showInfo(TAG, 'initSignalModel');
    this.checkCellularStatus();
  }

  /**
   * add mms app subscriber
   */
  async addSubscriberListener() {
    let events = [Constants.COMMON_EVENT_SPN_INFO_CHANGED];
    let commonEventSubscribeInfo = {
      events: events
    };
    commonEvent.createSubscriber(commonEventSubscribeInfo, this.createSubscriberCallBack.bind(this));
  }

  createSubscriberCallBack(err, data) {
    commonEventData = data;
    commonEvent.subscribe(commonEventData, this.subscriberCallBack.bind(this));
  }

  subscriberCallBack(err, data) {
    if (data.event === Constants.COMMON_EVENT_SPN_INFO_CHANGED) {
      if (data?.parameters?.CUR_PLMN) {
        Log.showInfo(TAG, `receive stateLink: ${data.parameters.CUR_PLMN}`);
        mStateLink.set(data.parameters.CUR_PLMN);
      } else {
        Log.showError(TAG, `get stateLink failed.`);
        mStateLink.set(Constants.NET_NULL);
      }
    }
  }

  uninitSignalModel() {
    Log.showInfo(TAG, 'uninitSignalModel');
    this.unInitObserver();
  }

  /**
     * Check the connection type and signal level of cellular network
     */
  checkCellularStatus() {
    let slotId = 0;
    Sim.hasSimCard(slotId, (err, value) => {
      if (value === true) {
        Radio.getNetworkState((err, value) => {
          if (err || !value) {
            mTypeLink.set(Constants.RADIO_TECHNOLOGY_UNKNOWN);
            mLevelLink.set(Constants.CELLULAR_NO_SIM_CARD);
          } else {
            // If there is no service, no signal is displayed.
            if (value.regState != Constants.REG_STATE_IN_SERVICE) {
              mTypeLink.set(Constants.RADIO_TECHNOLOGY_UNKNOWN);
              mLevelLink.set(Constants.CELLULAR_NO_SIM_CARD);
            } else {
              mTypeLink.set(value.cfgTech);
              let type = this.updateCellularType(value.cfgTech);
              Log.showInfo(TAG, `checkCellularStatus checkCellularStatus type: ${JSON.stringify(type)}`);
              Radio.getSignalInformation(slotId, (err, value) => {
                if (err || !value || !value.length) {
                  mLevelLink.set(Constants.CELLULAR_NO_SIM_CARD);
                } else {
                  for (let i = 0; i < value.length; i++) {
                    let infoType = this.getInfoType(value[i].signalType);
                    if (type === infoType) {
                      mLevelLink.set(value[i].signalLevel);
                      Log.showInfo(TAG, `checkCellularStatus getInfoType current i: ${i}; infoType: ${JSON.stringify(infoType)}`);
                      return;
                    }
                  }
                  mLevelLink.set(0);                }
              });
            }
          }
        });
      } else {
        Log.showWarn(TAG, `hasSimCard failed to hasSimCard because`);
        mLevelLink.set(Constants.CELLULAR_NO_SIM_CARD);
        mTypeLink.set(Constants.RADIO_TECHNOLOGY_UNKNOWN);
        mStateLink.set(Constants.NET_NULL);
      }
      if (!isInitObserver) {
        this.initObserver();
      }
    });
  }

  private getInfoType(type: number): string {
    let strType: string = '×';
    switch (type) {
      case 0:
        strType = '×';
        break;
      case 1:
      case 2:
        strType = '2G';
        break;
      case 3:
      case 4:
        strType = '3G';
        break;
      case 5:
        strType = '4G';
        break;
      case 6:
        strType = '5G';
        break;
    }
    return strType;
  }

  private updateCellularType(signalType): string {
    let typeString;
    switch (signalType) {
      case Constants.RADIO_TECHNOLOGY_UNKNOWN:
        typeString = '没有 SIM 卡';
        break;
      case Constants.RADIO_TECHNOLOGY_GSM:
      case Constants.RADIO_TECHNOLOGY_1XRTT:
        typeString = '2G';
        break;
      case Constants.RADIO_TECHNOLOGY_WCDMA:
      case Constants.RADIO_TECHNOLOGY_HSPA:
      case Constants.RADIO_TECHNOLOGY_HSPAP:
      case Constants.RADIO_TECHNOLOGY_TD_SCDMA:
      case Constants.RADIO_TECHNOLOGY_EVDO:
      case Constants.RADIO_TECHNOLOGY_EHRPD:
        typeString = '3G';
        break;
      case Constants.RADIO_TECHNOLOGY_LTE:
      case Constants.RADIO_TECHNOLOGY_LTE_CA:
      case Constants.RADIO_TECHNOLOGY_IWLAN:
        typeString = '4G';
        break;
      case Constants.RADIO_TECHNOLOGY_NR:
        typeString = '5G';
        break;
      default:
        typeString = '×';
        break;
    }
    return typeString;
  }

  /**
     * init the observer of the cellular and signal
     */
  initObserver() {
    Log.showInfo(TAG, 'initObserver');
    isInitObserver = true;
    Observer.on('signalInfoChange', (signalInfoChange) => {
      this.checkCellularStatus();
    });
    Observer.on('networkStateChange', (networkState) => {
      this.checkCellularStatus();
    });
    Observer.on('simStateChange', (simStateInfo) => {
      this.checkCellularStatus();
    });
  }

  /**
     * Uninit the observer of the cellular and signal
     */
  unInitObserver() {
    Log.showInfo(TAG, 'unInitObserver');
    Observer.off('signalInfoChange');
    Observer.off('networkStateChange');
    Observer.off('simStateChange');
    isInitObserver = false;
  }
}

let mSignalModel = new SignalModel();

export default mSignalModel as SignalModel;