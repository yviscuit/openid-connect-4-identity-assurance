# Requesting Verified Claims

## Requesting End-User Claims {#req_claims}

Verified Claims は OpenID Connect specification [@!OpenID] の Section 5.5. に定義されている `claims` parameter を利用することで, End-User について 個々の Claims のレベルで要求できる.

`verified_claims` は `claims` パラメーターの `userinfo` か `id_token` 要素に追加される.

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

`claims` パラメータを使用すると, RP はユースケースに必要な End-User に関する Claims を正確に選択できる. したがって, この拡張は RPs はデータ最小化の要件を満たすことができる.

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

この仕様では, RP が要求する特定の End-User Claim の移転の目的を説明できるようにするために, 追加のフィールド `purpose` を導入する.
`purpose` フィールドは, 個々に要求された各 Claim のメンバー値にすることができるが, Claim には複数の関連する目的を含めることはできない.

`purpose` OPTIONAL. OP から特定の End-User Claim を取得する目的を説明する文字列. `purpose` は 3 文字未満か 300 文字以上となってはならない (MUST NOT).
もしこのルールに違反した場合, authentication request は失敗し, OP は `invalid_request` エラーを RP にに返さなければならない (MUST).
OP は移転されるデータの指定された利用か承認される許可についてユーザーに通知するために, それぞれのユーザーの同意画面にこの `purpose` を表示しなければならない (MUST).
`purpose` パラメーターがリクエストに存在しない場合, OP はRPごとに事前設定された値を表示できる (MAY).
UI ローカリゼーションの詳細については, (#purpose) 参照.

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

注: `claims` サブ要素は省略でき, これは, 値が `null` である `claims` 要素と同等である.

注: `claims` サブ要素が空か, (#claimselement) に定義されている要件を満たなさい Claims を含む場合, OP は `invalid_request` エラーでトランザクションを中断するだろう.

## Requesting Verification Data {#req_verification}

`verification` 要素内容は, 基本的にそれぞれの `trust_framework` と Claim source のポリシーによって決定される.

この仕様は RP が特定のデータを `verification` 要素に明示的に要求する方法も定義する. 構文は (#req_claims) で指定されたルールに基づいており, `verification` 要素の構造へのナビゲーションのためにそれらを拡張する.

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

これは, 発行されたアサーションに検証の日付と利用可能な証拠が存在することを要求する.

注: `verified_claims` Claim の必須要素であるため, RP は明示的に` trust_framework` フィールドを要求する必要はない.

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

この例では, 特定のユーザーアカウントで利用可能なすべての証拠について, `method` 要素と `document` 要素を要求する.

注: `evidence` エントリの必須要素であるため, RP は明示的に `type` フィールドを要求する必要はない.

RPは, `document` 要素内に特定のデータが存在することを要求する場合もある. これも, 上記で使用した構文規則に従う.

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

注: `document` エントリの必須要素であるため, RP は明示的に `type` フィールドを要求する必要はない.

RP に要求された検証データを提供するか決定するのは, Claim source の裁量である.

## Defining constraints on Verification Data {#constraintedclaims}

RP は `verification` サブ要素の要素に関する要件を表現できる (MAY).

ここでも再び, `verified_claims` claim のネストされた性質によって, OpenID Connect specification [@!OpenID] の Section 5.5. で定義されている構文の拡張が必要である.

OpenID Connect specification [@!OpenID] の Section 5.5.1 は, Claim の 追加情報/制約を持つ JSON object を要求するような Claim のメンバー値であることを許す構文を定義する.
そのために, 特別なクエリの意味を持つ3つのメンバー (`essential`, ` value`, および `values`) を定義し, 他の特別なメンバーを定義できるようにする (理解されていないメンバーは無視しなければならない).

この仕様はそのメカニズムを再利用し, 新しいそのような `max_age` メンバーを導入する (下記参照).

まず, `value` か `values` フィールドを利用して, `trust_framework`, `evidence/type`, `evidence/method`, 及び `evidence/document/type` の利用可能な値を制限することができる (MAY).

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

RP は, 検証データの経過時間, すなわち `verification` 要素で主張された検証プロセスが実行されてからの経過時間に関する要件も表現できる (MAY).

したがって, この仕様では新しいメンバー `max_age` を定義している.

`max_age`: OPTIONAL. 日付またはタイムスタンプを含む Claims にのみ適用可能な JSON 数値. 日付/タイムスタンプの値からリクエストの時点までの経過を許可する最大時間 (秒) を定義する. OP は, 日付値の最後の有効な秒から開始した経過時間の計算を行わなければならない. 以下は, データの検証プロセスが 63113852 秒以前であることを認めない Claims のリクエストの例である.

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

OP はこの要件を満たそうとしなければならない (SHOULD). ユーザーの確認データがリクエストされた `max_age` よりも古い場合, OP はユーザーにオンラインID確認プロセスを介して, ユーザーの確認を更新しようとするかもしれない (MAY). 例えば 電子IDカードまたはビデオ識別アプローチを利用することによって.

OP が要件を満たすことができない場合 (`essential` とマークされている場合でも), RP に利用可能なデータを提供し, RP はデータの使用方法を決定できる. OP は, 必須 Claims として要求されたすべての Claims を返すことができない場合にエラーを返してはならない (MUST NOT).

