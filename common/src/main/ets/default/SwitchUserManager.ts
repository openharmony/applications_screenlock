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

import AccountManager from "@ohos.account.osAccount";
import {Log} from "./Log";
import {createOrGet} from "./SingleInstanceHelper";

const TAG = "SwitchUserManagerSc";
const SUBSCRIBE_KEY = "SystemUiAccount";
const USER_CHANGE_EVENT = "activate";
const DELAY_TIME = 50 * 1000;
export const INVALID_USER_ID = -1;

type AccountInfo = {
  localId: number;
  localName: string;
  photo: string;
};
export type UserChangeListener = {
  userChange: (data: UserInfo) => void;
};

export class UserInfo {
  userId: number = INVALID_USER_ID;
  userName: string = "";
  userIcon: string | Resource = "";
  [key: string]: any;
}

async function getCurrentAccountInfo(): Promise<AccountInfo> {
  let accountInfos = await AccountManager.getAccountManager().queryAllCreatedOsAccounts();
  Log.showInfo(TAG, `accountInfos size:${accountInfos.length}`);
  for (let accountInfo of accountInfos) {
    Log.showDebug(TAG, `accountInfo: ${accountInfo.localId}, isActive: ${accountInfo.isActived}`);
    if (accountInfo.isActived) {
      return accountInfo;
    }
  }
  return Promise.reject("Can't get active userInfo.");
}

function parseAccountInfo(accountInfo: AccountInfo): UserInfo {
  return {
    userId: accountInfo.localId,
    userName: accountInfo.localName,
    userIcon: accountInfo.photo,
  };
}

export class SwitchUserManager {
  mUserInfo: UserInfo = new UserInfo();
  mListeners = new Set<UserChangeListener>();
  mHasWait: boolean = false;

  static getInstance(): SwitchUserManager {
    return createOrGet(SwitchUserManager, TAG);
  }

  constructor() {
    Log.showDebug(TAG, `SwitchUserManager constructor`);
    AccountManager.getAccountManager().on(USER_CHANGE_EVENT, SUBSCRIBE_KEY, this.handleUserChange.bind(this));
  }

  public async getCurrentUserInfo(): Promise<UserInfo> {
    if (this.mUserInfo.userId == INVALID_USER_ID) {
      !this.mHasWait && (await new Promise((resolve) => setTimeout(resolve, DELAY_TIME)));
      this.mHasWait = true;
      this.mUserInfo = parseAccountInfo(await getCurrentAccountInfo());
    }
    Log.showInfo(TAG, `getCurrentUserInfo userId: ${this.mUserInfo.userId}`);
    return this.mUserInfo;
  }

  public registerListener(listener: UserChangeListener) {
    this.mListeners.add(listener);
  }

  public unregisterListener(listener: UserChangeListener) {
    this.mListeners.delete(listener);
  }

  handleUserChange(accountId: number): void {
    AccountManager.getAccountManager()
      .queryOsAccountById(accountId)
      .then((accountInfo) => {
        Log.showInfo(TAG, `userChange, accountInfo: ${JSON.stringify(accountInfo)}`);
        this.mUserInfo = parseAccountInfo(accountInfo);
        this.notifyUserChange();
      })
      .catch((err) => Log.showError(TAG, `Can't query account by ${accountId}, err: ${err}`));
  }

  notifyUserChange() {
    this.mListeners.forEach((listener) => listener.userChange(this.mUserInfo));
  }
}