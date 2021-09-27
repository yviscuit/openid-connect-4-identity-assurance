%%%
title = "OpenID Connect for Identity Assurance 1.0"
abbrev = "openid-connect-4-identity-assurance-1_0"
ipr = "trust200902"
workgroup = "connect"
keyword = ["security", "openid", "identity assurance"]

date = 2019-08-15T00:00:00Z

[seriesInfo]
name = "Internet-Draft"
value = "openid-connect-4-identity-assurance-1_0-07"
status = "standard"

[[author]]
initials="T."
surname="Lodderstedt"
fullname="Torsten Lodderstedt"
organization="yes.com"
    [author.address]
    email = "torsten@lodderstedt.net"

[[author]]
initials="D."
surname="Fett"
fullname="Daniel Fett"
organization="yes.com"
    [author.address]
    email = "mail@danielfett.de"


%%%

.# Abstract 

This specification defines an extension of OpenID Connect for providing Relying Parties with verified Claims about End-Users. This extension is intended to be used to verify the identity of a natural person in compliance with a certain law. 

{mainmatter}

# Introduction {#Introduction}

<!-- This specification defines an extension to OpenID Connect [@!OpenID] to address the use case of strong identity verification of a natural person in accordance with certain laws. Examples include Anti Money Laundering Laws, Telecommunication Acts, Anti Terror Laws, and regulations on trust services, such as eIDAS [@?eIDAS]. -->
この仕様では, OpenID Connect [@!OpenID] の拡張機能を定義して, 特定の法律に従って自然人の強力な identity verification のユースケースに対処している. 例には, マネーロンダリング防止法, 電気通信法, テロ対策法, eIDAS [@?eIDAS] などの信託サービスに関する規制が含まれる.

<!-- In such use cases, the Relying Parties (RPs) need to know the assurance level of the Claims about the End-User attested by the OpenID Connect Providers (OPs) or any other trusted source along with evidence related to the identity verification process. -->
そのようなユースケースでは, 依拠当事者 (RPs) は, OpenID Connect プロバイダー (OPs) またはその他の信頼できるソースによって証明されたエンドユーザーに関する Claim の保証レベルと, identity verification プロセスに関連するエビデンスを知る必要がある.

<!-- The `acr` Claim, as defined in Section 2 of the OpenID Connect specification [@!OpenID], is suited to attest information about the authentication performed in a OpenID Connect transaction. 
But identity assurance requires a different representation for the following reason: authentication is an aspect of an OpenID Connect transaction while identity assurance is a property of a certain Claim or a group of Claims and several of them will typically be conveyed to the RP as the result of an OpenID Connect transaction. -->
OpenID Connect 仕様 [@!OpenID] の Section 2 で定義されている `acr` Claim は, OpenID Connect トランザクションで実行される認証に関する情報を証明するのに適している. ただし, identity assurance には次の理由で異なる表現が必要である: 認証は OpenID Connect トランザクションの側面であり, identity assurance は特定の Claim または Claim のグループのプロパティであり, それらのいくつかは通常, OpenID Connect トランザクションの結果として RP に伝えられる.

<!-- For example, the assurance an OP typically will be able to attest for an e-mail address will be “self-asserted” or “verified by opt-in or similar mechanism”. The family name of a user, in contrast, might have been verified in accordance with the respective Anti Money Laundering Law by showing an ID Card to a trained employee of the OP operator. -->
たとえば, 通常, OP が電子メールアドレスを証明できるという保証は「自己表明」または「オプトインまたは同様のメカニズムによって検証」される. 対照的にユーザーの姓は, OP オペレーターの訓練を受けた従業員に ID カードを提示することにより, それぞれのマネーロンダリング防止法に従って検証された可能性がある.

<!-- Identity assurance therefore requires a way to convey assurance data along with and coupled to the respective Claims about the End-User. This specification proposes a suitable representation and mechanisms the RP will utilize to request verified claims about an End-User along with identity assurance data and for the OP to represent these verified Claims and accompanying identity assurance data. -->
したがって, identity assurance には, エンドユーザーに関する各 Claim とともに保証データを伝達する方法が必要である. この仕様は, RP がエンドユーザーに関する検証済み Claim を identity assurance データとともに要求し, OP がこれらの検証済み Claim と付随する identity assurance データを表すために利用する適切な表現とメカニズムを提案する.

## Terminology 

<!-- This section defines some terms relevant to the topic covered in this documents, heavily inspired by NIST SP 800-63A [@?NIST-SP-800-63a]. -->
このセクションでは, NIST SP 800-63A [@?NIST-SP-800-63a] に大きな影響を受けた, このドキュメントで扱われているトピックに関連するいくつかの用語を定義する.

<!-- * Identity Proofing - process in which a user provides evidence to an OP or claim provider reliably identifying themselves, thereby allowing the OP to assert that identification at a useful identity assurance level. -->
* Identity Proofing - ユーザーが OP または自分自身を確実に識別する Claim プロバイダーにエビデンスを提供することにより, OP が有用な identity assurance レベルで識別できるようにするプロセス.

<!-- * Identify Verification - process conducted by the OP or a claim provider to verify the user's identity. -->
* Identify Verification - ユーザーの身元を確認するために OP または Claim プロバイダーによって実行されるプロセス.

<!-- * Identity Assurance - process in which the OP or a claim provider attests identity data of a certain user with a certain assurance towards a RP, typically expressed by way of an assurance level. Depending on legal requirements, the OP may also be required to provide evidence of the identity verification process to the RP. -->
* Identity Assurance - OP または Claim プロバイダーが, RP に対してある一定の確からしさをもって特定のユーザーの Identity データを証明するプロセス.  通常は identity assurance レベルで表される. 法的要件に応じて, OP は identity verification プロセスのエビデンスを RP に提供する必要がある場合もある.

<!-- * Verified Claims - Claims about an End-User, typically a natural person, whose binding to a particular user account were verified in the course of an identity verification process. -->
* Verified Claims - 特定のユーザーアカウントへのバインドが identity verification プロセスの過程で検証されたエンドユーザー (通常は自然人) に関する Claim.

[1]: https://pages.nist.gov/800-63-3/sp800-63a.html "NIST Special Publication 800-63A, Digital Identity Guidelines, Enrollment and Identity Proofing Requirements"

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

# Claims {#claims}

## Additional Claims about End-Users {#userclaims}

<!-- In order to fulfill the requirements of some jurisdictions on identity assurance, this specification defines the following Claims for conveying user data in addition to the Claims defined in the OpenID Connect specification [@!OpenID]: -->
identity assurance に関する一部の権限の要件を満たすために, この仕様では OpenID仕様 [@!OpenID] に定義されている Claim にユーザデータを伝達するための以下の追加の Claim を定義する:

<!--
* `place_of_birth`: a structured Claim representing the End-User’s place of birth. It consists of the following fields:
 	* `country`: REQUIRED. [@!ISO3166-1] Alpha-2 (e.g., DE) or [@!ISO3166-3]
 	* `region`: State, province, prefecture, or region component. This field might be required in some jurisdictions.
 	* `locality`: REQUIRED. city or other locality
* `nationalities`: string array representing the user’s nationalities in ICAO 2-letter codes [@!ICAO-Doc9303], e.g. "US" or "DE". 3-letter codes MAY be used when there is no corresponding ISO 2-letter code, such as "EUE".
* `birth_family_name`: family name someone has when he or she is born, or at least from the time he or she is a child. This term can be used by a person who changes the family name later in life for any reason.
* `birth_given_name`: given name someone has when he or she is born, or at least from the time he or she is a child. This term can be used by a person who changes the given name later in life for any reason.
* `birth_middle_name`: middle name someone has when he or she is born, or at least from the time he or she is a child. This term can be used by a person who changes the middle name later in life for any reason.
* `salutation`: End-User’s salutation, e.g. “Mr.”
* `title`: End-User’s title, e.g. “Dr.”
-->
* `place_of_birth`: エンドユーザの出生地を示す構造化された Claim. 次のフィールドで構成される:
	* `country`: 必須 (REQUIRED). [@!ISO3166-1] Alpha-2 (例えば, DE) または [@!ISO3166-3] 
	* `region`: State, province, prefecture, または他の地域コンポーネント. 一部の管轄区域ではこのフィールドは必須かもしれない.
	* `locality`: 必須 (REQUIRED). city, または別の地域.
* `nationalities`: ユーザの国籍を表す ICAO 2-letter codes [@!ICAO-Doc9303] の文字配列. 例えば "US" や "DE". "EUE" のように対応する 2-letter code がない場合, 3-letter codes を利用してもよい (MAY).
* `birth_family_name`: 彼または彼女が生まれたとき, あるいは少なくとも子供の時から持っている姓. この用語は人生の途中に何らかの理由で姓を変更した人が利用できる.
* `birth_given_name`: 彼または彼女が生まれたとき, あるいは少なくとも子供の時から持っている名前. この用語は人生の途中に何らかの理由で名前を変更した人が利用できる.
* `birth_middle_name`: 彼または彼女が生まれたとき, あるいは少なくとも子供の時から持っているミドルネーム. この用語は人生の途中に何らかの理由でミドルネームを変更した人が利用できる.
* `salutation`: エンドユーザの敬称, 例えば “Mr.”
* `title`: エンドユーザの肩書, 例えば “Dr.”

## txn Claim

<!-- Strong identity verification typically requires the participants to keep an audit trail of the whole process. -->
一般的に, 強固な identity verification は参加者がプロセス全体の監査証跡を保持する必要がある.

<!-- The `txn` Claim as defined in [@!RFC8417] is used in the context of this extension to build audit trails across the parties involved in an OpenID Connect transaction. -->
[@!RFC8417] で定義されている `txn` Claim はこの拡張のコンテキストで使用され, OpenID Connect トランザクションに関わるの関係者全体の監査証跡を構築する.

<!-- If the OP issues a `txn`, it MUST maintain a corresponding audit trail, which at least consists of the following details: -->
OP が `txn` を発行する場合, 対応する監査証跡を維持する必要があり (MUST), 少なくとも次の詳細で構成される.

<!--
* the transaction id,
* the authentication methods employed, and
* the transaction type (e.g. scope values).
-->
* transaction id,
* 採用されている authentication methods, および
* transaction type (scope 値など).

<!-- This transaction data MUST be stored as long as it is required to store transaction data for auditing purposes by the respective regulation. -->
このトランザクションデータは, それぞれの規定による監査目的のためにトランザクションデータを保存する必要がある限り保存し続けなければならない (MUST).

<!-- The RP requests this Claim like any other Claim via the `claims` parameter or as part of a default Claim set identified by a scope value. -->
RP はこの Claim を `claims` パラメータを介して, または scope 値によって識別されるデフォルトの Claim の一部として, 他の Claim と同様に要求する.

<!-- The `txn` value MUST allow an RP to obtain these transaction details if needed. -->
`txn` 値は必要に応じて RP がこれらのトランザクションを参照できるようにしなければならない (MUST).

<!-- Note: the mechanism to obtain the transaction details from the OP and their format is out of scope of this specification. -->
注：トランザクションの詳細を, OP および, それらのフォーマットから取得するメカニズムはこの仕様の範囲外である.

# Verified Data Representation 

<!-- This extension to OpenID Connect wants to ensure that RPs cannot mix up verified and unverified Claims and incidentally process unverified Claims as verified Claims. -->
OpenID Connect のこの拡張は, RP が検証済みの Claim と未検証の Claim を混在させ, 検証済みの Claim として未検証の Claim を偶発的に処理できないようにすることを目的としている.

<!-- The representation proposed therefore provides the RP with the verified Claims within a container element `verified_claims`. This container is composed of the verification evidence related to a certain verification process and the corresponding Claims about the End-User which were verified in this process. -->
それ故, 提案された表現は `verified_claims` コンテナ要素内で検証済み Claim を RP に提供することである. このコンテナは特定の検証プロセスに関連する検証のエビデンスとこのプロセスで検証されたエンドユーザについての該当 Claim で構成されている.

<!-- This section explains the structure and meaning of `verified_claims` in detail. A machine-readable syntax definition is given as JSON schema in (#json_schema). It can be used to automatically validate JSON documents containing a  `verified_claims` element. --> 
このセクションでは `verified_claims` の構造と意味について詳しく説明する. 機械可読な構文定義は (#json_schema) で JSON スキーマとして提供される. `verified_claims` 要素を含む JSON ドキュメントを自動的に検証するために使用できる.

<!-- `verified_claims` consists of the following sub-elements: -->
`verified_claims` は以下のサブ要素で構成される:

<!--
* `verification`: REQUIRED. Object that contains all data about the verification process.
* `claims`: REQUIRED. Object that is the container for the verified Claims about the End-User.
-->
* `verification`: 必須 (REQUIRED). 検証プロセスに関するすべてのデータを含むオブジェクト.
* `claims`: 必須 (REQUIRED). エンドユーザに関するの検証済 Claim のためのコンテナであるオブジェクト.

<!-- Note: implementations MUST ignore any sub-element not defined in this specification or extensions of this specification. -->
注: 実装は, この仕様またはこの仕様の拡張で定義されていないサブ要素を無視しなければならない (MUST).

## verification Element {#verification}

<!-- This element contains the information about the process conducted to verify a person's identity and bind the respective person data to a user account. -->
この要素には, 個人の身元を確認し, それぞれの個人データをユーザーアカウントにバインドするために実行されたプロセスに関する情報が含まれる.

<!-- The `verification` element consists of the following elements: --> 
`verification` 要素は以下の要素を含む:

<!-- `trust_framework`: REQUIRED. String determing the trust framework governing the identity verification process and the identity assurance level of the OP. --> 
`trust_framework`: 必須 (REQUIRED). OP の identity verification プロセスと, identity assurance レベルを管理する trust framework を定める文字列.

<!-- An example value is `eidas_ial_high`, which denotes a notified eID system under eIDAS [@?eIDAS] providing identity assurance at level of assurance "High". -->
例としては `eidas_ial_high` で, これは eIDAS [@?eIDAS] 公認 eID システムを示し, assurance レベル "high" の identity assurance を提供する.

<!-- An initial list of standardized values is defined in [Trust Frameworks](#predefined_values_tf). Additional trust framework identifiers can be introduced [how?]. RPs SHOULD ignore `verified_claims` claims containing a trust framework id they don't understand. -->
標準化された値の初期リストは, [Trust Frameworks](#predefined_values_tf) で定義されている. 追加の trust framework identifiers も導入できる [how？]. RP は理解できない trust framework identifiers を含む `verified_claims` Claim を無視しなければならない (SHOLUD).

<!-- The `trust_framework` value determines what further data is provided to the RP in the `verification` element. A notified eID system under eIDAS, for example, would not need to provide any further data whereas an OP not governed by eIDAS would need to provide verification evidence in order to allow the RP to fulfill its legal obligations. An example of the latter is an OP acting under the German Anti-Money laundering law (`de_aml`). -->
`trust_framework` は, `verification` 要素の中で RP に提供される追加のデータを決定する. たとえば, eIDAS 公認 eID システムは, データを追加する必要はないが, eIDAS に管理されていない OP は RP が法的義務を果たすために verification evidence を提供する必要がある. 後者の例としては, ドイツのマネーロンダリング防止法 (`de_aml`) に基づいて行動する OP である.

<!-- `time`: Time stamp in ISO 8601:2004 [ISO8601-2004] `YYYY-MM-DDThh:mm:ss±hh` format representing the date and time when identity verification took place. Presence of this element might be required for certain trust frameworks. -->
`time`: ID の検証が行われた日時を示す ISO 8601:2004 [ISO8601-2004] `YYYY-MM-DDThh:mm:ss±hh` フォーマットのタイムスタンプ. 特定のトラストフレームワークでは, この要素の存在が必要になる場合がある.

<!-- `verification_process`: Unique reference to the identity verification process as performed by the OP. Used for backtracing in case of disputes or audits. Presence of this element might be required for certain trust frameworks. -->
`verification_process`: OP によって実行される identity verification プロセスへの一意の参照. 紛争(ないしは紛争解決)または監査の場合のバックトレースに使用される.特定のトラストフレームワークでは, この要素の存在が必要になる場合がある.

<!-- Note: While `verification_process` refers to the identity verification process at the OP, the `txn` claim refers to a particular OpenID Connect transaction in which the OP attested the user's verified identity data towards a RP. -->
注：`verification_process` は OP での identity verification プロセスを指すが, `txn` Claim は OP が RP に対してユーザ検証済 identity データを証明した特定の OpenID Connect トランザクションを指す.

<!-- `evidence` is a JSON array containing information about the evidence the OP used to verify the user's identity as separate JSON objects. Every object contains the property `type` which determines the type of the evidence. The RP uses this information to process the `evidence` property appropriately. -->
`evidence`: OP がユーザの identity を個別の JSON オブジェクトとして検証するために使用した `evidence` に関する情報を含む JSON 配列. すべてのオブジェクトには, エビデンスのタイプを決定する `type` プロパティが含まれている. RP はこの情報を `evidence` プロパティを適切に処理するために利用する.

<!-- Important: implementations MUST ignore any sub-element not defined in this specification or extensions of this specification. -->
重要:実装はこの仕様またはこの仕様の拡張で定義されていないサブ要素を無視しなければならない (MUST).

### Evidence 

<!-- The following types of evidence are defined: -->
次のエビデンスのタイプが定義されている:

<!--
* `id_document`: verification based on any kind of government issued identity document
* `utility_bill`: verification based on a utility bill
* `qes`: verification based on a eIDAS Qualified Electronic Signature
* -->
* `id_document`: あらゆる種類の政府発行の身分証明書に基づく検証
* `utility_bill`: 公共料金の支払に基づく検証
* `qes`: eIDAS 認定電子署名に基づく検証

#### id_document

<!-- The following elements are contained in an `id_document` evidence sub-element. --> 
次の種類の属性が `id_document` エビデンスのサブ要素として含まれる.

<!-- `method`: REQUIRED. The method used to verify the id document. Predefined values are given in  [Verification Methods](#predefined_values_vm) -->
`method`: 必須 (REQUIRED). id document を検証するために使われるメソッド. 事前に定義された値は [Verification Methods](#predefined_values_vm) で定義されている.

<!-- `verifier`: OPTIONAL. A JSON object denoting the legal entity that performed the identity verification on behalf of the OP. This object SHOULD only be included if the OP did not perform the identity verification itself. This object consists of the following properties: -->
`verifier`: オプション (OPTIONAL). OP に代わって identity verification を実行した法人を示す JSON オブジェクト. このオブジェクトは, OP が identity verification を実行しなかった場合にのみ含める必要がある (SHOULD). このオブジェクトは次のプロパティで構成される:

<!-- 
* `organization`: String denoting the organization which performed the verification on behalf of the OP.
* `txn`: identifier refering to the identity verification transaction. This transaction identifier can be resolved into transaction details during an audit.
-->
* `organization`: OP に代わって検証を行った組織を表す文字列.
* `txn`: identity verification のトランザクションを参照する識別子. このトランザクション識別子は, 監査中のトランザクションの詳細を分析できる.

<!-- `time`: Time stamp in ISO 8601:2004 [ISO8601-2004] `YYYY-MM-DDThh:mm:ss±hh` format representing the date when this id document was verified. --> 
`time`: この id document が検証された日付を表す ISO 8601:2004 [ISO8601-2004] `YYYY-MM-DDThh:mm:ss±hh` フォーマットのタイムスタンプ.

<!-- `document`: A JSON object representing the id document used to perform the id verification. It consists of the following properties: -->
`document`: ID 検証に使用される id document を表す JSON オブジェクト. 次のプロパティで構成される:

<!--
* `type`: REQUIRED. String denoting the type of the id document. Standardized values are defined in [Identity Documents](#predefined_values_idd). The OP MAY use other than the predefined values in which case the RPs will either be unable to process the assertion, just store this value for audit purposes, or apply bespoken business logic to it.
* `number`: String representing the number of the identity document.
* `issuer`: A JSON object containg information about the issuer of this identity document. This object consists of the following properties:
	*  `name`: REQUIRED. Designation of the issuer of the identity document
	*  `country`: String denoting the country or organization that issued the document as ICAO 2-letter-code [@!ICAO-Doc9303], e.g. "JP". ICAO 3-letter codes MAY be used when there is no corresponding ISO 2-letter code, such as "UNO".
* `date_of_issuance`: REQUIRED if this attribute exists for the particular type of document. The date the document was issued as ISO 8601:2004 YYYY-MM-DD format.
* `date_of_expiry`: REQUIRED if this attribute exists for the particular type of document. The date the document will expire as ISO 8601:2004 YYYY-MM-DD format.
-->
* `type`: 必須 (REQUIRED). id document のタイプを示す文字列. 標準化された値は [Identity Documents](#predefined_values_idd) で定義される. OP は事前に定義されていない値を使用するかもしれず (MAY), その場合, RP はアサーションを処理できないか, 監査目的でこの値を保存するだけか, またはそれに言及されたビジネスロジックであることを表す.
* `number`: identity document の番号を表す文字列.
* `issuer`: この identity document の発行者の情報を含む JSON オブジェクト. このオブジェクトは次のプロパティで構成される:
	*  `name`:必須 (REQUIRED). identity document の発行者の名称.
	*  `country`: ドキュメントを ICAO 2-letter-code [@!ICAO-Doc9303] として発行した国または組織を示す文字列 (例： "JP") . ICAO 3-letter codes は, "UNO" など, 対応する ISO 2-letter codes がない場合に使用できる.
* `date_of_issuance`: 特定の種類のドキュメント用にこの属性が存在する場合は必須 (REQUIRED). ISO 8601:2004 YYYY-MM-DD フォーマットでドキュメントが発行された日付.
* `date_of_expiry`: 特定の種類のドキュメント用にこの属性が存在する場合は必須 (REQUIRED). ISO 8601:2004 YYYY-MM-DD フォーマットのドキュメントの有効期限.

#### utility_bill

<!-- The following elements are contained in a `utility_bill` evidence sub-element. --> 
次の種類の要素が `utility_bill` エビデンスのサブ要素として含まれる.

<!-- `provider`: REQUIRED. A JSON object identifying the respective provider that issued the bill. The object consists of the following properties: -->
`provider`: 必須 (REQUIRED). 請求書を発行した各プロバイダを識別する JSON オブジェクト. オブジェクトは次のプロパティで構成される:

<!--
* `name`: A String designating the provider.
* All elements of the OpenID Connect `address` Claim ([@!OpenID])
-->
* `name`: プロバイダを指定する文字列.
* OpenID Connect の `address` Claim ([@!OpenID]) のすべての要素

<!-- `date`: A ISO 8601:2004 YYYY-MM-DD formatted string containing the date when this bill was issued. -->
`date`: この請求書が発行された日時を含む ISO 8601:2004 YYYY-MM-DD フォーマットの文字列.

#### qes

<!-- The following elements are contained in a `qes` evidence sub-element. --> 
次の種類の要素が `qes` エビデンスのサブ要素として含まれる.

<!-- `issuer`: REQUIRED. A String denoting the certification authority that issued the signer's certificate. --> 
`issuer`: 必須 (REQUIRED). 署名者の証明書を発行した証明機関を示す文字列.

<!-- `serial_number`: REQUIRED. String containing the serial number of the certificate used to sign. -->
`serial_number`:必須 (REQUIRED). 署名に使用される証明書のシリアルナンバーを含む文字列.

<!-- `created_at`: REQUIRED. The time the signature was created as ISO 8601:2004 YYYY-MM-DDThh:mm:ss±hh format. -->
`created_at`: 必須 (REQUIRED).  ISO 8601:2004 YYYY-MM-DDThh:mm:ss±hh フォーマットの署名が作られた時間.


## claims Element {#claimselement}

<!-- The `claims` element contains the claims about the End-User which were verified by the process and according to the policies determined by the corresponding `verification` element. -->
`claims` 要素にはプロセスによって検証され, 対応する `verification` 要素によって決定されたポリシーに従って検証されたエンドユーザについての Claim が含まれる.

<!-- The `claims` element MAY contain one or more of the following Claims as defined in Section 5.1 of the OpenID Connect specification [@!OpenID] -->
`claims` 要素には OpenID Connect specification [@!OpenID] の Section 5.1 で定義されている以下の Claim が一つ以上含まれるかもしれない (MAY)

* `name`
* `given_name`
* `middle_name`
* `family_name`
* `birthdate`
* `address`

<!-- or the claims defined in (#userclaims). -->
または (#userclaims) で定義されている Claim を含むかもしれない.

<!-- The `claims` element MAY also contain other claims given the value of the respective claim was verified in the verification process represented by the sibling `verification` element. -->
`claims` 要素は, 兄弟要素の `verification` で提示された検証プロセスでそれぞれの Claim の値が検証された場合, 他の Claim も含むかもしれない (MAY).

<!-- Claim names MAY be annotated with language tags as specified in Section 5.2 of the OpenID Connect specification [@!OpenID]. -->
Claim 名は, OpenID Connect 仕様 [@!OpenID] の Section 5.2 で指定されている言語タグで注釈を付けてもよい (MAY).

# Requesting Verified Claims

## Requesting End-User Claims {#req_claims}

<!-- Verified Claims can be requested on the level of individual Claims about the End-User by utilizing the `claims` parameter as defined in Section 5.5. of the OpenID Connect specification [@!OpenID]. -->
Verified Claims は OpenID Connect specification [@!OpenID] の Section 5.5. に定義されている `claims` parameter を利用することで, End-User について 個々の Claims のレベルで要求できる.

<!-- `verified_claims` is added to the `userinfo` or `id_token` element of the `claims` parameter. -->
`verified_claims` は `claims` パラメーターの `userinfo` か `id_token` 要素に追加される.

<!-- Since `verified_claims` contains the effective Claims about the End-User in a nested `claims` element, the syntax is extended to include expressions on nested elements as follows. The `verified_claims` element includes a `claims` element, which in turn includes the desired Claims as keys with a `null` value. An example is shown in the following: -->
`verified_claims` にはネストされた `claims` 要素の中に End-User についての有効な Claims が含まれるため, syntax は次のようにネストされた要素の式を含むように拡張される. `verified_claims` 要素は `claims` 要素を含み, `null` 値を持つキーとして要求する Claims を含む. 以下に例を示す.

```json
{  
   "userinfo":{  
      "verified_claims":{  
         "claims":{  
            "given_name":null,
            "family_name":null,
            "birthdate":null
         }
      }
   }	
}
```
<!-- Use of the `claims` parameter allows the RP to exactly select the Claims about the End-User needed for its use case. This extension therefore allows RPs to fulfill the requirement for data minimization. -->
`claims` パラメータを使用すると, RP はユースケースに必要な End-User に関する Claims を正確に選択できる. したがって, この拡張は RPs はデータ最小化の要件を満たすことができる.

<!-- RPs MAY indicate that a certain Claim is essential to the successful completion of the user journey by utilizing the `essential` field as defined in Section 5.5.1. of the OpenID Connect specification [@!OpenID]. The following example designates both given as well as family name as being essential. -->
RPs は, OpenID Connect specification [@!OpenID] の Section 5.5.1 で定義されている `essential` フィールドを利用することにより, 特定の Claim がユーザージャーニーの正常な完了に不可欠であることを示すことができる. 次の例では, 姓と名の両方を必須として指定している.

```json
{  
   "userinfo":{  
      "verified_claims":{  
         "claims":{  
            "given_name":{"essential": true},
            "family_name":{"essential": true},
            "birthdate":null
         }
      }
   }	
}
```

<!-- This specification introduces the additional field `purpose` to allow a RP 
to state the purpose for the transfer of a certain End-User Claim it is asking for. 
The field `purpose` can be a member value of each individually requested 
Claim, but a Claim cannot have more than one associated purpose. -->
この仕様では, RP が要求する特定の End-User Claim の移転の目的を説明できるようにするために, 追加のフィールド `purpose` を導入する.
`purpose` フィールドは, 個々に要求された各 Claim のメンバー値にすることができるが, 1つの Claim には複数の関連する目的を含めることはできない.

<!-- `purpose` OPTIONAL. String describing the purpose for obtaining a certain End-User Claim from the OP. The purpose MUST NOT be shorter than 3 characters or 
longer than 300 characters. If this rule is violated, the authentication 
request MUST fail and the OP returns an error `invalid_request` to the RP.
The OP MUST display this purpose in the respective user consent screen(s) 
in order to inform the user about the designated use of the data to be 
transferred or the authorization to be approved. If the parameter `purpose` 
is not present in the request, the OP MAY display a 
value that was pre-configured for the respective RP. For details on UI 
localization see (#purpose). -->
`purpose` OPTIONAL. OP から特定の End-User Claim を取得する目的を説明する文字列. `purpose` は 3 文字未満か 300 文字以上となってはならない (MUST NOT).
もしこのルールに違反した場合, authentication request は失敗し, OP は `invalid_request` エラーを RP にに返さなければならない (MUST).
移転されるデータの利用目的や承認しようとしている認可内容をユーザーに明示するため, OP は各同意画面にこの purpose を表示しなければならない (MUST).
`purpose` パラメーターがリクエストに存在しない場合, OP は RP ごとに事前設定された値を表示できる (MAY).
UI ローカリゼーションの詳細については, (#purpose) 参照.

<!-- Example: -->
例:

```json
{  
   "userinfo":{  
      "verified_claims":{  
         "claims":{  
            "given_name":{  
               "essential":true,
               "purpose":"To make communication look more personal"
            },
            "family_name":{  
               "essential":true
            },
            "birthdate":{  
               "purpose":"To send you best wishes on your birthday"
            }
         }
      }
   }
}
```
<!-- Note: A `claims` sub-element with value `null` is interpreted as a request for all possible Claims. An example is shown in the following: -->
注: 値が `null` の `claims` サブ要素は, 考えられるすべての Claims に対するリクエストとして解釈される. 以下に例を示す:

```json
{  
   "userinfo":{  
      "verified_claims":{  
         "claims":null
      }
   }	
}
```

<!-- Note: The `claims` sub-element can be omitted, which is equivalent to a `claims` element whose value is `null`. -->
注: `claims` サブ要素は省略でき, これは, 値が `null` である `claims` 要素と同等である.

<!-- Note: If the `claims` sub-element is empty or contains a Claim not fulfilling the requirements defined in (#claimselement), the OP will abort the transaction with an `invalid_request` error. -->
注: `claims` サブ要素が空か, (#claimselement) に定義されている要件を満たなさい Claims を含む場合, OP は `invalid_request` エラーでトランザクションを中断するだろう.

## Requesting Verification Data {#req_verification}

<!-- The content of the `verification` element is basically determined by the respective `trust_framework` and the Claim source's policy. -->
`verification` 要素内容は, 基本的にそれぞれの `trust_framework` と Claim source のポリシーによって決定される.

<!-- This specification also defines a way for the RP to explicitly request certain data to be present in the `verification` element. The syntax is based on the rules given in (#req_claims) and extends them for navigation into the structure of the `verification` element. -->
この仕様は RP が特定のデータを `verification` 要素に明示的に要求する方法も定義する. 構文は (#req_claims) で指定されたルールに基づいており, `verification` 要素の構造へのナビゲーションのためにそれらを拡張する.

<!-- Elements within `verification` can be requested in the same way as defined in (#req_claims) by adding the respective element as shown in the following example: -->
次の例で示すように, `verification` 内の要素としてそれぞれの要素を追加することで, (#req_claims) に定義されているのと同じ方法でリクエストできる.

```json
{  
   "verified_claims":{  
      "verification":{  
         "date":null,
         "evidence":null
      },
      "claims":null
   }
}
```

<!-- It requests the date of the verification and the available evidence to be present in the issued assertion.  -->
これは, 発行されたアサーションに検証の日付と利用可能な証拠が存在することを要求する.

<!-- Note: the RP does not need to explicitly request the `trust_framework` field as it is a mandatory element of the `verified_claims` Claim. -->
注: `verified_claims` Claim の必須要素であるため, RP は明示的に `trust_framework` フィールドを要求する必要はない.

<!-- The RP may also dig one step deeper into the structure and request certain data to be present within every `evidence`. A single entry is used as prototype for all entries in the result array: -->
RP は, 構造を1段深く掘り下げ, 特定のデータがすべての `evidence` 内に存在することを要求する場合もある. result array 内のすべてのエントリのプロトタイプとして, 単一のエントリが使用される.

```json
{  
   "verified_claims":{  
      "verification":{  
         "date":null,
         "evidence":[  
            {  
               "method":null,
               "document":null
            }
         ]
      },
      "claims":null
   }
}
```

<!-- This example requests the `method` element and the `document` element for every evidence available for a certain user account. -->
この例では, 特定のユーザーアカウントで利用可能なすべての証拠について, `method` 要素と `document` 要素を要求する.

<!-- Note: the RP does not need to explicitly request the `type` field as it is a mandatory element of any `evidence` entry. -->
注: `evidence` エントリの必須要素であるため, RP は明示的に `type` フィールドを要求する必要はない.

<!-- The RP may also request certain data within the `document` element to be present. This again follows the syntax rules used above. -->
RP は, `document` 要素内に特定のデータが存在することを要求する場合もある. これも, 上記で使用した構文規則に従う.

```json
{  
   "verified_claims":{  
      "verification":{  
         "date":null,
         "evidence":[  
            {  
               "method":null,
               "document":{  
                  "issuer":null,
                  "number":null,
                  "date_of_issuance":null
               }
            }
         ]
      },
      "claims":null
   }
}
```

<!-- Note: the RP does not need to explicitly request the `type` field as it is a mandatory element of any `document` entry.  -->
注: `document` エントリの必須要素であるため, RP は明示的に `type` フィールドを要求する必要はない.

<!-- It is at the discretion of the Claim source to decide whether the requested verification data is provided to the RP. -->
RP に要求された検証データを提供するか決定するのは, Claim source の裁量である.

## Defining constraints on Verification Data {#constraintedclaims}

<!-- The RP MAY express requirements regarding the elements in the `verification` sub-element. -->
RP は `verification` サブ要素の要素に関する要件を表現できる (MAY).

<!-- This, again, requires an extension to the syntax as defined in Section 5.5. of the OpenID Connect specification [@!OpenID] due to the nested nature of the `verified_claims` claim. -->
ここでも再び, `verified_claims` claim のネストされた性質によって, OpenID Connect specification [@!OpenID] の Section 5.5. で定義されている構文の拡張が必要である.

<!-- Section 5.5.1 of the OpenID Connect specification [@!OpenID] defines a query syntax that allows for the member value of the Claim being requested to be a JSON object with additional information/constraints on the Claim. For doing so it defines three members (`essential`, `value` and `values`) with special query 
meanings and allows for other special members to be defined (while stating that any members that are not understood must be ignored). -->
OpenID Connect specification [@!OpenID] の Section 5.5.1 は, Claim の 追加情報/制約を持つ JSON object を要求するような Claim のメンバー値であることを許す構文を定義する.
そのために, 特別なクエリの意味を持つ3つのメンバー (`essential`, ` value`, および `values`) を定義し, 他の特別なメンバーを定義できるようにする (理解されていないメンバーは無視しなければならない).

<!-- This specification re-uses that mechanism and introduces a new such member `max_age` (see below). -->
この仕様はそのメカニズムを再利用し, 新しいそのような `max_age` メンバーを導入する (下記参照).

<!-- To start with, the RP MAY limit the possible values of the elements `trust_framework`, `evidence/type`, `evidence/method`, and `evidence/document/type` by utilizing the `value` or `values` fields. -->
まず, `value` か `values` フィールドを利用して, `trust_framework`, `evidence/type`, `evidence/method`, 及び `evidence/document/type` の利用可能な値を制限することができる (MAY).


<!-- The following example shows that the RP wants to obtain an attestation based on AML and limited to users who were identified in a bank branch in person using government issued id documents. -->
次の例は, RP が AML(訳注: Anti-Money Laundering) に基づいて, 政府発行のIDドキュメントを使用して, 銀行の支店で直接本人確認を行った人に限定したユーザーの証明を取得したいことを示している.

```json
{  
   "userinfo":{  
      "verified_claims":{  
         "verification":{  
            "trust_framework":{  
               "value":"de_aml"
            },
            "evidence":[  
               {  
                  "type":{  
                     "value":"id_document"
                  },
                  "method":{  
                     "value":"pipp"
                  },
                  "document":{  
                     "type":{  
                        "values":[  
                           "idcard",
                           "passport"
                        ]
                     }
                  }
               }
            ]
         },
         "claims":null
      }
   }
}
```

<!-- The RP MAY also express a requirement regarding the age of the verification data, i.e., the time elapsed since the verification process asserted in the `verification` element has taken place. -->
RP は, 検証データの経過時間, すなわち `verification` 要素で主張された検証プロセスが実行されてからの経過時間に関する要件も表現できる (MAY).

<!-- This specification therefore defines a new member `max_age`. -->
したがって, この仕様では新しいメンバー `max_age` を定義している.

<!-- `max_age`: OPTIONAL. Is a JSON number value only applicable to Claims that contain dates or timestamps. It defines the maximum time (in seconds) to be allowed to elapse since the value of the date/timestamp up to the point in time of the request. The OP should make the calculation of elapsed time starting from the last valid second of the date value. The following is an example of a request for Claims where the verification process of the data is not allowed to be older than 63113852 seconds. -->
`max_age`: OPTIONAL. 日付またはタイムスタンプを含む Claims にのみ適用可能な JSON 数値. 日付/タイムスタンプの値からリクエストの時点までの経過を許可する最大時間 (秒) を定義する. OP は, 日付値の最後の有効な秒から開始した経過時間の計算を行わなければならない. 以下は, データの検証プロセスが 63113852 秒以前であることを認めない Claims のリクエストの例である.

<!-- The following is an example: -->
以下に例を示す:

```json
{  
   "userinfo":{  
      "verified_claims":{  
         "verification":{  
            "date":{  
               "max_age":63113852
            }
         },
         "claims":null
      }
   }
}
```

<!-- The OP SHOULD try to fulfill this requirement. If the verification data of the user is older than the requested `max_age`, the OP MAY attempt to refresh the user’s verification by sending her through a online identity verification process, e.g. by utilizing an electronic ID card or a video identification approach. -->
OP はこの要件を満たそうとしなければならない (SHOULD). ユーザーの検証データがリクエストされた `max_age` よりも古い場合, OP はユーザーにオンラインでの identity verification プロセスを介して, ユーザーの確認を更新しようとするかもしれない (MAY). 例えば 電子IDカードまたはビデオ識別アプローチを利用することによって.

<!-- If the OP is unable to fulfill the requirement (even in case it is marked as being `essential`), it will provide the RP with the data available and the RP may decide how to use the data. The OP MUST NOT return an error in case it cannot return all Claims requested as essential Claims. -->
OP が要件を満たすことができない場合 (`essential` とマークされている場合でも), RP に利用可能なデータを提供し, RP はデータの使用方法を決定できる. OP は, 必須 Claims として要求されたすべての Claims を返すことができない場合にエラーを返してはならない (MUST NOT).

# Examples

<!-- The following sections show examples of `verified_claims`. -->
以下のセクションでは `verified_claims` に関する例を示す.

<!-- The first and second section show JSON snippets of the general identity assurance case, where the RP is provided with verification evidence for different verification methods along with the actual Claims about the End-User. -->
最初と 2つ目のセクションでは, 一般的な identity assurance のケースの JSON snippets を示し, RP には End-User に関する実際の Claims と一緒に, 様々な検証方法による verification evidence が提供される.

<!-- The third section illustrates how the contents of this object could look like in case of a notified eID system under eIDAS, where the OP does not need to provide evidence of the identity verification process to the RP. -->
3つ目のセクションでは, OP が RP に対して identity verification プロセスのエビデンスを提供する必要がない eIDAS 公認 eID システムの場合, どのようにこのオブジェクトのコンテンツが見えるかを説明している.

<!-- Subsequent sections contain examples for using the `verified_claims` Claim on different channels and in combination with other (unverified) Claims. -->
後続のセクションでは, 異なる経路で `verified_claims` Claim を使用し, 他の (unverified) Claims と組み合わせて使用する例を含む.

## id_document

```JSON
{  
   "verified_claims":{  
      "verification":{  
         "trust_framework":"de_aml",
         "time":"2012-04-23T18:25:43.511+01",
         "verification_process":"676q3636461467647q8498785747q487",
         "evidence":[  
            {  
               "type":"id_document",
               "method":"pipp",
               "document":{  
                  "type":"idcard",
                  "issuer":{  
                     "name":"Stadt Augsburg",
                     "country":"DE"
                  },
                  "number":"53554554",
                  "date_of_issuance":"2012-04-23",
                  "date_of_expiry":"2022-04-22"
               }
            }
         ]
      },
      "claims":{  
         "given_name":"Max",
         "family_name":"Meier",
         "birthdate":"1956-01-28",
         "place_of_birth":{  
            "country":"DE",
            "locality":"Musterstadt"
         },
         "nationality":"DE",
         "address":{  
            "locality":"Maxstadt",
            "postal_code":"12344",
            "country":"DE",
            "street_address":"An der Sanddüne 22"
         }
      }
   }
}
```

## id_document + utility bill

```JSON
{  
   "verified_claims":{  
      "verification":{  
         "trust_framework":"de_aml",
         "time":"2012-04-23T18:25:43.511+01",
         "verification_process":"676q3636461467647q8498785747q487",
         "evidence":[  
            {  
               "type":"id_document",
               "method":"pipp",
               "document":{  
                  "document_type":"de_erp_replacement_idcard",
                  "issuer":{  
                     "name":"Stadt Augsburg",
                     "country":"DE"
                  },
                  "number":"53554554",
                  "date_of_issuance":"2012-04-23",
                  "date_of_expiry":"2022-04-22"
               }
            },
            {  
               "type":"utility_bill",
               "provider":{  
                  "name":"Stadtwerke Musterstadt",
                  "country":"DE",
                  "region":"Thüringen",
                  "street_address":"Energiestrasse 33"
               },
               "date":"2013-01-31"
            }
         ]
      },
      "claims":{  
         "given_name":"Max",
         "family_name":"Meier",
         "birthdate":"1956-01-28",
         "place_of_birth":{  
            "country":"DE",
            "locality":"Musterstadt"
         },
         "nationality":"DE",
         "address":{  
            "locality":"Maxstadt",
            "postal_code":"12344",
            "country":"DE",
            "street_address":"An der Sanddüne 22"
         }
      }
   }
}
```

## Notified eID system (eIDAS)

```JSON
{  
   "verified_claims":{  
      "verification":{  
         "trust_framework":"eidas_ial_substantial"
      },
      "claims":{  
         "given_name":"Max",
         "family_name":"Meier",
         "birthdate":"1956-01-28",
         "place_of_birth":{  
            "country":"DE",
            "locality":"Musterstadt"
         },
         "nationality":"DE",
         "address":{  
            "locality":"Maxstadt",
            "postal_code":"12344",
            "country":"DE",
            "street_address":"An der Sanddüne 22"
         }
      }
   }
}
```

## Verified Claims in UserInfo Response

### Request

<!-- In this example we assume the RP uses the `scope` parameter to request the email address and, additionally, the `claims` parameter, to request verified Claims. -->
この例では, RP は `scope` パラメーターを `email` `address` を要求するために使用し, さらに verified Claims を要求するために `claims` パラメータを使用することを想定する.

<!-- The scope value is: `scope=openid email` -->
scope 値は次の通り: `scope=openid email`

<!-- The value of the `claims` parameter is: -->
`claims` パラメータ値は次の通り:

```json
{  
   "userinfo":{  
       "verified_claims":{  
         "claims":{  
            "given_name":null,
            "family_name":null,
            "birthdate":null
         }
      }
   }	
}
```

### UserInfo Response

<!-- The respective UserInfo response would be -->
それぞれの UserInfo レスポンスは次の通り:

```http
HTTP/1.1 200 OK
Content-Type: application/json

{  
   "iss":"https://server.example.com",
   "sub":"248289761001",
   "email":"janedoe@example.com",
   "email_verified":true,
   "verified_claims":{  
      "verification":{  
         "trust_framework":"de_aml",
         "time":"2012-04-23T18:25:43.511+01",
         "verification_process":"676q3636461467647q8498785747q487",
         "evidence":[  
            {  
               "type":"id_document",
               "method":"pipp",
               "document":{  
                  "type":"idcard",
                  "issuer":{  
                     "name":"Stadt Augsburg",
                     "country":"DE"
                  },
                  "number":"53554554",
                  "date_of_issuance":"2012-04-23",
                  "date_of_expiry":"2022-04-22"
               }
            }
         ]
      },
      "claims":{  
         "given_name":"Max",
         "family_name":"Meier",
         "birthdate":"1956-01-28"
      }
   }
}
```

## Verified Claims in ID Tokens

### Request

<!-- In this case, the RP requests verified Claims along with other Claims about the End-User in the `claims` parameter and allocates the response to the ID Token (delivered from the token endpoint in case of grant type `code`). -->
この場合, RP は `claims` パラメーターで End-User に関する他の Claims と一緒に verified Claims を要求し, ID Token (grant type `code` の場合は token endpoint から配信される) にレスポンスを割り当てる.

<!-- The `claims` parameter value is -->
`claims` パラメータ値は次の通り:

```json
{  
   "id_token":{  
      "email":null,
      "preferred_username":null,
      "picture":null,
      "verified_claims":{  
         "claims":{  
            "given_name":null,
            "family_name":null,
            "birthdate":null
         }
      }
   }
}
```

### ID Token

<!-- The respective ID Token could be -->
それぞれの ID Token は次の通り:
```json
{  
   "iss":"https://server.example.com",
   "sub":"24400320",
   "aud":"s6BhdRkqt3",
   "nonce":"n-0S6_WzA2Mj",
   "exp":1311281970,
   "iat":1311280970,
   "auth_time":1311280969,
   "acr":"urn:mace:incommon:iap:silver",
   "email":"janedoe@example.com",
   "preferred_username":"j.doe",
   "picture":"http://example.com/janedoe/me.jpg",
   "verified_claims":{  
      "verification":{  
         "trust_framework":"de_aml",
         "time":"2012-04-23T18:25:43.511+01",
         "verification_process":"676q3636461467647q8498785747q487",
         "evidence":[  
            {  
               "type":"id_document",
               "method":"pipp",
               "document":{  
                  "type":"idcard",
                  "issuer":{  
                     "name":"Stadt Augsburg",
                     "country":"DE"
                  },
                  "number":"53554554",
                  "date_of_issuance":"2012-04-23",
                  "date_of_expiry":"2022-04-22"
               }
            }
         ]
      },
      "claims":{  
         "given_name":"Max",
         "family_name":"Meier",
         "birthdate":"1956-01-28"
      }
   }
}
```

## Aggregated Claims
<!-- Note: line breaks for display purposes only -->
Note: 改行は掲載上の都合による

```http
HTTP/1.1 200 OK
Content-Type: application/json

{ 
   "iss":"https://server.example.com", 
   "sub":"248289761001",
   "email":"janedoe@example.com",
   "email_verified":true,
   "_claim_names":{  
      "verified_claims":"src1"
   },
   "_claim_sources":{  
      "src1":{  
      "JWT":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJodHRwczovL3NlcnZlci5vdGh
      lcm9wLmNvbSIsInZlcmlmaWVkX2NsYWltcyI6eyJ2ZXJpZmljYXRpb24iOnsidHJ1c3RfZnJhbWV3b3
      JrIjoiZWlkYXNfaWFsX3N1YnN0YW50aWFsIn0sImNsYWltcyI6eyJnaXZlbl9uYW1lIjoiTWF4IiwiZ
      mFtaWx5X25hbWUiOiJNZWllciIsImJpcnRoZGF0ZSI6IjE5NTYtMDEtMjgifX19.M8tTKxzj5LBgqGj
      UAzFooEiCPJ4wcZVQDrnW5_ooAG4"
      }
   }
}
```

## Distributed Claims

```http
HTTP/1.1 200 OK
Content-Type: application/json

{
   "iss":"https://server.example.com",  
   "sub":"248289761001",
   "email":"janedoe@example.com",
   "email_verified":true,
   "_claim_names":{  
      "verified_claims":"src1"
   },
   "_claim_sources":{  
      "src1":{  
         "endpoint":"https://server.yetanotherop.com/claim_source",
         "access_token":"ksj3n283dkeafb76cdef"
      }
   }
}
```

# OP Metadata {#opmetadata}

<!-- The OP advertises its capabilities with respect to verified Claims in its openid-configuration (see [@!OpenID-Discovery]) using the following new elements: -->
OP は 以下の新しい属性を利用して openid-configuration (see [@!OpenID-Discovery]) で verified Claims に関する機能を通知する.

<!-- `verified_claims_supported`: Boolean value indicating support for `verified_claims`, i.e. the OpenID Connect for Identity Assurance extension. --> 
`verified_claims_supported`: `verified_claims` をサポートするか, つまり OpenID Connect for Identity Assurance extension のサポートを示す Boolean 値.

<!-- `trust_frameworks_supported` This is a JSON array containing all supported trust frameworks. -->
`trust_frameworks_supported` サポートする全ての trust frameworks を含む JSON 配列.

<!-- `evidence_supported` This JSON array contains all types of identity evidence the OP uses. -->
`evidence_supported` OP が利用する全ての identity evidence の種類を含む JSON 配列.

<!-- `id_documents_supported` This JSON array contains all identity documents utilized by the OP for identity verification. -->
`id_documents_supported` OP が identity verification に利用しているすべての identity documents を含む JSON 配列.

<!-- `id_documents_verification_methods_supported` This element is a JSON array containing the id document verification methods a OP supports as defined in (#verification). --> 
`id_documents_verification_methods_supported` (#verification) に定義される OP がサポートする id document verification method を含む JSON配列.

<!-- `claims_in_verified_claims_supported` This JSON array contains all claims supported within `verified_claims`. -->
`claims_in_verified_claims_supported` `verified_claims` 内でサポートされる全ての claims を含む JSON 配列

<!-- This is an example openid-configuration snippet: -->
以下に openid-configuration の snippet の例を示す.

```json
{  
...
   "verified_claims_supported":true,
   "trust_frameworks_supported":[
     "nist_800_63A_ial_2",
     "nist_800_63A_ial_3"
   ],
   "evidence_supported":[
      "id_document",
      "utility_bill",
      "qes"
   ]
   "id_documents_supported":[  
       "idcard",
       "passport",
       "driving_permit"
   ]
   "id_documents_verification_methods_supported":[  
       "pipp",
       "sripp",
       "eid"
   ]
   "claims_in_verified_claims_supported":[  
      "given_name",
      "family_name",
      "birthdate",
      "place_of_birth",
      "nationality",
      "address"
   ],
...
}
```

<!-- The OP MUST support the `claims` parameter and needs to publish this in its openid-configuration using the `claims_parameter_supported` element. -->
OP は `claims` パラメーターをサポートし, `claims_parameter_supported` 要素を利用して openid-configuration でこれを公開しなければならない (MUST).

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

# Privacy Consideration {#Privacy}
OP and RP MUST establish a legal basis before exchanging any personally identifiable information. It can be established upfront or in the course of the OpenID process. 

# Security Considerations {#Security}
      
The integrity and authenticity of the issued assertions MUST be ensured in order to prevent identity spoofing. The Claims source MUST therefore cryptographically sign all assertions. 

The confidentiality of all user data exchanged between the protocol parties MUST be ensured using suitable methods at transport or application layer. 

# Predefined Values {#predefined_values}

## Trust Frameworks {#predefined_values_tf}
This section defines trust framework identifiers for use with this specification.

| Identifier | Definition|
|:------------|:-----------|
|`de_aml`    |The OP verifies and maintains user identities in conforms with the German Anti-Money Laundering Law.|
|`eidas_ial_substantial`| The OP is able to attest user identities in accordance with the EU regulation No 910/2014 (eIDAS) at the identitfication assurance level "Substantial".|
|`eidas_ial_high`|The OP is able to attest user identities in accordance with the EU regulation No 910/2014 (eIDAS) at the identitfication assurance level "High".|
|`nist_800_63A_ial_2`|The OP is able to attest user identities in accordance with the NIST Special Publication 800-63A at the Identity Assurance Level 2.|
|`nist_800_63A_ial_3`|The OP is able to attest user identities in accordance with the NIST Special Publication 800-63A at the Identity Assurance Level 3.|
|`jp_aml`|The OP verifies and maintains user identities in conforms with the Japanese Act on Prevention of Transfer of Criminal Proceeds.|
|`jp_mpiupa`|The OP verifies and maintains user identities in conformance with the Japanese Act for Identification, etc. by Mobile Voice Communications Carriers of Their Subscribers, etc. and for Prevention of Improper Use of Mobile Voice Communications Services.|

## Identity Documents {#predefined_values_idd}

This section defines identity document identifiers for use with this specification.

| Identifier | Definition|
|:------------|:-----------|
|`idcard`|An identity document issued by a country's government for the purpose of identifying a citizen.|
|`passport`|A passport is a travel document, usually issued by a country's government, that certifies the identity and nationality of its holder primarily for the purpose of international travel.[@?OxfordPassport]|
|`driving_permit`|Official document permitting an individual to operate motorized vehicles. In the absence of a formal identity document, a driver's license may be accepted in many countries for identity verification.|
|`de_idcard_foreigners`|ID Card issued by the German government to foreign nationals.|
|`de_emergency_idcard`|ID Card issued by the German government to foreign nationals as passports replacement|
|`de_erp`|Electronic Resident Permit issued by the German government to foreign nationals|
|`de_erp_replacement_idcard`|Electronic Resident Permit issued by the German government to foreign nationals as replacement for another identity document|
|`de_idcard_refugees`|ID Card issued by the German government to refugees as passports replacement|
|`de_idcard_apatrids`|ID Card issued by the German government to apatrids as passports replacement|
|`de_certificate_of_suspension_of_deportation`|identity document issued to refugees in case of suspension of deportation that are marked as "id card replacement"|
|`de_permission_to_reside`|permission to reside issued by the German governed to foreign nationals appliying for asylum|
|`de_replacement_idcard`|ID Card replacement document issued by the German government to foreign nationals (see Act on the Residence, Economic Activity and Integration of Foreigners in the Federal Territory, Residence Act, Appendix D1 ID Card replacement according to § 48 Abs. 2 i.V.m. § 78a Abs. 4)|
|`jp_drivers_license`| Japanese drivers license
|`jp_residency_card_for_foreigner`| Japanese residence card for foreigners.|
|`jp_individual_number_card`| Japanese national id card.|
|`jp_permanent_residency_card_for_foreigner`| Japanese special residency card for foreigners to permit permanently resident.|
|`jp_health_insurance_card`| Japanese health and insurance card.|
|`jp_residency_card`| Japanese residency card|

## Verification Methods {#predefined_values_vm}

This section defines verification method identifiers for use with this specification.

| Identifier | Definition          |
|:------------|---------------------|
|`pipp`|Physical In-Person Proofing|
|`sripp`|Supervised remote In-Person Proofing|
|`eid`|Online verification of an electronic ID card|


# JSON Schema {#json_schema}

This section contains the JSON Schema of assertions containing the `verified_claims` claim. 

```JSON
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "definitions":{
    "qes":{
      "type":"object",
      "properties":{
        "type":{
          "type":"string",
          "enum":[
            "qes"
          ]
        },
        "issuer":{
          "type":"string"
        },
        "serial_number":{
          "type":"string"
        },
        "created_at":{
          "type":"string",
          "format":"date"
        }
      },
      "required": ["type","issuer","serial_number","issued_at"]
    },
    "utility_bill":{
      "type":"object",
      "properties":{
        "type":{
          "type":"string",
          "enum":[
            "utility_bill"
          ]
        },
        "provider":{
          "type":"object",
          "properties":{
            "name":{
              "type":"string"
            },
            "country":{
              "type":"string"
            },
            "region":{
              "type":"string"
            },
            "street_address":{
              "type":"string"
            }
          }
        },
        "date":{
          "type":"string"
        }
      },
      "required": ["type","provider","date"]
    },
    "id_document":{
      "type":"object",
      "properties":{
        "type":{
          "type":"string",
          "enum":[
            "id_document"
          ]
        },
        "method":{
          "type":"string",
          "enum":["pipp","sripp","eid"]
        },
        "verifier":{
          "type":"object",
          "properties":{
            "organization":{
              "type":"string"
            },
            "txn":{
              "type":"string"
            }
          }
        },
        "time":{
              "type":"string",
              "format":"time"
        },
        "document":{
          "type":"object",
          "properties":{
            "type":{
              "type":"string",
              "enum":[
                "idcard",
                "passport",
                "driving_permit",
                "de_idcard_foreigners",
                "de_emergency_idcard",
                "de_erp",
                "de_erp_replacement_idcard",
                "de_idcard_refugees",
                "de_idcard_apatrids",
                "de_certificate_of_suspension_of_deportation",
                "de_permission_to_reside",
                "de_replacement_idcard",
                "jp_drivers_license",
                "jp_residency_card_for_foreigner",
                "jp_individual_number_card",
                "jp_permanent_residency_card_for_foreigner",
                "jp_health_insurance_card",
                "jp_residency_card"
              ]
            },
            "number":{
              "type":"string"
            },
            "issuer":{
              "type":"object",
              "properties":{
                "name":{
                  "type":"string"
                },
                "country":{
                  "type":"string"
                }
              }
            },
            "date_of_issuance":{
              "type":"string",
              "format":"date"
            },
            "date_of_expiry":{
              "type":"string",
              "format":"date"
            }
          }
        }
      },
      "required":[
        "type",
        "method",
        "document"
      ]
    }
  },
  "type":"object",
  "properties":{
    "verified_claims":{
      "type":"object",
      "properties":{
        "verification":{
          "type":"object",
          "properties":{
            "trust_framework":{
              "type":"string",
              "enum":[
                "de_aml",
                "eidas_ial_substantial",
                "eidas_ial_hig",
                "nist_800_63A_ial_2",
                "nist_800_63A_ial_3",
                "jp_aml",
                "jp_mpiupa"
              ]
            },
            "time":{
              "type":"string",
              "format":"time"
            },
            "verification_process":{
              "type":"string"
            },
            "evidence":{
              "type":"array",
              "minItems": 1,
              "items":{
                "oneOf":[
                  {
                    "$ref":"#/definitions/id_document"
                  },
                  {
                    "$ref":"#/definitions/utility_bill"
                  },
                  {
                    "$ref":"#/definitions/qes"
                  }
                ]
              }
            }
          },
          "required":["trust_framework"],
          "additionalProperties": false
        },
        "claims":{
          "type":"object",
          "minProperties": 1
        }
      },
      "required":["verification","claims"],
      "additionalProperties": false
    },
    "txn": {"type": "string"}
  },
  "required":["verified_claims"]
}
```



<reference anchor="OpenID" target="http://openid.net/specs/openid-connect-core-1_0.html">
  <front>
    <title>OpenID Connect Core 1.0 incorporating errata set 1</title>
    <author initials="N." surname="Sakimura" fullname="Nat Sakimura">
      <organization>NRI</organization>
    </author>
    <author initials="J." surname="Bradley" fullname="John Bradley">
      <organization>Ping Identity</organization>
    </author>
    <author initials="M." surname="Jones" fullname="Mike Jones">
      <organization>Microsoft</organization>
    </author>
    <author initials="B." surname="de Medeiros" fullname="Breno de Medeiros">
      <organization>Google</organization>
    </author>
    <author initials="C." surname="Mortimore" fullname="Chuck Mortimore">
      <organization>Salesforce</organization>
    </author>
   <date day="8" month="Nov" year="2014"/>
  </front>
</reference>

<reference anchor="OpenID-Discovery" target="https://openid.net/specs/openid-connect-discovery-1_0.html">
  <front>
    <title>OpenID Connect Discovery 1.0 incorporating errata set 1</title>
    <author initials="N." surname="Sakimura" fullname="Nat Sakimura">
      <organization>NRI</organization>
    </author>
    <author initials="J." surname="Bradley" fullname="John Bradley">
      <organization>Ping Identity</organization>
    </author>
    <author initials="B." surname="de Medeiros" fullname="Breno de Medeiros">
      <organization>Google</organization>
    </author>
    <author initials="E." surname="Jay" fullname="Edmund Jay">
      <organization> Illumila </organization>
    </author>
   <date day="8" month="Nov" year="2014"/>
  </front>
</reference>

<reference anchor="NIST-SP-800-63a" target="https://doi.org/10.6028/NIST.SP.800-63a">
  <front>
    <title>NIST Special Publication 800-63A, Digital Identity Guidelines, Enrollment and Identity Proofing Requirements</title>
    <author fullname="Paul A. Grassi">
      <organization>NIST</organization>
    </author>
    <author initials="James L." surname="Fentony" fullname="James L. Fentony">
      <organization>Altmode Networks</organization>
    </author>
    <author initials="Naomi B." surname="Lefkovitz" fullname="Naomi B. Lefkovitz">
      <organization>NIST</organization>
    </author>
    <author initials="Jamie M." surname="Danker" fullname="Jamie M. Danker">
      <organization>Department of Homeland Security</organization>
    </author>
    <author initials="Yee-Yin" surname="Choong" fullname="Yee-Yin Choong">
      <organization>NIST</organization>
    </author>
    <author initials="Kristen K." surname="Greene" fullname="Kristen K. Greene">
      <organization>NIST</organization>
    </author>
    <author initials="Mary F." surname="Theofanos" fullname="Mary F. Theofanos">
      <organization>NIST</organization>
    </author>
   <date month="June" year="2017"/>
  </front>
</reference>

<reference anchor="eIDAS" target="https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32014R0910">
  <front>
    <title>REGULATION (EU) No 910/2014 OF THE EUROPEAN PARLIAMENT AND OF THE COUNCIL on electronic identification and trust services for electronic transactions in the internal market and repealing Directive 1999/93/EC</title>
    <author initials="" surname="European Parliament">
      <organization>European Parliament</organization>
    </author>
   <date day="23" month="July" year="2014"/>
  </front>
</reference>

<reference anchor="ISO8601-2004" target="http://www.iso.org/iso/catalogue_detail?csnumber=40874">
	<front>
	  <title>ISO 8601:2004. Data elements and interchange formats - Information interchange -
	  Representation of dates and times</title>
	  <author fullname="International Organization for Standardization">
	    <organization abbrev="ISO">International Organization for
	    Standardization</organization>
	  </author>
	  <date year="2004" />
	</front>
</reference>

<reference anchor="ISO3166-1" target="https://www.iso.org/standard/63545.html">
	<front>
	  <title>ISO 3166-1:1997. Codes for the representation of names of
	  countries and their subdivisions -- Part 1: Country codes</title>
	  <author fullname="International Organization for Standardization">
	    <organization abbrev="ISO">International Organization for
	    Standardization</organization>
	  </author>
	  <date year="2013" />
	</front>
</reference>

<reference anchor="ISO3166-3" target="https://www.iso.org/standard/63547.html">
	<front>
	  <title>ISO 3166-1:2013. Codes for the representation of names of countries and their subdivisions -- Part 3: Code for formerly used names of countries</title>
	  <author fullname="International Organization for Standardization">
	    <organization abbrev="ISO">International Organization for
	    Standardization</organization>
	  </author>
	  <date year="2013" />
	</front>
</reference>

<reference anchor="OxfordPassport" target="http://www.oxfordreference.com/view/10.1093/acref/9780199290543.001.0001/acref-9780199290543-e-1616">
  <front>
    <title>The New Oxford Companion to Law. ISBN 9780199290543.</title>
    <author initials="P" surname="Cane" fullname="P. Cane">
    </author>
    <author initials="Mary F." surname="Conaghan" fullname="J. Conaghan">
    </author>
   <date year="2008"/>
  </front>
</reference>

<reference anchor="ICAO-Doc9303" target="https://www.icao.int/publications/Documents/9303_p3_cons_en.pdf">
  <front>
    <title>Machine Readable Travel Documents, Seventh Edition, 2015, Part 3: Specifications Common to all MRTDs</title>
    	  <author fullname="INTERNATIONAL CIVIL AVIATION ORGANIZATION">
	    <organization abbrev="ICAO">INTERNATIONAL CIVIL AVIATION ORGANIZATION</organization>
	  </author>
   <date year="2015"/>
  </front>
</reference>

{backmatter}

# Acknowledgements {#Acknowledgements}
      
The following people at yes.com and partner companies contributed to the concept described in the initial contribution to this specification: Karsten Buch, Lukas Stiebig, Sven Manz, Waldemar Zimpfer, Willi Wiedergold, Fabian Hoffmann, Daniel Keijsers, Ralf Wagner, Sebastian Ebling, Peter Eisenhofer.
      
I would like to thank Sebastian Ebling, Marcos Sanz, Tom Jones, Mike Pegman, 
Michael B. Jones, and Jeff Lombardo for their valuable feedback that helped to evolve this specification. 

# Notices

Copyright (c) 2019 The OpenID Foundation.

The OpenID Foundation (OIDF) grants to any Contributor, developer, implementer, or other interested party a non-exclusive, royalty free, worldwide copyright license to reproduce, prepare derivative works from, distribute, perform and display, this Implementers Draft or Final Specification solely for the purposes of (i) developing specifications, and (ii) implementing Implementers Drafts and Final Specifications based on such documents, provided that attribution be made to the OIDF as the source of the material, but that such attribution does not indicate an endorsement by the OIDF.

The technology described in this specification was made available from contributions from various sources, including members of the OpenID Foundation and others. Although the OpenID Foundation has taken steps to help ensure that the technology is available for distribution, it takes no position regarding the validity or scope of any intellectual property or other rights that might be claimed to pertain to the implementation or use of the technology described in this specification or the extent to which any license under such rights might or might not be available; neither does it represent that it has made any independent effort to identify any such rights. The OpenID Foundation and the contributors to this specification make no (and hereby expressly disclaim any) warranties (express, implied, or otherwise), including implied warranties of merchantability, non-infringement, fitness for a particular purpose, or title, related to this specification, and the entire risk as to implementing this specification is assumed by the implementer. The OpenID Intellectual Property Rights policy requires contributors to offer a patent promise not to assert certain patent claims against other contributors and against implementers. The OpenID Foundation invites any interested party to bring to its attention any copyrights, patents, patent applications, or other proprietary rights that may cover technology that may be required to practice this specification.

# Document History

   [[ To be removed from the final specification ]]
   
   -07
   
   * fixed typos
   * changed `nationality` String claim to `nationalities` String array claim
   * replaced `agent` in id_document verifier element by `txn` element
   * qes method: fixed error in description of `issuer`
   * qes method: changed `issued_at` to `created_at` since this field applies to the signature (that is created and not issued)
   * Changed format of `nationalities` and issuing `country` to ICAO codes
   * Changed `date` in verification element to `time`
   * Added Japanese trust frameworks to pre-defined values
   * Added Japanese id documents to pre-defined values
   * adapted JSON schema and examples
   
   -06
   
   * Incorporated review feedback by Marcos Sanz and Adam Cooper
   * Added text on integrity, authenticity, and confidentiality for data passed between OP and RP to Security Considerations section
   * added `purpose` field to `claims` parameter
   * added feature to let the RP explicitly requested certain `verification` data
   
   -05
   
   * incorporated review feedback by Mike Jones
   * Added OIDF Copyright Notices
   * Moved Acknowledgements to Appendix A
   * Removed RFC 2119 keywords from scope & requirements section and rephrased section
   * rephrased introduction
   * replaced `birth_name` with `birth_family_name`, `birth_given_name`, and `birth_middle_name`
   * replaced `transaction_id` with `txn` from RFC 8417
   * added references to eIDAS, ISO 3166-1, ISO 3166-3, and ISO 8601-2004
   * added note on `purpose` and locales
   * changed file name and document title to include 1.0 version id
   * corrected evidence plural
   * lots of editorial fixes
   * Alignment with OpenID Connect Core wording
   * Renamed `id` to `verification_process`
   * Renamed `verified_person_data` to `verified_claims`
   
   -04
   
   * incorporated review feedback by Marcos Sanz 
   
   -03
   
   * enhanced draft to support multiple evidence
   * added a JSON Schema for assertions containing the `verified_person_data` Claim
   * added more identity document definitions
   * added `region` field to `place_of_birth` Claim
   * changed `eidas_loa_substantial/high` to `eidas_ial_substantial/high` 
   * fixed typos in examples
   * uppercased all editorial occurences of the term `claims` to align with OpenID Connect Core
   
   -02
   
   * added new request parameter `purpose`
   * simplified/reduced number of verification methods
   * simplfied identifiers
   * added `identity_documents_supported` to metadata section
   * improved examples
   
   -01 

   *  fixed some typos
   *  remove organization element (redundant) (issue 1080)
   *  allow other Claims about the End-User in the `claims` sub element (issue 1079)
   *  changed `legal_context` to `trust_framework`
   *  added explanation how the content of the verification element is determined by the trust framework
   *  added URI-based identifiers for `trust_framework`, `identity_document` and (verification) `method`
   *  added example attestation for notified/regulated eID system
   *  adopted OP metadata section accordingly 
   *  changed error behavior for `max_age` member to alig with OpenID Core
   *  Added feature to let the RP express requirements for verification data (trust framework, identity documents, verification method)
   *  Added privacy consideration section and added text on legal basis for data exchange
   *  Added explanation about regulated and un-regulated eID systems
   
   -00 (WG document)

   *  turned the proposal into a WG document
   *  changed name
   *  added terminology section and reworked introduction
   *  added several examples (ID Token vs UserInfo, unverified & verified claims, aggregated & distributed claims)
   *  incorporated text proposal of Marcos Sanz regarding max_age
   *  added IANA registration for new error code `unable_to_meet_requirement`

# 翻訳者 {#translator}

本仕様の翻訳は, OpenIDファウンデーションジャパン [@oidfj] KYCワーキンググループ[@oidfj-kycwg], 翻訳・教育ワーキンググループ [@oidfj-trans] を主体として, 有志のメンバーによって行われました.
質問や修正依頼などについては, Githubレポジトリー [@!oidfj-github]にご連絡ください.

* Muneomi Sakuta (SoftBank Corp.)
* Yuu Kikuchi (OPTiM Corp.)
* Nov Matake (YAuth.jp)