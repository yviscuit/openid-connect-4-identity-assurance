# Verified Data Representation 

OpenID Connectのこの拡張は,RPが検証済みのClaimと未検証のClaimを混在させ, 検証済みのClaimとして未検証のClaimを偶発的に処理できないようにすることを目的としている.

それ故, 提案された表現は`verified_claims`コンテナ要素内で検証済みClaimをRPに提供することである. このコンテナは特定の検証プロセスに関連する検証のエビデンスとこのプロセスで検証されたエンドユーザについての該当Claimで構成されている.

このセクションでは`verified_claims`の構造と意味について詳しく説明する. 機械可読な構文定義は(#json_schema)でJSONスキーマとして提供される. `verified_claims`要素を含むJSONドキュメントを自動的に検証するために使用できる.

`verified_claims`は以下のサブ要素で構成される:

* `verification`: 必須(REQUIRED). 検証プロセスに関するすべてのデータを含むオブジェクト.
* `claims`: 必須(REQUIRED). エンドユーザに関するの検証済Claimのためのコンテナであるオブジェクト.

注: 実装は, この仕様またはこの仕様の拡張で定義されていないサブ要素を無視しなければならない(MUST).

## verification Element {#verification}

この要素には, 個人の身元を確認し, それぞれの個人データをユーザーアカウントにバインドするために実行されたプロセスに関する情報が含まれる.

`verification`要素は以下の要素を含む:

`trust_framework`: 必須(REQUIRED). OPのidentity verificationプロセスと, identity assuranceレベルを管理するtrust frameworkを定める文字列.

例としては`eidas_ial_high`で, これはeIDAS [@?eIDAS] の下で通知されたeIDシステムを示し, assuranceレベル"high"のidentity assuranceを提供する.

標準化された値の初期リストは、[Trust Frameworks](#predefined_values_tf)で定義されている. 追加のtrust framework identifiersも導入できる[how？]. RPは理解できないtrust framework identifiersを含む`verified_claims`Claimを無視しなければならない(SHOLUD).

`trust_framework`は、`verification`要素の中でRPに提供される追加のデータを決定する. たとえば、eIDAS公認eIDシステムは, データを追加する必要はないが, eIDASに管理されていないOPはRPが法的義務を果たすために検証証拠を提供する必要がある. 後者の例としては、ドイツのマネーロンダリング防止法（`de_aml`）に基づいて行動するOPである.

`time`: IDの検証が行われた日時を示すISO 8601:2004 [ISO8601-2004] `YYYY-MM-DDThh:mm:ss±hh` フォーマットのタイムスタンプ. 特定のトラストフレームワークでは、この要素の存在が必要になる場合がある.

`verification_process`: OPによって実行されるidentity verificationプロセスへの一意の参照. 紛争または監査の場合のバックトレースに使用される.特定のトラストフレームワークでは、この要素の存在が必要になる場合がある.

注：`verification_process` はOPでのidentity verificationプロセスを指すが, `txn`ClaimはOPがRPに対してユーザ検証済identityデータを証明した特定のOpenID Connectトランザクションを指す.

`evidence`: OPがユーザのidentityを個別のJSONオブジェクトとして検証するために使用した `evidence` に関する情報を含むJSON配列. すべてのオブジェクトには, evidenceのタイプを決定する`type`プロパティが含まれている. RPはこの情報を`evidence`プロパティを適切に処理するために利用する.

重要:実装はこの仕様またはこの仕様の拡張で定義されていないサブ要素を無視しなければならない(MUST).

### Evidence 

次のevidenceのタイプが定義されている:

* `id_document`: あらゆる種類の政府発行の身分証明書に基づく検証
* `utility_bill`: 公共料金の支払に基づく検証
* `qes`: eIDAS認定電子署名に基づく検証

#### id_document

次の種類の属性が `id_document` evidenceのサブ要素として含まれる.

`method`: 必須(REQUIRED). id documentを検証するために使われるメソッド. 事前に定義された値は [Verification Methods](#predefined_values_vm)で定義されている.

`verifier`: オプション(OPTIONAL). OPに代わってidentity verificationを実行した法人を示すJSONオブジェクト. このオブジェクトは、OPがidentity verificationを実行しなかった場合にのみ含める必要がある(SHOULD). このオブジェクトは次のプロパティで構成される:

* `organization`: OPに変わって検証を行った組織を表す文字列.
* `txn`: identity verificationのトランザクションを参照する識別子. このトランザクション識別子は、監査中のトランザクションの詳細を分析できる.

`time`: このid documentが検証された日付を表すISO 8601:2004 [ISO8601-2004] `YYYY-MM-DDThh:mm:ss±hh`フォーマットのタイムスタンプ.

`document`: ID検証に使用されるid documentを表すJSONオブジェクト. 次のプロパティで構成される:

* `type`: 必須(REQUIRED). id documentのタイプを示す文字列. 標準化された値は[Identity Documents](#predefined_values_idd)で定義されます. OPは事前に定義されていない値を使用するかもしれず(MAY), その場合, RPはアサーションを処理できないか, 監査目的でこの値を保存するだけか, またはそれに言及されたビジネスロジックであることを表す.
* `number`: identity documentの番号を表す文字列.
* `issuer`: このidentity documentの発行者の情報を含むJSONオブジェクト. このオブジェクトは次のプロパティで構成される:
	*  `name`:必須(REQUIRED). identity documentの発行者の名称.
	*  `country`: ドキュメントを ICAO 2-letter-code [@!ICAO-Doc9303]として発行した国または組織を示す文字列（例： "JP"）. ICAO 3-letter codes は, "UNO"など, 対応するISO 2-letter codes がない場合に使用できる.
* `date_of_issuance`: 特定の種類のドキュメント用にこの属性が存在する場合は必須(REQUIRED). ISO 8601:2004 YYYY-MM-DDフォーマットでドキュメントが発行された日付.
* `date_of_expiry`: 特定の種類のドキュメント用にこの属性が存在する場合は必須(REQUIRED). ISO 8601:2004 YYYY-MM-DDフォーマットのドキュメントの有効期限.

#### utility_bill

次の種類の要素が `utility_bill` evidenceのサブ要素として含まれる.

`provider`: 必須(REQUIRED). 請求書を発行した各プロバイダを識別するJSONオブジェクト. オブジェクトは次のプロパティで構成される:

* `name`: プロバイダを指定する文字列.
* OpenID Connectの `address` Claim ([@!OpenID])のすべての要素

`date`: この請求書が発行された日時を含むISO 8601:2004 YYYY-MM-DDフォーマットの文字列.

#### qes

次の種類の要素が `qes` evidenceのサブ要素として含まれる.

`issuer`: 必須(REQUIRED). 署名者の証明書を発行した証明機関を示す文字列.

`serial_number`:必須(REQUIRED). 署名に使用される証明書のシリアルナンバーを含む文字列.

`created_at`: 必須(REQUIRED).  ISO 8601:2004 YYYY-MM-DDThh:mm:ss±hhフォーマットの署名が作られた時間.


## claims Element {#claimselement}

`claims`要素にはプロセスによって検証され, 対応する`verification` 要素によって決定されたポリシーに従って検証されたエンドユーザについてのClaimが含まれる.

`claims`要素にはOpenID Connect specification [@!OpenID]のSection 5.1で定義されている以下のClaimが一つ以上含まれるかもしれない(MAY)

* `name`
* `given_name`
* `middle_name`
* `family_name`
* `birthdate`
* `address`

または(#userclaims)で定義されているClaimを含むかもしれない.

`claims`要素は, 兄弟要素の`verification`で提示された検証プロセスでそれぞれのClaimの値が検証された場合, 他のClaimも含むかもしれない(MAY).

Claim名は, OpenID Connect仕様[@!OpenID]のSection5.2で指定されている言語タグで注釈を付けてもよい(MAY).
