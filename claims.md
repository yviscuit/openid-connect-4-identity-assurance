# Claims {#claims}

## Additional Claims about End-Users {#userclaims}

identity assuranceに関する一部の権限の要件を満たすために, この仕様ではOpenID仕様[@!OpenID]に定義されているClaimにユーザデータを伝達するための以下の追加のClaimを定義する:

* `place_of_birth`: エンドユーザの出生地を示す構造化されたClaim. 次のフィールドで構成される:
	* `country`: 必須(REQUIRED). [@!ISO3166-1] Alpha-2 (例えば, DE) または [@!ISO3166-3] 
	* `region`: State, province, prefecture, または他の地域コンポーネント. 一部の管轄区域ではこのフィールドは必須かもしれない.
	* `locality`: 必須(REQUIRED). city, または別の地域.
* `nationalities`: ユーザの国籍を表すICAO 2-letter codes [@!ICAO-Doc9303]の文字配列. 例えば "US" や "DE". "EUE"のように対応する2-letter codeがない場合, 3-letter codesを利用してもよい(MAY).
* `birth_family_name`: 彼または彼女が生まれたとき, あるいは少なくとも子供の時から持っている姓. この用語は人生の途中に何らかの理由で姓を変更した人が利用できる.
* `birth_given_name`: 彼または彼女が生まれたとき, あるいは少なくとも子供の時から持っている名前. この用語は人生の途中に何らかの理由で名前を変更した人が利用できる.
* `birth_middle_name`: 彼または彼女が生まれたとき, あるいは少なくとも子供の時から持っているミドルネーム. この用語は人生の途中に何らかの理由でミドルネームを変更した人が利用できる.
* `salutation`: エンドユーザの敬称, 例えば “Mr.”
* `title`: エンドユーザの肩書, 例えば “Dr.”

## txn Claim

一般的に, 強固なidentity verificationは参加者がプロセス全体の監査証跡を保持する必要がある.

[@!RFC8417]で定義されている`txn`Claimはこの拡張のコンテキストで使用され, OpenID Connectトランザクションに関わるの関係者全体の監査証跡を構築する.

OPが`txn`を発行する場合, 対応する監査証跡を維持する必要があり(MUST), 少なくとも次の詳細で構成される.

* transaction id,
* 採用されている authentication methods, および
* transaction type (scope値など).

このトランザクションデータは, それぞれの規定による監査目的のためにトランザクションデータを保存する必要がある限り保存し続けなければならない(MUST).

RPはこのClaimを`claims`パラメータを介して, またはscope値によって識別されるデフォルトのClaimの一部として, 他のClaimと同様に要求する.

`txn`値は必要に応じてRPがこれらのトランザクションを参照できるようにしなければならない(MUST).

注：トランザクションの詳細を, OPおよび, それらのフォーマットから取得するメカニズムはこの仕様の範囲外である.
    



