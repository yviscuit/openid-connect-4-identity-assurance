# Verified Data Representation 

<!-- This extension to OpenID Connect wants to ensure that RPs cannot mix up verified and unverified Claims and incidentally process unverified Claims as verified Claims. -->
OpenID Connect のこの拡張は, RP が検証済みの Claim と未検証の Claim を混在させ, 検証済みの Claim として未検証の Claim を偶発的に処理できないようにすることを目的としている.

<!-- The representation proposed therefore provides the RP with the verified Claims within a container element `verified_claims`. This container is composed of the verification evidence related to a certain verification process and the corresponding Claims about the End-User which were verified in this process. -->
それ故, 提案された表現は `verified_claims` コンテナ要素内で検証済み Claim を RP に提供することである. このコンテナは特定の検証プロセスに関連する検証のエビデンスとこのプロセスで検証されたエンドユーザについての該当 Claim で構成されている.

<!-- This section explains the structure and meaning of `verified_claims` in detail. A machine-readable syntax definition is given as JSON schema in (#json_schema). It can be used to automatically validate JSON documents containing a  `verified_claims` element. --> 
このセクションでは `verified_claims` の構造と意味について詳しく説明する. 機械可読な構文定義は (#json_schema) で JSON スキーマとして提供される. `verified_claims` 要素を含む JSON ドキュメントを自動的に検証するために使用できる.

<!-- `verified_claims` consists of the following sub-elements: -->
`verified_claims` は以下のサブ要素で構成される:

<!-- * `verification`: REQUIRED. Object that contains all data about the verification process. -->
* `verification`: 必須 (REQUIRED). 検証プロセスに関するすべてのデータを含むオブジェクト.
<!-- * `claims`: REQUIRED. Object that is the container for the verified Claims about the End-User. --> 
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
`trust_framework` は, `verification` 要素の中で RP に提供される追加のデータを決定する. たとえば, eIDAS 公認 eID システムは, データを追加する必要はないが, eIDAS に管理されていない OP は RP が法的義務を果たすために検証証拠を提供する必要がある. 後者の例としては, ドイツのマネーロンダリング防止法（`de_aml`）に基づいて行動する OP である.

<!-- `time`: Time stamp in ISO 8601:2004 [ISO8601-2004] `YYYY-MM-DDThh:mm:ss±hh` format representing the date and time when identity verification took place. Presence of this element might be required for certain trust frameworks. -->
`time`: ID の検証が行われた日時を示す ISO 8601:2004 [ISO8601-2004] `YYYY-MM-DDThh:mm:ss±hh` フォーマットのタイムスタンプ. 特定のトラストフレームワークでは, この要素の存在が必要になる場合がある.

<!-- `verification_process`: Unique reference to the identity verification process as performed by the OP. Used for backtracing in case of disputes or audits. Presence of this element might be required for certain trust frameworks. -->
`verification_process`: OP によって実行される identity verification プロセスへの一意の参照. 紛争または監査の場合のバックトレースに使用される.特定のトラストフレームワークでは, この要素の存在が必要になる場合がある.

<!-- Note: While `verification_process` refers to the identity verification process at the OP, the `txn` claim refers to a particular OpenID Connect transaction in which the OP attested the user's verified identity data towards a RP. -->
注：`verification_process` は OP での identity verification プロセスを指すが, `txn` Claim は OP が RP に対してユーザ検証済 identity データを証明した特定の OpenID Connect トランザクションを指す.

<!-- `evidence` is a JSON array containing information about the evidence the OP used to verify the user's identity as separate JSON objects. Every object contains the property `type` which determines the type of the evidence. The RP uses this information to process the `evidence` property appropriately. -->
`evidence`: OP がユーザの identity を個別の JSON オブジェクトとして検証するために使用した `evidence` に関する情報を含む JSON 配列. すべてのオブジェクトには, evidence のタイプを決定する `type` プロパティが含まれている. RP はこの情報を `evidence` プロパティを適切に処理するために利用する.

<!-- Important: implementations MUST ignore any sub-element not defined in this specification or extensions of this specification. -->
重要:実装はこの仕様またはこの仕様の拡張で定義されていないサブ要素を無視しなければならない (MUST).

### Evidence 

<!-- The following types of evidence are defined: -->
次の evidence のタイプが定義されている:

<!-- * `id_document`: verification based on any kind of government issued identity document --> 
* `id_document`: あらゆる種類の政府発行の身分証明書に基づく検証
<!-- * `utility_bill`: verification based on a utility bill -->
* `utility_bill`: 公共料金の支払に基づく検証
<!-- * `qes`: verification based on a eIDAS Qualified Electronic Signature -->
* `qes`: eIDAS 認定電子署名に基づく検証

#### id_document

<!-- The following elements are contained in an `id_document` evidence sub-element. --> 
次の種類の属性が `id_document` evidence のサブ要素として含まれる.

<!-- `method`: REQUIRED. The method used to verify the id document. Predefined values are given in  [Verification Methods](#predefined_values_vm) -->
`method`: 必須 (REQUIRED). id document を検証するために使われるメソッド. 事前に定義された値は [Verification Methods](#predefined_values_vm) で定義されている.

<!-- `verifier`: OPTIONAL. A JSON object denoting the legal entity that performed the identity verification on behalf of the OP. This object SHOULD only be included if the OP did not perform the identity verification itself. This object consists of the following properties: -->
`verifier`: オプション (OPTIONAL). OP に代わって identity verification を実行した法人を示す JSON オブジェクト. このオブジェクトは, OP が identity verification を実行しなかった場合にのみ含める必要がある (SHOULD). このオブジェクトは次のプロパティで構成される:

<!-- * `organization`: String denoting the organization which performed the verification on behalf of the OP. --> 
* `organization`: OP に変わって検証を行った組織を表す文字列.
<!-- * `txn`: identifier refering to the identity verification transaction. This transaction identifier can be resolved into transaction details during an audit. -->
* `txn`: identity verification のトランザクションを参照する識別子. このトランザクション識別子は, 監査中のトランザクションの詳細を分析できる.

<!-- `time`: Time stamp in ISO 8601:2004 [ISO8601-2004] `YYYY-MM-DDThh:mm:ss±hh` format representing the date when this id document was verified. --> 
`time`: この id document が検証された日付を表す ISO 8601:2004 [ISO8601-2004] `YYYY-MM-DDThh:mm:ss±hh` フォーマットのタイムスタンプ.

<!-- `document`: A JSON object representing the id document used to perform the id verification. It consists of the following properties: -->
`document`: ID 検証に使用される id document を表す JSON オブジェクト. 次のプロパティで構成される:

<!-- * `type`: REQUIRED. String denoting the type of the id document. Standardized values are defined in [Identity Documents](#predefined_values_idd). The OP MAY use other than the predefined values in which case the RPs will either be unable to process the assertion, just store this value for audit purposes, or apply bespoken business logic to it. -->
* `type`: 必須 (REQUIRED). id document のタイプを示す文字列. 標準化された値は [Identity Documents](#predefined_values_idd) で定義されます. OP は事前に定義されていない値を使用するかもしれず (MAY), その場合, RP はアサーションを処理できないか, 監査目的でこの値を保存するだけか, またはそれに言及されたビジネスロジックであることを表す.
<!-- * `number`: String representing the number of the identity document. -->
* `number`: identity document の番号を表す文字列.
<!-- * `issuer`: A JSON object containg information about the issuer of this identity document. This object consists of the following properties: -->
* `issuer`: この identity document の発行者の情報を含む JSON オブジェクト. このオブジェクトは次のプロパティで構成される:
	<!-- *  `name`: REQUIRED. Designation of the issuer of the identity document -->
	*  `name`:必須 (REQUIRED). identity document の発行者の名称.
	<!-- *  `country`: String denoting the country or organization that issued the document as ICAO 2-letter-code [@!ICAO-Doc9303], e.g. "JP". ICAO 3-letter codes MAY be used when there is no corresponding ISO 2-letter code, such as "UNO". -->
	*  `country`: ドキュメントを ICAO 2-letter-code [@!ICAO-Doc9303] として発行した国または組織を示す文字列（例： "JP"）. ICAO 3-letter codes は, "UNO" など, 対応する ISO 2-letter codes がない場合に使用できる.
<!-- * `date_of_issuance`: REQUIRED if this attribute exists for the particular type of document. The date the document was issued as ISO 8601:2004 YYYY-MM-DD format. -->
* `date_of_issuance`: 特定の種類のドキュメント用にこの属性が存在する場合は必須 (REQUIRED). ISO 8601:2004 YYYY-MM-DD フォーマットでドキュメントが発行された日付.
<!-- * `date_of_expiry`: REQUIRED if this attribute exists for the particular type of document. The date the document will expire as ISO 8601:2004 YYYY-MM-DD format. --> 
* `date_of_expiry`: 特定の種類のドキュメント用にこの属性が存在する場合は必須 (REQUIRED). ISO 8601:2004 YYYY-MM-DD フォーマットのドキュメントの有効期限.

#### utility_bill

<!-- The following elements are contained in a `utility_bill` evidence sub-element. --> 
次の種類の要素が `utility_bill` evidence のサブ要素として含まれる.

<!-- `provider`: REQUIRED. A JSON object identifying the respective provider that issued the bill. The object consists of the following properties: -->
`provider`: 必須 (REQUIRED). 請求書を発行した各プロバイダを識別する JSON オブジェクト. オブジェクトは次のプロパティで構成される:

<!-- * `name`: A String designating the provider. -->
* `name`: プロバイダを指定する文字列.
<!-- * All elements of the OpenID Connect `address` Claim ([@!OpenID]) -->
* OpenID Connect の `address` Claim ([@!OpenID]) のすべての要素

<!-- `date`: A ISO 8601:2004 YYYY-MM-DD formatted string containing the date when this bill was issued. -->
`date`: この請求書が発行された日時を含む ISO 8601:2004 YYYY-MM-DD フォーマットの文字列.

#### qes

<!-- The following elements are contained in a `qes` evidence sub-element. --> 
次の種類の要素が `qes` evidence のサブ要素として含まれる.

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
