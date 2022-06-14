/**
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
import { ConvertLunarCalendar } from '../../../../../common/src/main/ets/default/LunarCalendar'

export class DateTimeCommon {
  getSystemTime(isUsing24hFormat: boolean) {
    let dateTime = new Date();
    let hours = dateTime.getHours();
    if (!isUsing24hFormat && hours > 12) {
      hours = hours % 12;
    }
    let minutes = dateTime.getMinutes();
    let time = this.concatTime(hours, minutes)
    return time;
  }

  getSystemDate(): {} {
    let dateTime = new Date();
    let result = {
      'year': dateTime.getFullYear(),
      'month': dateTime.getMonth() + 1,
      'day': dateTime.getDate()
    }
    return result
  }

  getCalendarDate(): {} {
    let dateTime = new Date();
    let res = {
      'calendarYear': ConvertLunarCalendar( dateTime.getFullYear(), dateTime.getMonth() + 1, dateTime.getDate()).lunarYear,
      'calendarMonth': ConvertLunarCalendar( dateTime.getFullYear(), dateTime.getMonth() + 1, dateTime.getDate()).lunarMonth,
      'calendarDay': ConvertLunarCalendar( dateTime.getFullYear(), dateTime.getMonth() + 1, dateTime.getDate()).lunarDay
    }
    return res
  }

  getSystemWeek() {
    let dateTime = new Date();
    let days = dateTime.getDay();
    let week = this.convert(days)
    return week
  }

  concatTime(hours, minutes): string{
    return `${this.fill(hours)}:${this.fill(minutes)}`;
  };

  fill(value) {
    return (value > 9 ? "" : "0") + value;
  };

  convert(days) {
    switch (days) {
      case 0:
        return $r('app.string.sunday');
        break;
      case 1:
        return $r('app.string.monday');
        break;
      case 2:
        return $r('app.string.tuesday');
        break;
      case 3:
        return $r('app.string.wednesday');
        break;
      case 4:
        return $r('app.string.thursday');
        break;
      case 5:
        return $r('app.string.friday');
        break;
      case 6:
        return $r('app.string.saturday');
        break;
      default:
        break;
    }
  }
}

let dateTimeCommon = new DateTimeCommon();

export default dateTimeCommon as DateTimeCommon
