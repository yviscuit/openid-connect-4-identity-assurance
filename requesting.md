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

