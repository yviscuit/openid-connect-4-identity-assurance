%%%
title = "OpenID Connect for Identity Assurance 1.0"
abbrev = "openid-connect-4-identity-assurance-1_0"
ipr = "none"
workgroup = "eKYC-IDA"
keyword = ["security", "openid", "identity assurance", "ekyc"]

[seriesInfo]
name = "Internet-Draft"

value = "openid-connect-4-identity-assurance-1_0-12"

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

[[author]]
initials="M."
surname="Haine"
fullname="Mark Haine"
organization="Considrd.Consulting Ltd"
    [author.address]
    email = "mark@considrd.consulting"

[[author]]
initials="A."
surname="Pulido"
fullname="Alberto Pulido"
organization="Santander"
    [author.address]
    email = "alberto.pulido@santander.co.uk"

[[author]]
initials="K."
surname="Lehmann"
fullname="Kai Lehmann"
organization="1&1 Mail & Media Development & Technology GmbH"
    [author.address]
    email = "kai.lehmann@1und1.de"

[[author]]
initials="K."
surname="Koiwai"
fullname="Kosuke Koiwai"
organization="KDDI Corporation"
    [author.address]
    email = "ko-koiwai@kddi.com"

%%%

.# Abstract

This specification defines an extension of OpenID Connect for providing Relying Parties with Verified Claims about End-Users. This extension facilitates the verification of the identity of a natural person.

{mainmatter}

# Introduction {#Introduction}

<!-- This specification defines an extension to OpenID Connect [@!OpenID] for providing Relying Parties with identity information, i.e., Verified Claims, along with an explicit statement about the verification status of these Claims (what, how, when, according to what rules, using what evidence). This specification is aimed at enabling use cases requiring strong assurance, for example, to comply with regulatory requirements such as Anti-Money Laundering laws or access to health data, risk mitigation, or fraud prevention. -->
この仕様では，Relying Party に identity 情報，すなわち検証済みクレーム提供するための OpenID Connect[!@OpenID] の拡張と，これらのクレームの検証ステータスに関する明示的なステートメント（何を、どのように、いつ、どのルールに従って、 どのようなエビデンスを使用して）を定義する．
この仕様は，たとえば，マネーロンダリング防止法や健康データへのアクセス，リスクの軽減，不正防止などの規制要件に準拠するような，強力な保証を必要とするユースケースを可能にすることを目的としている．

<!-- In such use cases, the Relying Party (RP) needs to understand the trustworthiness or assurance level of the Claims about the End-User that the OpenID Connect Provider (OP) is willing to communicate, along with process-related information and evidence used to verify the End-User Claims. -->
そのようなユースケースでは, 依拠当事者 (RP) は, OpenID Connect プロバイダー (OP) の伝達するプロセス関連情報とエンドユーザーの Claim の検証に利用したエビデンスと一緒に，エンドユーザーに関する Claim の信頼性または保証レベルを知る必要がある.

<!-- The `acr` Claim, as defined in Section 2 of the OpenID Connect specification [@!OpenID], is suited to assure information about the authentication performed in an OpenID Connect transaction. 
Identity assurance, however, requires a different representation: While authentication is an aspect of an OpenID Connect transaction, assurance is a property of a certain Claim or a group of Claims. Several of them will typically be conveyed to the RP as the result of an OpenID Connect transaction. -->
OpenID Connect 仕様 [@!OpenID] の Section 2 で定義されている `acr` Claim は, OpenID Connect トランザクションで実行される認証に関する情報を証明するのに適している. ただし, identity assurance には異なる表現が必要である: 認証は OpenID Connect トランザクションの側面であり, assurance は特定の Claim または Claim のグループのプロパティである．それらのいくつかは通常, OpenID Connect トランザクションの結果として RP に伝えられる.

<!-- For example, the assurance an OP typically will be able to give for an e-mail address will be “self-asserted” or “verified by opt-in or similar mechanism”. The family name of an End-User, in contrast, might have been verified in accordance with the respective Anti Money Laundering Law by showing an ID Card to a trained employee of the OP operator. -->
たとえば, 通常 OP が電子メールアドレスに与えることができる保証は「自己表明」または「オプトインまたは同様のメカニズムによって検証」される. 対照的にエンドユーザーの姓は, OP オペレーターの訓練を受けた従業員に ID カードを提示することにより, それぞれのマネーロンダリング防止法に従って検証された可能性がある.

<!-- Identity assurance therefore requires a way to convey assurance data along with and coupled to the respective Claims about the End-User. This specification defines a suitable representation and mechanisms the RP will utilize to request Verified Claims about an End-User along with assurance data and for the OP to represent these Verified Claims and accompanying assurance data. -->
したがって, identity assurance には, エンドユーザーに関する各 Claim とともに保証データを伝達する方法が必要である. この仕様は, RP がエンドユーザーに関する検証済み Claim を 保証データとともに要求し, OP がこれらの検証済み Claim と付随する保証データを表すために利用する適切な表現とメカニズムを定義する.

<!-- Note: This specifications fulfills the criteria for portability and interoperability mechanisms of Digital ID systems as defined in [@FATF-Digital-Identity]. -->
Note: この仕様は [@FATF-Digital-Identity]　で定義されているデジタル ID システムのポータビリティと相互運用性メカニズムの基準を満たしている．

## Terminology

<!-- This section defines some terms relevant to the topic covered in this document, inspired by NIST SP 800-63A [@?NIST-SP-800-63a]. -->
このセクションでは, NIST SP 800-63A [@?NIST-SP-800-63a] の影響を受けた, このドキュメントで扱われているトピックに関連するいくつかの用語を定義する.

<!-- * Identity Proofing - process in which an End-User provides evidence to an OP or Claim provider reliably identifying themselves, thereby allowing the OP or Claim provider to assert that identification at a useful assurance level. -->
* Identity Proofing - エンドユーザーが OP または自分自身を確実に識別する Claim プロバイダーにエビデンスを提供することにより, OP または Claim provider が有用な assurance レベルで識別できるようにするプロセス.

<!-- * Identity Verification - process conducted by the OP or a Claim provider to verify the End-User's identity. -->
* Identity Verification - エンドユーザーの身元を確認するために OP または Claim プロバイダーによって実行されるプロセス.

<!-- * Identity Assurance - process in which the OP or a Claim provider asserts identity data of a certain End-User with a certain assurance towards an RP, typically expressed by way of an assurance level. Depending on legal requirements, the OP may also be required to provide evidence of the identity verification process to the RP. -->
* Identity Assurance - OP または Claim プロバイダーが, RP に対してある一定の確からしさをもって特定のエンドユーザーの Identity データを主張するプロセスで，通常は assurance レベルで表される. 法的要件に応じて, OP は identity verification プロセスのエビデンスを RP に提供する必要がある場合もある.

<!-- * Verified Claims - Claims about an End-User, typically a natural person, whose binding to a particular End-User account was verified in the course of an identity verification process. -->
* Verified Claims - 特定のエンドユーザーアカウントへのバインドが identity verification プロセスの過程で検証されたエンドユーザー (通常は自然人) に関する Claim.


# Scope

<!-- This specification defines the technical mechanisms to allow Relying Parties to request Verified Claims and to enable OpenID Providers to provide Relying Parties with Verified Claims ("the tools"). -->
本仕様は，Relying Party が検証済み Claim を要求できるようにし，OpenID Provider が Relying Party に検証済み Claim を提供できるようにするためのテクニカルメカニズムを定義する．("ツール")

<!-- Additional facets needed to deploy a complete solution for identity assurance, such as legal aspects (including liability), concrete trust frameworks, or commercial agreements are out of scope. It is up to the particular deployment to complement the technical solution based on this specification with the respective definitions ("the rules"). -->
法的側面(責任を含む)，具体的なトラストフレームワーク，商取引契約など，identity assurance の完全なソリューションを展開するために必要な追加の側面は範囲外である．本仕様に基づくテクニカルソリューションをそれぞれの定義で補完するのは，個別の展開次第である．("ルール")

<!-- Note: Although such aspects are out of scope, the aim of the specification is to enable implementations of the technical mechanism to be flexible enough to fulfill different legal and commercial requirements in jurisdictions around the world. Consequently, such requirements will be discussed in this specification as examples. -->
Note: そのような側面は範囲外であるが，仕様の目的は，世界中の管轄区域における異なる法律および商業的要件を満たすのに十分な柔軟性を備えたテクニカルメカニズムの実装を可能にすることである．従って，そのような要件は本仕様で例として検討する．

# Requirements

<!-- The RP will be able to request the minimal data set it needs (data minimization) and to express requirements regarding this data, the evidence and the identity verification processes employed by the OP. -->
RP は，必要最小限のデータセットの要求 (data minimization) と，このデータ，エビデンスおよび OP で採用されている identity verification プロセスに関する要件を表現できる．

<!-- This extension will be usable by OPs operating under a certain regulation related to identity assurance, such as eIDAS, as well as other OPs operating without such a regulation.  -->
この拡張機能は、eIDAS などの identity assurance に関連する特定の規制の下で動作する OP はもちろん，そのような規制なしで動作する他の OP でも使用できる．

<!-- It is assumed that OPs operating under a suitable regulation can assure identity data without the need to provide further evidence since they are approved to operate according to well-defined rules with clearly defined liability. For example in the case of eIDAS, the peer review ensures eIDAS compliance and the respective member state assumes the liability for the identities asserted by its notified eID systems. -->
適切な規制の下で運用されている OP は，明確に定義された責任を伴う明確に定義されたルールに従って運用することが承認されているため，追加のエビデンスを提供する必要なしに identity data を保証できると想定されている．例えば eIDAS の場合，ピアレビューは eIDAS コンプライアンスを保証し，それぞれの加盟国は、通知されたeID システムによって主張された identity に対する責任を負う．

<!-- Every other OP not operating under such well-defined conditions may be required to provide the RP data about the identity verification process along with identity evidence to allow the RP to conduct their own risk assessment and to map the data obtained from the OP to other laws. For example, if an OP verifies and maintains identity data in accordance with an Anti Money Laundering Law, it shall be possible for an RP to use the respective identity in a different regulatory context, such as eHealth or the beforementioned eIDAS. -->
そのような明確な条件下で動作していない他のすべての OP は，RP が独自のリスクアセスメントを行い，OP から入手したデータを他の法律にマッピングできるように，identity evidence に加えて identity verification プロセスに関する RP data を提供することを要求されるかもしれない．
例えば，もし OP がマネーロンダリング防止法に従って identity data を検証及び維持する場合，RP がeHealth や前述の eIDAS のような異なる規制のコンテキストでそれぞれの identity を利用できるようにすべきである．

<!-- The basic idea of this specification is that the OP provides all identity data along with metadata about the identity verification process at the OP. It is the responsibility of the RP to assess this data and map it into its own legal context. -->
本仕様の基本的な考え方は，OP は OP での identity verification プロセスに関するメタデータとともに，すべての identity data を提供することである．このデータを評価し，それを独自の法的コンテキストにマッピングするのは RP の責任である．

<!-- From a technical perspective, this means this specification allows the OP to provide Verified Claims along with information about the respective trust framework, but also supports the externalization of information about the identity verification process. -->
技術的な観点から，これは本仕様は OP が信頼するトラストフレームワークに関する情報とともに Verified Claim を提供できるようにするだけでなく，identity verificatoin process に関する情報の外部化もサポートすることを意味する．

<!-- The representation defined in this specification can be used to provide RPs with Verified Claims about the End-User via any appropriate channel. In the context of OpenID Connnect, Verified Claims can be provided in ID Tokens or as part of the UserInfo response. It is also possible to utilize the format described here in OAuth Access Tokens or Token Introspection responses to provide resource servers with Verified Claims. -->
本仕様で定義される表現は，いずれかの適切なチャネルを介してエンドユーザーに関する Verified Claim を RP に提供できる．OpenID Connect のコンテキストにおいて，Verified Claim はID Token またはUserInfoレスポンスの一部として提供できる．OAuth Access Token または Token Introspection レスポンスで記述される形式を用いてリソースサーバーに Verified Claim を提供することもできる．

<!-- This extension is intended to be truly international and support identity assurance across different jurisdictions. The extension is therefore extensible to support various trust frameworks, identity evidence, validation, and verification processes. -->
本拡張は，真に国際的で異なる管轄区域を跨いで identity assurance をサポートすることを意図している．
本拡張は従って，様々なトラストフレームワーク，identity エビデンス，バリデーションや検証プロセスをサポートするために拡張可能である．

<!-- In order to give implementors as much flexibility as possible, this extension can be used in conjunction with existing OpenID Connect Claims and other extensions within the same OpenID Connect assertion (e.g., ID Token or UserInfo response) utilized to convey Claims about End-Users. -->
実装者に可能な限りの柔軟性を与えるために, この拡張は既存の OpenID Connect の Claim および同じ OpenID Connect のアサーション(例えば, ID Token や UserInfo)内の他の拡張と組み合わせて使うことができる.

<!-- For example, OpenID Connect [@!OpenID] defines Claims for representing family name and given name of an End-User without a verification status. These Claims can be used in the same OpenID Connect assertion beside Verified Claims represented according to this extension. -->
例えば，OpenID Connect [@!OpenID] は検証ステータスのないエンドユーザーの性と名を表す Claim を定義している．これらの Claim は本拡張に従って表現される Verified Claim とともに同じ OpenID Connect のアサーションで使うことができる．

<!-- In the same way, existing Claims to inform the RP of the verification status of the `phone_number` and `email` Claims can be used together with this extension. -->
同じように，`phone_number` と `email` Claim の検証ステータスを RP に通知する既存 Claim も本拡張とともに使うことができる．

<!-- Even for representing Verified Claims, this extension utilizes existing OpenID Connect Claims if possible and reasonable. The extension will, however, ensure RPs cannot (accidentally) interpret unverified Claims as Verified Claims. -->
Verified Claim を表す場合でも，本拡張は可能かつ妥当であれば，既存の OpenID Connect の Claim を利用する．しかしながら，拡張は RP が未検証 Claim を Verified Claim として (誤って) 解釈できないようにする．

# Claims {#claims}

## Additional Claims about End-Users {#userclaims}

<!-- In order to fulfill the requirements of some jurisdictions on identity assurance, this specification defines the following Claims for conveying End-User data in addition to the Claims defined in the OpenID Connect specification [@!OpenID]: -->
identity assurance に関する一部の権限の要件を満たすために, この仕様では OpenID仕様 [@!OpenID] に定義されている Claim にエンドユーザデータを伝達するための以下の追加の Claim を定義する:

<!-- | Claim | Type | Description |
|:------|:-----|:------------|
|`place_of_birth`| JSON object | End-User’s place of birth. The value of this member is a JSON structure containing some or all of the following members:|
|||`country`: String representing country in [@!ISO3166-1] Alpha-2 (e.g., DE) or [@!ISO3166-3] syntax.|
|||`region`: String representing state, province, prefecture, or region component. This field might be required in some jurisdictions.|
|||`locality`: String representing city or locality component.|
|`nationalities`| array | End-User’s nationalities using ICAO 3-letter codes [@!ICAO-Doc9303], e.g., "USA" or "JPN". 2-letter ICAO codes MAY be used in some circumstances for compatibility reasons.|
|`birth_family_name`| string | End-User’s family name(s) when they were born, or at least from the time they were a child. This term can be used by a person who changes the family name later in life for any reason. Note that in some cultures, people can have multiple family names or no family name; all can be present, with the names being separated by space characters.|
|`birth_given_name`| string | End-User’s given name(s) when they were born, or at least from the time they were a child. This term can be used by a person who changes the given name later in life for any reason. Note that in some cultures, people can have multiple given names; all can be present, with the names being separated by space characters.|
|`birth_middle_name`| string | End-User’s middle name(s) when they were born, or at least from the time they were a child. This term can be used by a person who changes the middle name later in life for any reason. Note that in some cultures, people can have multiple middle names; all can be present, with the names being separated by space characters. Also note that in some cultures, middle names are not used.|
|`salutation`| string | End-User’s salutation, e.g., “Mr.”|
|`title`| string | End-User’s title, e.g., “Dr.”|
|`msisdn`| string | End-User’s mobile phone number formatted according to ITU-T recommendation [@!E.164], e.g., “+1999550123”|
|`also_known_as`| string | Stage name, religious name or any other type of alias/pseudonym with which a person is known in a specific context besides its legal name. This must be part of the applicable legislation and thus the trust framework (e.g., be an attribute on the identity card).| -->

| Claim | Type | Description |
|:------|:-----|:------------|
|`place_of_birth`| JSON object | エンドユーザーの出生地. このメンバー値は，次のメンバーの一部またはすべてを含む JSON 構造である:|
|||`country`: [@!ISO3166-1] Alpha-2 (例えば, DE) または [@!ISO3166-3] 構文で国を表す文字列. |
|||`region`: State, province, prefecture, または他の地域コンポーネントを表す文字列. 一部の管轄区域ではこのフィールドは必須かもしれない.|
|||`locality`: city, または別の地域を表す文字列.|
|`nationalities`| array | ICAO 3-letter codes [@!ICAO-Doc9303] (例: "USA" や "JPN")用いてエンドユーザーの国籍を表す. 互換性の理由から，状況によっては 2-letter ICAO codes が使われるかもしれない (MAY).|
|`birth_family_name`| string | エンドユーザーが生まれたとき, あるいは少なくとも子供の時から持っている姓. この用語は人生の途中に何らかの理由で姓を変更した人が利用できる. 一部の文化では，人々は複数の姓を持つことも，姓を持たないこともあることに注意すること．全ての名前はスペース文字で区切って存在する．|
|`birth_given_name`| string | エンドユーザーが生まれたとき, あるいは少なくとも子供の時から持っている名前. この用語は人生の途中に何らかの理由で名前を変更した人が利用できる．一部の文化では，人々は複数の名を持つことに注意すること．全ての名前はスペース文字で区切って存在する．|
|`birth_middle_name`| string | エンドユーザーが生まれたとき, あるいは少なくとも子供の時から持っているミドルネーム. この用語は人生の途中に何らかの理由でミドルネームを変更した人が利用できる.一部の文化では，人々は複数のミドルネームを持つことができることに注意すること．全ての名前はスペース文字で区切って存在する．また，一部の文化ではミドルネームが使用されていないことにも注意すること． |
|`salutation`| string | エンドユーザの敬称, 例えば “Mr.”|
|`title`| string | エンドユーザの肩書, 例えば “Dr.”|
|`msisdn`| string | ITU-T recommendation [@!E.164] (例: “+1999550123”) に従って表現されたエンドユーザーの携帯電話番号．|
|`also_known_as`| string | 芸名，宗教名，または実名以外の特定の文脈で人が知られているその他の種類の別名/仮名．これは、適用される法律の一部である必要があり，従ってトラストフレームワーク (例: IDカードの属性) である必要がある．|

## txn Claim

<!-- Strong identity verification typically requires the participants to keep an audit trail of the whole process. -->
一般的に, 強固な identity verification は参加者がプロセス全体の監査証跡を保持する必要がある.

<!-- The `txn` Claim as defined in [@!RFC8417] is used in the context of this extension to build audit trails across the parties involved in an OpenID Connect transaction. -->
[@!RFC8417] で定義されている `txn` Claim はこの拡張のコンテキストで使用され, OpenID Connect トランザクションに関わるの関係者全体の監査証跡を構築する.

<!-- If the OP issues a `txn`, it MUST maintain a corresponding audit trail, which at least consists of the following details: -->
OP が `txn` を発行する場合, 対応する監査証跡を維持する必要があり (MUST), 少なくとも次の詳細で構成される.

<!--
* the transaction ID,
* the authentication method employed, and
* the transaction type (e.g., the set of Claims returned).
-->
* transaction ID,
* 採用されている authentication methods, および
* transaction type (Claim セットの返却など).

<!-- This transaction data MUST be stored as long as it is required to store transaction data for auditing purposes by the respective regulation. -->
このトランザクションデータは, それぞれの規定による監査目的のためにトランザクションデータを保存する必要がある限り保存し続けなければならない (MUST).

<!-- The RP requests this Claim like any other Claim via the `claims` parameter or as part of a default Claim set identified by a scope value. -->
RP はこの Claim を `claims` パラメータを介して, または scope 値によって識別されるデフォルトの Claim の一部として, 他の Claim と同様に要求する.

<!-- The `txn` value MUST allow an RP to obtain these transaction details if needed. -->
`txn` 値は必要に応じて RP がこれらのトランザクションを参照できるようにしなければならない (MUST).

<!-- Note: The mechanism to obtain the transaction details from the OP and their format is out of scope of this specification. -->
注：トランザクションの詳細を, OP および, それらのフォーマットから取得するメカニズムはこの仕様の範囲外である.

## Extended address Claim

<!-- This specification extends the `address` Claim as defined in [@!OpenID] by another sub field containing the country as ISO code. -->
この仕様は，[@!OpenID] で定義されている `address`クレームを，国を ISO コードとして含む別のサブフィールドによって拡張する．

<!-- `country_code`: OPTIONAL. country part of an address represented using an ISO 3-letter code [@!ISO3166-3], e.g., "USA" or "JPN". 2-letter ISO codes [@!ISO3166-1] MAY be used for compatibility reasons. `country_code` MAY be used as alternative to the existing `country` field.  -->
`country_code`: OPTIONAL. ISO 3-letter code [@!ISO3166-3]  (例: "USA" や "JPN") を使用して表される住所の国部分．2-letter ISO codes [@!ISO3166-1] は，互換性の理由から使用されるかもしれない (NAY)．`country_code` は，既存の` country` フィールドの代わりに使用してもよい (MAY)．

# verified_claims Element {#verified_claims}

<!-- This specification defines a generic mechanism to add Verified Claims to JSON-based assertions. The basic idea is to use a container element, called `verified_claims`, to provide the RP with a set of Claims along with the respective metadata and verification evidence related to the verification of these Claims. This way, RPs cannot mix up Verified Claims and unverified Claims and accidentally process unverified Claims as Verified Claims. -->
この仕様は，JSON ベースのアサーションに Verified Claims を追加するための一般的な仕様を定義する．基本的な考え方は `verified_claims` と呼ばれるコンテナ要素を使用し，RP に一連の Claim と，これらの Claim の検証に関連するそれぞれのメタデータ及び検証のエビデンスを提供することである．このように，RP は検証済み Claim と未検証 Claim を混同したり，未検証 Claim を検証済み Claim として誤って処理することはできない．

<!-- The following example would assert to the RP that the OP has verified the Claims provided (`given_name` and `family_name`) according to an example trust framework `trust_framework_example`: -->
次の例では，トラストフレームワーク `trust_framework_example` の例に従って，OP が提供された Claim (`given_name` and `family_name`) を検証したことを RP に表明する:

<{{examples/response/verified_claims_simple.json}}


<!-- The normative definition is given in the following. -->
基準となる定義を以下に示す．

<!-- `verified_claims`: A single object or an array of objects, each object comprising the following sub-elements: -->
`verified_claims`: 単一のオブジェクトまたはオブジェクトの配列で，各オブジェクトは以下のサブ要素で構成される:

<!-- 
* `verification`: REQUIRED. Object that contains data about the verification process.
* `claims`: REQUIRED. Object that is the container for the Verified Claims about the End-User. 
-->
* `verification`: 必須 (REQUIRED). 検証プロセスに関するすべてのデータを含むオブジェクト.
* `claims`: 必須 (REQUIRED). エンドユーザに関するの検証済 Claim のためのコンテナであるオブジェクト.

<!-- Note: Implementations MUST ignore any sub-element not defined in this specification or extensions of this specification. -->
注: 実装は, この仕様またはこの仕様の拡張で定義されていないサブ要素を無視しなければならない (MUST).

<!-- Note: If not stated otherwise, every sub-element in `verified_claims` is defined as optional. Extensions of this specification, including trust framework definitions, can define further constraints on the data structure. -->
注: 特に明記されていない限り，`verified_claims` のすべてのサブ要素はオプショナルとして定義される．トラストフレームワークの定義を含む本仕様の拡張により，データ構造に対するさらなる制約を定義することができる．

<!-- A machine-readable syntax definition of `verified_claims` is given as JSON schema in It can be used to automatically validate JSON documents containing a `verified_claims` element. -->
`verified_claims`　の machine-readable な構文定義は [@!verified_claims.json] で JSON スキーマとして提供され，`verified_claims` 要素を含む JSON ドキュメントを自動的に検証するために利用できる．

## verification Element {#verification}

<!-- This element contains the information about the process conducted to verify a person's identity and bind the respective person data to a user account. -->
この要素には, 個人の身元を確認し, それぞれの個人データをユーザーアカウントにバインドするために実行されたプロセスに関する情報が含まれる.

<!-- The `verification` element consists of the following elements: -->
`verification` 要素は以下の要素を含む:

<!-- `trust_framework`: REQUIRED. String determining the trust framework governing the identity verification process of the OP. -->
`trust_framework`: 必須 (REQUIRED). OP の identity verification プロセスを管理する trust framework を定める文字列.

<!-- An example value is `eidas`, which denotes a notified eID system under eIDAS [@?eIDAS]. -->
例としては `eidas` で, これは eIDAS [@?eIDAS] 公認 eID システムを示す.

<!-- RPs SHOULD ignore `verified_claims` Claims containing a trust framework identifier they do not understand. -->
RPs は理解できないトラストフレームワーク識別子を含む `verified_claims` Claim を無視しなければならない (SHOULD)．

<!-- The `trust_framework` value determines what further data is provided to the RP in the `verification` element. A notified eID system under eIDAS, for example, would not need to provide any further data whereas an OP not governed by eIDAS would need to provide verification evidence in order to allow the RP to fulfill its legal obligations. An example of the latter is an OP acting under the German Anti-Money Laundering Law (`de_aml`). -->
`trust_framework` は, `verification` 要素の中で RP に提供される追加のデータを決定する. たとえば, eIDAS 公認 eID システムは, データを追加する必要はないが, eIDAS に管理されていない OP は RP が法的義務を果たすために verification evidence を提供する必要がある. 後者の例としては, ドイツのマネーロンダリング防止法 (`de_aml`) に基づいて行動する OP である.

<!-- `assurance_level`: OPTIONAL. String determining the assurance level associated with the End-User Claims in the respective `verified_claims`. The value range depends on the respective `trust_framework` value.  -->
`assurance_level`: OPTIONAL. それぞれの `verified_claims` のエンドユーザーのClaimに関連付けられた assurance レベルを決定する文字列. 値の範囲は，それぞれの `trust_framework` 値によって異なる. 

<!-- For example, the trust framework `eidas` can have the identity assurance levels `low`, `substantial` and `high`. -->
例えば，トラストフレームワーク `eidas` は，identity assurance level `low`, `substantial` と `high` を持つことができる．

<!-- For information on predefined trust framework and assurance level values see [@!predefined_values].  -->
事前定義されたトラストフレームワークと assurance level については [@!predefined_values] を参照すること. 

<!-- `assurance_process`: OPTIONAL. JSON object representing the assurance process that was followed, with one or more of the following sub-elements: -->
`assurance_process`: OPTIONAL. 以下のサブ要素の1つ以上を使用して，実行された assurance プロセスを表す JSON オブジェクト:

<!-- 
  * `policy`: OPTIONAL. String representing the standard or policy that was followed.
  * `procedure`: OPTIONAL. String representing a specific procedure from the `policy` that was followed.
  * `status`: OPTIONAL. String representing the current status of the identity verification process.
-->
  * `policy`: OPTIONAL. 準拠した標準またはポリシーを表す文字列．
  * `procedure`: OPTIONAL. 準拠した `policy` からの特定の手順を表す文字列．
  * `status`: OPTIONAL. identity verification プロセスの現在のステータスを表す文字列.

<!-- `time`: OPTIONAL. Time stamp in ISO 8601:2004 [@!ISO8601-2004] `YYYY-MM-DDThh:mm[:ss]TZD` format representing the date and time when the identity verification process took place. This time might deviate from (a potentially also present) `document/time` element since the latter represents the time when a certain evidence was checked whereas this element represents the time when the process was completed. Moreover, the overall verification process and evidence verification can be conducted by different parties (see `document/verifier`). Presence of this element might be required for certain trust frameworks. -->
`time`: OPTIONAL. Identity verification が行われた日時を示す ISO 8601:2004 [@!ISO8601-2004] `YYYY-MM-DDThh:mm[:ss]TZD` フォーマットのタイムスタンプ．この時間は，（潜在的に存在する）`document/time` 要素とは異なるかもしれない．なぜなら，後者はあるエビデンスがチェックされた時間を表すのに対し，この要素はプロセスが完了した時間を表すためである．さらに，全体の verification プロセスとエビデンスの検証は，異なる当事者が行うことができる（`document/verifier` を参照）．特定のトラストフレームワークでは，この要素の存在が要求される場合がある．


<!-- `verification_process`: OPTIONAL. Unique reference to the identity verification process as performed by the OP. Used for identifying and retrieving details in case of disputes or audits. Presence of this element might be required for certain trust frameworks. -->
`verification_process`: OPTIONAL. OP が実行する identity verification process への一意な参照．紛争や監査の際に詳細を識別して取り出すために使用される．特定のトラストフレームワークでは，この要素の存在が要求される場合がある．

<!-- Note: While `verification_process` refers to the identity verification process at the OP, the `txn` Claim refers to a particular OpenID Connect transaction in which the OP provided the End-User's verified identity data towards an RP. -->
注: `verification_process` は OP での identity verification process を指すが，`txn` Claim は OP がエンドユーザーの検証済み ID データを RP に提供した特定の OpenID Connect トランザクションを指す．

<!-- `evidence`: OPTIONAL. JSON array containing information about the evidence the OP used to verify the End-User's identity as separate JSON objects. Every object contains the property `type` which determines the type of the evidence. The RP uses this information to process the `evidence` property appropriately. -->
`evidence`: OPTIONAL. エンドユーザーの identity を確認するために OP が使用したエビデンスに関する情報を個別の JSON オブジェクトとして含む JSON 配列．すべてのオブジェクトには，エビデンスの種類を決めるプロパティ `type` が含まれる．RP は `evidence` プロパティを適切に処理するためにこの情報を使用する．

<!-- Important: Implementations MUST ignore any sub-element not defined in this specification or extensions of this specification. -->
重要: 実装は本仕様または本仕様の拡張で定義されていないサブ要素を無視しなければならない (MUST)．

### evidence Element

<!-- The `evidence` element is structured with the following elements: -->
`evidence` 要素は以下の要素で構成される:

<!-- `attachments`: OPTIONAL. Array of JSON objects representing attachments like photocopies of documents or certificates. See (#attachments) on how an attachment is structured. -->
`attachments`: OPTIONAL. ドキュメントや証明書のコピーなどの添付ファイルを表す JSON オブジェクトの配列．添付ファイルの構造については (#attachments) 参照．

<!-- `type`: REQUIRED. The value defines the type of the evidence. -->
`type`: REQUIRED. エビデンスのタイプを定義する値．

<!-- The following types of evidence are defined: -->
以下のエビデンスのタイプが定義されている:

<!-- 
* `document`: Verification based on any kind of physical or electronic document provided by the End-User.
* `electronic_record`: Verification based on data or information obtained electronically from an approved or recognized source.
* `vouch`: Verification based on an attestation or reference given by an approved or recognized person declaring they believe to the best of their knowledge that the Claim(s) are genuine and true.
* `utility_bill`: Verification based on a utility bill (this is to be deprecated in future releases and implementers are recommended to use the `document` type instead).
* `electronic_signature`: Verification based on an electronic signature.
-->
* `document`: エンドユーザーから提供されたあらゆる種類の物理的又は電子的文章に基づく検証．
* `electronic_record`: 承認または承認されたソースから電子的に取得したデータまたは情報に基づく検証．
* `vouch`: 承認または承認された人物が，Claim(s)　が正規かつ真実であると彼らの知る限り信じていることを宣言することによって与えられた証明または参照に基づく検証．
* `utility_bill`: 公共料金に基づく検証 (これは将来のリリースで非推奨になるため，実装者は代わりに `document` タイプを使うことを推奨する).
* `electronic_signature`: 電子署名に基づく検証．

<!-- Depending on the evidence type additional elements are defined, as described in the following. -->
エビデンスの種類に応じて，以下で説明するように追加の要素が定義される．

#### Evidence Type document

<!-- The following elements are contained in an evidence sub-element where type is `document`. -->
以下の要素は，タイプが `document` であるエビデンス サブ要素に含まれる．

<!-- `type`: REQUIRED. Value MUST be set to `document`. Note: `id_document` is an alias for `document` for backward compatibilty purposes but will be deprecated in future releases, implementers are recommended to use `document`. -->
`type`: REQUIRED. 値は `document` に設定しなければならない (MUST). 注: `id_document` は下位互換性を目的とした `document` のエイリアスであるが，将来のリリースでは非推奨となるため，実装者は `document` を使うことを推奨する.

<!-- `validation_method`: OPTIONAL. JSON object representing how the authenticity of the document was determined.  -->
`validation_method`: OPTIONAL. ドキュメントの信頼性がどのように決定されたかを表す JSON オブジェクト. 

<!-- 
  * `type`: REQUIRED. String representing the method used to check the authenticity of the document. For information on predefined `validation_method` values see [@!predefined_values].
  * `policy`: OPTIONAL. String representing the standard or policy that was followed.
  * `procedure`: OPTIONAL. String representing a specific procedure from the `policy` that was followed.
  * `status`: OPTIONAL. String representing the current status of the validation. 
  -->
  * `type`: REQUIRED. ドキュメントの信頼性をチェックするために利用されるメソッドを表す文字列．事前定義された `validation_method` 値については [@!predefined_values] 参照.
  * `policy`: OPTIONAL. 準拠する標準またはポリシーを表す文字列．
  * `procedure`: OPTIONAL. 準拠した `policy` からの特定の手順を表す文字列．
  * `status`: OPTIONAL. 検証の現在のステータスを表す文字列．

<!-- `verification_method`: OPTIONAL. JSON object representing how the user was proven to be the owner of the `claims`. -->
`verification_method`: OPTIONAL. ユーザーが `claims` の所有者であることをどのように証明したかを表す JSON オブジェクト.

<!-- 
  * `type`: REQUIRED. String representing the method used to verify that the user is the person that the document refers to. For information on predefined `verification_method` values see [@!predefined_values].
  * `policy`: OPTIONAL. String representing the standard or policy that was followed.
  * `procedure`: OPTIONAL. String representing a specific procedure from the `policy` that was followed.
  * `status`: OPTIONAL. String representing the current status of the verification.
-->
  * `type`: REQUIRED. ユーザーがドキュメントの参照する人物であることを確認するために使用されるメソッドを表す文字列. 事前定義された `verification_method` 値については [@!predefined_values] 参照.
  * `policy`: OPTIONAL. 準拠する標準またはポリシーを表す文字列.
  * `procedure`: OPTIONAL. 準拠した `policy` からの特定の手順を表す文字列．
  * `status`: OPTIONAL. 検証の現在のステータスを表す文字列．

<!-- `method`: OPTIONAL. The method used to validate the document and verify the person is the owner of it. In practice this is a combination of a `validation_method` and `verification_method`, implementers are recommended to use the `validation_method`
and `verification_method` types and deprecate the use of this option unless methods are defined by the trust framework. For information on predefined method values see [@!predefined_values].  -->
`method`: OPTIONAL. ドキュメントの検証と，その人がその所有者であることを確認するために使用される方法．実際には， `validation_method` と `verification_method` の組み合わせであり，実装者は `validation_method` と  `verification_method` タイプを使用することを推奨し，方法がトラストフレームワークによって定義されていない限り，このオプションの使用は非推奨である. 事前定義された値は [@!predefined_values] 参照. 

<!-- `verifier`: OPTIONAL. JSON object denoting the legal entity that performed the identity verification on behalf of the OP. This object SHOULD only be included if the OP did not perform the identity verification itself. This object consists of the following properties: -->
`verifier`: OPTIONAL. OP に代わって identity verification を実行した法人を示す JSON オブジェクト．このオブジェクトは，OP 自身が identity verification を実行しなかった場合にのみ含めるべきである (SHOULD). このオブジェクトは以下のプロパティで構成される:

<!-- 
* `organization`: REQUIRED. String denoting the organization which performed the verification on behalf of the OP.
* `txn`: OPTIONAL. Identifier referring to the identity verification transaction. The OP MUST ensure that the transaction identifier can be resolved into transaction details during an audit.
-->
* `organization`: REQUIRED. OP に代わって検証を実行した組織を示す文字列．
* `txn`: OPTIONAL. identity verification トランザクションを参照する識別子．OP は監査中にトランザクション識別子をトランザクションの詳細に解決できることを確認しなければならない (MUST)．

<!-- `time`: OPTIONAL. Time stamp in ISO 8601:2004 [@!ISO8601-2004] `YYYY-MM-DDThh:mm[:ss]TZD` format representing the date when this document was verified. -->
`time`: OPTIONAL. ドキュメントが検証された日付を表す ISO 8601:2004 [@!ISO8601-2004] `YYYY-MM-DDThh:mm[:ss]TZD` フォーマットのタイムスタンプ．

<!-- `document_details`: OPTIONAL. JSON object representing the document used to perform the identity verification. Note: `document` can be used as an alias for `document_details` for backward compatibility purposes but will be deprecated in future releases, implementers are recommended to use `document_details`. It consists of the following properties: -->
`document_details`: OPTIONAL. identity verification の実行に使用されたドキュメントを表す JSON オブジェクト． 注: `document` は下位互換性を目的とした `document_details` のエイリアスとして使用できるが，将来のリリースでは非推奨となるため，実装者は `document_details` を使用することを推奨する．これは以下のプロパティで構成される:

<!-- 
* `type`: REQUIRED. String denoting the type of the document. For information on predefined document values see [@!predefined_values]. The OP MAY use other than the predefined values in which case the RPs will either be unable to process the assertion, just store this value for audit purposes, or apply bespoken business logic to it.
* `document_number`: OPTIONAL. String representing an identifier/number that uniquely identifies a document that was issued to the End-User. This is used on one document and will change if it is reissued, e.g., a passport number, certificate number, etc. Note: `number` can be used as an alias for 'document_number' for backward compatibilty purposes but will be deprecated in future releases, implementers are recommended to use `document_number`.
* `personal_number`: OPTIONAL. String representing an identifier that is assigned to the End-User and is not limited to being used in one document, for example a national identification number, personal identity number, citizen number, social security number, driver number, account number, customer number, licensee number, etc.
* `serial_number`: OPTIONAL. String representing an identifier/number that identifies the document irrespective of any personalization information (this usually only applies to physical artefacts and is present before personalization).
* `date_of_issuance`: OPTIONAL. The date the document was issued as ISO 8601:2004 [@!ISO8601-2004] `YYYY-MM-DD` format.
* `date_of_expiry`: OPTIONAL. The date the document will expire as ISO 8601:2004 [@!ISO8601-2004] `YYYY-MM-DD` format.
* `issuer`: OPTIONAL. JSON object containing information about the issuer of this document. This object consists of the following properties:
    * `name`: OPTIONAL. Designation of the issuer of the document.
    * All elements of the OpenID Connect `address` Claim (see [@!OpenID])
    * `country_code`: OPTIONAL. String denoting the country or supranational organization that issued the document as ISO 3166/ICAO 3-letter codes [@!ICAO-Doc9303], e.g., "USA" or "JPN". 2-letter ICAO codes MAY be used in some circumstances for compatibility reasons.
    * `jurisdiction`: OPTIONAL. String containing the name of the region(s)/state(s)/province(s)/municipality(ies) that issuer has jurisdiction over (if this information is not common knowledge or derivable from the address).
-->
* `type`: REQUIRED. ドキュメントのタイプを表す文字列．事前定義されたドキュメント値については [@!predefined_values] 参照. OP は RP がアサーションを処理できないか，監査目的でこの値を保存するか，特注のビジネスロジックを適用する場合，事前定義された値以外を使用してもよい (MAY).
* `document_number`: OPTIONAL. エンドユーザーに発行されたドキュメントを一意に識別する識別子/番号を表す文字列．これはパスポート番号や証明書番号などのように，1つのドキュメントで利用され，再発行されると変更される．注: `number` は下位互換性を目的とした 'document_number' のエイリアスとして使用できるが，将来のリリースでは非推奨となるため，実装者は `document_number` を使用することを推奨する.
* `personal_number`: OPTIONAL. 国民識別番号，個人識別番号，市民番号，社会保障番号，運転免許証番号，口座番号，顧客番号，ライセンシー番号のような，エンドユーザーに割り当てられ，1つのドキュメントで使用されることに限定されない識別子を表す文字列．
* `serial_number`: OPTIONAL. パーソナライズ情報に関係なくドキュメントを識別する識別子/番号を表す文字列 (これは通常，物理的中間生成物にのみ適用され，パーソナライゼーションの前に存在する).
* `date_of_issuance`: OPTIONAL. ISO 8601:2004 [@!ISO8601-2004] `YYYY-MM-DD` 形式で表す，ドキュメントの発行された日付.
* `date_of_expiry`: OPTIONAL. ISO 8601:2004 [@!ISO8601-2004] `YYYY-MM-DD` 形式で表す，ドキュメントの有効期限の日付.
* `issuer`: OPTIONAL. ドキュメントの発行者に関する情報を含む JSON オブジェクト．このオブジェクトは下記のプロパティで構成される:
    * `name`: OPTIONAL. ドキュメントの発行者を指定する．
    * OpenID Connect `address` Claim (see [@!OpenID]) のすべての要素
    * `country_code`: OPTIONAL. "USA" や "JPN" のような ISO 3166/ICAO 3-letter codes [@!ICAO-Doc9303] で，ドキュメントを発行した国や超国家組織を表す文字列．状況によっては，互換性の理由から 2-letter ICAO codes が使用されるかもしれない (MAY)．
    * `jurisdiction`: OPTIONAL. 発行者が管轄する地域/州/件/市町村の名前を含む文字列 (この情報が一般的な知識でないか，住所から導き出せない場合)．

#### Evidence Type electronic_record

<!-- The following elements are contained in an evidence sub-element where type is `electronic_record`. -->
以下の要素は，タイプが `electronic_record` であるエビデンス サブ要素に含まれる．

<!-- `type`: REQUIRED. Value MUST be set to `electronic_record`. -->
`type`: REQUIRED. 値は `electronic_record` に設定しなければならない (MUST).

<!-- `validation_method`: OPTIONAL. JSON object representing how the authenticity of the record was determined.  -->
`validation_method`: OPTIONAL. ドキュメントの信頼性がどのように決定されたかを表す JSON オブジェクト. 

<!--
  * `type`: REQUIRED. String representing the method used to check the authenticity of the record. For information on predefined `validation_method` values see [@!predefined_values].
  * `policy`: OPTIONAL. String representing the standard or policy that was followed.
  * `procedure`: OPTIONAL. String representing a specific procedure from the `policy` that was followed.
  * `status`: OPTIONAL. String representing the current status of the validation.
-->
  * `type`: REQUIRED. ドキュメントの信頼性をチェックするために利用されるメソッドを表す文字列．事前定義された `validation_method` 値については [@!predefined_values] 参照.
  * `policy`: OPTIONAL. 準拠する標準またはポリシーを表す文字列．
  * `procedure`: OPTIONAL. 準拠した `policy` からの特定の手順を表す文字列．
  * `status`: OPTIONAL. 検証の現在のステータスを表す文字列．
    
<!-- `verification_method`: OPTIONAL. JSON object representing how the user was proven to be the owner of the `claims`. -->
`verification_method`: OPTIONAL. ユーザーが `claims` の所有者であることをどのように証明したかを表す JSON オブジェクト.

<!--
  * `type`: REQUIRED. String representing the method used to verify that the user is the person that the electronic record refers to. For information on predefined `verification_method` values see [@!predefined_values].
  * `policy`: OPTIONAL. String representing the standard or policy that was followed.
  * `procedure`: OPTIONAL. String representing a specific procedure from the `policy` that was followed.
  * `status`: OPTIONAL. String representing the current status of the verification.
-->
  * `type`: REQUIRED. ユーザーが電子記録の参照する人物であることを確認するために使用されるメソッドを表す文字列. 事前定義された `verification_method` 値については [@!predefined_values] 参照.
  * `policy`: OPTIONAL. 準拠する標準またはポリシーを表す文字列.
  * `procedure`: OPTIONAL. 準拠した `policy` からの特定の手順を表す文字列．
  * `status`: OPTIONAL. 検証の現在のステータスを表す文字列．

<!-- `verifier`: OPTIONAL. JSON object denoting the legal entity that performed the identity verification on behalf of the OP. This object SHOULD only be included if the OP did not perform the identity verification itself. This object consists of the following properties: -->
`verifier`: OPTIONAL. OP に代わって identity verification を実行した法人を示す JSON オブジェクト．このオブジェクトは，OP 自身が identity verification を実行しなかった場合にのみ含めるべきである (SHOULD). このオブジェクトは以下のプロパティで構成される:

<!--
* `organization`: REQUIRED. String denoting the organization which performed the verification on behalf of the OP.
* `txn`: OPTIONAL. Identifier referring to the identity verification transaction. This transaction identifier can be resolved into transaction details during an audit.
-->
* `organization`: REQUIRED. OP に代わって検証を実行した組織を示す文字列．
* `txn`: OPTIONAL. identity verification トランザクションを参照する識別子．このトランザクション識別子は，監査中にトランザクションの詳細を解決できることができる．

<!-- `time`: OPTIONAL. Time stamp in ISO 8601:2004 [@!ISO8601-2004] `YYYY-MM-DDThh:mm[:ss]TZD` format representing the date when this record was verified. -->
`time`: OPTIONAL. レコードが検証された日付を表す ISO 8601:2004 [@!ISO8601-2004] `YYYY-MM-DDThh:mm[:ss]TZD` フォーマットのタイムスタンプ．

<!-- `record`: OPTIONAL. JSON object representing the record used to perform the identity verification. It consists of the following properties: -->
`record`: OPTIONAL. identity verification の実行に使用されたレコードを表す JSON オブジェクト．これは以下のプロパティで構成される:

<!--
* `type`: REQUIRED. String denoting the type of electronic record. For information on predefined identity evidence values see [@!predefined_values]. The OP MAY use other than the predefined values in which case the RPs will either be unable to process the assertion, just store this value for audit purposes, or apply bespoken business logic to it.
* `personal_number`: OPTIONAL. String representing an identifier that is assigned to the End-User and is not limited to being used in one document, for example a national identification number, personal identity number, citizen number, social security number, driver number, account number, customer number, licensee number, etc.
* `created_at`: OPTIONAL. The time the record was created as ISO 8601:2004 [@!ISO8601-2004] `YYYY-MM-DDThh:mm[:ss]TZD` format.
* `date_of_expiry`: OPTIONAL. The date the evidence will expire as ISO 8601:2004 [@!ISO8601-2004] `YYYY-MM-DD` format.
* `source`: OPTIONAL. JSON object containing information about the source of this record. This object consists of the following properties:
    * `name`: OPTIONAL. Designation of the issuer of the document.
    * All elements of the OpenID Connect `address` Claim (see [@!OpenID]): OPTIONAL.
    * `country_code`: OPTIONAL. String denoting the country or supranational organization that issued the document as ISO 3166/ICAO 3-letter codes [@!ICAO-Doc9303], e.g., "USA" or "JPN". 2-letter ICAO codes MAY be used in some circumstances for compatibility reasons.
    * `jurisdiction`: OPTIONAL. String containing the name of the region(s) / state(s) / province(s) / municipality(ies) that issuer has jurisdiction over (if it’s not common knowledge or derivable from the address).
-->
* `type`: REQUIRED. 電子記録のタイプを表す文字列．事前定義された identity エビデンス値については [@!predefined_values] 参照. OP は RP がアサーションを処理できないか，監査目的でこの値を保存するか，特注のビジネスロジックを適用する場合，事前定義された値以外を使用してもよい (MAY).
 `personal_number`: OPTIONAL. 国民識別番号，個人識別番号，市民番号，社会保障番号，運転免許証番号，口座番号，顧客番号，ライセンシー番号のような，エンドユーザーに割り当てられ，1つのドキュメントで使用されることに限定されない識別子を表す文字列．
* `created_at`: OPTIONAL. ISO 8601:2004 [@!ISO8601-2004] `YYYY-MM-DD` 形式で表す，レコードの作成された日付.
* `date_of_expiry`: OPTIONAL. ISO 8601:2004 [@!ISO8601-2004] `YYYY-MM-DD` 形式で表す，ドキュメントの有効期限の日付.
* `source`: OPTIONAL. レコードのソースに関する情報を含む JSON オブジェクト．このオブジェクトは下記のプロパティで構成される:
    * `name`: OPTIONAL. ドキュメントの発行者を指定する．
    * OpenID Connect `address` Claim (see [@!OpenID]) のすべての要素: OPTIONAL.
    * `country_code`: OPTIONAL. "USA" や "JPN" のような ISO 3166/ICAO 3-letter codes [@!ICAO-Doc9303] で，ドキュメントを発行した国や超国家組織を表す文字列．状況によっては，互換性の理由から 2-letter ICAO codes が使用されるかもしれない (MAY)．
    * `jurisdiction`: OPTIONAL. 発行者が管轄する地域/州/件/市町村の名前を含む文字列 (それ一般的な知識でないか，住所から導き出せない場合)．

#### Evidence Type vouch


<!-- The following elements are contained in an evidence sub-element where type is `vouch`. -->
以下の要素は，タイプが `vouch` であるエビデンス サブ要素に含まれる．

<!-- `type`: REQUIRED. Value MUST be set to `vouch`. -->
`type`: REQUIRED. 値は `vouch` に設定しなければならない (MUST).

<!-- `validation_method`: OPTIONAL. JSON object representing how the authenticity of the vouch was determined.  -->
`validation_method`: OPTIONAL. ドキュメントの信頼性がどのように決定されたかを表す JSON オブジェクト. 

<!--
  * `type`: REQUIRED. String representing the method used to check the authenticity of the vouch. For information on predefined `validation_method` values see [@!predefined_values].
  * `policy`: OPTIONAL. String representing the standard or policy that was followed.
  * `procedure`: OPTIONAL. String representing a specific procedure from the `policy` that was followed.
  * `status`: OPTIONAL. String representing the current status of the validation.
-->
  * `type`: REQUIRED. 証拠の信頼性をチェックするために利用されるメソッドを表す文字列．事前定義された `validation_method` 値については [@!predefined_values] 参照.
  * `policy`: OPTIONAL. 準拠する標準またはポリシーを表す文字列．
  * `procedure`: OPTIONAL. 準拠した `policy` からの特定の手順を表す文字列．
  * `status`: OPTIONAL. 検証の現在のステータスを表す文字列．

<!-- `verification_method`: OPTIONAL. JSON object representing how the user was proven to be the owner of the Claims. -->
`verification_method`: OPTIONAL. ユーザーが `claims` の所有者であることをどのように証明したかを表す JSON オブジェクト.

<!--
  * `type`: REQUIRED. String representing the method used to verify that the user is the person that the vouch refers to. For information on predefined `verification_method` values see [@!predefined_values].
  * `policy`: OPTIONAL. String representing the standard or policy that was followed.
  * `procedure`: OPTIONAL. String representing a specific procedure from the `policy` that was followed.
  * `status`: OPTIONAL. String representing the current status of the verification.
-->
  * `type`: REQUIRED. ユーザーが証拠の参照する人物であることを確認するために使用されるメソッドを表す文字列. 事前定義された `verification_method` 値については [@!predefined_values] 参照.
  * `policy`: OPTIONAL. 準拠する標準またはポリシーを表す文字列.
  * `procedure`: OPTIONAL. 準拠した `policy` からの特定の手順を表す文字列．
  * `status`: OPTIONAL. 検証の現在のステータスを表す文字列．
    
<!-- `verifier`: OPTIONAL. JSON object denoting the legal entity that performed the identity verification on behalf of the OP. This object SHOULD only be included if the OP did not perform the identity verification itself. This object consists of the following properties: -->
`verifier`: OPTIONAL. OP に代わって identity verification を実行した法人を示す JSON オブジェクト．このオブジェクトは，OP 自身が identity verification を実行しなかった場合にのみ含めるべきである (SHOULD). このオブジェクトは以下のプロパティで構成される:

<!--
* `organization`: REQUIRED. String denoting the organization which performed the verification on behalf of the OP.
* `txn`: OPTIONAL. Identifier referring to the identity verification transaction. This transaction identifier can be resolved into transaction details during an audit.
-->
* `organization`: REQUIRED. OP に代わって検証を実行した組織を示す文字列．
* `txn`: OPTIONAL. identity verification トランザクションを参照する識別子．このトランザクション識別子は，監査中にトランザクションの詳細を解決できることができる．

<!-- `time`: OPTIONAL. Time stamp in ISO 8601:2004 [@!ISO8601-2004] `YYYY-MM-DDThh:mm[:ss]TZD` format representing the date when this vouch was verified. -->
`time`: OPTIONAL. 証拠が検証された日付を表す ISO 8601:2004 [@!ISO8601-2004] `YYYY-MM-DDThh:mm[:ss]TZD` フォーマットのタイムスタンプ．

<!-- `attestation`: OPTIONAL. JSON object representing the attestation that is the basis of the vouch. It consists of the following properties: -->
`attestation`: OPTIONAL. 証拠の基礎となるアテステーションを表す JSON オブジェクト．これは以下のプロパティで構成される:

<!--
* `type`: REQUIRED. String denoting the type of vouch. For information on predefined vouch values see [@!predefined_values]. The OP MAY use other than the predefined values in which case the RPs will either be unable to process the assertion, just store this value for audit purposes, or apply bespoken business logic to it.
* `reference_number`: OPTIONAL. String representing an identifier/number that uniquely identifies a vouch given about the End-User.
* `personal_number`: OPTIONAL. String representing an identifier that is assigned to the End-User and is not limited to being used in one document, for example a national identification number, personal identity number, citizen number, social security number, driver number, account number, customer number, licensee number, etc.
* `date_of_issuance`: OPTIONAL. The date the document was issued as ISO 8601:2004 [@!ISO8601-2004] `YYYY-MM-DD` format.
* `date_of_expiry`: OPTIONAL. The date the evidence will expire as ISO 8601:2004 [@!ISO8601-2004] `YYYY-MM-DD` format.
* `voucher`: OPTIONAL. JSON object containing information about the entity giving the vouch. This object consists of the following properties:
    * `name`: OPTIONAL. String containing the name of the person giving the vouch/reference in the same format as defined in Section 5.1 of the OpenID Connect specification for End-User Claims.
    * `birthdate`: OPTIONAL. String containing the birthdate of the person giving the vouch/reference in the same format as defined in Section 5.1 of the OpenID Connect specification for End-User Claims.
    * All elements of the OpenID Connect `address` Claim (see [@!OpenID]): OPTIONAL.
    * `occupation`: OPTIONAL. String containing the occupation or other authority of the person giving the vouch/reference.
    * `organization`: OPTIONAL. String containing the name of the organization the voucher is representing.
-->
* `type`: REQUIRED. 証拠のタイプを表す文字列．事前定義された証拠値については [@!predefined_values] 参照. OP は RP がアサーションを処理できないか，監査目的でこの値を保存するか，特注のビジネスロジックを適用する場合，事前定義された値以外を使用してもよい (MAY).
* `reference_number`: OPTIONAL. エンドユーザーについて与えられた証拠を一意に識別する識別子/番号を表す文字列．
* `personal_number`: OPTIONAL. 国民識別番号，個人識別番号，市民番号，社会保障番号，運転免許証番号，口座番号，顧客番号，ライセンシー番号のような，エンドユーザーに割り当てられ，1つのドキュメントで使用されることに限定されない識別子を表す文字列．
* `date_of_issuance`: OPTIONAL. ISO 8601:2004 [@!ISO8601-2004] `YYYY-MM-DD` 形式で表す，ドキュメントの発行された日付.
* `date_of_expiry`: OPTIONAL. ISO 8601:2004 [@!ISO8601-2004] `YYYY-MM-DD` 形式で表す，エビデンスの有効期限の日付.
* `voucher`: OPTIONAL. 証拠を提供するエンティティに関する情報を含む JSON オブジェクト．このオブジェクトは下記のプロパティで構成される:
    * `name`: OPTIONAL. ドキュメントの発行者を指定する．
    * `name`: OPTIONAL. OpenID Connect 仕様の Section 5.1 で定義されているのと同じ形式で，エンドユーザー Claim の証拠/参照を提供する人の名前を含む文字列．
    * `birthdate`: OPTIONAL. OpenID Connect 仕様の Section 5.1 で定義されているのと同じ形式で，エンドユーザー Claim の証拠/参照を提供する人の誕生日を含む文字列．
    * OpenID Connect `address` Claim (see [@!OpenID]) のすべての要素: OPTIONAL.
    * `occupation`: OPTIONAL. 証拠/参照を与える人の職業または他の権限を含む文字列 .
    * `organization`: OPTIONAL. voucher が表す組織の名前を含む文字列．

#### Evidence Type utility_bill

<!-- Note: This type is to be deprecated in future releases. Implementers are recommended to use `document` instead. -->
注: このタイプは将来のリリースで廃止となる．実装者は代わりに `document` を使うことを推奨する．

<!-- The following elements are contained in an evidence sub-element where type is  `utility_bill`.  -->
以下の要素は，タイプが `utility_bill` であるエビデンス サブ要素に含まれる．

<!-- `type`: REQUIRED. Value MUST be set to "utility_bill". -->
`type`: REQUIRED. 値は `utility_bill` に設定しなければならない (MUST).

<!-- `provider`: OPTIONAL. JSON object identifying the respective provider that issued the bill. The object consists of the following properties: -->
`provider`: OPTIONAL. 請求書を発行したそれぞれのプロバイダーを識別する JSON object．このオブジェクトは以下のプロパティで構成される:

<!--
* `name`: REQUIRED. String designating the provider.
* All elements of the OpenID Connect `address` Claim (see [@!OpenID])
-->
* `name`: REQUIRED. プロバイダーを指定する文字列.
* OpenID Connect `address` Claim (see [@!OpenID]) のすべての要素．

<!-- `date`: OPTIONAL. String in ISO 8601:2004 [@!ISO8601-2004] `YYYY-MM-DD` format containing the date when this bill was issued. -->
`date`: OPTIONAL. 請求書が発行された日付を含む ISO 8601:2004 [@!ISO8601-2004] `YYYY-MM-DD` 形式の文字列.

<!-- `method`: OPTIONAL. The method used to verify the utility bill. For information on predefined method values see [@!predefined_values].  -->
`method`: OPTIONAL. 公共料金の確認に使用される方法．事前定義されたメソッド値については [@!predefined_values] 参照.

<!-- `time`: OPTIONAL. Time stamp in ISO 8601:2004 [@!ISO8601-2004] `YYYY-MM-DDThh:mm[:ss]TZD` format representing the date when the utility bill was verified. -->
`time`: OPTIONAL. 公共料金の請求が確認された日付を表す ISO 8601:2004 [@!ISO8601-2004] `YYYY-MM-DDThh:mm[:ss]TZD` フォーマットのタイムスタンプ．

#### Evidence Type electronic_signature

<!-- The following elements are contained in a `electronic_signature` evidence sub-element. -->
以下の要素は，タイプが `electronic_signature` であるエビデンス サブ要素に含まれる．

<!-- `type`: REQUIRED. Value MUST be set to `electronic_signature`. -->
`type`: REQUIRED. 値は `electronic_signature` に設定しなければならない (MUST).

<!-- `signature_type`: REQUIRED. String denoting the type of signature used as evidence. The value range might be restricted by the respective trust framework.  -->
`signature_type`: REQUIRED. エビデンスとして使用される署名のタイプを表す文字列. 値の範囲は，それぞれのトラストフレームワークによって制限されるかもしれない． 

<!-- `issuer`: REQUIRED. String denoting the certification authority that issued the signer's certificate. -->
`issuer`: REQUIRED. 署名者の証明書を発行した認証局を表す文字列.

<!-- `serial_number`: REQUIRED. String containing the serial number of the certificate used to sign. -->
`serial_number`: REQUIRED. 署名に使用される証明書のシリアル番号を表す文字列.

<!-- `created_at`: OPTIONAL. The time the signature was created as ISO 8601:2004 [@!ISO8601-2004] `YYYY-MM-DDThh:mm[:ss]TZD` format. -->
`created_at`: OPTIONAL. ISO 8601:2004 [@!ISO8601-2004] `YYYY-MM-DD` 形式で表す，署名の作成された日付.

### Attachments {#attachments}

During the identity verification process, specific document artifacts will be created and depending on the trust framework, will be required to be stored for a specific duration. These artifacts can later be reviewed during audits or quality control for example. These artifacts include, but are not limited to:
identity verification プロセス中に，特定のドキュメントアーティファクトが生成され，トラストフレームワークに応じて特定の期間保存する必要がある．これらのアーティファクトは，後で監査や品質管理などの際に確認することができる．これらのアーティファクトには次のものが含まれるが，これらに限定されない:

<!--
* scans of filled and signed forms documenting/certifying the verification process itself,
* scans or photocopies of the documents used to verify the identity of End-Users,
* video recordings of the verification process,
* certificates of electronic signatures.
-->
* 検証プロセス自体を文章化/証明する，記入済みかつ署名済みフォームのスキャン
* エンドユーザーの identity を確認するために使用されるドキュメントのスキャンまたは写真コピー
* 検証プロセスのビデオ録画
* 電子署名の証明書


<!-- When requested by the RP, these artifacts can be attached to the Verified Claims response allowing the RP to store these artifacts along with the Verified Claims information. -->
RP から要求された場合，RP が検証済み Claim 情報とともにこれらのアーティファクトを保存できるように，これらのアーティファクトを検証済み Claim のレスポンスに添付することができる．

<!-- An attachment is represented by a JSON object. This specification allows two types of representations: -->
添付ファイルは JSON オブジェクト形式で表現される．本仕様では2種類の表現が可能である:

#### Embedded Attachments

<!-- All the information of the document (including the content itself) is provided within a JSON object having the following elements: -->
(コンテンツ自身を含む) ドキュメントのすべての情報は，以下の要素を持つ JSON オブジェクト内で提供される:

<!-- `desc`: OPTIONAL. Description of the document. This can be the filename or just an explanation of the content. The used language is not specified, but is usually bound to the jurisdiction of the underlying trust framework of the OP. -->
`desc`: OPTIONAL. ドキュメントの説明. ファイル名または単なるコンテンツの説明にすることができる．使用する言語は指定されていないが，通常 OP の基礎となるトラストフレームワークの管轄に拘束される．

<!-- `content_type`: REQUIRED. Content (MIME) type of the document. See [@!RFC6838]. Multipart or message media types are not allowed. Example: "image/png" -->
`content_type`: REQUIRED. ドキュメントのコンテンツ (MIME) タイプ． [@!RFC6838] 参照．マルチパートまたはメッセージメディアタイプは許可されない．例: "image/png"

<!-- `content`: REQUIRED. Base64 encoded representation of the document content. -->
`content`: REQUIRED. ドキュメントコンテンツの Base64 エンコード表現.

<!-- The following example shows embedded attachments. The actual contents of the documents are truncated: -->
以下の例は，埋め込まれた添付ファイルを示す．ドキュメントの実際の内容は切り捨てられている:

<{{examples/response/embedded_attachments.json}}

<!-- Note: Due to their size, embedded attachments are not appropriate when embedding Verified Claims in access tokens or ID tokens. -->
注: サイズが大きいため，アクセストークンまたは ID トークンに検証済み Claim を埋め込む場合，埋め込み添付ファイルは適切ではない．

#### External Attachments

<!-- External attachments are similar to distributed Claims. The reference to the external document is provided in a JSON object with the following elements: -->
External attachments は分散 Claim と似ている．外部ドキュメントへの参照は，以下の要素を持つ JSON オブジェクト内で提供される:

<!-- `desc`: OPTIONAL. Description of the document. This can be the filename or just an explanation of the content. The used language is not specified, but is usually bound to the jurisdiction of the underlying trust framework or the OP. -->
`desc`: OPTIONAL. ドキュメントの説明. ファイル名または単なるコンテンツの説明にすることができる．使用する言語は指定されていないが，通常 OP の基礎となるトラストフレームワークの管轄に拘束される．

<!-- `url`: REQUIRED. OAuth 2.0 resource endpoint from which the document can be retrieved. Providers MUST protect this endpoint. The endpoint URL MUST return the document whose cryptographic hash matches the value given in the `digest` element. -->
`url`: REQUIRED. ドキュメントを取得できる OAuth 2.0 リソースエンドポイント．プロバイダはこのエンドポイントを保護しなければならない (MUST)．このエンドポイント URL は，暗号化ハッシュが `digest` 要素で提供される値と一致するドキュメントを返さなければならない (MUST)．

<!-- `access_token`: OPTIONAL. Access Token as type `string` enabling retrieval of the document from the given `url`. The attachment MUST be requested using the OAuth 2.0 Bearer Token Usage [@!RFC6750] protocol and the OP MUST support this method, unless another Token Type or method has been negotiated with the Client. Use of other Token Types is outside the scope of this specification. If the `access_token` element is not available, RPs MUST use the Access Token issued by the OP in the Token response and when requesting the attachment the RP MUST use the same method as when accessing the UserInfo endpoint. If the value of this element is `null`, no Access Token is used to request the attachment and the RP MUST NOT use the Access Token issued by the Token response. In this case the OP MUST incorporate other effective methods to protect the attachment and inform/instruct the RP accordingly. -->
`access_token`: OPTIONAL. 与えられた `url` からドキュメントを取得できるようにする `string` タイプの Access Token．添付ファイルは OAuth 2.0 Bearer Token Usage [@!RFC6750] プロトコルを使用してリクエストしなければならず (MUST)， 別のトークンタイプまたはメソッドが Client とネゴシエートされていない限り，OP はメソッドをサポートしなければならない (MUST)．他のトークンタイプの仕様は本仕様の範囲外である．`access_token` 要素が利用できない場合，RP は Token Response で OP によって発行された Access Token を利用しなければならず (MUST)，添付ファイルを要求する時，RP は UserInfo エンドポイントにアクセスするときと同じ方法を使用しなければならない (MUST)．この要素の値が `null` の場合，添付ファイルを要求するために Access Token は使用されず，RP は Token Response によって発行された Access Token を使用してはならない (MUST NOT)．この場合，OP は添付ファイルを保護するための他の有効な方法を組み込み，それに応じて RP に通知/指示しなければならない (MUST)．

<!-- `expires_in`: OPTIONAL. Positive integer representing the number of seconds until the attachment becomes unavailable and/or the provided `access_token` becomes invalid. -->
`expires_in`: OPTIONAL. 添付ファイルが使用できなくなるか，指定された `access_token` が無効になるまでの秒数を表す正の整数．

<!-- `digest`: REQUIRED. JSON object representing a cryptographic hash of the document content. The JSON object has the following elements: -->
`digest`: REQUIRED. ドキュメントコンテンツの暗号化ハッシュを表す JSON オブジェクト．JSON オブジェクトは以下の要素を持つ:

<!--
* `alg`: REQUIRED. Specifies the algorithm used for the calculation of the cryptographic hash. The algorithm has been negotiated previously between RP and OP during Client Registration or Management.
* `value`: REQUIRED. Base64 encoded representation of the cryptographic hash.
-->
* `alg`: REQUIRED. 暗号化ハッシュの計算に使用されるアルゴリズムを指定する．アルゴリズムは，Client の登録または管理の間に RP と OP の間で事前にネゴシエートされている．
* `value`: REQUIRED. 暗号化ハッシュの Base64 エンコード表現．

<!-- External attachments are suitable when embedding Verified Claims in Tokens. However, the `verified_claims` element is not self-contained. The documents need to be retrieved separately, and the digest values MUST be calculated and validated to ensure integrity. -->
External attachments は検証済み Claim を Token に埋め込む場合に適している．だがしかし，`verified_claims` 要素は自己完結型ではない．ドキュメントは個別に取得しなければならず，整合性を確保するためにダイジェスト値を計算し，検証しなければならない (MUST)．

<!-- The following example shows external attachments: -->
以下の例は external attachments を示す:

<{{examples/response/external_attachments.json}}

#### Privacy Considerations

<!-- As attachments will most likely contain more personal information than was requested by the RP with specific Claim names, an OP MUST ensure that the End-User is well aware of when and what kind of attachments are about to be transferred to the RP. If possible or applicable, the OP SHOULD allow the End-User to review the content of these attachments before giving consent to the transaction. -->
添付ファイルには，特定の Claim 名を使用して RP から要求されたよりも多くの個人情報が含まれる可能性が高いため，OP はいつどのような種類の添付ファイルが RP に転送されるかを，エンドユーザーが十分に認識していることを確認しなければならない (MUST)．可能であれば，あるいは適用可能であれば，OP はエンドユーザーがトランザクションに同意する前に，これらの添付ファイルのコンテンツを確認できるようにするべきである (SHOULD)．

## claims Element {#claimselement}

<!-- The `claims` element contains the Claims about the End-User which were verified by the process and according to the policies determined by the corresponding `verification` element. -->
`claims` 要素にはプロセスによって検証され, 対応する `verification` 要素によって決定されたポリシーに従って検証されたエンドユーザについての Claim が含まれる.


The `claims` element MAY contain one or more of the following Claims as defined in Section 5.1 of the OpenID Connect specification [@!OpenID]

* `name`
* `given_name`
* `middle_name`
* `family_name`
* `birthdate`
* `address`

and the Claims defined in (#userclaims).

The `claims` element MAY also contain other Claims provided the value of the respective Claim was verified in the verification process represented by the sibling `verification` element.

Claim names MAY be annotated with language tags as specified in Section 5.2 of the OpenID Connect specification [@!OpenID].

## verified_claims Delivery

OPs can deliver `verified_claims` in various ways. 

A `verified_claims` element can be added to an OpenID Connect UserInfo response or an ID Token.

OAuth Authorization Servers can add `verified_claims` to access tokens in JWT format or Token Introspection responses, either in plain JSON or JWT-protected format.

An OP or AS MAY also include `verified_claims` in the above assertions, whether they are access tokens or in Token Introspection responses, as aggregated or distributed claims (see Section 5.6.2 of the OpenID Connect specification [@!OpenID]). 

In this case, every assertion provided by the external Claims source MUST contain 

* an `iss` Claim identifying the claims source,
* a `sub` Claim identifying the End-User in the context of the claim source,
* a `verified_claims` element containing one or more `verified_claims` objects.

The `verified_claims` element in a response MUST have one of the following forms:

* a JSON string referring to a certain claim source (as defined in [@!OpenID])
* a JSON array of strings referring to the different claim sources
* a JSON object composed of sub elements formatted with the syntax as defined for requesting `verified_claims` where the name of the object is the name of the respective claim source. Every object contains additional information about the `verified_claims` object provided by the respective claims source, i.e., the End-User Claims and verification data provided by the respective claims source. This allows the RP to look ahead before it actually requests distributed Claims in order to prevent extra time, cost, data collisions, etc. caused by these requests. 

Note: The two later forms extend the syntax as defined in Section 5.6.2 of the OpenID Connect specification [@!OpenID]) in order to accommodate the specific use cases for `verified_claims`.

The following are examples of assertions including Verified Claims as aggregated Claims 

<{{examples/response/aggregated_claims_simple.json}}

and distributed Claims.

<{{examples/response/distributed_claims.json}}

The following example shows an ID token containing `verified_claims` from two different external claims sources, one as aggregated and the other as distributed Claims. 

<{{examples/response/multiple_external_claims_sources.json}}

The next example shows an ID token containing `verified_claims` from two different external claims sources along with additional data about the content of the Verified Claims (look ahead).

<{{examples/response/multiple_external_claims_sources_with_lookahead.json}}

Claims sources SHOULD sign the assertions containing `verified_claims` in order to demonstrate authenticity and provide for non-repudiation. 
The way an RP determines the key material used for validation of the signed assertions is out of scope. The recommended way is to determine the claims source's public keys by obtaining its JSON Web Key Set via the `jwks_uri` metadata value read from its `openid-configuration` metadata document. This document can be discovered using the `iss` Claim of the particular JWT.

The OP MAY combine aggregated and distributed Claims with `verified_claims` provided by itself (see (#op_attested_and_external_claims)).

If `verified_claims` elements are contained in multiple places of a response, e.g., in the ID token and an embedded aggregated Claim, the RP MUST preserve the claims source as context of the particular `verified_claims` element.

Note: Any assertion provided by an OP or AS including aggregated or distributed Claims MAY contain multiple instances of the same End-User Claim. It is up to the RP to decide how to process these different instances. 

# Requesting Verified Claims

Making a request for Verified Claims and related verification data can be explicitly requested on the level of individual data elements by utilizing the `claims` parameter as defined in Section 5.5 of the OpenID Connect specification [@!OpenID].

It is also possible to use the `scope` parameter to request one or more specific pre-defined Claim sets as defined in Section 5.4 of the OpenID Connect specification [@!OpenID].

Note: The OP MUST NOT provide the RP with any data it did not request. However, the OP MAY at its discretion omit Claims from the response. 

## Requesting End-User Claims {#req_claims}

Verified Claims can be requested on the level of individual Claims about the End-User by utilizing the `claims` parameter as defined in Section 5.5 of the OpenID Connect specification [@!OpenID].

Note: A machine-readable definition of the syntax to be used to request `verified_claims` is given as JSON schema in [@!verified_claims_request.json]. It can be used to automatically validate `claims` request parameters.

To request Verified Claims, the `verified_claims` element is added to the `userinfo` or the `id_token` element of the `claims` parameter.

Since `verified_claims` contains the effective Claims about the End-User in a nested `claims` element, the syntax is extended to include expressions on nested elements as follows. The `verified_claims` element includes a `claims` element, which in turn includes the desired Claims as keys with a `null` value. An example is shown in the following:

<{{examples/request/claims.json}}

Use of the `claims` parameter allows the RP to exactly select the Claims about the End-User needed for its use case. This extension therefore allows RPs to fulfill the requirement for data minimization.

RPs MAY indicate that a certain Claim is essential to the successful completion of the request for Verified Claims by utilizing the `essential` field as defined in Section 5.5.1 of the OpenID Connect specification [@!OpenID]. The following example designates both given name as well as family name as being essential.

<{{examples/request/essential.json}}

This specification introduces the additional field `purpose` to allow an RP
to state the purpose for the transfer of a certain End-User Claim it is asking for.
The field `purpose` can be a member value of each individually requested
Claim, but a Claim cannot have more than one associated purpose.

`purpose`: OPTIONAL. String describing the purpose for obtaining a certain End-User Claim from the OP. The purpose MUST NOT be shorter than 3 characters or
longer than 300 characters. If this rule is violated, the authentication
request MUST fail and the OP return an error `invalid_request` to the RP.
The OP MUST display this purpose in the respective End-User consent screen(s)
in order to inform the End-User about the designated use of the data to be
transferred or the authorization to be approved. If the parameter `purpose`
is not present in the request, the OP MAY display a
value that was pre-configured for the respective RP. For details on UI
localization, see (#purpose).

Example:

<{{examples/request/purpose.json}}

## Requesting Verification Data {#req_verification}

RPs request verification data in the same way they request Claims about the End-User. The syntax is based on the rules given in (#req_claims) and extends them for navigation into the structure of the `verification` element.

Elements within `verification` are requested by adding the respective element as shown in the following example:

<{{examples/request/verification.json}}

It requests the trust framework the OP complies with and the date of the verification of the End-User Claims.

The RP MUST explicitly request any data it wants the OP to add to the `verification` element. 

Therefore, the RP MUST set fields one step deeper into the structure if it wants to obtain evidence. One or more entries in the `evidence` array are used as filter criteria and templates for all entries in the result array. The following examples shows a request asking for evidence of type `document`.

<{{examples/request/verification_deeper.json}}

The example also requests the OP to add the respective `method` and the `document` elements (including data about the document type) for every evidence to the resulting `verified_claims` Claim.

A single entry in the `evidence` array represents a filter over elements of a certain evidence type. The RP therefore MUST specify this type by including the `type` field including a suitable `value` sub-element value. The `values` sub-element MUST NOT be used for the `evidence/type` field. 

If multiple entries are present in `evidence`, these filters are linked by a logical OR.

The RP MAY also request certain data within the `document` element to be present. This again follows the syntax rules used above:

<{{examples/request/verification_document.json}}

# Example Requests
The following section show examples of requests for `verified_claims`.

## Verification of Claims by a document

<{{examples/request/verification_deeper.json}}

## Verification of Claims by trust framework and evidence types

<{{examples/request/verification_claims_trust_frameworks_evidence.json}}

## Verification of Claims by trust framework and verification method

<{{examples/request/verification_spid_document_biometric.json}}

## Verification of Claims by trust framework with a document and include attachments

<{{examples/request/verification_aml_with_attachments.json}}

## Verification of Claims by electronic signature

<{{examples/request/verification_electronic_signature.json}}


### Attachments

RPs can explicitly request to receive attachments along with the Verified Claims:

<{{examples/request/verification_with_attachments.json}}

As with other Claims, the attachment Claim can be marked as essential in the request as well.

### Error Handling

The OP has the discretion to decide whether the requested verification data is to be provided to the RP. 

## Defining further constraints on Verification Data {#constraintedclaims}

### value/values

The RP MAY limit the possible values of the elements `trust_framework`, `evidence/method`, `evidence/verification_method', `evidence/validation_method` and `evidence/document/type` by utilizing the `value` or `values` fields and the element `evidence/type` by utilizing the `value` field. 

Note: Examples on the usage of a restriction on `evidence/type` were given in the previous section. 

The following example shows how an RP may request Claims either complying with trust framework `gold` or `silver`.

<{{examples/request/verification_claims_different_trust_frameworks.json}} 

The following example shows that the RP wants to obtain an attestation based on the German Anti Money Laundering Law (trust framework `de_aml`) and limited to End-Users who were identified in a bank branch in person (physical in person proofing - method `pipp`) using either an `idcard` or a `passport`.

<{{examples/request/verification_aml.json}}

The OP MUST NOT ignore some or all of the query restrictions on possible values and MUST NOT deliver available verified/verification data that does not match these constraints.

### max_age

The RP MAY also express a requirement regarding the age of certain data, like the time elapsed since the issuance/expiry of certain evidence types or since the verification process asserted in the `verification` element took place. Section 5.5.1 of the OpenID Connect specification [@!OpenID] defines a query syntax that allows for new special query members to be defined. This specification introduces a new such member `max_age`, which is applicable to the possible values of any elements containing dates or timestamps (e.g., `time`, `date_of_issuance` and `date_of_expiry` elements of evidence of type `document`).

`max_age`: OPTIONAL. JSON number value only applicable to Claims that contain dates or timestamps. It defines the maximum time (in seconds) to be allowed to elapse since the value of the date/timestamp up to the point in time of the request. The OP should make the calculation of elapsed time starting from the last valid second of the date value.

The following is an example of a request for Claims where the verification process of the data is not allowed to be older than 63113852 seconds:

<{{examples/request/verification_max_age.json}}

The OP SHOULD try to fulfill this requirement. If the verification data of the End-User is older than the requested `max_age`, the OP MAY attempt to refresh the End-User’s verification by sending them through an online identity verification process, e.g., by utilizing an electronic ID card or a video identification approach.

### Requesting Claims sets with different verification requirements

It is also possible to request different trust frameworks, assurance levels, and methods for different Claim sets. This requires the RP to send an array of `verified_claims` objects instead of passing a single object. 

The following example illustrates this functionality.

<{{examples/request/verification_claims_by_trust_frameworks.json}}
 
When the RP requests multiple verifications as described above, the OP is supposed to process any element in the array independently. The OP will provide `verified_claims` response elements for every `verified_claims` request element whose requirements it is able to fulfill. This also means if multiple `verified_claims` elements contain the same End-User Claim(s), the OP delivers the Claim in as many Verified Claims response objects it can fulfil. For example, if the trust framework the OP uses is compatible with multiple of the requested trust frameworks, it provides a `verified_claims` element for each of them.

The RP MAY combine multiple `verified_claims` Claims in the request with multiple `trust_framework` and/or `assurance_level` values using the `values` element. In that case, the rules given above for processing `values` are applied for the particular `verified_claims` request object.

<{{examples/request/verification_claims_by_trust_frameworks_same_claims.json}} 

In the above example, the RP asks for family and given name either under trust framework `gold` with an evidence of type `document` or under trust framework `silver` or `bronze` but with an evidence `electronic_record`.

## Handling Unfulfillable Requests and Unavailable Data
In some cases, OPs cannot deliver the requested data to an RP, for example, because the data is not available or does not match the RP's requirements. The rules for handling these cases are described in the following.

Extensions of this specification MAY define additional rules or override these rules, for example

* to allow or disallow the use of Claims depending on scheme-specific checks,
* to enable a finer-grained control of the RP over the behavior of the OP when data is unavailable or does not match the criteria, or
* to abort transactions (return error codes) in cases where requests cannot be fulfilled.

Important: The behavior described below is independent from the use of `essential` (as defined in Section 5.5 of [@!OpenID]).

### Unavailable Data
If the RP does not have data about a certain Claim, does not understand/support the respective Claim, or the End-User does not consent to the release of the data, the respective Claim MUST be omitted from the response. The OP MUST NOT return an error to the RP. If the End-User does not consent to the whole transaction, standard OpenID Connect logic applies, as defined in Section 3.1.2.6 of [@!OpenID]. 


### Data not Matching Requirements
When the available data does not fulfill the requirements of the RP expressed through `value`, `values`, or `max_age`, the following logic applies:

 * If the respective requirement was expressed for a Claim within `verified_claims/verification`, the whole `verified_claims` element MUST be omitted. 
 * Otherwise, the respective Claim MUST be omitted from the response.

In both cases, the OP MUST NOT return an error to the RP.

### Omitting Elements

If an element is to be omitted according to the rules above, but is required for a valid response, its parent element MUST be omitted as well. This process MUST be repeated until the response is valid.

### Error Handling

If the `claims` sub-element is empty, the OP MUST abort the transaction with an `invalid_request` error.

Claims unknown to the OP or not available as Verified Claims MUST be ignored and omitted from the response. If the resulting `claims` sub-element is empty, the OP MUST omit the `verified_claims` element.

## Requesting sets of Claims by scope {#req_scope}

Verified Claims about the End-User can be requested as part of a pre-defined set by utilizing the `scope` parameter as defined in Section 5.4 of the OpenID Connect specification [@!OpenID].

When using this approach the Claims associated with a `scope` are administratively defined at the OP.  The OP configuration and RP request parameters will determine whether the Claims are returned via the ID Token or UserInfo endpoint as defined in Section 5.3.2 of the OpenID Connect specification [@!OpenID].

# Example Responses

The following sections show examples of responses containing `verified_claims`.

The first and second sections show JSON snippets of the general identity assurance case, where the RP is provided with verification evidence for different methods along with the actual Claims about the End-User.

The third section illustrates how the contents of this object could look like in case of a notified eID system under eIDAS, where the OP does not need to provide evidence of the identity verification process to the RP.

Subsequent sections contain examples for using the `verified_claims` Claim on different channels and in combination with other (unverified) Claims.

## ID document [deprecated format]

<{{examples/response/id_document.json}}

## Document 

<{{examples/response/document.json}}

## Document and verifier details

<{{examples/response/document_verifier.json}}

## Document with external attachments

<{{examples/response/document_with_attachments.json}}

## Document with other checks 

<{{examples/response/document_with_checks.json}}

## Utility statement with attachments

<{{examples/response/utility_statement_with_attachments.json}}

## Document + utility statement

<{{examples/response/document_and_utility_statement.json}}

## ID document + utility bill [deprecated format]

<{{examples/response/id_document_and_utility_bill.json}}

## Notified eID system (eIDAS)

<{{examples/response/eidas.json}}

## Electronic_record

<{{examples/response/electronic_record.json}}

## Vouch

<{{examples/response/vouch.json}}

## Vouch with embedded attachments

<{{examples/response/vouch_with_attachments.json}}

## Document with validation and verification details

<{{examples/response/document_validation_verification_methods.json}}

## Multiple Verified Claims

<{{examples/response/multiple_verified_claims.json}}

## Verified Claims in UserInfo Response

### Request

In this example we assume the RP uses the `scope` parameter to request the email address and, additionally, the `claims` parameter, to request Verified Claims.

The scope value is: `scope=openid email`

The value of the `claims` parameter is:

<{{examples/request/userinfo.json}}

### UserInfo Response

The respective UserInfo response would be

<{{examples/response/userinfo.json}}

## Verified Claims in ID Tokens

### Request

In this case, the RP requests Verified Claims along with other Claims about the End-User in the `claims` parameter and allocates the response to the ID Token (delivered from the token endpoint in case of grant type `authorization_code`).

The `claims` parameter value is

<{{examples/request/id_token.json}}

### ID Token

The respective ID Token could be

<{{examples/response/userinfo.id_token.json}}

## Claims provided by the OP and external sources {#op_attested_and_external_claims}

This example shows how an OP can mix own Claims and Claims provided by  
external sources in a single ID token. 

<{{examples/response/all_in_one.json}}

## Self-Issued OpenID Connect Provider and External Claims

This example shows how a Self-Issued OpenID Connect Provider (SIOP) 
may include Verified Claims obtained from different external Claim
sources into a ID Token.

<{{examples/response/siop_aggregated_and_distributed_claims.json}}

# OP Metadata {#opmetadata}

The OP advertises its capabilities with respect to Verified Claims in its openid-configuration (see [@!OpenID-Discovery]) using the following new elements:

`verified_claims_supported`: REQUIRED. Boolean value indicating support for `verified_claims`, i.e., the OpenID Connect for Identity Assurance extension.

`trust_frameworks_supported`: REQUIRED. JSON array containing all supported trust frameworks. This array must have at least one member.

`evidence_supported`: REQUIRED. JSON array containing all types of identity evidence the OP uses. This array may have zero or more members.

`documents_supported`: REQUIRED when `evidence_supported` contains "document" or "id_document". JSON array containing all identity document types utilized by the OP for identity verification.

`documents_methods_supported`: OPTIONAL. JSON array containing the validation & verification process the OP supports (see @!predefined_values).

`documents_validation_methods_supported`: OPTIONAL. JSON array containing the document validation methods the OP supports (see @!predefined_values).

`documents_verification_methods_supported`: OPTIONAL. JSON array containing the verification methods the OP supports (see @!predefined_values).

`electronic_records_supported`: REQUIRED when `evidence_supported` contains "electronic_record". JSON array containing all electronic record types the OP supports (see @!predefined_values).

`claims_in_verified_claims_supported`: REQUIRED. JSON array containing all Claims supported within `verified_claims`.

`attachments_supported`: REQUIRED when OP supports external attachments. JSON array containing all attachment types supported by the OP. Possible values are `external` and `embedded`. If the list is empty, the OP does not support attachments.

`digest_algorithms_supported`: REQUIRED when OP supports external attachments. JSON array containing all supported digest algorithms which can be used as `alg` property within the digest object of external attachments. If the OP supports external attachments, at least the algorithm `sha-256` MUST be supported by the OP as well. The list of possible digest/hash algorithm names is maintained by IANA in [@!hash_name_registry] (established by [@?RFC6920]).

This is an example openid-configuration snippet:

```json
{
...
   "verified_claims_supported":true,
   "trust_frameworks_supported":[
     "nist_800_63A_3"
   ],
   "evidence_supported": [
      "document",
      "electronic_record",
      "vouch",
      "electronic_signature"
   ],
   "documents_supported": [
       "idcard",
       "passport",
       "driving_permit"
   ],
   "documents_methods_supported": [
       "pipp",
       "sripp",
       "eid"
   ],
   "electronic_records_supported": [
       "secure_mail"
   ],   
   "claims_in_verified_claims_supported": [
      "given_name",
      "family_name",
      "birthdate",
      "place_of_birth",
      "nationalities",
      "address"
   ],
  "attachments_supported": [
    "external",
    "embedded"
  ],
  "digest_algorithms_supported": [
    "sha-256"
  ],
...
}
```

The OP MUST support the `claims` parameter and needs to publish this in its openid-configuration using the `claims_parameter_supported` element.

If the OP supports distributed and/or aggregated Claim types in `verified_claims`, the OP MUST advertise this in its metadata using the `claim_types_supported` element.

# Client Registration and Management

During Client Registration (see [@!OpenID-Registration]) as well as during Client Management [@?RFC7592] the following additional properties are available:

`digest_algorithm`: String value representing the chosen digest algorithm (for external attachments). The value MUST be one of the digest algorithms supported by the OP as advertised in the [OP metadata](#opmetadata). If this property is not set, `sha-256` will be used by default.

# Transaction-specific Purpose {#purpose}

This specification introduces the request parameter `purpose` to allow an RP
to state the purpose for the transfer of End-User data it is asking for.

`purpose`: OPTIONAL. String describing the purpose for obtaining certain End-User data from the OP. The purpose MUST NOT be shorter than 3 characters and MUST NOT be longer than 300 characters. If these rules are violated, the authentication request MUST fail and the OP returns an error `invalid_request` to the RP.

The OP SHOULD use the purpose provided by the RP to inform the respective End-User about the designated use of the data to be transferred or the authorization to be approved.

In order to ensure a consistent UX, the RP MAY send the `purpose` in a certain language and request the OP to use the same language using the `ui_locales` parameter.

If the parameter `purpose` is not present in the request, the OP MAY utilize a description that was pre-configured for the respective RP.

Note: In order to prevent injection attacks, the OP MUST escape the text appropriately before it will be shown in a user interface. The OP MUST expect special characters in the URL decoded purpose text provided by the RP. The OP MUST ensure that any special characters in the purpose text cannot be used to inject code into the web interface of the OP (e.g., cross-site scripting, defacing). Proper escaping MUST be applied by the OP. The OP SHALL NOT remove characters from the purpose text to this end.

# Privacy Consideration {#Privacy}

Timestamps with a time zone component can potentially reveal the person’s location. To preserve the person’s privacy timestamps within the verification element and Verified Claims that represent times SHOULD be represented in Coordinated Universal Time (UTC), unless there is a specific reason to include the time zone, such as the time zone being an essential part of a consented time related Claim in verified data.

The use of scopes is a potential shortcut to request a pre-defined set of Claims, however, the use of scopes might result in more data being returned to the RP than is strictly necessary and not achieving the goal of data minimization. The RP SHOULD only request End-User Claims and metadata it requires.

# Security Considerations {#Security}

This specification focuses on mechanisms to carry End-User Claims and accompanying metadata in JSON objects and JSON 
web tokens, typically as part of an OpenID Connect protocol exchange. Since such an exchange is supposed to take place 
in security sensitive use cases, implementers MUST 

* ensure End-Users are authenticated using appropriately strong authentication methods, and
* combine this specification with an appropriate security profile for OpenID Connect. 

## End-User Authentication

Secure identification of End-Users not only depends on the identity verification at the OP but also on the strength of the user authentication at the OP. Combining a strong identification with weak authentication creates a false impression of security while being open to attacks. For example if an OP uses a simple PIN login, an attacker could guess the PIN of another user and identify himself as the other user at an RP with a high identity assurance level. To prevent this kind of attack, RPs SHOULD request the OP to authenticate the user at a reasonable level, typically using multi-factor authentication, when requesting verified End-User Claims. OpenID Connect supports this by way of the `acr_values` request parameter. 

## Security Profile

This specification does not define or require a particular security profile since there are several security 
profiles and new security profiles under development.  Implementers shall be given flexibility to select the security profile that best suits 
their needs. Implementers might consider [@?FAPI-1-RW] or [@?FAPI-2-BL]. 

Implementers are recommended to select a security profile that has a certification program 
or other resources that allow both OpenID Providers and Relying Parties to ensure they have complied with the profile’s security and 
interoperability requirements, such as the OpenID Foundation Certification Program, https://openid.net/certification/.

The integrity and authenticity of the issued assertions MUST be ensured in order to prevent identity spoofing. 

The confidentiality of all End-User data exchanged between the protocol parties MUST be ensured using suitable 
methods at transport or application layer.

# Predefined Values {#predefined_values}

This specification focuses on the technical mechanisms to convey Verified Claims and thus does not define any identifiers for trust frameworks, documents, methods, validation methods or verification methods. This is left to adopters of the technical specification, e.g., implementers, identity schemes, or jurisdictions.

Each party defining such identifiers MUST ensure the collision resistance of these identifiers. This is achieved by including a domain name under the control of this party into the identifier name, e.g., `https://mycompany.com/identifiers/cool_verification_method`.

The eKYC and Identity Assurance Working Group maintains a wiki page [@!predefined_values_page] that can be utilized to share predefined values with other parties.

{backmatter}

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

<reference anchor="OpenID-Registration" target="https://openid.net/specs/openid-connect-registration-1_0.html">
  <front>
    <title>OpenID Connect Dynamic Client Registration 1.0 incorporating errata set 1</title>
    <author initials="N." surname="Sakimura" fullname="Nat Sakimura">
      <organization>NRI</organization>
    </author>
    <author initials="J." surname="Bradley" fullname="John Bradley">
      <organization>Ping Identity</organization>
    </author>
    <author initials="M." surname="Jones" fullname="Mike Jones">
      <organization>Microsoft</organization>
    </author>
   <date day="8" month="Nov" year="2014"/>
  </front>
</reference>

<reference anchor="FAPI-1-RW" target="https://bitbucket.org/openid/fapi/src/master/Financial_API_WD_002.md">
  <front>
    <title>Financial-grade API - Part 2: Read and Write API Security Profile</title>
    <author initials="" surname="OpenID Foundation's Financial API (FAPI) Working Group">
      <organization>OpenID Foundation's Financial API (FAPI) Working Group</organization>
    </author>
   <date day="9" month="Sep" year="2020"/>
  </front>
</reference>

<reference anchor="FAPI-2-BL" target="https://bitbucket.org/openid/fapi/src/master/FAPI_2_0_Baseline_Profile.md">
  <front>
    <title>FAPI 2.0 Baseline Profile </title>
    <author initials="" surname="OpenID Foundation's Financial API (FAPI) Working Group">
      <organization>OpenID Foundation's Financial API (FAPI) Working Group</organization>
    </author>
   <date day="9" month="Sep" year="2020"/>
  </front>
</reference>

<reference anchor="NIST-SP-800-63a" target="https://doi.org/10.6028/NIST.SP.800-63a">
  <front>
    <title>NIST Special Publication 800-63A, Digital Identity Guidelines, Enrollment and Identity Proofing Requirements</title>
    <author initials="Paul. A." surname="Grassi" fullname="Paul A. Grassi">
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

<reference anchor="FATF-Digital-Identity" target="https://www.fatf-gafi.org/media/fatf/documents/recommendations/Guidance-on-Digital-Identity.pdf">
  <front>
    <title>Guidance on Digital Identity</title>
    <author initials="" surname="FATF">
      <organization>Financial Action Task Force (FATF)</organization>
    </author>
   <date month="March" year="2020"/>
  </front>
</reference>

<reference anchor="JPAML" target=" https://elaws.e-gov.go.jp/search/elawsSearch/elaws_search/lsg0500/detail?lawId=420M60000f5a001#58">
  <front>
    <title>Ordinance for Enforcement of the Act on Prevention of Transfer of Criminal Proceeds</title>
    <author>
      <organization>Cabinet Office,
Ministry of Internal Affairs and Communications,
Ministry of Justice,
Ministry of Finance,
Ministry of Health, Labor and Welfare,
Ministry of Agriculture, Forestry and Fisheries,
Ministry of Economy, Trade and Industry,
Ministry of Land, Infrastructure and Transport</organization>
    </author>
   <date day="8" month="November" year="2019"/>
  </front>
</reference>

<reference anchor="ISO8601-2004" target="http://www.iso.org/iso/catalogue_detail?csnumber=40874">
    <front>
      <title>ISO 8601:2004. Data elements and interchange formats - Information interchange -
      Representation of dates and times</title>
      <author surname="International Organization for Standardization">
        <organization abbrev="ISO">International Organization for Standardization</organization>
      </author>
      <date year="2004" />
    </front>
</reference>

<reference anchor="ISO3166-1" target="https://www.iso.org/standard/63545.html">
    <front>
      <title>ISO 3166-1:1997. Codes for the representation of names of
      countries and their subdivisions -- Part 1: Country codes</title>
      <author surname="International Organization for Standardization">
        <organization abbrev="ISO">International Organization for Standardization</organization>
      </author>
      <date year="2013" />
    </front>
</reference>

<reference anchor="ISO3166-3" target="https://www.iso.org/standard/63547.html">
    <front>
      <title>ISO 3166-1:2013. Codes for the representation of names of countries and their subdivisions -- Part 3: Code for formerly used names of countries</title>
      <author surname="International Organization for Standardization">
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
      <author surname="INTERNATIONAL CIVIL AVIATION ORGANIZATION">
        <organization>INTERNATIONAL CIVIL AVIATION ORGANIZATION</organization>
      </author>
   <date year="2015"/>
  </front>
</reference>

<reference anchor="verified_claims.json" target="https://openid.net/schemas/verified_claims-11.json">
  <front>
    <title>JSON Schema for assertions using verified_claims</title>
    <author>
        <organization>OpenID Foundation</organization>
      </author>
   <date year="2020"/>
  </front>
</reference>

<reference anchor="verified_claims_request.json" target="https://openid.net/schemas/verified_claims_request-11.json">
  <front>
    <title>JSON Schema for requesting verified_claims</title>
    <author>
        <organization>OpenID Foundation</organization>
      </author>
   <date year="2020"/>
  </front>
</reference>

<reference anchor="predefined_values_page" target="https://openid.net/wg/ekyc-ida/identifiers/">
  <front>
    <title>Overview page for predefined values</title>
    <author>
      <organization>OpenID Foundation</organization>
    </author>
    <date year="2021"/>
  </front>
</reference>

<reference anchor="E.164" target="https://www.itu.int/rec/T-REC-E.164/en">
  <front>
    <title>Recommendation ITU-T E.164</title>
    <author>
      <organization>ITU-T</organization>
    </author>
    <date year="2010" month="11"/>
  </front>
</reference>

<reference anchor="hash_name_registry" target="https://www.iana.org/assignments/named-information/">
  <front>
    <title>Named Information Hash Algorithm Registry</title>
    <author>
      <organization>IANA</organization>
    </author>
    <date year="2016" month="09"/>
  </front>
</reference>

# IANA Considerations

## JSON Web Token Claims Registration

This specification requests registration of the following value in the IANA "JSON Web Token Claims Registry" established by [@!RFC7519]. 

### Registry Contents

{spacing="compact"}
Claim Name:
: `verified_claims`

Claim Description:
: This container Claim is composed of the verification evidence related to a certain verification process and the corresponding Claims about the End-User which were verified in this process.
 
Change Controller:
: eKYC and Identity Assurance Working Group - openid-specs-ekyc-ida@lists.openid.net

Specification Document(s):
: Section [Verified Claims](#verified_claims) of this document

Claim Name: 
: `place_of_birth`

Claim Description: 
: A structured Claim representing the End-User’s place of birth. 

Change Controller: 
: eKYC and Identity Assurance Working Group - openid-specs-ekyc-ida@lists.openid.net
    
Specification Document(s): 
: Section [Claims](#claims) of this document

Claim Name: 
: `nationalities`

Claim Description:
: String array representing the End-User’s nationalities.

Change Controller:
: eKYC and Identity Assurance Working Group - openid-specs-ekyc-ida@lists.openid.net

Specification Document(s): 
: Section [Claims](#claims) of this document

Claim Name: 
: `birth_family_name`

Claim Description:
: Family name(s) someone has when they were born, or at least from the time they were a child. This term can be used by a person who changes the family name(s) later in life for any reason. Note that in some cultures, people can have multiple family names or no family name; all can be present, with the names being separated by space characters.

Change Controller:
: eKYC and Identity Assurance Working Group - openid-specs-ekyc-ida@lists.openid.net

Specification Document(s): 
: Section [Claims](#claims) of this document

Claim Name:
: `birth_given_name`

Claim Description: 
: Given name(s) someone has when they were born, or at least from the time they were a child. This term can be used by a person who changes the given name later in life for any reason. Note that in some cultures, people can have multiple given names; all can be present, with the names being separated by space characters.

Change Controller: 
: eKYC and Identity Assurance Working Group - openid-specs-ekyc-ida@lists.openid.net

Specification Document(s): 
: Section [Claims](#claims) of this document

Claim Name:
: `birth_middle_name`

Claim Description:
: Middle name(s) someone has when they were born, or at least from the time they were a child. This term can be used by a person who changes the middle name later in life for any reason. Note that in some cultures, people can have multiple middle names; all can be present, with the names being separated by space characters. Also note that in some cultures, middle names are not used.

Change Controller:
: eKYC and Identity Assurance Working Group - openid-specs-ekyc-ida@lists.openid.net

Specification Document(s): 
: Section [Claims](#claims) of this document

Claim Name:
: `salutation`

Claim Description:
: End-User’s salutation, e.g., “Mr.”

Change Controller:
: eKYC and Identity Assurance Working Group - openid-specs-ekyc-ida@lists.openid.net

Specification Document(s): 
: Section [Claims](#claims) of this document

Claim Name:
: `title`

Claim Description:
: End-User’s title, e.g., “Dr.”

Change Controller:
: eKYC and Identity Assurance Working Group - openid-specs-ekyc-ida@lists.openid.net

Specification Document(s): 
: Section [Claims](#claims) of this document

Claim Name:
: `msisdn`

Claim Description:
: End-User’s mobile phone numer formatted according to ITU-T recommendation [@!E.164], e.g., “+1999550123”

Change Controller:
: eKYC and Identity Assurance Working Group - openid-specs-ekyc-ida@lists.openid.net

Specification Document(s):
: Section [Claims](#claims) of this document

Claim Name:
: `also_known_as`

Claim Description:
: Stage name, religious name or any other type of alias/pseudonym with which a person is known in a specific context besides its legal name. This must be part of the applicable legislation and thus the trust framework (e.g., be an attribute on the identity card).

Change Controller:
: eKYC and Identity Assurance Working Group - openid-specs-ekyc-ida@lists.openid.net

Specification Document(s): 
: Section [Claims](#claims) of this document

# Acknowledgements {#Acknowledgements}

The following people at yes.com and partner companies contributed to the concept described in the initial contribution to this specification: Karsten Buch, Lukas Stiebig, Sven Manz, Waldemar Zimpfer, Willi Wiedergold, Fabian Hoffmann, Daniel Keijsers, Ralf Wagner, Sebastian Ebling, Peter Eisenhofer.

We would like to thank Julian White, Bjorn Hjelm, Stephane Mouy, Alberto Pulido, Joseph Heenan, Vladimir Dzhuvinov, Kosuke Koiwai, Azusa Kikuchi, Naohiro Fujie, Takahiko Kawasaki, Sebastian Ebling, Marcos Sanz, Tom Jones, Mike Pegman, Michael B. Jones, Jeff Lombardo, Taylor Ongaro, Peter Bainbridge-Clayton, and Sascha Preibisch for their valuable feedback and contributions that helped to evolve this specification.

# Notices

Copyright (c) 2020 The OpenID Foundation.

The OpenID Foundation (OIDF) grants to any Contributor, developer, implementer, or other interested party a non-exclusive, royalty free, worldwide copyright license to reproduce, prepare derivative works from, distribute, perform and display, this Implementers Draft or Final Specification solely for the purposes of (i) developing specifications, and (ii) implementing Implementers Drafts and Final Specifications based on such documents, provided that attribution be made to the OIDF as the source of the material, but that such attribution does not indicate an endorsement by the OIDF.

The technology described in this specification was made available from contributions from various sources, including members of the OpenID Foundation and others. Although the OpenID Foundation has taken steps to help ensure that the technology is available for distribution, it takes no position regarding the validity or scope of any intellectual property or other rights that might be claimed to pertain to the implementation or use of the technology described in this specification or the extent to which any license under such rights might or might not be available; neither does it represent that it has made any independent effort to identify any such rights. The OpenID Foundation and the contributors to this specification make no (and hereby expressly disclaim any) warranties (express, implied, or otherwise), including implied warranties of merchantability, non-infringement, fitness for a particular purpose, or title, related to this specification, and the entire risk as to implementing this specification is assumed by the implementer. The OpenID Intellectual Property Rights policy requires contributors to offer a patent promise not to assert certain patent claims against other contributors and against implementers. The OpenID Foundation invites any interested party to bring to its attention any copyrights, patents, patent applications, or other proprietary rights that may cover technology that may be required to practice this specification.

# Document History

   [[ To be removed from the final specification ]]

   -12

   * introduced `document` evidence type, which is more universal than `id_document`
   * deprecated `id_document`
   * introduced `electronic_record` and `vouch` evidence types
   * introduced `validation_method` & `verification_method` to provide more detail than `method`
   * added lookahead capabilities for disctributed Claims 
   * added support to attach document artifacts
   * changed evidence type `qes` to `electronic_signature` 
   * Added Claim `also_known_as`
   * Added text regarding security profiles
   * Editorial improvements
   * Added further co-authors
   * Added `assurance_level` field
   * added `assurance_process` type
   * Added text about dependency between identity assurance and authentication assurance
   * Added new field `country_code` to `address` Claim
   * Relaxed requirements for showing purpose

   -11
  
   * Added support for requesting different sets of Claims with different requirements regarding trust_framework and other verification elements (e.g., evidence)
   * added `msisdn` Claim
   * clarified scope of this specification

   -10

   * Editorial improvements
   * Improved JSON schema (alignment with spec and bug fix)
   
   -09
 
   * `verified_claims` element may contain one or more Verified Claims objects
   * an individual assertion may contain `verified_claims` elements in the assertion itself and any aggregated or distributed Claims sets it includes or refers to, respectively
   * moved all definitions of pre-defined values for trust frameworks, id documents and verification methods to a wiki page as non-normative overview
   * clarified and simplified request syntax
   * reduced mandatory requirement `verified_claims` to bare minimum
   * removed JSON schema from draft and added reference to JSON schema file instead
   * added request JSON schema
   * added IANA section with JSON Web Token Claims Registration
   * integrated source into single md file
   * added privacy considerations regarding time zone data, enhanced syntax definition of time and date-time fields in spec and response schema
   * fixed typos

   -08
   
   * added `uripp` verification method
   * small fixes to examples
   
   -07
   
   * fixed typos
   * changed `nationality` String Claim to `nationalities` String array Claim
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
   *  added several examples (ID Token vs UserInfo, unverified & Verified Claims, aggregated & distributed Claims)
   *  incorporated text proposal of Marcos Sanz regarding max_age
   *  added IANA registration for new error code `unable_to_meet_requirement`
