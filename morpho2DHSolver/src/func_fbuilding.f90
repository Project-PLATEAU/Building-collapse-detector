module func_fbuilding
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
    ! 土石流外力を計算するサブルーチン
    ! 流動の向きや傾斜はこの関数の外で処理済み
    ! 全構造種別の建物に対して実行される。
    ! 
    ! [IN]
    ! Rmbu: 密度(kg/m^3)
    ! G: 重力加速度(m/s^2)
    ! ZZbbu: 土石流深さ(静的応力計算時に使われる値)(m)
    ! Hbu: 土石流深さ(流動による応力計算時に使われる値)(m)
    ! Ubu: 流動速(m/s)
    ! [OUT]
    ! fbuilding: 単位幅あたり外力(N/m)
    real*8 function fbuilding(Rmbu,G,ZZbbu,Hbu,Ubu)
        real*8 :: Rmbu,G,ZZbbu,Hbu,Ubu

        fbuilding = Rmbu*G*ZZbbu**2./2.+Rmbu*Hbu*Ubu**2.

    end function
end module
