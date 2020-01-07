# Introduction {#Introduction}

この仕様では, OpenID Connect [@!OpenID]の拡張機能を定義して, 特定の法律に従って自然人の強力なidentity verificationのユースケースに対処している. 例には, マネーロンダリング防止法, 電気通信法, テロ対策法, eIDAS [@?eIDAS]などの信託サービスに関する規制が含まれる.

そのようなユースケースでは, 依拠当事者（RPs）は, OpenID Connectプロバイダー（OPs）またはその他の信頼できるソースによって証明されたエンドユーザーに関するClaimの保証レベルと, identity verificationプロセスに関連するエビデンスを知る必要がある.

OpenID Connect仕様[@!OpenID]のセクション2で定義されている`acr`Claimは, OpenID Connectトランザクションで実行される認証に関する情報を証明するのに適してる. ただし, identity assuranceには次の理由で異なる表現が必要である: 認証はOpenID Connectトランザクションの側面であり, identity assuranceは特定のClaimまたはClaimのグループのプロパティであり, それらのいくつかは通常, OpenID Connectトランザクションの結果としてRPに伝えられる.

たとえば, 通常, OPが電子メールアドレスを証明できるという保証は「自己表明」または「オプトインまたは同様のメカニズムによって検証」される. 対照的にユーザーの姓は, OPオペレーターの訓練を受けた従業員にIDカードを提示することにより, それぞれのアンチマネーロンダリング法に従って検証された可能性がある.

したがって, identity assuranceには, エンドユーザーに関する各Claimとともに保証データを伝達する方法が必要である. この仕様は, RPがエンドユーザーに関する検証済みClaimをidentity assuranceデータとともに要求し, OPがこれらの検証済みClaimと付随するidentity assuranceデータを表すために利用する適切な表現とメカニズムを提案する.

## Terminology 

このセクションでは, NIST SP 800-63A [@?NIST-SP-800-63a]に大きな影響を受けた, このドキュメントで扱われているトピックに関連するいくつかの用語を定義する.

* Identity Proofing - ユーザーがOPまたは自分自身を確実に識別するClaimプロバイダーにエビデンスを提供することにより, OPが有用なidentity assuranceレベルで識別できるようにするプロセス.

* Identify Verification - ユーザーの身元を確認するためにOPまたはClaimプロバイダーによって実行されるプロセス.

* Identity Assurance - OPまたはClaimプロバイダーが, RPに対してある一定の確からしさをもって特定のユーザーのIdentityデータを証明するプロセス.  通常はidentity assuranceレベルで表される. 法的要件に応じて, OPはidentity verificationプロセスのエビデンスをRPに提供する必要がある場合もある.

* Verified Claims - 特定のユーザーアカウントへのバインドがidentity verificationプロセスの過程で検証されたエンドユーザー（通常は自然人）に関するClaim.

[1]: https://pages.nist.gov/800-63-3/sp800-63a.html "NIST Special Publication 800-63A, Digital Identity Guidelines, Enrollment and Identity Proofing Requirements"


    
