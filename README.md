<p align="center">
  <img src="Sources/hee-button/Resources/hero.png" alt="HeeButton in the menu bar" width="480">
</p>

# HeeButton

Mac の menu bar に へ〜ボタンを置けます。意味？ ないです。

## Icons

Pick one from the right-click **Icon** menu:

| <img src="Sources/hee-button/Resources/hee-simple-blue@2x.png" width="36" height="36" alt="Simple Blue"> | <img src="Sources/hee-button/Resources/he-simple@2x.png" width="36" height="36" alt="Simple"> | <img src="Sources/hee-button/Resources/button@2x.png" width="36" height="36" alt="Button"> |
|:--:|:--:|:--:|
| Simple Blue (default) | Simple | Button |

## Install

### Download

[**releases/latest**](https://github.com/kujiy/hee-button/releases/latest) から `.app` をダウンロードして `/Applications` に移動し、

```sh
xattr -dr com.apple.quarantine /Applications/HeeButton.app
open -a HeeButton
```

### Homebrew

```sh
brew install kujiy/homebrew-tap/hee-button
xattr -dr com.apple.quarantine /Applications/HeeButton.app
open -a HeeButton
```
