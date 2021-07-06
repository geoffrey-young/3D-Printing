# Voron 2.4 models, modifications, etc
#### some functional and aesthetic Voron 2.4 modifications...

---

| modifications to core Voron 2.4 parts | |
| :--- | :--- |
| [`blower_housing_rear.stl`](stl/blower_housing_rear.stl) | fix for [Voron-Afterburner issue #13](https://github.com/VoronDesign/Voron-Afterburner/issues/13) that adds additional clearance for the blower wires in the rear housing |
| [`lgx_AftB_Mount_Front.STL`](stl/lgx_AftB_Mount_Front.STL) | minor adjustments to the [Bondtech LGX mount in Discord](https://cdn.discordapp.com/attachments/635687829254701107/823914498700083220/lgx_AftB_Mount_Front.STL) that provides additional clearance for normal M3x20 screws so the toolhead mounts to the x carriage assembly properly |
| [`nozzle_probe.stl`](stl/nozzle_probe.stl) | allows for screwing down the z-endstop microswitch [`nozzle_probe.stl`](https://github.com/VoronDesign/Voron-2/blob/Voron2.4/STLs/VORON2.4/Z_Endstop/nozzle_probe.stl) from the opposite side so that you don't have to worry about the microswitch wires touching the screw heads.  both the self-tapping BOM or standard M2x10 screws work |
| [`rail_installation_guide_center_x2.stl`](stl/rail_installation_guide_center_x2.stl) | simple mod of [`rail_installation_guide_center_x2.stl`](https://github.com/VoronDesign/Voron-2/blob/Voron2.4/STLs/VORON2.4/Tools/rail_installation_guide_center_x2.stl) that makes it possible to use the guide for the gantry dual rail install.  I have no idea how people install those rails without something like this |

---

| fun and handy extras | |
| :-------------------------------- | :--- |
| [`chain-ends`](stl/chain-ends/) | modification of chain ends [found on thingiverse](https://www.thingiverse.com/thing:3993841) but a bit beefier, with 2 holes, and for both xy and z generic chains.  works well for the extrusions, AB, and z mounts, and I squeezed the holes onto the igus chain brackets without modification.  ymmv.  |
| [`exhaust_filter_grill_insert.stl`](stl/exhaust_filter_grill_insert.stl) | holds the bowden tube in place in the exhaust filter grill for folks who aren't using a filter |
| [`lgx-chain-anchor.stl `](stl/lgx-chain-anchor.stl) | afterburner chain anchor, specific to the [`lgx-cable-cover.stl `](stl/lgx-cable-cover.stl) below, as well as Igus chain mounts or my generic [`chain-ends`](stl/chain-ends/) above. the combination of the cable cover and chain anchor requires two M3x25 screws.  available in [low resolution](stl/lgx-chain-anchor-low.stl) and [fully rendered](stl/lgx-chain-anchor.stl) versions  |
| [`lgx-cable-cover.stl `](stl/lgx-cable-cover.stl) | afterburner cable cover, inspired by [Craxoor's PCB cover](https://github.com/craxoor/VoronMods/tree/master/PCB%20Cover).  I really like the style of Craxoor's cover, but the lgx needed a few things shuffled around and that model was too difficult to modify.  this was designed from scratch with sizes and holes specific to the lgx.  you may need off-sized screws (like M3x22 or something) if you don't use it with the associated cable anchor.  available in [low resolution](stl/lgx-cable-cover-low.stl) and [fully rendered](stl/lgx-cable-cover.stl) versions |
| [`lgx-gear-cover.stl `](stl/lgx-gear-cover.stl ) | little cover for the Large Gears on the LGX so it doesn't chew through the fan wires |
| [`lgx-lever-cover.stl`](stl/lgx-lever-cover.stl) | drop-in replacement for the Bondtech LGX Extruder filament pre-tension lever (also released on my [thingiverse](https://www.thingiverse.com/thing:4873766) |
| [`skirt_fan_mount.stl`](stl/skirt_fan_mount.stl) | simple mount for the skirt fans to make them more secure than tape.  uses M3 heatsets in the inward-facing side of the fans and your choice of M3 slot inserts |
| [`spider_bracket.stl`](stl/spider_bracket.stl) | mounts the spider board horizontally or vertically with a single [standard pcb din clip](https://github.com/VoronDesign/Voron-2/blob/Voron2.4/STLs/VORON2.4/Electronics_Compartment/DIN_Brackets/pcb_din_clip_x3.stl).  also released to [VoronUsers](https://github.com/geoffrey-young/VoronUsers/tree/geoffrey-young-spider_bracket/printer_mods/geoffreyyoung/spider_bracket) |
| [`spool-holder/`](stl/spool-holder/) | modification of the core spool holder for roller bearings.  requires two 608zz bearings, two M3 threaded inserts, and two M3x16 screws |
| [`squash-foot`](stl/squash-foot.stl) | squash ball foot replacement for the BOM rubber feet.  uses non-BOM M5x12 countersunk screws like the ones in [this kit](https://www.amazon.com/gp/product/B0734Q7DDG) |
| [`z-drive-main_side-inserts.stl`](stl/z-drive-main_side-inserts.stl) | some push-in bling for the side of the z-drive housing |

more to come...

