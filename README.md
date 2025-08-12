# Kaleidoscope K

![GitHub License](https://img.shields.io/github/license/korarei/AviUtl2_Kaleidoscope_K_Script)
![GitHub Last commit](https://img.shields.io/github/last-commit/korarei/AviUtl2_Kaleidoscope_K_Script)
![GitHub Downloads](https://img.shields.io/github/downloads/korarei/AviUtl2_Kaleidoscope_K_Script/total)
![GitHub Release](https://img.shields.io/github/v/release/korarei/AviUtl2_Kaleidoscope_K_Script)

画像を万華鏡風に加工する，AviUtl ExEdit2用スクリプト．

[ダウンロードはこちらから．](https://github.com/korarei/AviUtl2_Kaleidoscope_K_Script/releases)

[AviUtl版はこちらから．](https://github.com/korarei/AviUtl_Kaleidoscope_K_Script)

## 動作確認

- [AviUtl ExEdit2 beta6](https://spring-fragrance.mints.ne.jp/aviutl/)

## 導入・削除・更新

初期配置場所は`変形`である．

`オブジェクト追加メニューの設定`から`ラベル`を変更することで任意の場所へ移動可能．

### 導入

1.  同梱の`*.anm2`を`%ProgramData%`内の`aviutl2\\Script`フォルダまたはその子フォルダに入れる．

`beta4`以降では`aviutl2.exe`と同じ階層内の`data\\Script`フォルダ内でも可．

### 削除

1.  導入したものを削除する．

### 更新

1.  導入したものを上書きする．

## 使い方

- Center

  中心座標を指定する．この値はアンカーでも指定可能．

- Tile Scale

  万華鏡全体のスケールを変更する．タイル (繰り返し単位) がスケーリングされたとも言える．

- Tile Size

  タイルとして使用する領域サイズを割合で指定する．200.0のとき，画像の縦と横のうち大きい方のサイズとなる．

- Rotation

  タイルを回転させる．

- Floating Center

  `Center`で指定した場所を万華鏡の中心とする．

- Lock Center Position

  `Tile Scale`を調整した際，`Center`値をスケーリングしないかどうかを決める．`true`で固定．

- Mirroring

  万華鏡の種類を指定する．現在以下の10種類が使用可能．

  - Unfold
  
  - Wheel
  
  - Fish Head
  
  - Can Meas
  
  - Flip Flop
  
  - Flower
  
  - Dia Cross
  
  - Flipper
  
  - Starlish
  
  - Tiler

- PI

  パラメータインジェクション．ここで指定すると，設定パネルの値を上書きする．

  ```lua
  {
    cx = 0.0, -- 中心X座標 (number)
    cy = 0.0, -- 中心Y座標 (number)
    tile_scale = 100.0, -- 万華鏡全体のスケール (number)
    tile_size = 100.0, -- タイスサイズ (number)
    rotation = 0.0, -- 回転量 (number)
    floating_center = false, -- 万華鏡中心を移動させる (boolean or number)
    lock_center_pos = true, -- 中心座標をスケーリング対象外にするかどうか (boolean or number)
    mirroring = 0 -- 万華鏡の種類 (number)
  }
  ```

  `{}`は既に挿入済みであるため，PI項目では中身のみ記載する．

## License

LICENSEファイルに記載．

## Change Log

- **v1.0.1**
  - 改行コードをCRLFに変更．

  - PIでkey指定するように変更． (v1.0.0とPI項目に互換性がない．)

- **v1.0.0**
  - Release
