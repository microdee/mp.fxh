#if !defined(particles_emitter_shape_pin_fxh)
#define particles_emitter_shape_pin_fxh

#if !defined(SHAPEVOLUME_SELECTOR_PINNAME)
#define SHAPEVOLUME_SELECTOR_PINNAME "Shape Volume"

iShapeVolume SelectedShape <string uiname=SHAPEVOLUME_SELECTOR_PINNAME;string linkclass="SphereVolume,CylinderVolume,BoxVolume,TorusVolume";> = SphereVolume;

#endif