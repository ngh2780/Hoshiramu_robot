# Canine musculoskeletal robotic platform for veterinary orthopedic operations
### [Gihyeok Na](mailto:gihyeok2@illinois.edu), [Shoma Tanaka](mailto:tanaka.s.ca@m.titech.ac.jp), [Shiying Chen](mailto:b09502174@ntu.edu.tw), [Yasuji Harada](mailto:yasuji@nvlu.ac.jp), [Hiroyuki Nabae](mailto:nabae.h.aa@m.titech.ac.jp), and [Koichi Suzumori](mailto:suzumori.k.aa@m.titech.ac.jp)

<p align="center">
<img width="40%" alt="HoshiRamu" src="https://github.com/user-attachments/assets/e65bed34-cb22-4fad-9f89-9c7f26b4fd0d">
</p>

---

## 1. 研究概要

重度の[内側膝蓋骨脱臼](https://www.qldvetspecialists.com.au/medial-patella-luxation)を持つプードルの実際の症例に基づいた筋骨格ロボットを製作する．筋骨格ロボットは動物の筋肉と類似した特性を持つ細径マッキベン型人工筋をアクチュエーターとして使用し，後肢の必須てきな骨格筋が再現する．従来のコンピューターシミュレーションの筋骨格モデルでは筋肉を点と点を結ぶ大きさのない線として定義していたため，筋肉と他の組織間の相互作用が考慮されないという欠点がある．しかし，本ロボットは物理的な筋肉と骨格を持つため，そのような欠点を克服できると期待される．本ロボットを整形外科的手術に応用することで，手術前の手術計画（骨を切削する角度などの決定）および予後の予測，手術法のリハーサルなどが可能になると期待される．
本研究の実用性（実世界での適用性）を示すために，**1) 正常な後肢**，**2) 手術後の後肢**，**手術前の後肢**の3つの対照群の歩行を比較および分析する．（具体的な分析及び定量的比較手法は未定である．）**手術後の後肢**については，実際の獣医師による手術を進める．歩行のための入力はすべて同一である．**2手術後の後肢**の歩行が**手術前の後肢**よりも自然であることを確認する．


## 2. 作業の流れ
本研究は大きく以下のような作業に分類される．

* ロボットの制作：ロボットの筋骨格系および土台の製作
* 歩行動作の再現：電空レギュレータによる筋肉制御
* 歩行動作の比較：同一の制御入力での各比較群の歩行動作比較

詳細は以下で説明する．

---
## 3. ロボットの制作
### 3. 1. 骨格
ロボットの骨は**右脚**に疾患を持つHoshiRamu（トイプードル）のCTデータに基づいている．政策の容易さと妥当性（スタンダードプードル）を考慮し骨格を**2.5倍**したものを使う．骨格に関連した各種ファイルは基本的に`\component\hindlimb_skeleton`に保存されている．
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

Autodesk Fusion 360によって修正されている．ファイルの容量が大きいため，研究室サーバー``のみにアップロードされている．

`\component\hindlimb_skeleton\3d_print(zotrax_m200_plus_z-ultrat)`には骨を印刷するための3Dプリントファイルが保存されている．基本的にはZotrax M200のZ-ULTRAT（Ivory色）を使用して印刷する．印刷する際，<u>配置の仕方によって失敗する可能性がある</u>ため，必ず既存のファイルを参考にすることを推奨する．なお，印刷する際には<u>z方向の位置をに2mm程度あげて印刷することを推奨する.</u>

`\component\hindlimb_skeleton\joint_and_ligament_references`には骨の組立と筋肉の付着に必要な情報が保存されている．





2. ### 筋肉


### 3. 土台

## 2. 보행동작의 재현
## 3. 보행동작의 비교



###     1. 골격
####        1. Componenet List
####        2. How to Assemble
####        3. 주의사항
###    2. McKibben PAM Module
####        1. Component List
####        2. How to Assemble
####        3. 주의사항
###    3. 土台
####        1. Component List
####        2. 주의사항


### 3. Muscle Length Determination







## 4. Pressure Control
### 3. Muscle Length Determination
