# redmine_evm

Original:https://github.com/imaginary-cloud/redmine_evm V1.0.0 (4-Jul-2014)

# About

このプラグインはチケットの予定工数、完了日、進捗率、
作業時間を使って、EVMを計測します。ベースラインも設定することができます。
本家からの主な変更点は以下の通り

1. 週単位でEVM値を算出していたのを日単位に変更
2. チケットが親子関係にあるとき子のチケットだけでEVM値を算出
3. グラフ表示をHighchartsへ変更
4. グラフ表示エリアを拡大
5. EVM値のBAC,EACをグラフ表示
6. 主要EVM値(PV,EV,AC,SV,CV,SPI,CPI,BAC,EAC)をサマリーとしてTOPに表示
7. EVM値の説明をToolTipで表示 
8. サイドバーの廃止

# Installation

1. Download tarball 
2. cd {redmine_root}/plugins/; mkdir redmine_evm 
3. Extract files to {redmine_root}/plugins/redmine_evm/
4. rake redmine:plugins:migrate NAME=redmine_evm RAILS_ENV=production

# How to use
  
First make sure that the project planning is complete, then set up a baseline under the "Baselines" tab in the project settings.

# Screenshot

Main screen
![evm sample screenshot](./doc/screenshot_overview.png "overview")

Baseline Setting list
![evm sample screenshot](./doc/screenshot_setting.png "setting baseline list")


# Keywords

EVM, CPI, SPI, Earned Value Management, Baseline, Forecast, Redmine, Plugin

# Emvironment

* Redmine version                2.5.2.stable
* Ruby version                   1.9.2-p328 
* Rails version                  3.2.17

# License

Copyright © 2014 ImaginaryCloud, imaginarycloud.com. This plugin is licensed under the MIT license.

