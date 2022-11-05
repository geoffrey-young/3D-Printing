# yet another buffer array...

| | |
| :---: | :---: |
| ![buffer](./images/buffer.jpg) | ![buffer out](./images/buffer-out.jpg) |


## why?

filament buffers are hard™

I didn't realize how hard until I ventured down this path.

I started like most do, and loyally printed some [ercf carrot patch](https://github.com/EtteGit/EnragedRabbitProject/tree/main/Carrot_Patch) units.  space limitations required me to mount them overhead, which is where things started to go sideways - every time I needed to put in new filament I had to find a chair and fsck around with the confined carrot patch space, sharp edges, filament whiplash, and whatnot - all overhead - until my shoulders hurt, cursing the entire time.  I figured there had to be a better way...  

it turns out, there really isn't.  yes, there's the nifty [buffer array usermod](https://github.com/EtteGit/EnragedRabbitProject/tree/main/usermods/ERCF-Buffer-Array), which saves on space but doesn't remove what turned out to be my main source of frustration - not having direct access to the wheel.  this alone generated so much yelling the neighbors started to complain.  beyond the carrot patch and its variants, all the solutions seem to end in a single slot *hey lets shove the filament in this little space* approach.  given my 1200mm bowden path, those weren't poised to work out well unless I made them half a mile long.

all I wanted was a lightning-fast, super-simple, overhead-mounted, expletive-free, wheel-based, wicked-dependable filament buffer solution.  how hard could it be?

this thing here is where I ended up.

honestly, I'm surprised it actually works.


## what's here

- [assembly](#assembly)
  * [BOM](#BOM)
  * [array](#array)
  * [buffer segments](#buffer-segments)
  * [tag plates](#tag-plates)
  * [other stuff](#other-stuff)
- [pictures](#pictures)
- [credits](#credits)

---


## assembly

hopefully, y'all find this pretty self explanatory, and can figure it out from the pictures.  basically, we have:

- a series of buffer slot slider thingies
- held together by a frame

that's about it.

**note:** the models are not necessarily (currently) oriented for optimal printing, but hopefully the expected orientation is obvious.

*no parts have included supports to remove, nor are supports necessary for any part.*


### BOM

BOM for a 9 slot.  hopefully this is a full, accurate list...

| item                                               | 9 filament block total |
| :---                                               | :---                   |
| m3x8                                               | 37                     |
| m3x8 flat head                                     | 18                     |
| m3x12                                              | 9                      |
| m3 nut                                             | 9                      |
| m3 heatset                                         | 27                     |
| m2x8 self tapping                                  | 63                     |
| 608 bearing                                        | 9                      |
| ecas connector                                     | 18                     |
| disc magnet (optional, depending on configuration) | 18                     |
| PTFE/FEP 4mm OD x (2.5mm or 3.0mm ID) tubing       | variable               |

plus mounting hardware if you want to use the bottom bracket to mount the array on something.

m3x6 can be substituted for all the m3x8 with no detrimental effect - the holes are long enough for both.

I used these 10x3 disc magnets [from amazon](https://www.amazon.com/dp/B09ZLFNZ4S).  ymmv.

these m2x8 hex cap self threading screws [from amazon](https://www.amazon.com/gp/product/B00YBMRAH4) are really handy, both for this and other voron projects, like klicky.


### array

currently, there is only a 9 slot version, limited by the bottom bracket and side latches.  I'll put out some 3 and 6 slot variations "soonish"

| part                                                           | description                                       | hardware       | 9 filament total |
| :---                                                           | :---                                              | :---           | :---             |
| [`array-front.stl`](stl/array-front.stl)                       | front of array                                    | m3x8           | 4                |
| [`array-front-screen.stl`](stl/array-front-screen.stl)         | front screen, to enclose the first buffer segment | m3x8 flat head | 2                |
| [`array-back.stl`](stl/array-back.stl)                         | back of the array                                 | m3x8           | 4                |
| [`array-latch-9a.stl`](stl/array-latch-9a.stl)                 | side latch                                        | m3x8           | 9                |
| [`array-latch-9b.stl`](stl/array-latch-9b.stl)                 | side latch                                        | m3x8           | 9                |
| [`array-bottom-bracket-9.stl`](stl/array-bottom-bracket-9.stl) | bottom bracket                                    | m3x8           | 9                |


### buffer segments

two top options are provided: choose either the one with two ecas connectors, or the one with one ecas and one disc magnet.

| part                                                               | description                                                   | hardware            | per filament | 9 filament total |
| :---                                                               | :---                                                          | :---                | :---         | :---             |
| [`buffer-bottom.stl`](stl/buffer-bottom.stl)                       | segment bottom                                                | m3 heatset          | 3            | 27               |
| [`buffer-top-ecas+ecas.stl`](stl/buffer-top-ecas+ecas.stl)         | segment top, both sides ecas connector                        | ecas                | 2            | 18               |
| [`buffer-top-ecas+magnet.stl`](stl/buffer-top-ecas+magnet.stl)     | segment top, one side ecas and one side disc magnet connector | ecas, disc magnet   | 1 each       | 9 each           |
| [`buffer-bowden-magnet-end.stl`](stl/buffer-bowden-magnet-end.stl) | if you use the ecas+magnet top                                | ecas, disc magnet   | 1 each       | 9 each           |
| [`buffer-screen-a.stl`](stl/buffer-screen-a.stl)                   | segment screen for wheel                                      | m3x8 flat head      | 2            | 18               |
| [`buffer-screen-b.stl`](stl/buffer-screen-b.stl)                   | segment top screen                                            | m2x8 self-threading | 7            | 63               |
| [`buffer-bearing-insert.stl`](stl/buffer-bearing-insert.stl)       | holds the wheel in place                                      | m3x12, m3 nut       | 1 each       | 9 each           |
| [`buffer-handle.stl`](stl/buffer-handle.stl)                       | segment handle                                                | m3x8                | 2            | 18               |
| [`buffer-wheel.stl`](stl/buffer-wheel.stl)                         | wheel                                                         | 608 bearing         | 1            | 9                |

the wheel is same as the ercp wheel, except with a filament hole (with marker) for easier loading.  feel free to use the stock ercp wheel instead.


### tag plates

if you mount your buffer overhead your numbers will be upside down.  you can find upside down tag plates [here](../upside-down-numbers).


### other stuff

I mounted my ercf at 90 degrees using a french cleat system, which you can find [here](../mounts/ercf-french-cleat/).

the 90 degree mounting created some challenges accessing the filament block ecas connectors, so I made [an extension](../extender/) to help.

a magnetic bowden "bridge" (plus some springs) keeps my bowden tubes straight, clear, and managed.  available [here](../mounts/bridge/).


## pictures

| | |
| :--- | :--- | 
| [![buffer](./images/buffer-thumb.jpg)](./images/buffer.jpg) |  [![buffer 2](./images/buffer-2-thumb.jpg)](./images/buffer-2.jpg)|
| [![buffer wheel](./images/buffer-wheel-1-thumb.jpg)](./images/buffer-wheel-1.jpg) |  [![buffer wheel 2](./images/buffer-wheel-2-thumb.jpg)](./images/buffer-wheel-2.jpg)|
| [![artie](./images/artie-thumb.jpg)](./images/artie.jpg) |  [![artie 2](./images/artie-2-thumb.jpg)](./images/artie-2.jpg)|


## credits

- the entire concept here started after seeing [this mmu buffer on printables.com](https://www.printables.com/model/30811-mmu-slot-buffer).  while my work isn't really a mod of that (I modeled everything myself from scratch), I did copy the latch concept nearly... verbatim?  I'm sure there's a word for it.  anyway, the latch works really well, and needless to say I coudn't have figured a mechanism like that on my own.  this project owes sincere credit and gratitude to all the work and effort over there.  many thanks!

- all the fittings and cutouts - ecas and m3 holes, bridging, etc - were taken directly from either the [ercf project](https://github.com/EtteGit/EnragedRabbitProject) or the [voron 2.4 project](https://github.com/VoronDesign/Voron-2/).  since I use blender and don't cad, I really appreciate all the community work that has gone into getting those measurements and fit tricks just right.  kudos to team voron, be they enraged or not.

- the buffer wheel is taken right from [ercf project](https://github.com/EtteGit/EnragedRabbitProject).  no need to reinvent the wheel...

- probably others - if you feel left out let me know :)
