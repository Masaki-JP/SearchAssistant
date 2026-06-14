
もし分からないことがあれば質問すること。

コミットメッセージ、ブランチ名、プルリクエストなどは以前のものを参考にして作成すること。
例: コミットメッセージは「change: SearchHistoryのサンプルを追加」「fix: SettingViewのカラースキーム固定を解除」「rename: XMLParserManagerをSuggestionXMLParserに改名」、ブランチ名は「change/fetch-keyboard-toolbar-settings-on-appear」「improve/instagram-search-space」「fix/setting-view-color-scheme」のようにすること。
コミットメッセージは多少長くなっても構わないので、分かりやすさを重視すること。

「PRを提出して」と言われた場合は、DraftではなくReady for reviewの状態まで進めること。

Xcodeが空行に入れるインデント用スペースはXcodeの仕様として扱い、不要な空白整理として削除しないこと。

ビューのプロパティとメソッドには、アクセスレベルを付けないこと。

HistoryListやSuggestionListのようにXXXList形式のビューを切り出す場合は、渡される配列が空配列ではないことを前提として作成すること。

エージェントファイルの更新のコミットメッセージとブランチ名はプレフィックスを「agent」とすること。

プロジェクト全体を作り直した変更は、マージコミット「0c3852e（Merge branch 'change/recreate-search-assistant-project'）」で取り込まれている。実変更コミットは「f2df292（change: 旧プロジェクトのコードを移植）」。

mainにマージするときはファストフォワードを使わないこと。

指示があるまでコミットは行わない。

`origin/main`に含まれていない`main`のコミットを確認すること。そのうち最も古いコミットの日時が`origin/main`の最新コミットの日時より3日以上前である場合、または`main`が`origin/main`より30コミット以上進んでいる場合は、その旨を教えてください。これらの条件に当てはまらない場合は、何の報告も必要ありません。

mainは原則マージコミットのみとする。
コミットの指示があったとき、カレントブランチがmainであれば、ブランチを切る。ブランチ名は変更内容を元に命名する。
mainにマージを行うとき、マージ元のブランチ名がtmpとなっていたり、プレフィックスがついていないなどのときは、マージを行わずにその旨を教えてください。
