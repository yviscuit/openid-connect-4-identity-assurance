# Transaction-specific Purpose {#purpose}

<!-- This specification introduces the request parameter `purpose` to allow a RP
to state the purpose for the transfer of user data it is asking for. -->
この仕様では,  RP が要求しているユーザーデータの移転目的の説明を可能にする `purpose` リクエストパラメーターを導入する.

<!-- `purpose` OPTIONAL. String describing the purpose for obtaining certain user data from the OP. The purpose MUST NOT be shorter than 3 characters and MUST NOT be longer than 300 characters. If these rules are violated, the authentication request MUST fail and the OP returns an error `invalid_request` to the RP. -->
`purpose` OPTIONAL. OP から特定のユーザーデータを取得する目的を説明する文字列. `purpose` は 3 文字未満か 300 文字以上となってはならない (MUST NOT). もしこのルールに違反した場合, authentication request は失敗し, OP は `invalid_request` エラーを RP にに返さなければならない (MUST).

<!-- The OP MUST display this purpose in the respective user consent screen(s) in order to inform the user about the designated use of the data to be transferred or the authorization to be approved. -->
移転されるデータの利用目的や承認しようとしている認可内容をユーザーに明示するため, OP は各同意画面にこの purpose を表示しなければならない (MUST).

<!-- In order to ensure a consistent UX, the RP MAY send the `purpose` in a certain language and request the OP to use the same language using the `ui_locales` parameter. -->
一貫性のある UX を確保するために, RP は特定の言語で `purpose` を送信し, `ui_locales` パラメーターを使用して同じ言語を使用するよう OP に要求するかもしれない (MAY).

<!-- If the parameter `purpose` is not present in the request, the OP MAY utilize a description that was pre-configured for the respective RP. -->
`purpose` パラメーターがリクエストに存在しない場合, OP は RP ごとに事前設定された値を表示できる (MAY).

<!-- Note: In order to prevent injection attacks, the OP MUST escape the text appropriately before it will be shown in a user interface. The OP MUST expect special characters in the URL decoded purpose text provided by the RP. The OP MUST ensure that any special characters in the purpose text cannot be used to inject code into the web interface of the OP (e.g., cross-site scripting, defacing). Proper escaping MUST be applied by the OP. The OP SHALL NOT remove characters from the purpose text to this end. -->
注: インジェクション攻撃を防ぐために, OP はユーザーインターフェイスに表示される前にテキストを適切にエスケープしなければならない (MUST).  OP は, RP によって提供された URL デコードされた purpose テキスト中に特殊文字を予期しなければならない (MUST). OP は, purpose テキスト内の特殊文字を使用して, OP の Web インターフェイスにコードをインジェクト (例: クロスサイトスクリプティング, 改ざんなど) 出来ないようにしなければならない (MUST).  OP は適切なエスケープを適用しなければならない (MUST). OP は, この目的のために purpose テキストから文字を削除してはならない (SHALL NOT).
