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
import Log from './Log';
import FileIo from '@ohos.fileio';

const TAG = 'ScreenLock-ScreenLockCommon';
const DFAULT_SIZE = 4096;
const CHAR_CODE_AT_INDEX = 0;

export enum ScreenLockStatus {
  Locking = 1,
  Unlock = 2,
  RecognizingFace = 3,
  FaceNotRecognized = 4
}

export function ReadConfigFile(fileName) {
  Log.showInfo(TAG, `readConfigFile fileName:${fileName}`);
  let stream;
  let content : string = "";
  try {
    let stream = FileIo.createStreamSync(fileName, 'r');
    Log.showInfo(TAG, `readConfigFile stream:` + stream);
    let buf = new ArrayBuffer(DFAULT_SIZE);
    let len = stream.readSync(buf);
    Log.showInfo(TAG, `readConfigFile len:` + len);
    let arr = new Uint8Array(buf);
    let charAt = ' '.charCodeAt(CHAR_CODE_AT_INDEX);
    for (let i = len;i < DFAULT_SIZE; i++) {
      arr[i] = charAt;
    }
    content = String.fromCharCode.apply(null, arr);
    Log.showDebug(TAG, `readConfigFile content:` + JSON.stringify(content));
  } catch (error) {
    Log.showError(TAG, `readConfigFile error:` + JSON.stringify(error));
    content = "";
  } finally {
    stream.closeSync();
  }
  return JSON.stringify(content);
}