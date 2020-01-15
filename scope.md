# Scope and Requirements

<!-- The scope of the extension is to define a mechanism to assert verified Claims, in general, and to introduce new Claims about the End-User required in the identity assurance space; one example would be the place of birth. -->
本仕様のスコープは, 検証されたClaimをアサートするメカニズムを定義し, identity assuranceスペースで必要とされるエンドユーザに関する新しいClaimを導入することである; 例の一つとして出生地がある.

<!-- The RP will be able to request the minimal data set it needs (data minimization) and to express requirements regarding this data and the evidence and the identity verification processes employed by the OP. -->
RPは必要とする最小限のデータセットを要求し（データの最小化）, このデータとOPで利用されるエビデンス, およびidentity verificationプロセスに関する要件を表すことができる.

<!-- This extension will be usable by OPs operating under a certain regulation related to identity assurance, such as eIDAS notified eID systems, as well as other OPs. Strictly regulated OPs can attest identity data without the need to provide further evidence since they are approved to operate according to well-defined rules with clearly defined liability. --> 
この拡張機能は, eIDAS公認eIDシステムなどのidentity assuranceに関連する特定の規制の下で動作するOP, および他のOPで使用できる. 厳密に規制されたOPは, はっきりと定義された責任を伴う明確に定義されたルールに従って動作することを承認されているため, さらなるエビデンスを提出することなくidentityデータを証明することができる.

<!-- For example in the case of eIDAS, the peer review ensures eIDAS compliance and the respective member state takes the liability for the identities asserted by its notified eID systems. Every other OP not operating under such well-defined conditions is typically required to provide the RP data about the identity verification process along with identity evidence to allow the RP to conduct their own risk assessment and to map the data obtained from the OP to other laws. For example, it shall be possible to use identity data maintained in accordance with the Anti Money Laundering Law to fulfill requirements defined by eIDAS. -->
例えばeIDASのケースでは, ピアレビューがeIDASのコンプライアンスを保証し, それぞれのメンバー国は公認eIDシステムによるidentityの主張に対して責任を負う. そのような明確に定義された条件下にない他のすべてのOPは, 一般的に, RPが独自のリスク評価を実施し, OPから取得したデータを他の法律にマッピングできるように, identityエビデンスに加えて, RPにidentity verificationプロセスに関するデータを提供する必要がある. 例えばeIDASで定義された要件を満たすために, マネーロンダリング防止法に従って維持されているidentityデータを使用することができる.

<!-- From a technical perspective, this means this specification allows the OP to attest verified Claims along with information about the respective trust framework (and assurance level) but also supports the externalization of information about the identity verification process. -->
技術的な観点から, この仕様はOPが各トラストフレームワーク(とassuranceレベル)についての情報に加えて, 検証済みClaimの証明を許可することを意味するが, identity verificationプロセスに関する情報の表出化のサポートも行う.

<!-- The representation defined in this specification can be used to provide RPs with verified Claims about the End-User via any appropriate channel. In the context of OpenID Connnect, verified Claims can be attested in ID Tokens or as part of the UserInfo response. It is also possible to utilize the format described here in OAuth Token Introspection responses (see [@?RFC7662] and [@?I-D.ietf-oauth-jwt-introspection-response]) to provide resource servers with
verified Claims. -->
この仕様で定義された表現方式は, 適切なチャネルを介してエンドユーザに関する検証済ClaimをRPに提供するために利用できる. OpenID Connectのコンテキストでは, 検証済ClaimはID TokenかUserInfo responseの一部として証明することができる. またOAuth Token Introspection response ([@?RFC7662] 及び [@?I-D.ietf-oauth-jwt-introspection-response]を参照)で説明されている形式を利用して, 検証済Claimをリソースサーバに提供することも可能である.

<!-- This extension is intended to be truly international and support identity assurance for different and across jurisdictions. The extension is therefore extensible to support additional trust frameworks, verification methods, and identity evidence. -->
この拡張は真に国際的なものであり, 異なる管轄のidentity assuranceもサポートさせる予定である. そのためこの拡張機能は追加のトラストフレームワーク, 検証メソッド, identityエビデンスをサポートするために拡張することができる.

<!-- In order to give implementors as much flexibility as possible, this extension can be used in conjunction with existing OpenID Connect Claims and other extensions within the same OpenID Connect assertion (e.g., ID Token or UserInfo response) utilized to convey Claims about End-Users. -->
実装者に可能な限りの柔軟性を与えるために, この拡張は既存のOpenID ConnectのClaimおよび同じOpenID Connectのアサーション(例えば, ID TokenやUserInfo)内の他の拡張と組み合わせて使うことができる.

<!-- For example, OpenID Connect [@!OpenID] defines Claims for representing family name and given name of a user without a verification status. Those Claims can be used in the same OpenID Connect assertion beside verified Claims represented according to this extension. -->
例えば, OpenID Connect [@!OpenID] は検証ステータスのないユーザの姓と名を表すClaimを定義している. これらのClaimはこの拡張に従って表現される検証済みClaimとともに同じOpenID Connectのアサーションで使うことができる.

<!-- In the same way, existing Claims to inform the RP of the verification status of the `phone_number` and `email` Claims can be used together with this extension. -->
同じように, RPに`phone_number`と`email`Claimの検証ステータスを通知する既存Claimもこの拡張とともに使うことができる.

<!-- Even for asserting verified Claims, this extension utilizes existing OpenID Connect Claims if possible and reasonable. The extension will, however, ensure RPs cannot (accidentally) interpret unverified Claims as verified Claims. -->
検証済みClaimを主張する場合でも, この拡張は可能かつ妥当であれば既存のOpenID ConnectのClaimを利用する. しかしながら, 拡張はRPが未検証Claimを検証済Claimとして(誤って)解釈できないようにする.
