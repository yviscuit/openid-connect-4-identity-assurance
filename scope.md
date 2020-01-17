# Scope and Requirements

<!-- The scope of the extension is to define a mechanism to assert verified Claims, in general, and to introduce new Claims about the End-User required in the identity assurance space; one example would be the place of birth. -->
本仕様のスコープは, 検証された Claim をアサートするメカニズムを定義し, identity assurance スペースで必要とされるエンドユーザに関する新しい Claim を導入することである; 例の一つとして出生地がある.

<!-- The RP will be able to request the minimal data set it needs (data minimization) and to express requirements regarding this data and the evidence and the identity verification processes employed by the OP. -->
RP は必要とする最小限のデータセットを要求し (データの最小化) , このデータと OP で利用されるエビデンス, および identity verification プロセスに関する要件を表すことができる.

<!-- This extension will be usable by OPs operating under a certain regulation related to identity assurance, such as eIDAS notified eID systems, as well as other OPs. Strictly regulated OPs can attest identity data without the need to provide further evidence since they are approved to operate according to well-defined rules with clearly defined liability. --> 
この拡張機能は, eIDAS 公認 eID システムなどの identity assurance に関連する特定の規制の下で動作する OP, および他の OP で使用できる. 厳密に規制された OP は, はっきりと定義された責任を伴う明確に定義されたルールに従って動作することを承認されているため, さらなるエビデンスを提出することなく identity データを証明することができる.

<!-- For example in the case of eIDAS, the peer review ensures eIDAS compliance and the respective member state takes the liability for the identities asserted by its notified eID systems. Every other OP not operating under such well-defined conditions is typically required to provide the RP data about the identity verification process along with identity evidence to allow the RP to conduct their own risk assessment and to map the data obtained from the OP to other laws. For example, it shall be possible to use identity data maintained in accordance with the Anti Money Laundering Law to fulfill requirements defined by eIDAS. -->
例えば eIDAS のケースでは, ピアレビューが eIDAS のコンプライアンスを保証し, それぞれのメンバー国は公認 eID システムによる identity の主張に対して責任を負う. そのような明確に定義された条件下にない他のすべての OP は, 一般的に, RP が独自のリスク評価を実施し, OP から取得したデータを他の法律にマッピングできるように, identity evidence に加えて, RP に identity verification プロセスに関するデータを提供する必要がある. 例えば eIDAS で定義された要件を満たすために, マネーロンダリング防止法に従って維持されている identity データを使用することができる.

<!-- From a technical perspective, this means this specification allows the OP to attest verified Claims along with information about the respective trust framework (and assurance level) but also supports the externalization of information about the identity verification process. -->
技術的な観点から, この仕様は OP が各トラストフレームワーク(と assurance レベル)についての情報に加えて, 検証済み Claim の証明を許可することを意味するが, identity verification プロセスに関する情報の表出化のサポートも行う.

<!-- The representation defined in this specification can be used to provide RPs with verified Claims about the End-User via any appropriate channel. In the context of OpenID Connnect, verified Claims can be attested in ID Tokens or as part of the UserInfo response. It is also possible to utilize the format described here in OAuth Token Introspection responses (see [@?RFC7662] and [@?I-D.ietf-oauth-jwt-introspection-response]) to provide resource servers with
verified Claims. -->
この仕様で定義された表現方式は, 適切なチャネルを介してエンドユーザに関する検証済 Claim を RP に提供するために利用できる. OpenID Connect のコンテキストでは, 検証済 Claim は ID Token か UserInfo response の一部として証明することができる. また OAuth Token Introspection response ([@?RFC7662] 及び [@?I-D.ietf-oauth-jwt-introspection-response] を参照)で説明されている形式を利用して, 検証済 Claim をリソースサーバに提供することも可能である.

<!-- This extension is intended to be truly international and support identity assurance for different and across jurisdictions. The extension is therefore extensible to support additional trust frameworks, verification methods, and identity evidence. -->
この拡張は真に国際的なものであり, 異なる管轄の identity assurance もサポートさせる予定である. そのためこの拡張機能は追加のトラストフレームワーク, 検証メソッド, identity evidenceをサポートするために拡張することができる.

<!-- In order to give implementors as much flexibility as possible, this extension can be used in conjunction with existing OpenID Connect Claims and other extensions within the same OpenID Connect assertion (e.g., ID Token or UserInfo response) utilized to convey Claims about End-Users. -->
実装者に可能な限りの柔軟性を与えるために, この拡張は既存の OpenID Connect の Claim および同じ OpenID Connect のアサーション(例えば, ID Token や UserInfo)内の他の拡張と組み合わせて使うことができる.

<!-- For example, OpenID Connect [@!OpenID] defines Claims for representing family name and given name of a user without a verification status. Those Claims can be used in the same OpenID Connect assertion beside verified Claims represented according to this extension. -->
例えば, OpenID Connect [@!OpenID] は検証ステータスのないユーザの姓と名を表す Claim を定義している. これらの Claim はこの拡張に従って表現される検証済み Claim とともに同じ OpenID Connect のアサーションで使うことができる.

<!-- In the same way, existing Claims to inform the RP of the verification status of the `phone_number` and `email` Claims can be used together with this extension. -->
同じように, RP に `phone_number` と `email` Claim の検証ステータスを通知する既存 Claim もこの拡張とともに使うことができる.

<!-- Even for asserting verified Claims, this extension utilizes existing OpenID Connect Claims if possible and reasonable. The extension will, however, ensure RPs cannot (accidentally) interpret unverified Claims as verified Claims. -->
検証済み Claim を主張する場合でも, この拡張は可能かつ妥当であれば既存の OpenID Connect の Claim を利用する. しかしながら, 拡張は RP が未検証 Claim を検証済 Claim として(誤って)解釈できないようにする.
