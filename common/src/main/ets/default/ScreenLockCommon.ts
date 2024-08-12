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
import {Log} from './Log';
import {AbilityManager} from '../default/abilitymanager/abilityManager'

const TAG = 'ScreenLock-ScreenLockCommon';
export enum ScreenLockStatus {
  Locking = 1,
  Unlock = 2,
  RecognizingFace = 3,
  FaceNotRecognized = 4
}

export function ReadConfigFile(fileName, callBack:(data)=>void) {
  Log.showInfo(TAG, `readConfigFile fileName:${fileName}`);
  let jsonCfg : string = "";
  let context = AbilityManager.getContext(AbilityManager.ABILITY_NAME_SCREEN_LOCK);
  Log.showInfo(TAG, `readConfigFile context:${context}`);
  let resManager = context.resourceManager;
  Log.showInfo(TAG, `readConfigFile resManager:${resManager}`);
  resManager.getRawFile(fileName).then((data)=>{
    let content : string = String.fromCharCode.apply(null, data);
    Log.showInfo(TAG, `readDefaultFile content length: ${content.length}`);
    jsonCfg = JSON.parse(content);
    callBack(jsonCfg);
  })
  .catch((error)=>{
    Log.showError(TAG, `readDefaultFile filed: ${JSON.stringify(error)}`);
  });
}