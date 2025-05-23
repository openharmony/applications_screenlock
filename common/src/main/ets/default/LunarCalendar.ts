/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
export function ConvertLunarCalendar(gregorianCalendarYear, gregorianCalendarMonth, gregorianCalendarDay) {
    let lunarIndex1 = 2,
        lunarIndex2 = 9,
        lunarIndex3 = 10,
        lunarIndex4 = 11,
        lunarDay1 = 20,
        lunarDay2 = 21,
        hour = 24,
        minutes = 60,
        multiple = 1000,
        initialLunarTime = 1949

    let lunarMonth = ['正', '二', '三', '四', '五', '六', '七', '八', '九', '十', '冬', '腊'],
        lunarDay = ['一', '二', '三', '四', '五', '六', '七', '八', '九', '十', '初', '廿'],
        heavenlyStemsAnd = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'],
        earthlyBranches = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];

    let LUNAR_MON_START_INDEX = 0
    let LUNAR_MON_END_INDEX = 11

    let lunarCalendar = [
        0x0b557,
        0x06ca0, 0x0b550, 0x15355, 0x04da0, 0x0a5b0, 0x14573, 0x052b0, 0x0a9a8, 0x0e950, 0x06aa0,
        0x0aea6, 0x0ab50, 0x04b60, 0x0aae4, 0x0a570, 0x05260, 0x0f263, 0x0d950, 0x05b57, 0x056a0,
        0x096d0, 0x04dd5, 0x04ad0, 0x0a4d0, 0x0d4d4, 0x0d250, 0x0d558, 0x0b540, 0x0b6a0, 0x195a6,
        0x095b0, 0x049b0, 0x0a974, 0x0a4b0, 0x0b27a, 0x06a50, 0x06d40, 0x0af46, 0x0ab60, 0x09570,
        0x04af5, 0x04970, 0x064b0, 0x074a3, 0x0ea50, 0x06b58, 0x055c0, 0x0ab60, 0x096d5, 0x092e0,
        0x0c960, 0x0d954, 0x0d4a0, 0x0da50, 0x07552, 0x056a0, 0x0abb7, 0x025d0, 0x092d0, 0x0cab5,
        0x0a950, 0x0b4a0, 0x0baa4, 0x0ad50, 0x055d9, 0x04ba0, 0x0a5b0, 0x15176, 0x052b0, 0x0a930,
        0x07954, 0x06aa0, 0x0ad50, 0x05b52, 0x04b60, 0x0a6e6, 0x0a4e0, 0x0d260, 0x0ea65, 0x0d530,
        0x05aa0, 0x076a3, 0x096d0, 0x04afb, 0x04ad0, 0x0a4d0, 0x1d0b6, 0x0d250, 0x0d520, 0x0dd45,
        0x0b5a0, 0x056d0, 0x055b2, 0x049b0, 0x0a577, 0x0a4b0, 0x0aa50, 0x1b255, 0x06d20, 0x0ada0,
        0x14b63, 0x09370, 0x049f8, 0x04970, 0x064b0, 0x168a6, 0x0ea50, 0x06b20, 0x1a6c4, 0x0aae0,
        0x0a2e0, 0x0d2e3, 0x0c960, 0x0d557, 0x0d4a0, 0x0da50, 0x05d55, 0x056a0, 0x0a6d0, 0x055d4,
        0x052d0, 0x0a9b8, 0x0a950, 0x0b4a0, 0x0b6a6, 0x0ad50, 0x055a0, 0x0aba4, 0x0a5b0, 0x052b0,
        0x0b273, 0x06930, 0x07337, 0x06aa0, 0x0ad50, 0x14b55, 0x04b60, 0x0a570, 0x054e4, 0x0d160,
        0x0e968, 0x0d520, 0x0daa0, 0x16aa6, 0x056d0, 0x04ae0, 0x0a9d4, 0x0a2d0, 0x0d150, 0x0f252,
        0x0d520
    ]

    function ConvertLunarCalendar(gregorianCalendarYear, gregorianCalendarMonth, gregorianCalendarDay) {
        gregorianCalendarMonth -= 1;
        let daySpan = (Date.UTC(gregorianCalendarYear, gregorianCalendarMonth, gregorianCalendarDay) - Date.UTC(initialLunarTime, 0, leapFebruarySmallDay)) / (hour * minutes * minutes * multiple) + 1;
        let outputLunarYear, outputLunarMonth, outputLunarDay;
        for (let j = 0; j < lunarCalendar.length; j++) {
            daySpan -= lunarYearDays(lunarCalendar[j]);
            if (daySpan <= 0) {
                outputLunarYear = initialLunarTime + j;
                daySpan += lunarYearDays(lunarCalendar[j]);
                break
            }
        }
        let k = 0
        for (; k < lunarYearMonths(lunarCalendar[outputLunarYear - initialLunarTime]).length; k++) {
            daySpan -= lunarYearMonths(lunarCalendar[outputLunarYear - initialLunarTime])[k];
            if (daySpan <= 0) {
                if (hasLeapMonth(lunarCalendar[outputLunarYear - initialLunarTime]) > -1 && hasLeapMonth(lunarCalendar[outputLunarYear - initialLunarTime]) <= k) {
                    if (hasLeapMonth(lunarCalendar[outputLunarYear - initialLunarTime]) < k) {
                        outputLunarMonth = k;
                    } else if (hasLeapMonth(lunarCalendar[outputLunarYear - initialLunarTime]) === k) {
                        outputLunarMonth = '闰' + k;
                    } else {
                        outputLunarMonth = k + 1;
                    }
                } else {
                    outputLunarMonth = k + 1;
                }
                daySpan += lunarYearMonths(lunarCalendar[outputLunarYear - initialLunarTime])[k];
                break
            }
        }
        if (outputLunarMonth == undefined) {
            outputLunarMonth = (k > LUNAR_MON_END_INDEX) ? LUNAR_MON_END_INDEX + 1 : k;
            outputLunarMonth = (k == LUNAR_MON_START_INDEX) ? LUNAR_MON_START_INDEX + 1 : k;
        } else {
            outputLunarMonth = (outputLunarMonth > LUNAR_MON_END_INDEX) ? LUNAR_MON_END_INDEX + 1 : outputLunarMonth;
            outputLunarMonth = (outputLunarMonth == LUNAR_MON_START_INDEX) ? LUNAR_MON_START_INDEX + 1 : outputLunarMonth;
        }

        outputLunarDay = daySpan;
        if (hasLeapMonth(lunarCalendar[outputLunarYear - initialLunarTime]) > -1 && (typeof (outputLunarMonth) === 'string' && outputLunarMonth.indexOf('闰') > -1)) {
            let reg = /\d/.exec(outputLunarMonth)
            outputLunarMonth = `闰${lunarMonth[Number(reg)- 1]}`
        } else {
            outputLunarMonth = lunarMonth[outputLunarMonth - 1];
        }
        outputLunarYear = getHeavenlyStemsAnd(outputLunarYear) + getEarthlyBranches(outputLunarYear);
        if (outputLunarDay < lunarIndex4) {
            outputLunarDay = `${lunarDay[lunarIndex3]}${lunarDay[outputLunarDay-1]}`
        } else if (outputLunarDay > lunarIndex3 && outputLunarDay < lunarDay1) {
            outputLunarDay = `${lunarDay[lunarIndex2]}${lunarDay[outputLunarDay-lunarIndex4]}`
        } else if (outputLunarDay === lunarDay1) {
            outputLunarDay = `${lunarDay[1]}${lunarDay[lunarIndex2]}`
        } else if (outputLunarDay > lunarDay1 && outputLunarDay < leapFebruaryBigDay) {
            outputLunarDay = `${lunarDay[lunarIndex4]}${lunarDay[outputLunarDay-lunarDay2]}`
        } else if (outputLunarDay === leapFebruaryBigDay) {
            outputLunarDay = `${lunarDay[lunarIndex1]}${lunarDay[lunarIndex2]}`
        }
        return {
            lunarYear: outputLunarYear,
            lunarMonth: outputLunarMonth,
            lunarDay: outputLunarDay,
        }
    }

    function hasLeapMonth(outputLunarYear) {
        let lastHexadecimalDigit = 0xf
        if (outputLunarYear & lastHexadecimalDigit) {
            return outputLunarYear & lastHexadecimalDigit
        } else {
            return -1
        }
    }

    let leapFebruarySmallDay = 29,
        leapFebruaryBigDay = 30

    function leapMonthDays(outputLunarYear) {
        let hexadecimalFirstDigit = 0xf0000
        if (hasLeapMonth(outputLunarYear) > -1) {
            return (outputLunarYear & hexadecimalFirstDigit) ? leapFebruaryBigDay : leapFebruarySmallDay
        } else {
            return 0
        }
    }

    let convertToHexDigit = 0x8000,
        convertToHex = 0x8

    function lunarYearDays(outputLunarYear) {
        let totalDays = 0;
        for (let i = convertToHexDigit; i > convertToHex; i >>= 1) {
            let monthDays = (outputLunarYear & i) ? leapFebruaryBigDay : leapFebruarySmallDay;
            totalDays += monthDays;
        }
        if (hasLeapMonth(outputLunarYear) > -1) {
            totalDays += leapMonthDays(outputLunarYear);
        }
        return totalDays
    }

    function lunarYearMonths(outputLunarYear) {
        let monthArr = [];
        for (let i = convertToHexDigit; i > convertToHex; i >>= 1) {
            monthArr.push((outputLunarYear & i) ? leapFebruaryBigDay : leapFebruarySmallDay);
        }
        if (hasLeapMonth(outputLunarYear)) {
            monthArr.splice(hasLeapMonth(outputLunarYear), 0, leapMonthDays(outputLunarYear));
        }
        return monthArr
    }

    let Day3 = 3

    function getHeavenlyStemsAnd(outputLunarYear) {
        let heavenlyStemsAndKey = (outputLunarYear - Day3) % lunarIndex3;
        if (heavenlyStemsAndKey === 0) heavenlyStemsAndKey = lunarIndex3;
        return heavenlyStemsAnd[heavenlyStemsAndKey - 1]
    }

    function getEarthlyBranches(outputLunarYear) {
        let monthMultiple = 12
        let EarthlyBranchesKey = (outputLunarYear - Day3) % monthMultiple;
        if (EarthlyBranchesKey === 0) EarthlyBranchesKey = monthMultiple;
        return earthlyBranches[EarthlyBranchesKey - 1]
    }

    return ConvertLunarCalendar(gregorianCalendarYear, gregorianCalendarMonth, gregorianCalendarDay)
}