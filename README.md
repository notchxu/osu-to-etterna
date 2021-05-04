#osutoetterna

##Instructions
1. Copy `osu_to_etterna_noteskin` over to `/NoteSkins/dance/`.
2. Copy `osu_to_etterna` over to `/Themes/`.
3. Copy your osu! skin over to `/Themes/osu_to_etterna/Graphics/OsuSkins/`.
4. In `/Themes/osu_to_etterna/metrics.ini` change the line `OsuFolder=""` to `OsuFolder="<your_osu_skin_folder>"`.
5. Delete the folder `/Save/LocalProfiles/\[your_profile_name\]/osu_to_etterna_settings/` if it exists. (You won't have to do this on first download, since this folder doesn't yet exist.)

##In-game customizations
1. From the beginning menu, go to `Options -\> Display Options -\> Appearance Options` and change `Theme` to `osu_to_etterna`.
2. In the song selection menu, go to `Player Options`.
3. Change `NoteSkin` to `osu_to_etterna_noteskin`.
4. To find your CMod from your osu!mania scroll speed, use the formula `CMod = scroll_speed * 3200/receptor_size` where `receptor_size` denotes your receptor size, and can be found in Player Options. 
5. Turn on `Customize Gameplay`, and then in gameplay you will be able to move around judgements/combo/percent/PA Count/etc.

##Setting up Etterna/pack download/etc.
Etienne has some good videos on this.

##Known issues
Q: Support for [n]key?
A: Right now, there's only support for 4k.

Q: My holds look weird.
A: Your holds will look weird if the widths and heights are not powers of 2. To fix this, open up the editor and scale the widths and heights of your hold body sprites to the nearest powers of 2. (Go to [this osu! skinning guide](https://docs.google.com/spreadsheets/d/1bhnV-CQRMy3Z0npQd9XSoTdkYxz0ew5e648S00qkJZ8/edit#gid=2074725196) to find exactly where the hold body sprites are in your skin.)

Q: My judgments/combo are too small.
A: The reason that this occurs is that you likely didn't have the double resolution sprites in your osu! skin. To fix this, use Customize Gameplay to double the zoom. You will then likely have spacing issues; to fix those, go to `/Themes/osu_to_etterna/Fonts/_osucombo.ini` and change `AdvanceExtraPixels=` from `-5` to `-2.5`.
