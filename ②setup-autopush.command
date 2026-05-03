#!/bin/bash
echo "=== 自動push設定を登録します ==="
echo ""

# 古い設定を解除
launchctl bootout gui/$(id -u) "$HOME/Library/LaunchAgents/com.user.dailyenglish.push.plist" 2>/dev/null && echo "古い設定を解除しました" || echo "（既存設定なし）"

# 新しいplistをコピー
cp "$HOME/Claude/English news app/com.user.dailyenglish.push.plist" "$HOME/Library/LaunchAgents/"
echo "plistをコピーしました"

# 登録
launchctl bootstrap gui/$(id -u) "$HOME/Library/LaunchAgents/com.user.dailyenglish.push.plist" && echo "登録成功！" || echo "登録に失敗しました"

echo ""
echo "=== 登録確認 ==="
launchctl list | grep dailyenglish && echo "✅ 自動push設定が有効です！" || echo "❌ 登録されていません"
echo ""
echo "これで毎時間チェックし、未pushのコミットがあれば自動でGitHubにpushされます。"
echo "スリープ後も起動直後に自動実行されます。"
read -p "Enterキーで閉じる..."
