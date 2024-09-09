# Canine musculoskeletal robotic platform for veterinary orthopedic operations
### [Gihyeok Na](mailto:gihyeok2@illinois.edu), [Shoma Tanaka](mailto:tanaka.s.ca@m.titech.ac.jp), [ShihYing Chen](mailto:sychen@kth.se), [Yasuji Harada](mailto:yasuji@nvlu.ac.jp), [Hiroyuki Nabae](mailto:nabae.h.aa@m.titech.ac.jp), and [Koichi Suzumori](mailto:suzumori.k.aa@m.titech.ac.jp)

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
## 3. 1.骨格
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

`.stl`ファイルはAutodesk Fusion 360によって修正されている．ファイルの容量が大きいため，研究室サーバー`\\192.168.88.20\share\RobotLibrary\Home\OB\Na\Hoshiramu_robot\component\hindlimb_skeleton\3d_fusion`のみにアップロードされている．

`\component\hindlimb_skeleton\3d_print(zotrax_m200_plus_z-ultrat)`には骨を印刷するための3Dプリントファイルが保存されている．基本的には<u>Zotrax M200のZ-ULTRAT（Ivory色）</u>を使用して印刷する．印刷する際，<u>配置の仕方によって失敗する可能性がある</u>ため，**必ず既存のファイルを参考にする**ことを推奨する．なお，印刷する際には**z方向の位置をに2mm程度あげて印刷することを推奨する.**

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
- 股関節: [アウトドア用ゴムロープΦ5mm](https://www.monotaro.com/p/5835/1746/)
- 股関節用紐止め: [Φ5.0mm コードストッパー](https://www.monotaro.com/p/5011/2344/)
- 膝関節，足首関節: [ニトリルゴム紐丸型Φ4mm](https://www.monotaro.com/p/2007/5284/?t.q=%83j%83g%83%8A%83%8B%83S%83%80)
- 膝蓋骨: [ニトリルゴム紐丸型Φ2.5mm](https://www.monotaro.com/p/2007/5257/)

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
8. 膝蓋骨の上下を確認した上に，手順2～6と同様に作業して大腿骨に繋げる．
9. **Anchor end**部品を使用して，大腿骨と脛骨を繋げる．

**足首節**の結合手順は基本的に膝関節と同じであるが，下に位置する靭帯から作業した方が良い．

靭帯を挿入するときにはラジオペンチを利用すると簡単にできる．また，除去する時にもラジオペンチでてこの原理を使って引っ張り出す．穴に残っているゴムひもの残骸はドリルで除去する．

## 3. 2. 筋肉

### 3. 2. 1. 各筋肉の名称
空圧チャンネル番号|英文名称|和文名称|略称
---|---|---|---
1|Iliopsaos|腸腰筋|IP
2|Gluteus Medius|中殿筋|GLU
3|Biceps Femoris|大腿二頭筋|BF
4|Semitendinosus|半腱様筋|SMT
5|Rectus Femoris|大腿直筋|RF
6|Vastus Lateralis|外側広筋|VL
6|Vastus Medius|内側広筋|VM
6|Vastus Intermedius|中間広筋|VI
7|Gastrocnemius|腓腹筋|GN
8|Cranial Tibial|前脛骨筋|CT

大腿四頭筋の中で大腿直筋のみ個別で動き，残りの筋肉（外側広筋，内側広筋，中間広筋）は単体で動く．

### 3. 2. 2. McKibben PAM Module
本ロボットのアクチュエーターとして細径McKibben型人工を採択する．人工筋モジュールを作ることより，効率的な維持補修ができる．以下はモジュールを構成する部品であり，3Dプリントされる部品（7.～13.）の`.ipt`，`.stl`ファイルは`component\mckibben_pam_module`に，印刷方向などを最適に設定した印刷ファイル（mfp）は`component\mckibben_pam_module\markforged`保存されている．印刷時は<u>Markforged Onyx</u>を使用する．
- 細径McKibben型人工筋（Φ4mm）
- 空気チューブ（Φ3mm）
- [クレモナより糸（Φ0.7mm）](https://www.monotaro.com/p/0671/2755/?t.q=%83N%83%8C%83%82%83i%82%E6%82%E8%8E%85)
- [純綿水糸（約0.5mm）](https://www.monotaro.com/p/1887/8457/?t.q=%8E%85)
- [ミニタイプ 違径ユニオンストレート（Φ4x3mm）](https://www.monotaro.com/p/1041/2263/)
- [ユニオンワイ（Φ4mm）](https://www.monotaro.com/p/0914/7451/)
- Input Connector
- Input Connector Air Inlet
- Input Connector Add-on
- Terminal End
- Terminal End Add-on
- Anhcor End
- Expansion Ring（Φ4.8mm）

人工筋モジュールの制作要領は以下の通りである．

<p align="center">
<img width="100%" alt="mckibben pam module instruction" src="https://github.com/user-attachments/assets/6b0267bf-0181-486e-a51c-be1fcab1247f">
</p>

1. Anchor Endの溝に沿って**約1mm**の穴を開ける．<u>ラジオペンチなどでAnchor Endを固定してハンドドリルを使用ると容易になる．</u>同様にTerminal End Add-onにも穴を開ける．
2. クレモナより糸（腱）でAnchor EndとTerminal End Add-onを結ぶ．<u>片方を先に結って長さに沿って印をつけてから作業した方が良い．</u>結び目に軽く瞬間接着剤を付けて固定させる．多数の人工筋が接続する部分は中間にExpansion Ring（4.8mm）を追加する．<u>この時，糸の長さ（腱全体の長さからExpansion Ringの外径を引いたもの）に注意する．</u>
3. Anchor Endが挿入される骨の穴に事前に瞬間接着剤を塗布する．そして，Anchor Endをラジオペンチで押し込む．骨からAnchor Endを除去するとき，ラジオペンチを使うと良いが，うまくいかない場合は**Φ3.2mm**ドリルで除去できる．<u>大量に作る際は一気に手順1～3を反復する．</u>
4. 空圧チューブに**2mm**，**3mm**間隔で交互に印をつけ，**5mm**間隔でカッターで切断する．
5. 人工筋を適切長さで切る．このあと，片方の断面が垂直になるように綺麗に整える．
6. 人工筋のチューブを引っ張って漏出させる．このあと，チューブを印を基準で長い方（**3mm**）まで挿入し，爪楊枝で瞬間接着剤を満遍なく360度適切量塗布する．
7. 接着剤が乾燥したら人工筋のスリーブを元の位置に戻し，純綿水糸で結んで人工筋のスリーブをチューブに固定する．このあと，結び目を作って残った糸は切り取って，紐とスリーブに爪楊枝で瞬間接着剤を満遍なく360度適切量塗布する．この時，紐を基準として，**空圧チューブと近い方だけ**に接着剤を塗布する．
8. Input Connector Air Inletをラジオペンチで持ち，**3.1mm**のドリルで穴を拡張する．<u>大量に作る際は一気に手順4～7を反復する．</u>
9. 瞬間接着剤用プライマーが入っている容器（紙コップ等）にInput ConnectorとInput Connector Air Inletを入れ，表面に溶液を付ける．（大量に作るときにはこの方法が一番速い．）容器から部品鵜を出し，軽く振って乾燥させる．
10. Input ConnectorとInput Connector Air Inletが接触する部分をやすりで削る．そして，角張るところが一致するようにし，面に瞬間接着剤を塗布して接着する．このあと，接着面の隙間に満遍なく瞬間接着剤を入れて空気が漏れないようにする．
11. Input Connectorの二つの穴の壁に瞬間接着剤を塗布し，7.で制作した人工筋を各穴に挿入する．そして，隙間に接着面の隙間に満遍なく瞬間接着剤を入れて空気が漏れないようにする．
12. Input Connector Air Inletの穴に空気チューブを挿入する．この時，Input Connector Air Inletの厚みは**2mm**であるため，空気チューブに印を付けてもよい．（2mmより多少長く入っても良い．）そして，隙間に接着面の隙間に満遍なく瞬間接着剤を入れて空気が漏れないようにする．<u>大量に作る際は一気に手順8～12を反復する．</u>
13. 人工筋の長さを決めるための印がつけている状態で，人工筋のスリーブを引っ張ったまま持ち，チューブを少し切断する．
14. スリーブを指先でまとめ，Terminal Endを通す．通したTerminal Endを印まで持っていく．
15. 人工筋の印があるところをカッターで切る．そして，**約4mm**で印を付けた**Φ3mm以上**の電線を人工筋のチューブに印の部分まで挿入する．このあと，電線の印があるところをカッターで切る．
16. Terminal Endを人工筋の端まで持ってくる．<u>この時Terminal Endが人工筋から離れないように格別に注意する．</u>そして，瞬間接着剤を上部から満遍なく塗布して空気漏れがないようにする．
17. Input Connector Add-onをInput Connectorに接合する．この時，瞬間接着剤を隙間に塗布すれば良い．
18. <u>接着剤を使用せず</u>Input Connector Add-onと3.で制作したTerminal End Add-onを結合させる．同様にTerminal EndとTerminal End Add-onを結合させる．
19. 修理などの理由で特定の筋肉を交替するときには，ラジオペンチなどを用いてTerminal End Add-onからInput Connector Add-onとTerminal Endを分離する．

### 3. 2. 3. 筋肉の長さ決定
筋肉の長さ決定に必要なファイルは基本的に`\muscle_length_determination`に保存されている．モーションデータとOpenSimを用いた筋肉の長さの基本的な決め方は以下の通りである．
1. 公開されている犬のモーションデータから歩き歩容のものを選び，要らないフレームはトリミングして加工する．
    - モーションデータは[Zhang et. al., "SIGGRAPH 2018
Mode-Adaptive Neural Networks for Quadruped Motion Control"](https://starke-consult.de/AI4Animation/SIGGRAPH_2018/MotionCapture.zip)または`\\192.168.88.20\share\RobotLibrary\Home\OB\Na\Hoshiramu_robot\raw_data\motion_capture\bvh`から入手できる．
    - OpenSimで使うには`.bvh`拡張子の`.trc`拡張子への変換が必要である．トリミング，拡張子変換はAutodesk Motion Builderを使えば良い．
    - `\\192.168.88.20\share\RobotLibrary\Home\OB\Na\Hoshiramu_robot\raw_data\motion_capture`には`.trc`拡張子に変換が済んだモーションデータが保存されている．
    - 加工済のモーションデータは`\opensim_model\walking_motion.trc`である．
2. OpenSim Creatorでロボットの筋骨格モデルを作成する．
    - OpenSim Creatorの基本的な使い方は[チュートリアル文書](https://docs.opensimcreator.com/manual/en/latest/)または[チュートリアル動画](https://youtu.be/QdFV4ompxE8?si=6n_GxXH4BfBztjk0)に紹介されている．（文書の方がより詳細である．）
    - モデル作成に使われた3Dモデルファイルは`\opensim_model\geometry`に保存されている．
    - 作成した本ロボットのOpenSimモデルは`\opensim_model\hindlimb_hoshiramu.osim`である．
3. 作成したモデル（`.osim`ファイル）をOpenSimで読み込む．
4. 「Tools」→「IK Trial」の「Marker data for trial」→モーションデータ（`.trc`）選択→「Run」
5. メイン画面の右上から動作を再生し，確認する．
    - 動作がおかしい場合，「Tools」→「Scale Model」→「Scale Factors」でShift+左クリックですべての項目を選択→「Use manual scales（Uniformチェック）」で縮小または拡大を試してみる．
    - 本ロボットの場合，0.4倍するとうまくいく．
    - 0.4倍のモデルはすでに`\opensim_model\hindlimb_hoshiramu_scaled_x0.4.osim`で保存されているため，手順3でこのファイルを読み込めば良い．そして，「File」→「Load Motion」→`\opensim_model\walking_motion.mot`を選択すると加工済の歩きのモーションデータから得られた逆運動学データが読み込まれる．
6. 時間に対して筋肉の長さのグラーフを出す．「Tools」→「Plot」で「X-Quantity」を「Time」と設定しなければいけないが，これは「Y-Quantity」を設定してからできるよになっている．最終的には「Y-Quantity」を「muscle-tendon length」と設定する必要があるが，最初からそれに設定すると時間を選べない．なので，最初に「Y-Quantity」を「IKResults」と設定し，適当に項目を選んで「X-Quantity」を「Time」に設定する．そして，「Y-Quantity」をまた「muscle-tendon length」に変更し，「Muscles」をクリックして左足の筋肉をすべて選択する．そのあと，「Add」をクリックするとグラフが出力される．
    - 「Computing equilibrium for muscle states」というメッセージだけ出て何も実行されない場合がある．この場合，「X-Quantity」を適当に別のものに変え，「Add」をクリックと何も意味を持たないグラフが出力される．そして，また「Y-Quantity」を変更する段階に戻り，最終的に「X-Quantity」を「Time」に設定してグラフを出力すると良い．以前に出力された意味のないグラフを選択し，「Delete」を選択すると削除できる．
7. グラフでマウス右クリックして「Export Data」を選択する．「Files of type」を「Motion or storage file (.mot,.sot)」から「All files」に変更し，「File name」を`ファイル名.csv`として保存する．
    - `\raw_data\opensim_IK`にある`left_joint_angle.csv`，`left_muscle_length.csv`，`right_muscle_length.csv`は抽出されたデータである．
    - `\raw_data\opensim_IK`にある`normalized_muscle_length.fig`は`left_muscle_length.csv`を一つの周期において視覚化したグラフである．y軸は正規化（現在の長さ/周期で最長の長さ）された筋肉の長さである．
8. OpenSimから抽出した情報に基づいて，一つの周期における「正規化された長さが1となる時刻」と「その時刻の関節角」を求める．つまり，筋肉の長さが最長である時（正規化された長さが1となる時刻）の姿勢（各関節角）が分かれば人工筋の長さを決定できる．糸などを用いて各基準点を結び，分度器を道いて糸が成す角を測ってその姿勢になった状態で骨格を固定する．そして，ボルトを用いて筋肉の起始点と停止点に糸を固定して，印を付けたあと，二つの印の間の長さを測ると筋肉の自然長が分かる．
    - 基本的に必要なものは`\muscle_length_determination`に保存されている．
    - `\ligament_and_muscle_lengths.xlsx`は靭帯の長さ，筋肉全体の長さ，腱（糸）の長さをまとめたものである．
        - <u>正常ではない右足（手術前及び手術後）の大腿四頭筋の長さはは正常の約70～80%で設定する．</u>
    - `\muscle_length_determination\joint_angle_reference`には各筋肉が最長の長さであるときの各関節角がまとめられてある．
        - 画面上で角度の測定は[PicPick](https://picpick.app/ja/)を使うと容易にできる．
    - `\muscle_length_determination\joint_angle_reference\matlab_code\length_determination_and_control.m`は一つの周期における筋肉の正規化された長さと関節角を出力するコードである．
        - `SAVE_FIGURES = true;`とすると，グラフ（`.fig`，`.svg`）を保存できる．
        - `\muscle_length_determination\joint_angle_reference\matlab_data\muscle_length_and_joint_angle.mat`は加工されたデータである．`hip_stf_tcl_angles_for_筋肉名_length`は筋肉が最長の長さを持つ姿勢の`[股関節角，膝関節核，足首関節角]`を表す．

## 3. 3. 土台

## 3. 3. 1. 組立
土台はロボットが水平方向（x）と垂直方向（z）のみに移動できるようにする．また，垂直方向の移動を担当する部品を通じてロボットの骨盤が特定の高さで固定することもできる．以下は土台に必要な部品一覧である．

- [アルミフレームHFS5-2020-160-AH24-BH136-Z6-XA20-XB65-XC140](https://jp.misumi-ec.com/vona2/detail/110302683830/?ProductCode=HFS5-2020-160-AH24-BH136-Z6-XA20-XB65-XC140): ロボットの脊椎上部に結合するための3つの穴がある．側面にはゴムひもが通る2つ穴がある．
- [Φ4.0mm コードストッパー](https://www.monotaro.com/p/6591/8728/): ゴムロープの長さ調節による張力及びロボットの垂直位置調節ができる．
- [アウトドア用ゴムロープΦ4mm](https://www.monotaro.com/p/5835/1728/): ロボットの脊椎上部結束アルミフレームの側面の2つの穴を通って土台と連結する．
- [リニアレールJKSG10-95-S1](https://jp.misumi-ec.com/vona2/detail/110300071610/?ProductCode=JKSG10-95-S1): 垂直方向移動のためのリニアレール．
- [リニアスライダGFW-647](https://jp.misumi-ec.com/vona2/detail/221005408710/?ProductCode=GFW-647): 水平方向移動のためのリニアスライダ．
- [グリーンフレームN（長さ1200mm)](https://jp.misumi-ec.com/vona2/detail/221005398123/?HissuCode=GFF-000&PNSearch=GFF-000&KWSearch=GFF-000&searchFlow=results2products&list=PageSearchResult): 水平方向移動のためのレール．GF-SFコネクタを利用してアルミフレームに固定する．
- [グリンフレームS（長さ30mm）](https://jp.misumi-ec.com/vona2/detail/221005398314/?ProductCode=GFF-400%2FL30): アルミフレームにグリンフレーム（レール）を固定するのに補助的に必要である．
- [マルチコネクタインナー型S ADC](https://www.monotaro.com/g/01400972/): 「グリンフレームS（長さ30mm）」をアルミフレームに固定するのに必要である．
- [ダブルコネクタN-S](https://www.monotaro.com/g/01400847/): レールのグリンフレームNと補助グリンフレームSを連結する部品である．
- [GF-SFコネクタSGFA-627](https://jp.misumi-ec.com/vona2/detail/221005409744/?ProductCode=GFA-627): 「マルチコネクタインナー型S ADC」をアルミフレームに固定するために必要である．レールの垂直位置を決めるためにはこの部品の位置を調節する．
- [アルミフレームHFS5-2020-1200-TPW](https://jp.misumi-ec.com/vona2/detail/110302683830/?ProductCode=HFS5-2020-1200-TPW): X
- [アルミフレームHFS5-2020-1000](https://jp.misumi-ec.com/vona2/detail/110302683830/?ProductCode=HFS5-2020-1000): Z
- [アルミフレームHFS5-2020-900-Z5-XA90-XB810](https://jp.misumi-ec.com/vona2/detail/110302683830/?ProductCode=HFS5-2020-900-Z5-XA90-XB810): Y1
- [アルミフレームHFS5-2020-740-Z5-XA10-XB730](https://jp.misumi-ec.com/vona2/detail/110302683830/?ProductCode=HFS5-2020-740-Z5-XA10-XB730): Y2
- [薄型ブラケットHBLSS6](https://jp.misumi-ec.com/vona2/detail/110302370570/): 固定用ロープを通し，コードストッパーで張力調整をする．
- [アルミフレームHFS6-3030-80](https://jp.misumi-ec.com/vona2/detail/110302686450/): リニアスライダとブラケットを連結するための部品．リニアスライダ上部の両端に結束する．
- [アルミ丸パイプΦ10mm](https://www.monotaro.com/p/4035/6373/): 740mmに切断して使う．


## 3. 3. 2. 垂直方向リニアガイド
<p align="center">
<img width="100%" alt="linear guide module instruction" src="https://github.com/user-attachments/assets/82ee4f47-4fcf-4090-8dbb-a8162c595863">
</p>

`\component\linear_guide`に必要なCADファイルが入っている．
1. アルミ丸パイプの中央に20mm間隔でM3の穴を二つ開ける．
2. 「Top」部品とボルトで，「Pipe holder」部品とボルトなしで仮組立する．
3. 「Pipe holder」の穴でアルミ丸パイプに印をつけて，仮組立てあるものを分解する．
4. 印がついているところに既存の穴と垂直となるように新しく穴を開ける．
5. 残りの部品を組み立てる．

注意事項
- Tapと表記してあるところはねじ切り加工タップを利用して加工する．
- ねじの規格のみ表記してあるところは追加でドリルで穴を拡張する必要がある．

# 歩行動作の再現
以下の図は歩行動作の際限の基本的な方針または考え方である．この段階で必要な要素は基本的に`\pressure_control`に保存されている．
<p align="center">
<img width="100%" alt="pressure control diagram" src="https://github.com/user-attachments/assets/0592e693-a997-4d19-8837-3ceb1c7155c7">
</p>

1. [3. 1. 骨格](#3-1-骨格)と[3. 2. 筋肉](#3-2-筋肉)で説明したOpenSim筋骨格モデルとモーションデータを用いてOpenSimで逆運動学解析を行う．
    - `\pressure_control\matlab_code\muscle_length_wrt_presusre.m`で可能な糸（腱）の最低長さを確認できる．実行し現れるグラフで，Min.より正規化された筋肉の長さの最小値が下になければならない．これを参考にして糸の長さを決定する．糸の長さはできるだけ短い方が望ましいが，干渉などを考慮して適切に決める必要がある．
2. フレーム（連続時間）に対する各筋肉の長さ $L_{i}\left(t\right)$と3. 2. 3. 筋肉の長さ決定で得られた筋肉の初期長さ（自然長）$L_{i, 0}$，実験データから得られた空圧と筋肉の長さの関係 $L_{i}\left(P\right)$から特定の時間に加える空圧 $P_i\left(t\right)$を逆算できる．
$$L_i\left(t\right) = L_{i, 0}\varepsilon\left[P_i\left(t\right)\right]$$
$$P_i\left(t\right) = \varepsilon\left[\frac{L_i\left(t\right)}{L_{i, 0}} \right]^{-1}$$
3. 加圧する特定の時刻 $t_j$を決める．$L_{i}\left(t\right)$の極大値・極小値を加圧の基準点とし，その時点で加圧かつその間を特定の間隔で分けて加圧時点 $t_j$を決定する．
    - $t_j$の決定は`\pressure_control\pressurize_time_point.xlsx`を参考にする．
    - 適切な $t_j$は適切に決められているが，修正が必要な場合，`\pressure_control\matlab_code\required_pressure_calculation.m`の以下の部分を修正すれば良い．
        ```
        function muscle_data = determine_pressure_points(muscle_data, muscle_index, timeline, TIMELINE_EXTENSION_FACTOR)
            global_end_point = 1.7498; % 
            ...
            function pressurize_point_one_cycle = calculate_pressure_points_case1(global_end_point)
            ...
            function pressurize_point_one_cycle = calculate_pressure_points_case2(global_end_point)
            ...
            function pressurize_point_one_cycle = calculate_pressure_points_case5(global_end_point)
        ```
        一つ目の周期は反復されず，二つ目の周期のみ反復される．その理由は，$t=0$で全ての筋肉が空気が入力されるが，極小値・極大値に基づいて決まった $t_j$の都合によって，二つ目の周期はそうではない場合もあるからである．しかし，二つ目の周期は反復できるように $t_j$が設定されている．
        - `global_end_point`は一つ目の周期が終わる時点である．
        - `local_min_max_point`は極小値・極大値である．
        - `..._section`は基準時点（極小値・極大値）間の区切られた区画である．
4. $P_i\left(t\right)$を計算する．
    - `\pressure_control\matlab_code\required_pressure_calculation.m`を利用すると空圧ー収縮率の実験データと基準時点の正規化された筋肉の長さから加圧時点の空圧を計算できる．
        - 実験データから $\varepsilon\left(P\right)$を近似して計算に使う．
        - 人工筋の弛緩時と収縮時の区別は1（収縮）と0（弛緩）である．
        - 筋肉データ（全体長さまたは糸の長さ）が修正された場合，`\pressure_control\matlab_data\require_pressure_calculation_data.mat`を修正する．`initial total length`は筋肉全体の初期長さ，`total tendon length`は糸の総合長さである．
        - `PLOT_GRAPHS`，`SAVE_FIGURES`は`true`または`false`でグラフ表示，グラフ保存可否を設定できる．`PLOT_ALL_MUSCLE_SUBPLOT`と`EXPORT_VIDEO`昨日はまだ未完成である．
        - 時間の延長は`TIMELINE_EXTENSION_FACTOR`を調整する．1が元の時間スケールである．
5. 求まって$P_i\left(t\right)$に元ついてマイクロコンピュータのプログラムを作成する．`\pressure_control\stm32_code`に保存されている．
    - コンパイル<u>時必ずファイル名を`main.cpp`に設定しなければならない．</u>そうしないと，エラーが出る．
    - 増幅回路の配線図は`\pressure_control\wiring_diagram_mirrored.png`である．左右反転されているため，半田付けの時容易である．

# 歩行動作の比較
