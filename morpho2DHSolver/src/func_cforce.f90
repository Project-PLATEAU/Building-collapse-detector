module func_cforce
USE allo1
USE allo2
USE allo3
USE allo4
USE allo5
USE GRIDCOORD
USE GridCond
USE CalcCond
USE Take1Var
implicit none

contains
    ! 建屋倒壊とみなす単位長さあたりの力の閾値を計算する
    ! 全建物(構造種別・階数などによらず)に対して実行される
    !
    ! 構造種別の違いはBCritAの絶対値で判定する必要がある。
    ! RC等の非木造のBCritAは木造に比べるとかなり大きいという仮定の元に判定する。
    !
    ! [IN]
    ! BCritA : 基本となる建屋倒壊判定閾値(N/m)
    ! IByearA: 建築年(西暦)
    !          建築年が不明な場合は1000が与えられる。
    ! BHeightA: 建物高さ(m)
    ! IBStoryA: 建物階数コード(「20231110_建物属性の設定方法.pdf」記載の建物階数コード)
    !    501: 地下階なし_地上1階
    !    502: 地下階なし_地上2階
    !    503: 地下階なし_地上3階
    !    504: 地下階なし_地上4-5階
    !    505: 地下階なし_地上6-7階
    !    506: 地下階なし_地上8-10階
    !    507: 地下階なし_地上11-15階
    !    508: 地下階なし_地上16階以上
    !    511: 地下階あり_地上1階
    !    512: 地下階あり_地上2階
    !    513: 地下階あり_地上3階
    !    514: 地下階あり_地上4-5階
    !    515: 地下階あり_地上6-7階
    !    516: 地下階あり_地上8-10階
    !    517: 地下階あり_地上11-15階
    !    518: 地下階あり_地上16階以上
    !    521: 不明
    ! [OUT]
    ! ByearAA: 基本となる建屋倒壊判定閾値BCritAにかける倍率
    !          年代・階数等によって変動。
    ! cforce: 建屋倒壊とみなす単位長さあたりの力の閾値(N/m)
    real*8 function cforce(BCritA, IByearA, ByearAA, BHeightA, IBStoryA)
        integer, intent(in) :: IByearA,IBStoryA
        real*8, intent(in)  :: BCritA, BHeightA
        real*8, intent(out) :: ByearAA
      
      ! 初期値の設定
      ! BCritAの変動は無にする
      ByearAA=1.0
      cforce = BCritA
      
      ! 木造以外の場合
      ! 全構造種別に対して実行される
      ! 構造種別の違いはBCritAの絶対値で判定できる。
      ! RC等のBCritAは木造に比べるとかなり大きい数値
      if (BCritA > 2000e+3) then
        ! 木造以外はこれでおしまい
        return
      end if
      
      ! 木造の場合
      ! 年代毎に倒壊判定閾値を変動させる
      if (IByearA >= 2000) then
        ByearAA=1.10
      else if (IByearA >= 1982) then
        ByearAA=1.00  ! 基準
      else if (IByearA >= 1959) then
        ByearAA=1.00
      else
        ! 1958年以前と、年代不明=1000の場合
        ! 年代不明の場合は古すぎて情報が残っていない可能性があるので、
        ! 安全側の評価結果になるように閾値(耐力)を低めに設定する。
        ! 耐力をゼロにしてしまうと、建物が完全に無いことになって、実態とかけ離れすぎるリスクが高いので、ゼロにはしない。
        ByearAA=0.80
      end if
      
      cforce = BCritA*ByearAA
    end function
end module
