# Another One of Inventory
もう一つのインベントリ画面を提供します。おまけ機能として、キーボード操作限定でクイックスロットを拡張します。

## 追加インベントリ画面
![キャプチャ](https://user-images.githubusercontent.com/50558182/72211763-0b189580-3514-11ea-9950-7f72576284e4.PNG)  
もう一つの小さいインベントリ画面を表示します。  

この画面は拡大縮小できます。拡大縮小するには画面右上の ◥ をドラッグしてください。  
画面ふちにカーソルを合わせると拡大縮小できそうに見えますが、正常に動作しないので必ず右上の ◥ をつまんでください

左のアイコンは分類タブです。  
上から順に
- すべてのアイテム
- 装備
- 消耗品
- レシピ
- カード類
- その他
- 素材
- クエスト
- ジェム類
- プレミアム
- 時間制限のあるアイテム
- 検索  

となります。  
検索はLuaの検索パターンが使用できます。  
画面が小さくなると一部のアイコンが隠れる場合があります、その時はホイールでスクロールしてください。  
  

![キャプチャ2](https://user-images.githubusercontent.com/50558182/72211703-1919e680-3513-11ea-841d-71db0eaec9ca.PNG)    
画面上部の空欄を右クリックするとソートできます。
- Grid View:アイテムをアイコンで表示します。（デフォルト）
- List View:アイテムをリスト表示します。
- No Sort :本アドオン独自のソートを無効化します。（この場合、本来のインベントリ画面のソートが使用されます。）
- Sort Ascending:昇順でソートします。
- Sort Descending:降順でソートします。
- Sort by Name:名前でソートします。
- Sort by Level:使用可能レベル(ジェム・カードの場合は経験値)でソートします。
- Sort by Rarity:レアリティでソートします。
- Sort by Level-Rarity:使用可能レベルでソートしたのち、同順位をレアリティでソートします。
  
ロックの解除＆有効化はALTキーを押しながら左クリックです。
インベントリ画面が消えた場合は、システムメニューのAddons→Another one of inventoryをクリックしてください。  
![キャプチャ4](https://user-images.githubusercontent.com/50558182/72212187-c3493c80-351a-11ea-870e-b2d1c5446711.PNG)  

### 注意点
* 本来のインベントリ画面とは違い、消費したor無くなったアイテムの欄は詰められません。
* アイテム数が多いと更新に時間がかかる場合があります。
* インベントリを必要とする画面が表示された場合、自動で画面中央によける機能があります。可能な限り確認していますが、すべての画面を網羅してはいません。
* カードの合成などで一旦登録したのちキャンセルすると当該アイテムが操作不能になりますが、その場合は左の分類タブをクリックして、画面を更新して下さい。

### 内部的なお話
* アイテムをドラッグすると、フレーム名を一時的に`inventory`に偽装工作しています。

## 拡張クイックスロット
おまけ機能としてクイックスロットを最大１６個拡張します。キーボード操作限定です。

### 事前準備
デフォルトでは有効になっておりませんため、  
`(TreeofSaviorのフォルダ)\addons\anotheroneofinventory\settings_alt.json`を編集し、  
`invokekey`の項目を追加してください。
(`invokekey`は大文字で入力してください。)
```json
{"version":0,"invokekey":"V"}
```

### 使い方
`invokekey`で指定したキーを押しっぱなしにすると以下の画面が表示されます。
![キャプチャ3 PNG](https://user-images.githubusercontent.com/50558182/72211759-fe943d00-3513-11ea-8290-72466edcbd10.jpg)

4x4のクイックスロットがひし形に並んでいます。  
このクイックスロットへは、スキルもしくはアイテムを登録できます。  
発動するには、方向キーを２回押してください。  
たとえば、上図のSPエリクサー(小)を発動するには ↑・→ の順に方向キーを押します。

この設定はキャラクター個別で行われます。
### 制約
クイックスロットを右クリックで発動するのとほぼ同等とお考え下さい。
* チャネリングスキル・チャージスキルは使用できません。
* 位置指定スキルはキャラクターの目の前に発動します。たまに不発します。
* 対象指定スキルは自分に対して発動します。そのため、リザレクションは無意味と化します。

### 注意点
* 文字入力中に、`invokekey`で指定したキーを押すとたまに拡張クイックスロットが表示される場合があります。  
極力回避するようにしていますが、もし発生する場合は入力ボックスをクリックしてフォーカス状態にして下さい。
# リリースノート
## v0.0.5
* よけるウインドウの追加
* バグ修正
## v0.0.4
* よけるウインドウの追加
* バグ修正
## v0.0.3
* バグ修正
## v0.0.2
* 左側ウインドウをよけた時の挙動変更
* よけるウインドウにアーツ製造を追加。
## v0.0.1
初回
