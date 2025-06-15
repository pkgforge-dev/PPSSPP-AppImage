# PPSSPP-AppImage

# This AppImage is now available directly on ppsspp: https://github.com/hrydgard/ppsspp/pull/20464

-------------------------------------------------------------------------------------------------------------------


AppImage made using [sharun](https://github.com/VHSgunzo/sharun), which makes it extremely easy to turn any binary into a portable package without using containers or similar tricks.

**This AppImage bundles everything and should work on any linux distro, even on musl based ones.**

It is possible that this appimage may fail to work with appimagelauncher, I recommend these alternatives instead: 

* [AM](https://github.com/ivan-hc/AM) `am -e pkgforge-dev/ppsspp-appimage ppsspp`

* [dbin](https://github.com/xplshn/dbin) `dbin install ppsspp.appimage`

* [soar](https://github.com/pkgforge/soar) `soar install ppsspp`

This appimage works without fuse2 as it can use fuse3 instead, it can also work without fuse at all thanks to the [uruntime](https://github.com/VHSgunzo/uruntime)

<details>
  <summary><b><i>raison d'être</i></b></summary>
    <img src="https://github.com/user-attachments/assets/d40067a6-37d2-4784-927c-2c7f7cc6104b" alt="Inspiration Image">
  </a>
</details>
