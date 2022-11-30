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
export const WindowNameMap = {
  2112: 'navigation',
  2108: 'status',
  2111: 'volume'
};

export interface Rect {
  left: number;
  top: number;
  width: number;
  height: number;
};

export type WindowType = 'status' | 'navigation';

export default class Constants {
  static URI_VAR: string = 'dataability:///com.ohos.settingsdata.DataAbility';

  static getUriSync(key: string): string {
    return "datashare:///com.ohos.settingsdata/entry/settingsdata/SETTINGSDATA?Proxy=true&key=" + key;
  }
}