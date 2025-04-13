document.addEventListener('DOMContentLoaded', function () {
    // ポモドーロタイマーの設定
    const POMODORO_MINUTES = 25;
    const BREAK_MINUTES = 5;

    let timer; //タイマー
    let timeLeft = POMODORO_MINUTES * 60; //残り時間
    let isRunning = false; //タイマー実行中フラグ
    let isBreak = false; //休憩中フラグ
    let currentSessionId = null;

    //進捗を保存
    let lastSaveTime = 0; //最後に保存した時間を記録するための変数
    const SAVE_INTERVAL = 60 * 1000 //保存間隔用

    //タイマー表示用にhtmlからそれぞのIDを取得
    const TIMER_DISPLAY = document.getElementById('timer-display');
    const START_BUTTON = document.getElementById('start-timer');
    const PAUSE_BUTTON = document.getElementById('pause-timer');
    const RESET_BUTTON = document.getElementById('reset-timer');
    const TIMER_STATUS = document.getElementById('timer-status');

    //タイマー表示を更新
    function updateTIMER_DISPLAY() {
        const MINUTES = Math.floor(timeLeft / 60);
        const SECONDS = timeLeft % 60;
        //タイマーの数値を00:00表示にする
        TIMER_DISPLAY.textContent = `${MINUTES.toString().padStart(2, '0')}:${SECONDS.toString().padStart(2, '0')}`;
    }

    //進捗を保存する関数
    function saveProgress() {
        if (!currentSessionId || !isRunning || !isBreak) return;
        const ELAPSED_TIME = POMODORO_MINUTES * 60 - timeLeft;//現在の実行時間を計算
        const ELAPSED_MINUTES = Math.floor(ELAPSED_TIME / 60);//分に変換

        console.log("進捗を保存", ELAPSED_MINUTES, "分経過");

        //fetch関数でhttpリクエストを送信
        fetch('/timers/save_progress', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                //Railsのセキュリティ対策。CSRFトークンをHTMLから取得して送信するらしい。。。
                'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
            },
            body: JSON.stringify({
                session_id: currentSessionId,
                elapsed_minutes: ELAPSED_MINUTES
            })
        })
            .then(response => response.json())
            .then(data => {
                console.log("進捗保存成功:", data);
                lastSaveTime = Date.now();//最終保存時間を更新
            })
            .catch(error => console.error('進捗保存エラー:', error));
    }

    // タイマーを開始
    function startTimer() {
        console.log("タイマー関数が呼ばれた")
        if (!isRunning) {
            isRunning = true;

            // 作業セッションの開始
            if (!isBreak && !currentSessionId) {
                console.log("新しいセッション開始")
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
                        console.log("セッション接続成功")
                        currentSessionId = data.id;
                        lastSaveTime = Date.now(); //保存開始時間を初期化
                        TIMER_STATUS.className = 'alert alert-info';
                        TIMER_STATUS.style.display = 'block';
                        TIMER_STATUS.textContent = '作業セッション中';
                    })
                    .catch(error => console.error('エラー:', error));
            }

            //タイマー機能（1秒ごとにこの関数を実行）
            timer = setInterval(function () {
                timeLeft--;
                updateTIMER_DISPLAY();

                //1分ごとに進捗を保存
                if (!isBreak && currentSessionId && (Date.now() - lastSaveTime >= SAVE_INTERVAL)) {
                    saveProgress();
                }

                //残り時間が0の動き
                if (timeLeft <= 0) {
                    clearInterval(timer);//タイマーストップ

                    // タイマー終了時のブラウザ通知　（ブラウザのWeb Notifications API）
                    if (Notification.permission === 'granted') {
                        new Notification(isBreak ? '作業時間開始!' : '休憩時間!');//newで通知の作成
                    }

                    if (isBreak) {
                        // 休憩終了時の処理
                        isBreak = false;
                        timeLeft = POMODORO_MINUTES * 60;//ポモドーロを25分にタイマーリセット
                        TIMER_STATUS.className = 'alert alert-info';//作業スタイル青に変更
                        TIMER_STATUS.textContent = '作業セッション中';
                    } else {
                        // 作業終了時の処理
                        completeSession();//学習セッションの完了
                        isBreak = true;
                        timeLeft = BREAK_MINUTES * 60;//休憩タイマーを5分にリセット
                        TIMER_STATUS.className = 'alert alert-success';//作業スタイル緑に変更
                        TIMER_STATUS.textContent = '休憩中';
                    }

                    updateTIMER_DISPLAY();
                    isRunning = false;
                    START_BUTTON.disabled = false;
                    PAUSE_BUTTON.disabled = true;
                }
            }, 1000);

            START_BUTTON.disabled = true;
            PAUSE_BUTTON.disabled = false;
            RESET_BUTTON.disabled = false;
        }
    }

    // タイマーを一時停止
    function pauseTimer() {
        if (isRunning) {
            clearInterval(timer);
            isRunning = false;
            START_BUTTON.disabled = false;
            PAUSE_BUTTON.disabled = true;

            //一時停止時にも進捗を保存
            if (!isBreak && currentSessionId) {
                saveProgress();
            }
        }
    }

    //タイマーをリセット
    function resetTimer() {
        clearInterval(timer);
        isRunning = false;
        isBreak = false;
        timeLeft = POMODORO_MINUTES * 60;
        updateTIMER_DISPLAY();
        START_BUTTON.disabled = false;
        PAUSE_BUTTON.disabled = true;
        RESET_BUTTON.disabled = true;

        if (currentSessionId) {
            completeSession();
        }

        TIMER_STATUS.style.display = 'none';
    }

    // セッションを完了
    function completeSession() {
        if (currentSessionId) {
            console.log("セッション完了:", currentSessionId)
            fetch('/timers/complete', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
                },
                body: JSON.stringify({
                    session_id: currentSessionId
                })
            })
                .then(response => response.json())
                .then(data => {
                    console.log("セッション完了成功")
                    currentSessionId = null;
                    document.getElementById('today-duration').textContent = data.today_total + '分';
                    document.getElementById('week-duration').textContent = data.week_total + '分';
                    document.getElementById('total-duration').textContent = data.all_time_total + '分';
                    //ページをリロードして履歴を更新
                    setTimeout(() => location.reload(), 1000);
                })
                .catch(error => console.error('Error:', error));
        }
    }

    //ページを離れる前に進捗を保存
    window.addEventListener('beforeunload', function () {
        if (isRunning && !isBreak && currentSessionId) {
            saveProgress();
        }
    });

    //ブラウザの通知許可表示
    if (Notification.permission !== 'granted' && Notification.permission !== 'denied') {
        Notification.requestPermission();
    }

    //各ボタン動作処理
    if (START_BUTTON) {
        START_BUTTON.addEventListener('click', function () {
            console.log("開始ボタンクリック");
            startTimer();
        });
    }
    if (PAUSE_BUTTON) {
        PAUSE_BUTTON.addEventListener('click', function () {
            console.log("一時停止ボタンクリック");
            pauseTimer();
        });
    }
    if (RESET_BUTTON) {
        RESET_BUTTON.addEventListener('click', function () {
            console.log("リセットボタンクリック");
            resetTimer();
        });
    }

    //タイマーの初期表示
    updateTIMER_DISPLAY();
});
