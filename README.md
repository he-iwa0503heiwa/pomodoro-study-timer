# ポモドーロ学習タイマー

## 概要
ポモドーロ・テクニックを使った学習時間管理アプリケーションです。25分の集中作業と5分の休憩を繰り返すことで、効率的な学習をサポートします。学習時間は自動的に記録され、日々の学習状況を可視化できます。

## 主要機能
- **ポモドーロタイマー:** 25分の集中作業と5分の休憩を自動で切り替え
- **学習記録機能:** セッションごとの学習時間を自動記録
- **統計ダッシュボード:** 日次/週次/月次の学習時間を視覚的に表示
- **中断保存機能:** ブラウザを閉じても進捗を1分ごとに自動保存
- **ユーザー認証:** ログイン、メール認証、パスワードリセット
- **プロフィール管理:** 目標設定とアバター画像のカスタマイズ
- **メール認証・確認機能:** ログイン時にメールでの認証

## 使用技術
### フロントエンド
- HTML/CSS/JavaScript
- Bootstrap 5
- Stimulus.js（モダンなDOM操作）

### バックエンド
- Ruby 3.4.2
- Ruby on Rails 8.0.2
- SQLite（データベース）
- PostgreSQL（本番用データベース）

### 認証・セキュリティ
- Devise（ユーザー認証）
- Rails Active Storage（画像アップロード）

  
## 技術的な見どころ
- **StimulusJSの活用:** 従来のJavaScriptとは異なり、HTMLマークアップと密接に連携するコンポーネント指向のアプローチを採用
- **非同期処理:** タイマー処理とデータ保存をAjaxで実現し、ユーザー体験を向上
- **ブラウザ通知API:** 集中時間と休憩時間の切り替わりをデスクトップ通知で知らせる機能
- **Bootstrapによる基本的なレスポンシブ対応:** モバイルとデスクトップでの表示に対応

## デプロイメント

このWebサイトは、クラウドプラットフォームである [Render](https://render.com/) を使用して継続的にデプロイされています。GitHubリポジトリへのプッシュをトリガーとして、自動的にビルドとデプロイが行われます。

- **ライブURL:** [RenderのライブURL](https://pomodoro-study-timer.onrender.com)
    - こちらから実際に動作するWebサイトにアクセスできます。
- **環境:** Production
    - 現在、このURLで公開されているのは本番環境のバージョンです。
- **ブランチ:** `main` 
    - このブランチの最新のコミットが自動的にデプロイされます。
  
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
