#!/bin/bash
cd "$HOME/Claude/English news app"
git add -A
git diff --cached --quiet || git commit -m "Pending changes $(date '+%Y-%m-%d')"
git push origin main
echo ""
echo "✅ Pushが完了しました！"
echo "1〜2分後にiPhoneで https://ht1927.github.io/daily-english-news/ を確認してください。"
read -p "Enterキーで閉じる..."
