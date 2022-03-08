/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import account_osAccount from '@ohos.account.osAccount'
import commonEvent from '@ohos.commonEvent';
import Log from '../../../../../../../../common/src/main/ets/default/Log.ets'
import {UserData} from '../data/userData.ets'

const TAG = "ScreenLock-AccountsModel"
const TYPE_ADMIN = 0;
const TYPE_NORMAL = 1;
const TYPE_GUEST = 2;

let mCommonEventSubscribeInfo = {
  events: [
    commonEvent.Support.COMMON_EVENT_USER_ADDED,
    commonEvent.Support.COMMON_EVENT_USER_REMOVED
  ]
};

let mEventSubscriber

export default class AccountsModel {
  modelInit() {
    Log.showInfo(TAG, "start ModelInit")
    this.getAllUsers()
    commonEvent.createSubscriber(mCommonEventSubscribeInfo, this.createSubscriberCallBack.bind(this));
    Log.showInfo(TAG, "start ModelInit finish")
  }

  private createSubscriberCallBack(err, data) {
    Log.showInfo(TAG, "start createSubscriberCallBack " + JSON.stringify(data))
    mEventSubscriber = data
    commonEvent.subscribe(data, this.getAllUsers.bind(this));
    Log.showInfo(TAG, "start createSubscriberCallBack finish")
  }

  private getAllUsers() {
    Log.showInfo(TAG, "start getAllUsers")
    let tempLink = AppStorage.SetAndLink('userList', []);
    let accountList = tempLink.get();
    let count = accountList.length;
    accountList.splice(0, count)
    Log.showInfo(TAG, "start query")
    account_osAccount.getAccountManager().queryAllCreatedOsAccounts().then((list) => {
      Log.showInfo(TAG, "start sort")
      list.sort(this.sortAccount.bind(this));
      for (const user of list) {
        Log.showInfo(TAG, "start get user" + JSON.stringify(user))
        if (user.isActived) {
          AppStorage.SetOrCreate('userId', user.localId)
        }
        account_osAccount.getAccountManager().getOsAccountProfilePhoto(user.localId).then((path) => {
          Log.showInfo(TAG, "start get photo:" + path)
          let userData: UserData = {
            userId: user.localId,
            userName: user.localName,
            userIconPath: path
          }
          accountList.push(userData)
        })
      }
    })
  }

  private sortAccount(info1, info2): number {
    if (info1.isActived || info2.isActived) {
      return info1.isActived ? -1 : 1;
    } else if (info1.type.ADMIN == TYPE_ADMIN || info2.type.ADMIN == TYPE_ADMIN) {
      return info1.type.ADMIN == TYPE_ADMIN ? -1 : 1;
    } else if ( info1.type.GUEST == TYPE_GUEST || info2.type.GUEST == TYPE_GUEST) {
      return info1.type.GUEST == TYPE_GUEST ? 1 : -1;
    } else {
      return info2.localId - info1.localId;
    }
  }


  onUserSwitch(userId: number) {
    Log.showInfo(TAG, "onUserSwitch:" + userId)
    account_osAccount.getAccountManager().activateOsAccount(userId).then(() => {
      Log.showInfo(TAG, "activateOsAccount")
    })
    Log.showInfo(TAG, "onUserSwitch:" + userId + "finish")
  }

  modelFinish() {
    Log.showInfo(TAG, "start modelFinish")
    commonEvent.unsubscribe(mEventSubscriber);
  }
}