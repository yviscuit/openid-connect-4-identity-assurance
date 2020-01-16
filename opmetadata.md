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
