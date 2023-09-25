/*
 * Copyright (C) The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.amolg.flutterbarcodescanner;

import android.content.Context;

import androidx.annotation.NonNull;

import com.amolg.flutterbarcodescanner.camera.GraphicOverlay;
import com.google.android.gms.vision.MultiProcessor;
import com.google.android.gms.vision.Tracker;
import com.google.android.gms.vision.barcode.Barcode;

import java.util.List;

/**
 * Factory for creating a tracker and associated graphic to be associated with a new barcode.  The
 * multi-processor uses this factory to create barcode trackers as needed -- one for each barcode.
 */
class BarcodeTrackerFactory implements MultiProcessor.Factory<Barcode> {
    private GraphicOverlay<BarcodeGraphic> mGraphicOverlay;
    private Context mContext;

    private List<Integer> barcodeTypes;

    public BarcodeTrackerFactory(GraphicOverlay<BarcodeGraphic> mGraphicOverlay, Context mContext, List<Integer> barcodeTypes) {
        this.mGraphicOverlay = mGraphicOverlay;
        this.mContext = mContext;
        this.barcodeTypes = barcodeTypes;
        int barcodeTypeCount = 0;
        if (barcodeTypes != null) {
            barcodeTypeCount = barcodeTypes.size();
        }
        System.out.println("init BarcodeTrackerFactory with " + barcodeTypeCount + " barcode types");
    }

    @NonNull
    @Override
    public Tracker<Barcode> create(@NonNull Barcode barcode) {
        BarcodeGraphic graphic = new BarcodeGraphic(mGraphicOverlay);
        return new BarcodeGraphicTracker(mGraphicOverlay, graphic, mContext, barcodeTypes);
    }
}