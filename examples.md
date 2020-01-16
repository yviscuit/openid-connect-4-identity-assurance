# Examples

<!-- The following sections show examples of `verified_claims`. -->
以下のセクションでは `verified_claims` に関する例を示す.

<!-- The first and second section show JSON snippets of the general identity assurance case, where the RP is provided with verification evidence for different verification methods along with the actual Claims about the End-User. -->
最初と 2つ目のセクションでは, 一般的な identity assuarance のケースの JSON snippets を示し, RP には End-User に関する実際の Claims と一緒に, 様々な検証方法による verification evidence が提供される.

<!-- The third section illustrates how the contents of this object could look like in case of a notified eID system under eIDAS, where the OP does not need to provide evidence of the identity verification process to the RP. -->
3つ目のセクションでは, OP が RP に対して identity verification プロセスの evidence を提供する必要がない eIDAS 公認 eID システムの場合, どのようにこのオブジェクトのコンテンツが見えるかを説明している.

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
