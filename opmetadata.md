# OP Metadata {#opmetadata}

OP は 以下の新しい属性を利用して openid-configuration (see [@!OpenID-Discovery]) で verified Claims に関する機能を通知します。

`verified_claims_supported`: `verified_claims` をサポートするか, つまり OpenID Connect for Identity Assuarance extension のサポートを示す Boolean 値.

`trust_frameworks_supported` サポートする全ての trust frameworks を含む JSON 配列.

`evidence_supported` OP が利用する全ての identity evicence の種類を含む JSON 配列.

`id_documents_supported` OP が identity verification に利用しているすべての identity documents を含む JSON 配列.

`id_documents_verification_methods_supported` (#verification) に定義される OP がサポートする id document verification method を含む JSON配列.

`claims_in_verified_claims_supported` `verified_claims` 内でサポートされる全ての claims を含む JSON 配列

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

OP は `claims` パラメーターをサポートし、`claims_parameter_supported` 要素を利用して openid-configuration でこれを公開しなければならない (MUST).
