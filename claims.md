# Claims {#claims}

## Additional Claims about End-Users {#userclaims}

<!-- In order to fulfill the requirements of some jurisdictions on identity assurance, this specification defines the following Claims for conveying user data in addition to the Claims defined in the OpenID Connect specification [@!OpenID]: -->
identity assurance に関する一部の権限の要件を満たすために, この仕様では OpenID仕様 [@!OpenID] に定義されている Claim にユーザデータを伝達するための以下の追加の Claim を定義する:

<!-- * `place_of_birth`: a structured Claim representing the End-User’s place of birth. It consists of the following fields: -->
* `place_of_birth`: エンドユーザの出生地を示す構造化された Claim. 次のフィールドで構成される:
	<!-- * `country`: REQUIRED. [@!ISO3166-1] Alpha-2 (e.g., DE) or [@!ISO3166-3] -->
	* `country`: 必須 (REQUIRED). [@!ISO3166-1] Alpha-2 (例えば, DE) または [@!ISO3166-3] 
	<!-- * `region`: State, province, prefecture, or region component. This field might be required in some jurisdictions. -->
	* `region`: State, province, prefecture, または他の地域コンポーネント. 一部の管轄区域ではこのフィールドは必須かもしれない.
	<!-- * `locality`: REQUIRED. city or other locality -->
	* `locality`: 必須 (REQUIRED). city, または別の地域.
<!-- * `nationalities`: string array representing the user’s nationalities in ICAO 2-letter codes [@!ICAO-Doc9303], e.g. "US" or "DE". 3-letter codes MAY be used when there is no corresponding ISO 2-letter code, such as "EUE". -->
* `nationalities`: ユーザの国籍を表す ICAO 2-letter codes [@!ICAO-Doc9303] の文字配列. 例えば "US" や "DE". "EUE" のように対応する 2-letter code がない場合, 3-letter codes を利用してもよい (MAY).
<!-- * `birth_family_name`: family name someone has when he or she is born, or at least from the time he or she is a child. This term can be used by a person who changes the family name later in life for any reason. -->
* `birth_family_name`: 彼または彼女が生まれたとき, あるいは少なくとも子供の時から持っている姓. この用語は人生の途中に何らかの理由で姓を変更した人が利用できる.
<!-- * `birth_given_name`: given name someone has when he or she is born, or at least from the time he or she is a child. This term can be used by a person who changes the given name later in life for any reason. -->
* `birth_given_name`: 彼または彼女が生まれたとき, あるいは少なくとも子供の時から持っている名前. この用語は人生の途中に何らかの理由で名前を変更した人が利用できる.
<!-- * `birth_middle_name`: middle name someone has when he or she is born, or at least from the time he or she is a child. This term can be used by a person who changes the middle name later in life for any reason. -->
* `birth_middle_name`: 彼または彼女が生まれたとき, あるいは少なくとも子供の時から持っているミドルネーム. この用語は人生の途中に何らかの理由でミドルネームを変更した人が利用できる.
<!-- * `salutation`: End-User’s salutation, e.g. “Mr.” -->
* `salutation`: エンドユーザの敬称, 例えば “Mr.”
<!-- * `title`: End-User’s title, e.g. “Dr.” -->
* `title`: エンドユーザの肩書, 例えば “Dr.”

## txn Claim

<!-- Strong identity verification typically requires the participants to keep an audit trail of the whole process. -->
一般的に, 強固な identity verification は参加者がプロセス全体の監査証跡を保持する必要がある.

<!-- The `txn` Claim as defined in [@!RFC8417] is used in the context of this extension to build audit trails across the parties involved in an OpenID Connect transaction. -->
[@!RFC8417] で定義されている `txn` Claim はこの拡張のコンテキストで使用され, OpenID Connect トランザクションに関わるの関係者全体の監査証跡を構築する.

<!-- If the OP issues a `txn`, it MUST maintain a corresponding audit trail, which at least consists of the following details: -->
OP が `txn` を発行する場合, 対応する監査証跡を維持する必要があり (MUST), 少なくとも次の詳細で構成される.

<!-- * the transaction id, -->
* transaction id,
<!-- * the authentication methods employed, and -->
* 採用されている authentication methods, および
<!-- * the transaction type (e.g. scope values). -->
* transaction type (scope 値など).

<!-- This transaction data MUST be stored as long as it is required to store transaction data for auditing purposes by the respective regulation. -->
このトランザクションデータは, それぞれの規定による監査目的のためにトランザクションデータを保存する必要がある限り保存し続けなければならない (MUST).

<!-- The RP requests this Claim like any other Claim via the `claims` parameter or as part of a default Claim set identified by a scope value. -->
RP はこの Claim を `claims` パラメータを介して, または scope 値によって識別されるデフォルトの Claim の一部として, 他の Claim と同様に要求する.

<!-- The `txn` value MUST allow an RP to obtain these transaction details if needed. -->
`txn` 値は必要に応じて RP がこれらのトランザクションを参照できるようにしなければならない (MUST).

<!-- Note: the mechanism to obtain the transaction details from the OP and their format is out of scope of this specification. -->
注：トランザクションの詳細を, OP および, それらのフォーマットから取得するメカニズムはこの仕様の範囲外である.
    



