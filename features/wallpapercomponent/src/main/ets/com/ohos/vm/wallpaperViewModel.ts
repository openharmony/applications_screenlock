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

import WallpaperMar from '@ohos.app.wallpaperability'
import Log from '../../../../../../../../common/src/main/ets/default/Log.ets'
//TODO:import image from '@ohos.multimedia.image'

const TAG = 'ScreenLock-WallpaperViewModel'

export default class WallpaperViewModel {
    screenlockWallpaper: string = ''

    ViewModelInit(): void{
        Log.showInfo(TAG, 'ViewModelInit');
        this.getScreenLockWallpaper()
    }

    private getScreenLockWallpaper() {
        Log.showInfo(TAG, 'getScreenLockWallpaper');
        WallpaperMar.getPixelMap(WallpaperMar.WALLPAPER_LOCKSCREEN, (error, data) => {
            if (error != undefined && error != null) {
                Log.showInfo(TAG, 'getScreenLockWallpaper error:' + JSON.stringify(error));
            } else {
                Log.showInfo(TAG, 'getScreenLockWallpaper data:' + JSON.stringify(data));
                this.screenlockWallpaper = data
            }
        })
    }
}
