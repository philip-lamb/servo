/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */

use crate::dom::xrcompositionlayer::XRCompositionLayer;
use dom_struct::dom_struct;

#[dom_struct]
pub struct XRCubeLayer {
    composition_layer: XRCompositionLayer,
}
