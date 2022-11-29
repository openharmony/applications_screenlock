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

import Log from '../../../../../../common/src/main/ets/default/Log';
import AbilityManager from '../../../../../../common/src/main/ets/default/abilitymanager/abilityManager';
import CommonStyleConfiguration from '../../../../../../common/src/main/ets/default/StyleConfiguration';
import BatteryStyleConfiguration from '../../../../../../features/batterycomponent/src/main/ets/default/common/StyleConfiguration'
import WifiStyleConfiguration from '../../../../../../features/wificomponent/src/main/ets/default/common/StyleConfiguration'
import SignalStyleConfiguration from '../../../../../../features/signalcomponent/src/main/ets/default/common/StyleConfiguration'
import ClockStyleConfiguration from '../../../../../../features/clockcomponent/src/main/ets/default/common/StyleConfiguration';
import IndexStyleConfiguration from './StyleConfiguration'

const TAG = 'Lock-StatusBar-StyleManager';

export default class StyleManager {
    static STANDARD_DISPLAY_WIDTH: number = 1280;
    static STANDARD_DISPLAY_HEIGHT: number = 800;
    static maxWidth: number = StyleManager.STANDARD_DISPLAY_WIDTH;

    static setStyle() {
        try {
            let dis = AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_STATUS_BAR, 'dis');
            Log.showInfo(TAG, `setStyle, configMaxWidth${JSON.stringify(dis.width)}`)
            StyleManager.maxWidth = dis.width;
        } catch (error) {
            Log.showDebug(TAG, `set status error:` + JSON.stringify(error));
        }

        // Common
        {
            let style: any = CommonStyleConfiguration.getCommonStyle();
            style.statusBarFontSize = StyleManager.calcScaleSizePx(14);
            style.statusBarMarginLeftRight = StyleManager.calcScaleSizePx(10);
            Log.showDebug(TAG, `setStyle ${JSON.stringify(style.statusBarFontSize)},
                ${JSON.stringify(style.statusBarMarginLeftRight)}`)
        }

        // Clock
        {
            let style: any = ClockStyleConfiguration.getClockComponentStyle();
            style.statusBarClockMaxWidth = StyleManager.calcScaleSizePx(37);
            Log.showDebug(TAG, `statusBarClockMaxWidth ${JSON.stringify(style.statusBarClockMaxWidth)}`)
        }

        // Battery-Icon
        {
            let style: any = BatteryStyleConfiguration.getBatteryComponentStyle();
            style.componentGap = StyleManager.calcScaleSizePx(6);
        }

        // Battery-Pic
        {
            let style: any = BatteryStyleConfiguration.getBatteryPicStyle();
            style.picGap = StyleManager.calcScaleSizePx(1);
            style.picBodyWidth = StyleManager.calcScaleSizePx(18.75);
            style.picBodyHeight = StyleManager.calcScaleSizePx(10.83);
            style.picBodyPadding = StyleManager.calcScaleSizePx(1);
            style.picBodyBorderWidth = StyleManager.calcScaleSizePx(1);
            style.picBorderRadius = StyleManager.calcScaleSizePx(2);
            style.picHeadBorderRadius = StyleManager.calcScaleSizePx(1);
            style.picChargingColor = '#00ff21';
            style.picLevelLowColor = '#ff0000';
            style.picHeadWidth = StyleManager.calcScaleSizePx(1.5);
            style.picHeadHeight = StyleManager.calcScaleSizePx(5);
            Log.showDebug(TAG, `picHeadHeight: ${JSON.stringify(style.picHeadHeight)}`)

        }

        // Signal-Icon
        {
            let style: any = SignalStyleConfiguration.getSignalComponentStyle();
            style.cellularImageWidth = StyleManager.calcScaleSizePx(25);
            style.cellularImageHeight = StyleManager.calcScaleSizePx(20);
            style.statusBarSignalTypeFontSize = StyleManager.calcScaleSizePx(7);
            style.statusBarSignalUnknownFontSize = StyleManager.calcScaleSizePx(12);
            style.signalTextMaxWeight = StyleManager.calcScaleSizePx(100);
            style.netSignalTextMaxWidth = StyleManager.calcScaleSizePx(18);
        }


        // Wifi-Icon
        {
            let style: any = WifiStyleConfiguration.getStartsBarWifiComponentStyle();
            style.statusBarWifiWidth = StyleManager.calcScaleSizePx(20);
            style.statusBarWifiHeight = StyleManager.calcScaleSizePx(20);
            Log.showDebug(TAG, `statusBarWifiHeight ${JSON.stringify(style.statusBarWifiHeight)}`)
        }

    }

    static number2px(n: number): string {
        return n.toString() + 'px';
    }

    static calcScaleSize(n: number): number {
        return n * StyleManager.maxWidth / StyleManager.STANDARD_DISPLAY_WIDTH;
    }

    static calcScaleSizePx(n: number): string {
        return StyleManager.number2px(StyleManager.calcScaleSize(n));
    }
}