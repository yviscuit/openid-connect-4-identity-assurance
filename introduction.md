# Introduction {#Introduction}

<!-- This specification defines an extension to OpenID Connect [@!OpenID] to address the use case of strong identity verification of a natural person in accordance with certain laws. Examples include Anti Money Laundering Laws, Telecommunication Acts, Anti Terror Laws, and regulations on trust services, such as eIDAS [@?eIDAS]. -->
この仕様では, OpenID Connect [@!OpenID] の拡張機能を定義して, 特定の法律に従って自然人の強力な identity verification のユースケースに対処している. 例には, マネーロンダリング防止法, 電気通信法, テロ対策法, eIDAS [@?eIDAS] などの信託サービスに関する規制が含まれる.

<!-- In such use cases, the Relying Parties (RPs) need to know the assurance level of the Claims about the End-User attested by the OpenID Connect Providers (OPs) or any other trusted source along with evidence related to the identity verification process. -->
そのようなユースケースでは, 依拠当事者 (RPs) は, OpenID Connect プロバイダー (OPs) またはその他の信頼できるソースによって証明されたエンドユーザーに関す るClaim の保証レベルと, identity verification プロセスに関連するエビデンスを知る必要がある.

<!-- The `acr` Claim, as defined in Section 2 of the OpenID Connect specification [@!OpenID], is suited to attest information about the authentication performed in a OpenID Connect transaction. But identity assurance requires a different representation for the following reason: authentication is an aspect of an OpenID Connect transaction while identity assurance is a property of a certain Claim or a group of Claims and several of them will typically be conveyed to the RP as the result of an OpenID Connect transaction. -->
OpenID Connect 仕様 [@!OpenID] のセクション2で定義されている `acr` Claim は, OpenID Connect トランザクションで実行される認証に関する情報を証明するのに適してる. ただし, identity assurance には次の理由で異なる表現が必要である: 認証は OpenID Connect トランザクションの側面であり, identity assurance は特定の Claim または Claim のグループのプロパティであり, それらのいくつかは通常, OpenID Connect トランザクションの結果として RP に伝えられる.

<!-- For example, the assurance an OP typically will be able to attest for an e-mail address will be “self-asserted” or “verified by opt-in or similar mechanism”. The family name of a user, in contrast, might have been verified in accordance with the respective Anti Money Laundering Law by showing an ID Card to a trained employee of the OP operator. -->
たとえば, 通常, OP が電子メールアドレスを証明できるという保証は「自己表明」または「オプトインまたは同様のメカニズムによって検証」される. 対照的にユーザーの姓は, OP オペレーターの訓練を受けた従業員に ID カードを提示することにより, それぞれのアンチマネーロンダリング法に従って検証された可能性がある.

<!-- Identity assurance therefore requires a way to convey assurance data along with and coupled to the respective Claims about the End-User. This specification proposes a suitable representation and mechanisms the RP will utilize to request verified claims about an End-User along with identity assurance data and for the OP to represent these verified Claims and accompanying identity assurance data. -->
したがって, identity assurance には, エンドユーザーに関する各 Claim とともに保証データを伝達する方法が必要である. この仕様は, RP がエンドユーザーに関する検証済み Claim を identity assurance データとともに要求し, OP がこれらの検証済み Claim と付随する identity assurance データを表すために利用する適切な表現とメカニズムを提案する.

## Terminology 

<!-- This section defines some terms relevant to the topic covered in this documents, heavily inspired by NIST SP 800-63A [@?NIST-SP-800-63a]. -->
このセクションでは, NIST SP 800-63A [@?NIST-SP-800-63a] に大きな影響を受けた, このドキュメントで扱われているトピックに関連するいくつかの用語を定義する.

<!-- * Identity Proofing - process in which a user provides evidence to an OP or claim provider reliably identifying themselves, thereby allowing the OP to assert that identification at a useful identity assurance level. -->
* Identity Proofing - ユーザーが OP または自分自身を確実に識別する Claim プロバイダーにエビデンスを提供することにより, OP が有用な identity assurance レベルで識別できるようにするプロセス.

<!-- * Identify Verification - process conducted by the OP or a claim provider to verify the user's identity. -->
* Identify Verification - ユーザーの身元を確認するために OP または Claim プロバイダーによって実行されるプロセス.

<!-- * Identity Assurance - process in which the OP or a claim provider attests identity data of a certain user with a certain assurance towards a RP, typically expressed by way of an assurance level. Depending on legal requirements, the OP may also be required to provide evidence of the identity verification process to the RP. -->
* Identity Assurance - OP または Claim プロバイダーが, RP に対してある一定の確からしさをもって特定のユーザーの Identity データを証明するプロセス.  通常は identity assurance レベルで表される. 法的要件に応じて, OP は identity verification プロセスのエビデンスを RP に提供する必要がある場合もある.

<!-- * Verified Claims - Claims about an End-User, typically a natural person, whose binding to a particular user account were verified in the course of an identity verification process. -->
* Verified Claims - 特定のユーザーアカウントへのバインドが identity verification プロセスの過程で検証されたエンドユーザー (通常は自然人) に関する Claim.

[1]: https://pages.nist.gov/800-63-3/sp800-63a.html "NIST Special Publication 800-63A, Digital Identity Guidelines, Enrollment and Identity Proofing Requirements"


    
