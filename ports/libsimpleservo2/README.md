This is a basic wrapper around Servo. While libservo itself (/components/servo/) offers a lot of flexibility,
libsimpleservo2 (/ports/libsimpleservo2/) tries to make it easier to embed Servo, without much configuration needed.
It is limited to only one view (no tabs, no multiple rendering area).

It differs from libsimpleservo in that it does not attempt to display in a platform native widget, but instead
bootstraps its renderinng context from the context active when init_with_gl is called, and allows the final
composited output to be copied into a texture in this same context by calling fill_gl_texture.
