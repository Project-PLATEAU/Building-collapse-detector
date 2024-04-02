# 家屋倒壊判定モジュール 

![概要](img/screenshot_01.png)

## 1. 概要 
本リポジトリでは、2023年度のProject PLATEAUが開発した「家屋倒壊判定モジュール」のソースコードを公開しています。  
「家屋倒壊判定モジュール」は、土石流シミュレーションシステム[iRIC Morpho2DH](https://i-ric.org/solvers/morpho2dh/)（以下、「Morpho2DH」と呼びます）を活用し、3D都市モデルから得られる建物の形状や配置、構造種別等の属性情報を考慮した精度の高い土石流シミュレーションが実施するためのスクリプトです。  

本スクリプトは、無償で利用可能な流体シミュレーションプラットフォームである[「iRIC」](https://i-ric.org/ja/)を前提としたソルバー改変プログラムとして構築されています。  

## 2. 「家屋倒壊判定モジュール」について 
「家屋倒壊判定モジュール」は、家屋倒壊等の影響を考慮した精緻な土砂災害シミュレーションを行うためのプログラムです。  
Morpho2DHの土石流流動モデルをベースに、iRICに読み込まれた3D都市モデル（地形LOD1モデル）を地形条件として土石流流動を計算できるようにしています。  
さらに、ここで算出した2m×2mサイズのメッシュ単位の流体力を用い、3D都市モデル（建築物LOD1モデル）の位置情報及び属性情報を組み合わせることで、メッシュごとに土石流に対して家屋が倒壊したかを判定する機能を提供します。  
3D都市モデルはCSV形式またはShapefile形式に変換したうえで利用します。  
また、シミュレーション結果をTerriaMap上で可視化するための[「Morpho2DH to CZMLコンバータ」](https://github.com/Project-PLATEAU/Morpho2DH-to-CZML-Converter)を別途提供しています。  

本システムの詳細については[技術検証レポート](https://www.mlit.go.jp/plateau/file/libraries/doc/plateau_tech_doc_0072_ver01.pdf)を参照してください。

## 3. 利用手順

本システムの構築手順及び利用手順については[利用チュートリアル](https://plateau-acn.github.io/Building-collapse-detector/)を参照してください。

## 4. システム概要

* 「家屋倒壊判定モジュール」は、家屋の属性情報(構造種別等)を考慮して倒壊判定閾値を変動させる機能を持ったFortranサブルーチンです。
* Morpho2DHのオブジェクトファイル群と一緒にビルドすることにより、家屋倒壊判定アルゴリズムをカスタマイズしたMorpho2DHの実行バイナリ(ソルバーのexe)を作成できます。
* 倒壊判定アルゴリズムの詳細に関しては、[家屋倒壊判定に関する技術資料](tech_report.pdf)をご覧ください。

## 5. 利用技術

ソルバーの実行バイナリのビルドに以下のFortranコンパイラが必要です。

| 種別    | 名称                                                                                                    | バージョン   | 内容           |
|-------|-------------------------------------------------------------------------------------------------------|---------|--------------|  
| コンパイラ | [Intel oneAPI](https://www.intel.com/content/www/us/en/developer/tools/oneapi/toolkits.html#base-kit) | Intel(R) 64, Version 2021.10.0 Build 20230609_000000    | Fortranコンパイラ |
|  | [Microsoft Visual Studio 2019](https://visualstudio.microsoft.com/ja/)                                                                      | 16.11.8 | C,C++コンパイラ  |

## 6. 動作環境 <!-- 動作環境についての仕様を記載ください。 -->

| 項目     | 最小動作環境                        | 推奨動作環境          | 
|--------|-------------------------------|-----------------| 
| OS     | Microsoft Windows 10/11 64bit | 同左              | 
| CPU    | Intel Core i5以上               | Intel Core i7以上 | 
| メモリ    | 4GB以上                         | 16GB以上          | 
| HDD    | 5GB以上の空き容量                    | 50GB以上          | 
| ネットワーク | 高速インターネット環境                   |                 | 

## 7. 本リポジトリのフォルダ構成 <!-- 本GitHub上のソースファイルの構成を記載ください。 -->

本リポジトリのフォルダ構成は、以下のようになっております。
`morpho2DHSolver`フォルダ内に、倒壊判定モジュール組み込み版Morpho2DHのソルバーのソースやオブジェクトファイルが含まれています。
ソルバーの利用方法やビルド方法は[利用チュートリアル](https://r5-plateau-acn.github.io/Building-collapse-detector/)をご覧ください。

| フォルダ名                                   | 詳細                                           |
|-----------------------------------------|----------------------------------------------|
| morpho2DHSolver&emsp;&emsp;&emsp;&emsp; | 倒壊判定モジュール組み込み版Morpho2DHのソルバーのソースやオブジェクトファイル  |
| &emsp;iRICsolvers_Morpho2DH             | ビルド済みのMorpho2DHのソルバー(morpho2d.exe)が保存されるフォルダ |
| &emsp;&emsp;definition.xml              | exeのバージョン等が記載されているxml                        |
| &emsp;&emsp;morpho2d.exe                | ビルド済みのMorpho2DHのソルバーのexe                     |
| &emsp;&emsp;translation_ja_JP.ts        | 翻訳ファイル                                       |
| &emsp;src                               | Morpho2DHのソルバーのソース・オブジェクトファイルを収めているフォルダ      |
| &emsp;&emsp;build.bat                   | ビルドを実行するバッチファイル                              |
| &emsp;&emsp;func_cforce.f90             | 家屋倒壊閾値を変動させるサブルーチン                           |
| &emsp;&emsp;func_fbuilding.f90          | 土石流外力を計算するサブルーチン                             |
| &emsp;&emsp;*.obj                       | 建屋倒壊判定以外のソルバーのビルド済みファイル                      |
| &emsp;&emsp;*.mod                       | 建屋倒壊判定以外のソルバーのビルド済みファイル                      |
| &emsp;&emsp;*.lib                       | 建屋倒壊判定以外のソルバーのビルド済みファイル                      |
| tech_report.pdf                         | 倒壊判定ロジックに関する技術資料                             |

## 8. ライセンス <!-- 変更せず、そのまま使うこと。 -->

- ソースコード及び関連ドキュメントの著作権は国土交通省に帰属します。
- 本ドキュメントは[Project PLATEAUのサイトポリシー](https://www.mlit.go.jp/plateau/site-policy/)（CCBY4.0及び政府標準利用規約2.0）に従い提供されています。

## 9. 注意事項 <!-- 変更せず、そのまま使うこと。 -->

- 本リポジトリは参考資料として提供しているものです。動作保証は行っていません。
- 本リポジトリについては予告なく変更又は削除をする可能性があります。
- 本リポジトリの利用により生じた損失及び損害等について、国土交通省はいかなる責任も負わないものとします。

## 10. 参考資料

- 技術検証レポート: https://www.mlit.go.jp/plateau/file/libraries/doc/plateau_tech_doc_0072_ver01.pdf
- PLATEAU WebサイトのUse caseページ「精緻な土砂災害シミュレーション」: https://www.mlit.go.jp/plateau/use-case/uc23-02/
- iRIC Morpho2DH: https://i-ric.org/solvers/morpho2dh/
