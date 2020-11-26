/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */

use crate::dom::bindings::codegen::Bindings::XRViewBinding::XREye;
use crate::dom::bindings::codegen::Bindings::XRWebGLBindingBinding::XRCubeLayerInit;
use crate::dom::bindings::codegen::Bindings::XRWebGLBindingBinding::XRCylinderLayerInit;
use crate::dom::bindings::codegen::Bindings::XRWebGLBindingBinding::XREquirectLayerInit;
use crate::dom::bindings::codegen::Bindings::XRWebGLBindingBinding::XRProjectionLayerInit;
use crate::dom::bindings::codegen::Bindings::XRWebGLBindingBinding::XRQuadLayerInit;
use crate::dom::bindings::codegen::Bindings::XRWebGLBindingBinding::XRTextureType;
use crate::dom::bindings::codegen::Bindings::XRWebGLBindingBinding::XRWebGLBindingBinding::XRWebGLBindingMethods;
use crate::dom::bindings::codegen::UnionTypes::WebGLRenderingContextOrWebGL2RenderingContext;
use crate::dom::bindings::error::Error;
use crate::dom::bindings::error::Fallible;
use crate::dom::bindings::reflector::reflect_dom_object;
use crate::dom::bindings::reflector::Reflector;
use crate::dom::bindings::root::Dom;
use crate::dom::bindings::root::DomRoot;
use crate::dom::webglrenderingcontext::WebGLRenderingContext;
use crate::dom::window::Window;
use crate::dom::xrcompositionlayer::XRCompositionLayer;
use crate::dom::xrcubelayer::XRCubeLayer;
use crate::dom::xrcylinderlayer::XRCylinderLayer;
use crate::dom::xrequirectlayer::XREquirectLayer;
use crate::dom::xrframe::XRFrame;
use crate::dom::xrprojectionlayer::XRProjectionLayer;
use crate::dom::xrquadlayer::XRQuadLayer;
use crate::dom::xrsession::XRSession;
use crate::dom::xrview::XRView;
use crate::dom::xrwebglsubimage::XRWebGLSubImage;
use dom_struct::dom_struct;

#[dom_struct]
pub struct XRWebGLBinding {
    reflector: Reflector,
    session: Dom<XRSession>,
    context: Dom<WebGLRenderingContext>,
}

impl XRWebGLBinding {
    pub fn new_inherited(session: &XRSession, context: &WebGLRenderingContext) -> XRWebGLBinding {
        XRWebGLBinding {
            reflector: Reflector::new(),
            session: Dom::from_ref(session),
            context: Dom::from_ref(context),
        }
    }

    pub fn new(
        global: &Window,
        session: &XRSession,
        context: &WebGLRenderingContext,
    ) -> DomRoot<XRWebGLBinding> {
        reflect_dom_object(
            Box::new(XRWebGLBinding::new_inherited(session, context)),
            global,
        )
    }

    #[allow(non_snake_case)]
    pub fn Constructor(
        global: &Window,
        session: &XRSession,
        context: WebGLRenderingContextOrWebGL2RenderingContext,
    ) -> DomRoot<XRWebGLBinding> {
        let context = match context {
            WebGLRenderingContextOrWebGL2RenderingContext::WebGLRenderingContext(ctx) => ctx,
            WebGLRenderingContextOrWebGL2RenderingContext::WebGL2RenderingContext(ctx) => {
                ctx.base_context()
            },
        };
        XRWebGLBinding::new(global, session, &context)
    }
}

impl XRWebGLBindingMethods for XRWebGLBinding {
    /// https://immersive-web.github.io/layers/#dom-xrwebglbinding-createprojectionlayer
    fn CreateProjectionLayer(
        &self,
        _: XRTextureType,
        _: &XRProjectionLayerInit,
    ) -> Fallible<DomRoot<XRProjectionLayer>> {
        // https://github.com/servo/servo/issues/27468
        Err(Error::NotSupported)
    }

    /// https://immersive-web.github.io/layers/#dom-xrwebglbinding-createquadlayer
    fn CreateQuadLayer(
        &self,
        _: XRTextureType,
        _: &Option<XRQuadLayerInit>,
    ) -> Fallible<DomRoot<XRQuadLayer>> {
        // https://github.com/servo/servo/issues/27493
        Err(Error::NotSupported)
    }

    /// https://immersive-web.github.io/layers/#dom-xrwebglbinding-createcylinderlayer
    fn CreateCylinderLayer(
        &self,
        _: XRTextureType,
        _: &Option<XRCylinderLayerInit>,
    ) -> Fallible<DomRoot<XRCylinderLayer>> {
        // https://github.com/servo/servo/issues/27493
        Err(Error::NotSupported)
    }

    /// https://immersive-web.github.io/layers/#dom-xrwebglbinding-createequirectlayer
    fn CreateEquirectLayer(
        &self,
        _: XRTextureType,
        _: &Option<XREquirectLayerInit>,
    ) -> Fallible<DomRoot<XREquirectLayer>> {
        // https://github.com/servo/servo/issues/27493
        Err(Error::NotSupported)
    }

    /// https://immersive-web.github.io/layers/#dom-xrwebglbinding-createcubelayer
    fn CreateCubeLayer(&self, _: &Option<XRCubeLayerInit>) -> Fallible<DomRoot<XRCubeLayer>> {
        // https://github.com/servo/servo/issues/27493
        Err(Error::NotSupported)
    }

    /// https://immersive-web.github.io/layers/#dom-xrwebglbinding-getsubimage
    fn GetSubImage(
        &self,
        _: &XRCompositionLayer,
        _: &XRFrame,
        _: XREye,
    ) -> Fallible<DomRoot<XRWebGLSubImage>> {
        // https://github.com/servo/servo/issues/27468
        Err(Error::NotSupported)
    }

    /// https://immersive-web.github.io/layers/#dom-xrwebglbinding-getviewsubimage
    fn GetViewSubImage(
        &self,
        _: &XRProjectionLayer,
        _: &XRView,
    ) -> Fallible<DomRoot<XRWebGLSubImage>> {
        // https://github.com/servo/servo/issues/27468
        Err(Error::NotSupported)
    }
}
