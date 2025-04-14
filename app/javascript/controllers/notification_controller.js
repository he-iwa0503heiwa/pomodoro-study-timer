import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    // 通知許可の確認とリクエスト
    this.checkNotificationPermission();
  }

  checkNotificationPermission() {
    // ブラウザが通知をサポートしているか確認
    if (!("Notification" in window)) {
      console.log("このブラウザは通知をサポートしていません");
      return;
    }

    // 通知許可がまだ決定されていない場合、許可をリクエスト
    if (Notification.permission !== 'granted' && Notification.permission !== 'denied') {
      this.requestNotificationPermission();
    }
  }

  requestNotificationPermission() {
    Notification.requestPermission()
      .then(permission => {
        if (permission === "granted") {
          console.log("通知許可が与えられました");
        }
      });
  }
}