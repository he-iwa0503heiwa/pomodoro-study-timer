import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["display", "status", "todayDuration", "weekDuration", "totalDuration"];
  static values = {
    pomodoroMinutes: { type: Number, default: 25 },
    breakMinutes: { type: Number, default: 5 }
  };

  connect() {
    // タイマー関連の変数を初期化
    this.timer = null;//タイマー
    this.timeLeft = this.pomodoroMinutesValue * 60;//残り時間
    this.isRunning = false;//作動中フラグ
    this.isBreak = false;//休憩中フラグ
    this.currentSessionId = null;//勉強用セッションID
    this.lastSaveTime = 0;//
    this.SAVE_INTERVAL = 60 * 1000; //1分ごとに保存

    // 初期表示を更新
    this.updateTimerDisplay();
    
    console.log("タイマーコントローラーが接続");
  }

  disconnect() {
    // ページを離れる時にタイマーをクリア
    if (this.timer) {
      clearInterval(this.timer);
    }
    
    // 進行中のセッションがあれば保存
    if (this.isRunning && !this.isBreak && this.currentSessionId) {
      this.saveProgress();
    }
  }

  //開始ボタン
  start() {
    console.log("開始ボタンクリック");
    if (!this.isRunning) {
      this.isRunning = true;

      //作業セッションの開始（休憩中でなく、セッションIDがない場合）
      if (!this.isBreak && !this.currentSessionId) {
        console.log("新しいセッション開始");
        fetch('/timers', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
          },
          body: JSON.stringify({})
        })
          .then(response => response.json())
          .then(data => {
            console.log("セッション接続成功", data);
            this.currentSessionId = data.id;
            this.lastSaveTime = Date.now(); // 保存開始時間を初期化
            this.statusTarget.className = 'alert alert-info';
            this.statusTarget.style.display = 'block';
            this.statusTarget.textContent = '作業セッション中';
          })
          .catch(error => console.error('エラー:', error));
      }

      // タイマー機能（1秒ごとにこの関数を実行）
      this.timer = setInterval(() => {
        this.timeLeft--;
        this.updateTimerDisplay();

        // 1分ごとに進捗を保存
        if (!this.isBreak && this.currentSessionId && (Date.now() - this.lastSaveTime >= this.SAVE_INTERVAL)) {
          this.saveProgress();
        }

        // 残り時間が0の動き
        if (this.timeLeft <= 0) {
          clearInterval(this.timer); // タイマーストップ

          // タイマー終了時のブラウザ通知
          if (Notification.permission === 'granted') {
            new Notification(this.isBreak ? '作業時間開始!' : '休憩時間!');
          }

          if (this.isBreak) {
            // 休憩終了時の処理
            this.isBreak = false;
            this.timeLeft = this.pomodoroMinutesValue * 60; // ポモドーロを25分にタイマーリセット
            this.statusTarget.className = 'alert alert-info'; // 作業スタイル青に変更
            this.statusTarget.textContent = '作業セッション中';
          } else {
            // 作業終了時の処理
            this.completeSession(); // 学習セッションの完了
            this.isBreak = true;
            this.timeLeft = this.breakMinutesValue * 60; // 休憩タイマーを5分にリセット
            this.statusTarget.className = 'alert alert-success'; // 作業スタイル緑に変更
            this.statusTarget.textContent = '休憩中';
          }

          this.updateTimerDisplay();
          this.isRunning = false;
          this.setButtonStates();
        }
      }, 1000);

      this.setButtonStates();
    }
  }

  // 一時停止ボタン
  pause() {
    console.log("一時停止ボタンクリック");
    if (this.isRunning) {
      clearInterval(this.timer);
      this.isRunning = false;
      this.setButtonStates();

      // 一時停止時にも進捗を保存
      if (!this.isBreak && this.currentSessionId) {
        this.saveProgress();
      }
    }
  }

  // リセットボタン
  reset() {
    console.log("リセットボタンクリック");
    clearInterval(this.timer);
    this.isRunning = false;
    this.isBreak = false;
    this.timeLeft = this.pomodoroMinutesValue * 60;
    this.updateTimerDisplay();
    this.setButtonStates();

    if (this.currentSessionId) {
      this.completeSession();
    }

    this.statusTarget.style.display = 'none';
  }

  // タイマー表示を更新
  updateTimerDisplay() {
    const minutes = Math.floor(this.timeLeft / 60);
    const seconds = this.timeLeft % 60;
    this.displayTarget.textContent = `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
  }

  // ボタンの状態を設定
  setButtonStates() {
    const startButton = document.getElementById('start-timer');
    const pauseButton = document.getElementById('pause-timer');
    const resetButton = document.getElementById('reset-timer');
    
    if (this.isRunning) {
      startButton.disabled = true;
      pauseButton.disabled = false;
      resetButton.disabled = false;
    } else {
      startButton.disabled = false;
      pauseButton.disabled = true;
      resetButton.disabled = !this.currentSessionId && this.timeLeft === this.pomodoroMinutesValue * 60;
    }
  }

  // 進捗を保存する関数
  saveProgress() {
    if (!this.currentSessionId || !this.isRunning || this.isBreak) return;
    
    const elapsedTime = this.pomodoroMinutesValue * 60 - this.timeLeft; // 現在の実行時間を計算
    const elapsedMinutes = Math.floor(elapsedTime / 60); // 分に変換

    console.log("進捗を保存", elapsedMinutes, "分経過");

    fetch('/timers/save_progress', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({
        session_id: this.currentSessionId,
        elapsed_minutes: elapsedMinutes
      })
    })
      .then(response => response.json())
      .then(data => {
        console.log("進捗保存成功:", data);
        this.lastSaveTime = Date.now(); // 最終保存時間を更新
      })
      .catch(error => console.error('進捗保存エラー:', error));
  }

  // セッションを完了する関数
  completeSession() {
    if (this.currentSessionId) {
      console.log("セッション完了:", this.currentSessionId);
      fetch('/timers/complete', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({
          session_id: this.currentSessionId
        })
      })
        .then(response => response.json())
        .then(data => {
          console.log("セッション完了成功", data);
          this.currentSessionId = null;
          
          if (this.hasTodayDurationTarget) {
            this.todayDurationTarget.textContent = data.today_total + '分';
          }
          if (this.hasWeekDurationTarget) {
            this.weekDurationTarget.textContent = data.week_total + '分';
          }
          if (this.hasTotalDurationTarget) {
            this.totalDurationTarget.textContent = data.all_time_total + '分';
          }
          
          // ページをリロードして履歴を更新
          setTimeout(() => location.reload(), 1000);
        })
        .catch(error => console.error('Error:', error));
    }
  }
}