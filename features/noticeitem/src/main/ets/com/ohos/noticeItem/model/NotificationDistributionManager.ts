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

import Log from '../../../../../../../../../common/src/main/ets/default/Log';
import DeviceManager from '@ohos.distributedDeviceManager';
import DeviceInfo from '@ohos.deviceInfo';

const TAG = `NotificationDistributionManager`;

let distributionManager = null;

export default class NotificationDistributionManager {
  deviceManager = null

  static getInstance() {
    Log.showInfo(TAG, `getInstance`);
    if (distributionManager == null) {
      Log.showDebug(TAG, `getInstance distributionManager new`);
      distributionManager = new NotificationDistributionManager();
      distributionManager.initDeviceManager();
      return distributionManager;
    }
    Log.showDebug(TAG, `getInstance return distributionManager`);
    return distributionManager;
  }

  constructor() {
    Log.showDebug(TAG, `constructor`);
  }

  initDeviceManager() {
    Log.showInfo(TAG, `initDeviceManager`);
    try {
      this.deviceManager =DeviceManager.createDeviceManager("com.ohos.systemui");
      Log.showInfo(TAG, "createDeviceManager success");
    } catch(err) {
      Log.showError(TAG, `createDeviceManager err: ${JSON.stringify(err)}`);
      return;
    }
  }

  getTrustedDeviceDeviceName(deviceId) {
    Log.showDebug(TAG, `getTrustedDeviceDeviceName deviceId:${deviceId}`);
    let deviceName = '';
    let deviceArr:any[] = this.getTrustedDeviceListSync();
    Log.showDebug(TAG, `getTrustedDeviceDeviceName deviceArr:${deviceArr.length}`);
    if (deviceArr && deviceArr.length > 0) {
      for (let item of deviceArr) {
        if (item.deviceId == deviceId) {
          deviceName = item.deviceName;
          break;
        }
      }
    }
    return deviceName;
  }

  getTrustedDeviceListSync(): Array<any>{
    Log.showDebug(TAG, `getTrustedDeviceListSync`);
    return this.deviceManager.getAvailableDeviceListSync();
  }

  getLocalDeviceInfoSync() {
    Log.showDebug(TAG, `getLocalDeviceInfoSync`);
    let deviceInfo = {
      deviceId : this.deviceManager.getLocalDeviceId(),
      deviceName : this.deviceManager.getLocalDeviceName(),
      deviceType : this.deviceManager.getLocalDeviceType(),
      networkId : this.deviceManager.getLocalDeviceNetworkId()
    }
    return deviceInfo;
  }

  release() {
    DeviceManager.releaseDeviceManager(this.deviceManager);
  }
}

NotificationDistributionManager.getInstance();