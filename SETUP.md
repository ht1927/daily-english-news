# Daily English News — iPhoneからアクセス可能にするセットアップガイド

このガイドは「**毎朝の英語学習ページをiPhoneのSafariから見られるようにする**」ための一度きりの初期設定手順です。所要時間：約15分。

完了すると、以下のような完全自動フローになります：

```
毎朝 06:01 ──── Claude が最新ニュースを取得 → index.html を更新 → git commit
毎朝 06:15 ──── Mac の launchd が自動で git push
            ──── GitHub Pages が即時反映
            ──── iPhone Safari で https://ht1927.github.io/daily-english-news/ を開く
```

**あなたのサイトURL（セットアップ完了後に有効になります）：**
## 👉 https://ht1927.github.io/daily-english-news/

---

## ステップ 1：GitHub アカウント確認 ✅

GitHubアカウント `ht1927` は確認済みです。ステップ2から始めてください。

## ステップ 2：Mac に GitHub CLI（`gh`）をインストール

ターミナル（**アプリケーション → ユーティリティ → ターミナル**）を開いて、まず Homebrew が入っているか確認：

```bash
which brew
```

何も出ない場合は Homebrew をインストール：

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Homebrew が入ったら gh をインストール：

```bash
brew install gh
```

## ステップ 3：GitHub に認証

```bash
gh auth login
```

質問に対して以下を選択：
- **What account do you want to log into?** → `GitHub.com`
- **What is your preferred protocol for Git operations?** → `HTTPS`
- **Authenticate Git with your GitHub credentials?** → `Yes`
- **How would you like to authenticate?** → `Login with a web browser`

ブラウザが開くので、表示されたコードを入力して認証を完了します。

## ステップ 4：リポジトリを作成して push

ターミナルで以下を実行（**`daily-english-news` の部分は好きな名前でOK**）：

```bash
cd ~/Claude/English\ news\ app
gh repo create daily-english-news --public --source=. --remote=origin --push
```

これで初回 push が完了します。

## ステップ 5：GitHub Pages を有効化

```bash
gh api -X POST /repos/$(gh api user --jq .login)/daily-english-news/pages \
  -f "source[branch]=main" -f "source[path]=/"
```

数十秒〜1分待つと、ページが公開されます。URLを確認：

```bash
gh api /repos/$(gh api user --jq .login)/daily-english-news/pages --jq .html_url
```

> 出力例：`https://ht1927.github.io/daily-english-news/`
>
> このURLをiPhoneのSafariで開いてブックマーク追加・ホーム画面に追加すると毎朝チェックしやすくなります。

## ステップ 6：launchd エージェントを設置（自動pushの仕組み）

このフォルダにある `com.user.dailyenglish.push.plist` を `~/Library/LaunchAgents/` に置きます：

```bash
cp ~/Claude/English\ news\ app/com.user.dailyenglish.push.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.user.dailyenglish.push.plist
```

これで毎朝 06:15 に自動で `git push` が実行されます。

> ⚠️ Mac がスリープ中だと実行されません。電源ON or 蓋を開けて起きている時間帯に push が走るよう、必要に応じて時間帯を `.plist` の `Hour`/`Minute` で調整してください。

## ステップ 7（任意）：手動テスト

スケジュールを待たずにまず動作確認したい場合：

```bash
# ローカルファイル更新は Cowork から「Run now」で実行可能
# その後、launchd を手動で発火：
launchctl start com.user.dailyenglish.push
# ログ確認
cat /tmp/dailyenglish-push.log
cat /tmp/dailyenglish-push.err
```

---

## トラブルシューティング

| 症状 | 対処 |
|---|---|
| `gh: command not found` | `brew install gh` を実行（ステップ2参照） |
| `Permission denied` で push | `gh auth login` を再実行（ステップ3参照） |
| サイトが404 | GitHub Pagesの反映に最大10分。`gh api /repos/<user>/daily-english-news/pages` で `status` を確認 |
| 06:15 に push されない | Mac がスリープしていた可能性。`launchctl list | grep dailyenglish` で登録確認 |

---

## URL を Claude に伝える

セットアップ完了後、Claudeのチャットで以下のように伝えてください：

> 「私のGitHubユーザー名は `xxxxx` で、リポジトリ名は `daily-english-news` です」

スケジュールタスクのプロンプトに反映して、毎朝の通知メッセージにあなたのURLが含まれるようにします。
