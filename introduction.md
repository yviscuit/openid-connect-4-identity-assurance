# Introduction {#Introduction}

この仕様では, OpenID Connect [@!OpenID]の拡張機能を定義して, 特定の法律に従って自然人の強力なidentity検証のユースケースに対処しています. 例には, マネーロンダリング防止法, 電気通信法, テロ対策法, eIDAS [@?eIDAS]などの信託サービスに関する規制が含まれます.

そのようなユースケースでは, 依拠当事者（RPs）は, OpenID Connectプロバイダー（OPs）またはその他の信頼できるソースによって証明されたエンドユーザーに関するクレームの保証レベルと, IDの検証プロセスに関連するエビデンスを知る必要があります.

OpenID Connect仕様[@!OpenID]のセクション2で定義されている`acr`クレームは, OpenID Connectトランザクションで実行される認証に関する情報を証明するのに適しています. ただし, identity assuranceには次の理由で異なる表現が必要です: 認証はOpenID Connectトランザクションの側面であり, identity assuranceは特定のクレームまたはクレームのグループのプロパティであり, それらのいくつかは通常, OpenID Connectトランザクションの結果としてRPに伝えられます.

たとえば, 通常, OPが電子メールアドレスを証明できるという保証は「自己表明」または「オプトインまたは同様のメカニズムによって検証」されます. 対照的にユーザーの姓は, OPオペレーターの訓練を受けた従業員にIDカードを提示することにより, それぞれのアンチマネーロンダリング法に従って検証された可能性があります.

したがって, identity assuranceには, エンドユーザーに関する各クレームとともに保証データを伝達する方法が必要です. この仕様は, RPがエンドユーザーに関する検証済みクレームをidentity assuranceデータとともに要求し, OPがこれらの検証済みクレームと付随するidentity assuranceデータを表すために利用する適切な表現とメカニズムを提案します.

## Terminology 

このセクションでは, NIST SP 800-63A [@?NIST-SP-800-63a]に大きな影響を受けた, このドキュメントで扱われているトピックに関連するいくつかの用語を定義します.

* Identity Proofing - ユーザーがOPまたは自分自身を確実に識別するクレームプロバイダーにエビデンスを提供することにより, OPが有用なidentity assuranceレベルでそのIDを識別できるようにするプロセス.

* Identify Verification - ユーザーの身元を確認するためにOPまたはクレームプロバイダーによって実行されるプロセス.

* Identity Assurance - OPまたはクレームプロバイダーが, RPに対して特定の保証を伴う特定のユーザーのIDデータを証明するプロセス. 通常はidentity assuranceレベルで表されます. 法的要件に応じて, OPは本人確認プロセスのエビデンスをRPに提供する必要がある場合もあります.

* Verified Claims - 特定のユーザーアカウントへのバインドがidentity検証プロセスの過程で検証されたエンドユーザー（通常は自然人）に関するクレーム.

[1]: https://pages.nist.gov/800-63-3/sp800-63a.html "NIST Special Publication 800-63A, Digital Identity Guidelines, Enrollment and Identity Proofing Requirements"


    
