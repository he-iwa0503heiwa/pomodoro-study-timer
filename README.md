# ポモドーロ学習タイマー

## 概要
ポモドーロ・テクニックを使った学習時間管理アプリケーションです。25分の集中作業と5分の休憩を繰り返すことで、効率的な学習をサポートします。学習時間は自動的に記録され、日々の学習状況を可視化できます。

## 機能
- ポモドーロタイマー（25分作業/5分休憩）
- 学習時間の自動記録
- 1分ごとの自動保存機能（中断時も学習時間を記録）
- 日次/週次/合計の学習時間統計
- ユーザー認証システム
- メール認証・確認機能
- パスワードリセットメール機能
- プロフィール編集機能

## 使用技術
- Ruby 3.4.2
- Ruby on Rails 8.0.2
- SQLite
- JavaScript
- Bootstrap 5
- Devise（認証）
  

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

- リファクタリング
- テストコード追加
- 学習記録の参照
- フレンド機能の実装（友達の学習時間を見て競争できる機能）
- デプロイ
- AI機能搭載
- モバイル対応の強化

## スクリーンショット
トップ画面
<img width="1470" alt="スクリーンショット 2025-04-14 21 46 54" src="https://github.com/user-attachments/assets/378f67dc-f2de-447a-a6ec-7109272004d3" />

アカウント新規登録画面
<img width="1470" alt="スクリーンショット 2025-04-14 21 47 14" src="https://github.com/user-attachments/assets/2ad8ae0f-e933-480d-9ce9-4569a7d9d166" />

ログイン画面
<img width="1470" alt="スクリーンショット 2025-04-14 21 47 35" src="https://github.com/user-attachments/assets/0b0c07dd-dff9-4592-8efb-024497e9ea5e" />

プロフィール画面
<img width="1470" alt="スクリーンショット 2025-04-14 21 48 56" src="https://github.com/user-attachments/assets/b284c935-2c5e-40a8-ae55-62a6a27803e4" />

プロフィール編集画面
<img width="1470" alt="スクリーンショット 2025-04-14 21 49 10" src="https://github.com/user-attachments/assets/0fe46c95-b27b-4369-b1f5-d3f81cc9c452" />

タイマー画面
<img width="1470" alt="スクリーンショット 2025-04-14 21 49 33" src="https://github.com/user-attachments/assets/0758125f-24e0-4694-8d3b-24607bcd5cb2" />



## 作者
藤野　平和
