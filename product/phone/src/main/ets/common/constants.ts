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

export default class Constants {

  //touch mode
  static TOUCHTYPE_DOWN: number = 0;
  static TOUCHTYPE_UP: number  = 1;
  static TOUCHTYPE_MOVE: number  = 2;

  //layout params - Pic
  static FULL_CONTAINER_WIDTH = '100%'
  static FULL_CONTAINER_HEIGHT = '100%'
  static NOTIFICATION_AREA_WIDTH = '96%'
  static NOTIFICATION_AREA_HEIGHT = '40%'
  static LOCKICON_AREA_WIDTH = '15%'
  static P_LOCKICON_AREA_WIDTH = '77vp'
  static DATETIME_AREA_WIDTH = '20%'
  static P_DATETIME_AREA_WIDTH = '123vp'

  static PASSWORD_AREA_WIDTH = '312vp'

  static STATUS_ABOUT_TO_APPEAR  = 1
  static STATUS_ABOUT_TO_DISAPPEAR = 2
  static STATUS_ON_PAGE_SHOW = 3
  static STATUS_ON_PAGE_HIDE = 4
}