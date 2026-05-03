#!/bin/bash
cd "$HOME/Claude/English news app"

# すべての stale lock ファイルを削除
find .git -name "*.lock" -delete
echo "Lock files removed."

# commit & push
git add index.html
git diff --cached --quiet || git commit -m "Daily update: $(date '+%Y-%m-%d')"
git push origin main

echo ""
echo "✅ Pushが完了しました！"
echo "1〜2分後に https://ht1927.github.io/daily-english-news/ を確認してください。"
read -p "Enterキーで閉じる..."
