# Canine musculoskeletal robotic platform for veterinary orthopedic operations
### [Gihyeok Na](mailto:gihyeok2@illinois.edu), [Shoma Tanaka](mailto:tanaka.s.ca@m.titech.ac.jp), [ShihYing Chen](mailto:b09502174@ntu.edu.tw), [Yasuji Harada](mailto:yasuji@nvlu.ac.jp), [Hiroyuki Nabae](mailto:nabae.h.aa@m.titech.ac.jp), and [Koichi Suzumori](mailto:suzumori.k.aa@m.titech.ac.jp)

<p align="center">
<img width="60%" alt="HoshiRamu" src="https://github.com/user-attachments/assets/e65bed34-cb22-4fad-9f89-9c7f26b4fd0d">
</p>

---
# 目次
1. [研究概要](#1-研究概要)
2. [作業の流れ](#2-作業の流れ)
3. [ロボットの製作](#3-ロボットの製作)
    1. [骨格](#3-1-骨格)
    2. [筋肉](#3-2-筋肉)
    3. [土台](#3-3-土台)
4. [歩行動作の再現](#4-歩行動作の再現)
5. [歩行動作の比較](#5-歩行動作の比較)

# 1. 研究概要
重度の[内側膝蓋骨脱臼](https://www.qldvetspecialists.com.au/medial-patella-luxation)を持つプードルの実際の症例に基づいた筋骨格ロボットを製作する．筋骨格ロボットは動物の筋肉と類似した特性を持つ細径マッキベン型人工筋をアクチュエーターとして使用し，後肢の必須的な骨格筋が再現する．従来のコンピューターシミュレーションの筋骨格モデルでは筋肉を点と点を結ぶ大きさのない線として定義していたため，筋肉と他の組織間の相互作用が考慮されないという欠点がある．しかし，本ロボットは物理的な筋肉と骨格を持つため，そのような欠点を克服できると期待される．本ロボットを整形外科的手術に応用することで，手術前の手術計画（骨を切削する角度などの決定）および予後の予測，手術法のリハーサルなどが可能になると期待される．
本研究の実用性（実世界での適用性）を示すために，**1）正常な後肢**，**2）手術後の後肢**，**3）手術前の後肢**の3つの対照群の歩行を比較および分析する．（具体的な分析及び定量的比較手法は未定である．）**手術後の後肢**については，実際の獣医師による手術を進める．歩行のための入力はすべて同一である．**手術後の後肢**の歩行が**手術前の後肢**よりも自然であることを確認する．


# 2. 作業の流れ
本研究は大きく以下のような作業に分類される．

* ロボットの制作：ロボットの筋骨格系および土台の製作
* 歩行動作の再現：電空レギュレータによる筋肉制御
* 歩行動作の比較：同一の制御入力での各比較群の歩行動作比較

詳細は以下で説明する．

---
# 3. ロボットの製作
## 3. 1. 骨格
### 3. 1. 1. 3Dプリント

ロボットの骨は**右脚**に疾患を持つHoshiRamu（トイプードル）のCTデータに基づいている．政策の容易さと妥当性（スタンダードプードル）を考慮し骨格を**2.5倍**したものを使う．後，足を地面に立っている状態にさせるために修正した犬の骨格模型の足を使う．（大きさはHoshiRamuの足に合わせてある．）関連した各種ファイルは基本的に`\component\hindlimb_skeleton`に保存されている．
関節|意味
---|---
hip|股関節
stf (stifle)|膝関節
tlc (talocrural) |足首関節

`\component\hindlimb_skeleton\stl`にはロボットの骨格となるファイルが保存されている．以下は骨の英文名称と和文名称を示す．

英文名称|和文名称
---|---
Spine|脊椎
Pelvis|骨盤
Femur|大腿骨
Tibia|脛骨
Patella|膝蓋骨
Pes|足骨

以下は標識の区別方法を示す．
標識|意味
---|---
L/R|左/右
ball/pin_joint|ボール/ピン関節になっている
solid|内部が詰められている
mirrored|左右反転（右の正常脚用）
scaled_x2.5|2.5倍拡大されている

stlファイルはAutodesk Fusion 360によって修正されている．ファイルの容量が大きいため，研究室サーバー``のみにアップロードされている．

`\component\hindlimb_skeleton\3d_print(zotrax_m200_plus_z-ultrat)`には骨を印刷するための3Dプリントファイルが保存されている．基本的にはZotrax M200のZ-ULTRAT（Ivory色）を使用して印刷する．印刷する際，<u>配置の仕方によって失敗する可能性がある</u>ため，必ず既存のファイルを参考にすることを推奨する．なお，印刷する際には<u>z方向の位置をに2mm程度あげて印刷することを推奨する.</u>

脊椎と骨盤は別の部品となっているため，固定が必要である．なお，脊椎の上部はアルミフレームと連結される．以下の図の通りタブ加工すれば良い．作業する際には水平に注意する．

<p align="center">
<img width="60%" alt="spine and pelvis" src="https://github.com/user-attachments/assets/bb814817-7cc8-4f43-87b6-cf8c9d940ad7">
</p>

地面との摩擦を増加させるために，地面と接触する足指の部分にグルーガンを適量塗布する．

<p align="center">
<img width="30%" alt="pes" src="https://github.com/user-attachments/assets/a462f482-d951-4097-aa89-6be2ec2c578e">
</p>


### 3. 1. 2. 骨格の組立
`\component\hindlimb_skeleton\joint_and_ligament_references`には関節の接続と筋肉の付着に必要な情報が保存されている．左脚を基準として作成されているが，右足を作業する時には左右反転して見れば良い．<u>番号が一致する穴</u>を靭帯で繋げる．足首関節を繋げるときは人体の上下関係と追加穴に注意する．靭帯の長さは`\muscle_length_determination\ligament_and_muscle_lengths_short_ligaments.xlsx`にまとめてある．靭帯用のゴム紐は以下のものを使う．
* [股関節](https://www.monotaro.com/p/5835/1746/): アウトドア用ゴムロープΦ5mm
* [股関節用紐止め](https://www.monotaro.com/p/5011/2344/)
* [膝関節，足首関節](https://www.monotaro.com/p/2007/5284/?t.q=%83j%83g%83%8A%83%8B%83S%83%80): ニトリルゴム紐丸型Φ4mm
* [膝蓋骨](https://www.monotaro.com/p/2007/5257/): ニトリルゴム紐丸型Φ2.5mm

**股関節**の結合手順は以下の通りである．
1. 骨盤及び大腿骨の穴に**5.2mm**の刃を使い，電動ドリルで穴を拡張する．（この時，大腿骨のサポート剤がしっかり除去されている方が望ましい．六角レンチとハンマーなどを使用して除去できる．）
2. ゴムロープの片方に玉を結ぶ．
3. 大腿骨の外側からゴムロープ遠し，骨盤と連結する．
4. 骨盤の内側から紐止めで固定する．この際，適度に張力を調整する．

**膝関節**の結合手順は以下の通りである．<u>作業の容易さを考えて，十字靭帯（５，６番）を先にした方が良い．</u>
1. **4.1mm**の刃を使い，電動ドリルで穴を拡張することだけではなく，浅い所があるので少し深くする．
2. ゴムひもを適切な長さに切って，片方を穴に入れる．そして，印を付けて深さが分かるようにする．
3. 反対側の穴にゴムひもの反対側の端を入れ，2.と同様に印を付けて深さが分かるようにする．
4. 3.で付けた印から端までの長さを測定する．
5. 2.で付けた印から（靭帯の長さ+4.で測定した値）だけ離れたところを切る．
6. 穴に瞬間接着剤を入れ，ゴム紐を固定させる．この時ラジオペンチを使うと容易にできる．
7. 膝蓋骨の裏面と大腿骨の溝を紙やすりなどで研磨し，表面を滑らかにする．
8. 膝蓋骨の上下を確認した上に，手順2. -- 6.と同様に作業して大腿骨に繋げる．
9. **Anchor end**部品を使用して，大腿骨と脛骨を繋げる．

**足首節**の結合手順は基本的に膝関節と同じであるが，下に位置する靭帯から作業した方が良い．

靭帯を除去する時にはラジオペンチでてこの原理を使って引っ張り出す．穴に残っているゴムひもの残骸はドリルで除去する．

## 3. 2. 筋肉
### 3. 2. 1 McKibben PAM Module
### 3. 2. 2 筋肉の長さ決定

## 3. 3. 土台

# 4. 歩行動作の再現

# 5. 歩行動作の比較