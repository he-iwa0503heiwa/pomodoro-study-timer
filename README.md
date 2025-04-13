# ポモドーロ学習タイマー

## 概要
ポモドーロ・テクニックを使った学習時間管理アプリケーションです。25分の集中作業と5分の休憩を繰り返すことで、効率的な学習をサポートします。学習時間は自動的に記録され、日々の学習状況を可視化できます。

## 機能
- ポモドーロタイマー（25分作業/5分休憩）
- 学習時間の自動記録
- 1分ごとの自動保存機能（中断時も学習時間を記録）
- 日次/週次/合計の学習時間統計
- ユーザー認証システム
- プロフィール編集機能

## 使用技術
- Ruby 3.4.2
- Ruby on Rails 8.0.2
- SQLite
- JavaScript
- Bootstrap 5
- Devise（認証）
- Heroku（デプロイ予定）

## セットアップ
```bash
# リポジトリのクローン
git clone https://github.com/he-iwa0503heiwa/pomodoro-study-timer.git
cd pomodoro-study-timer

# 依存関係のインストール
bundle install

# データベースのセットアップ
rails db:create
rails db:migrate

# サーバー起動
rails server
```
## 今後の改善点

JavaScriptコードのモジュール化とリファクタリング
フレンド機能の実装（友達の学習時間を見て競争できる機能）
学習カテゴリの追加
モバイル対応の強化
テストの充実

## スクリーンショット
（スクリーンショットを追加予定）

## ライセンス
MIT

## 作者
藤野　平和
