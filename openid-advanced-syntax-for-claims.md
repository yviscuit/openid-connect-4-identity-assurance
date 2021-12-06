%%%
title = "OpenID Connect Advanced Syntax for Claims (ASC) 1.0"
abbrev = "openid-connect-4-identity-assurance-1_0"
ipr = "none"
workgroup = "eKYC-IDA"
keyword = ["openid", "identity assurance", "ekyc"]

[seriesInfo]
name = "Internet-Draft"

value = "openid-connect-advanced-syntax-for-claims-1_0-00"

status = "standard"

[[author]]
initials="D."
surname="Fett"
fullname="Daniel Fett"
organization="yes.com"
    [author.address]
    email = "mail@danielfett.de"

%%%

.# Abstract

This specification defines an extension of OpenID Connect to enable new features for requesting and receiving Claims and meta information about Claims.

{mainmatter}

# Introduction {#Introduction}
- resolves ambiguity, e.g., applying value/values to compound claims.
## Terminology
TBD
# Scope
TBD
# Selective Abort/Omit

Using Selective Abort/Omit (SAO), an RP can define the expected behavior of an OP when certain data is not available, when a user does not consent to the release of the data, or when restrictions defined on claims using `value`, `values`, or `max_age` cannot be fulfilled. 

Note: SAO is in particular useful when some of the claims (e.g., verified claims) are priced and the RP is only interested to pay for the respective claims if certain conditions are met.

This feature is fully independent from the use of `essential` as defined in Section 5.5 of [@!OpenID].

## Syntax

The RP can use the following two "case keys" on all standard OpenID Connect claims, verified claims, and verification elements:

 * `if_unavailable` describes the case that the OP does not have data about this
   claim or does not support this claim, or that the user did not consent to the release of the data. Note that the latter can only apply if the user interface of the OP allows the user to deselect single claims. If the user does not consent to the whole transaction, standard OpenID Connect logic applies. 

 * `if_different` describes the case that the restrictions on claim data expressed using
   `value`, `values`, or `max_age` cannot be fulfilled with the available data.
   Will be ignored if no restriction was defined.


For each of these two keys, one of the following expected "actions" can be defined:

 * `omit`: Omit this particular claim from the response. If an element is to be
   omitted that is required for a valid response, its parent elements MUST be
   omitted as well, recursively until the response is valid.

 * `omit_set`: Omit this particular claim and all claims for which the same
   action is set. This can be used by the RP to define a set of claims that is
   only useful when delivered in full.

 * `omit_verified_claims`: (Only applicable when used with [@ekyc].) Omit this
   particular claim and the whole `verified_claims` section. Only valid within
   the `verified_claims` section.

 * `abort`: Abort the whole transaction by returning an Authentication Error
   Response (as in Section 3.1.2.6 of [@!OpenID]) using the error code
   `access_denied` to the RP. The `error_description` SHOULD indicate which rule
   led to the abort of the transaction if and only if the action is
   `if_unavailable` or the user has consented to the release of the data (see
   (#privacy_if_no) below).

If both conditions apply (e.g., the user did not consent to the release of data
and this data does not fulfill a `value` restriction), the case `if_unavailable`
takes precedence.  Whenever an `abort` action is met, it takes precedence over
any of the other actions, i.e., the transaction is aborted in this case.

Omitting Claims can be recursive: If a Claim is omitted through `omit` or `omit_set`, or it is a Claim within `verified_claims` and `omit_verified_claims` was applied, the Claim's `if_unavailable` action is triggered as well.

The following table shows the default actions when case keys are omitted:

|                  | default | within `verified_claims/verification` of [@ekyc] |
| ---------------- | ------- | ------------------------------------------------ |
| `if_unavailable` | `omit`  | `omit`                                           |
| `if_different`   | `omit`  | `omit_verified_claims`                           |


Example:

<{{examples/request/omit_abort.json}}

This example would yield the following results (among other outcomes, always assuming that other data is available and matches the requirements):


| Condition                                                             | Result                                                                  |
| --------------------------------------------------------------------- | ----------------------------------------------------------------------- |
| `phone_number` not available                                          | Transaction is aborted.                                                 |
| `email` not available                                        | `email` is omitted.                                            |
| `email` is not `test@example.com`                            | Transaction is aborted.                                                 |
| `trust_framework` is not `de_aml` or is unavailable                   | Transaction is aborted.                                                 |
| `verification_process` is unavailable                                 | `verified_claims` is omitted → `custom_paid_claim` is omitted as well   |
| verified `address` is unavailable                                     | `verified_claims` is omitted → `custom_paid_claim` is omitted as well   |
| verified `nationalities` or verified `place_of_birth` are unavailable | `nationalities`, `place_of_birth`, and `custom_paid_claim` are omitted. |


## Error Handling

If the `claims` sub-element is empty or if an action is used that is unknown to the OP, the OP MUST abort the transaction with an `invalid_request` error. If a case key is used that is unknown to the OP, it MUST be ignored.


## Privacy {#privacy_if_no}


In the interest of data minimization, RPs SHOULD use the mechanisms shown above to limit cases in which incomplete data sets are provided by the OP that are not useful to the RP.


An RP might be able to derive information from a response even if the response is an error response or claims are omitted. For example, the following request can be used to derive whether or not the user is named `Max`:

```json
{
  "given_name": {
    "value": "Max",
    "if_different": "abort",
    "if_unavailable": "omit"
  }
}
```

When the request is aborted, the user is not called Max. In a naive implementation, the abort of the request might happen before the user has consented to the release of the data. In this case, using a series of carefully crafted requests, an RP might be able to derive substantial information about a user even if the user's name is never transferred from the OP to the RP directly. A malicious RP can use this to derive user information without the user's consent or without paying for the data.

To avoid leakage of user information through this mechanism without the user's consent, implementations MUST in general avoid evaluating `if_not_match` before a user has consented to the release of the data if privacy is a concern in the respective application. In the example above, the user would be asked to confirm the release of the given name data field before the OP aborts the transaction or omits the claim. OPs MAY make exceptions for RPs when a contractual or trust relationship with this RP was established beforehand or there are other mechanisms in place such that this kind of misuse is prevented.

OPs MUST also consider whether the (un)availability of data (`if_unavailable`) can leak data in a similar way in the respective application and, if so, apply the same restrictions. 

To the same end, and to avoid relying parties not paying for data, OPs SHOULD additionally consider rate-limiting requests and monitoring requests for anomalies (frequent dynamic changes in request structure, frequent aborts).

## Selective Abort/Omit Metadata

An OP supporting SAO shall publish the key `selective_abort_omit_supported` in its OP Metadata as follows:


```json
...
  "selective_abort_omit_supported": true,
...
```

## Compatibility Considerations

An OP not supporting SAO will ignore the additional keys as defined in Section 5.5.1 of [@!OpenID]. The RP may therefore receive data from such an OP when aborting the transaction was requested instead. RPs can avoid this by checking for SAO support at the OP before sending the request.


# Transformed Claims

Using Transformed Claims (TC), a claim value can be transformed using a limited set of functions before any further evaluation on the claim value is performed and before the claim value is returned to the RP.

Each Transformed Claim is based off exactly one Claim provided by the OP. For example, the Claim `birthdate` can be used to derive a Transformed Claim for age verification (End-User is above a certain age) by applying a suitable chain of functions.

Each function takes one input value (the original Claim's value or the output of the previous function) and produces one output value. Besides the input value, functions can only have static function arguments, typically zero or one.

## Example: Age Verification

The Claim `birthdate`, a date, can be transformed into an integer using the function `years_ago`. This function outputs the number of years between the current date and the input date, rounded down. The resulting integer can be transformed using the function `gte` with the argument `18`. This function evaluates whether the input value is greater than or equal to the given argument. Its output is either `true` or `false`. The resulting Transformed Claim, representing whether the End-User is above 18 or not, can be aliased, for example `above_18`. This Claim can be used within the OpenID Connect `claims` parameter instead of or together with the original Claim, `birthdate`.

If data for the original Claim `birthdate` is unavailable, the new Claim `above_18` shall be treated like an unavailable Claim as well.

## Defining Transformed Claims

Transformed Claims are defined by the RP in the `claims` parameter of the Authentication Request. The RP adds a new subelement `transformed_claims` within the root of the `claims` JSON structure.

`transformed_claims` is a JSON object in which each key represents a definition for a new Transformed Claim. Each definition consists of an object with the following keys:

 * `claim` defines the Claim on which the Transformed Claim is based
 * `fn` is the array of functions to apply to the base Claim, in order of application. Each function is either a string, like `year_ago` to apply the function without further arguments, or an array, like `["gte", 18]`, to apply the function with arguments.

For example, the Transformed Claim for age verification from above could be defined as follows:

```json
{
  "transformed_claims": {
    "above_18": {
      "claim": "birthdate",
      "fn": [
        "years_ago",
        [
          "gte",
          18
        ]
      ]
    }
  },
  "id_token": {
    ...
  }
}

```

Note: There can be multiple Transformed Claims defined on the same base Claim. 

TODO: Define charset for transformed claim names, shall not start with ':'. 

### Requesting Transformed Claims

To request a Transformed Claim, the RP uses the name of the Transformed Claim where it would normally use the base Claim. A colon (`:`) is prepended to avoid confusion with potentially existing normal Claims. 

Example:
```json
{
  "transformed_claims": {
    "above_18": {
      "claim": "birthdate",
      "fn": [
        "years_ago",
        [
          "gte",
          18
        ]
      ]
    }
  },
  "id_token": {
    "given_name": null,
    "family_name": null,
    ":above_18": null
  }
}

```

In some circumstances, the same Claim name can appear in different locations within the `claims` parameter with different meanings. For example, in [@ekyc], `birthdate` can also be used within `verified_claims/claims`. Therefore, the reference to the base Claim shall be evaluated relative to the location where the Transformed Claim is used. 

Example: In [@ekyc], the same `above_18` Claim defined above can be evaluated based on the 'Verified Claim' `birthdate` when used like this:

```json
{
  ...
  "id_token": {
    "verified_claims": {
      "claims": {
        "given_name": null,
        "family_name": null,
        ":above_18": null
      },
      ...
    }
  }
}

```
It is therefore theoretically possible to use the same Transformed Claim in two
different locations in the request, yielding potentially different values.

Any option available for normal Claims can also be used with Transformed Claims. The evaluation of these options (e.g., a constraint defined using `value`) is always performed based on the transformed value.

```json
{
  ...
  "id_token": {
    "given_name": null,
    "family_name": null,
    ":above_18": {
      "value": true,
      "essential": true
    }
  }
}
```

There is no requirement to use all defined Transformed Claims within a request.

## Data Types 
Claims defined in [@!OpenID] and [@ekyc] have one of the data types 'string', 'boolean', 'number', 'JSON object' or 'array'. For the purpose of this specification, these data types are used as well as the new data type 'date', which applies to Claims representing dates, and 'datetime', which applies to Claims representing date and time. Therefore, `birthdate` is both of type `string` and `date`, and `updated_at` is both of type `number` and `datetime`.

Todo: Define input formats for date and datetime.

## Transformation Functions

In the following, a base set of transformation functions is defined. OPs supporting Transformed Claims shall support at least one transformation function.

In the following, the first function argument `Input` refers to the value of the
base Claim, or, if multiple functions are to be applied, the output of the
previous function. For other arguments, the RP defines a constant value in each
request. Optional arguments may be omitted.

This specification defines the following functions:

### Counting Years

Function signature: `years_ago(date|datetime Input, optional date ReferenceDate) → number`

If only an input date or datetime is provided, returns the number of years elapsed since the given `Input` day, rounded down. With a `ReferenceDate`, returns the number of years elapsed between the `Input` date and the `ReferenceDate`. 

Note: If the year of the `Input` date is `0000`, the resulting Claim shall be unavailable.

Note: When applied to an array of valid input values, returns an array with the function applied to each input value in order. 

### Equality
Function signatures:
 * `eq(string Input, string Compare) → boolean`
 * `eq(number Input, number Compare) → boolean`
 * `eq(boolean Input, boolean Compare) → boolean`
 * `eq(date|datetime Input, date|datetime Compare) → boolean`

Return `true` if and only if `Input` equals `Output`. Return `false` otherwise. For comparisons between `date` and `datetime` values, the time of day is ignored unless `Input` and `Compare` are both of type `datetime`.
### Number/Date/Datetime Comparison
Function signatures:

 * `gt(number Input, number Compare): → boolean` 
 * `gt(date|datetime Input, date|datetime Compare): → boolean` 
 * `lt(number Input, number Compare): → boolean` 
 * `lt(date|datetime Input, date|datetime Compare): → boolean` 
 * `gte(number Input, number Compare): → boolean`
 * `gte(date|datetime Input, date|datetime Compare): → boolean`
 * `lte(number Input, number Compare): → boolean`
 * `lte(date|datetime Input, date|datetime Compare): → boolean`

Evaluate whether `Input` is greather/less than (or equal to) the given
`Compare`. For comparisons between `date` and `datetime` values, the time of day
is ignored unless `Input` and `Compare` are both of type `datetime`.

Note: When applied to an array of valid input values, returns an array with the function applied to each input value in order. 

### Hashing
Function signature: `hash(string Input, string HashAlgorithm) → string`

Returns the hash of the UTF-8 representation of the input string, encoded as a
lowercase hex string. `HashAlgorithm` refers to the hash algorithm to be used,
with valid values being `sha-256` and `sha-512`.

Example: `hash('Jörg', 'sha-256')` produces the string
`8e63741c42f7c08025339f1a380d98030a698aa04f1fa3c595dcb581632af452`.

This function can be used together with the `eq` operator or a restriction
expressed using `value` or `values` to have the OP match a string against a
value without revealing the clear-text value to the OP. 

It is important to note that the privacy advantage is generally limited,
especially when the input strings can be enumerated easily, as is common for
names, numbers and date/datetime values. A malicious OP could try to calculate
the hashes of all possible clear-text values and match the hashes against the
hash provided by the RP in order to reveal the original clear-text value.

### Array Evaluation
Function signatures:
 * `any(array of booleans Input) → boolean` 
 * `all(array of booleans Input) → boolean` 
 * `none(array of booleans Input) → boolean`

Return `true` if and only if any, all, or none of the boolean values in the `Input` array are `true`. Return `false` otherwise.
### JSON Object Access

Function signature: `get(JSON object Input, string Key) → *`

From the JSON object `Input`, return the member with key `Key`. If the respective key is not available in the JSON object, the resulting Claim shall be unavailable.

### Matching 

Function signature: `match(string Input, string RegEx) → boolean`

Return `true` if and only if the `RegEx` matches the `Input` string. The match
can be at any location within `Input` unless further constrained by `RegEx`. Return `false` otherwise.

Important: OPs implementing this function shall take precautions against 'catastrophic backtracking', i.e., regular expressions that are designed to exhaust the computing power of the OP. To this end, a reasonably brief time limit on the execution time for the regular expression matching operation shall be imposed, e.g., a few milliseconds. If the execution takes longer, the resulting Claim shall be unavailable.

TODO: Define Regex dialect to use. PCRE, PCRE2?


### Extending the Transformation Functions

Extensions of this specification may define further Transformation Functions.
New Transformation Functions defined outside official standards shall use the
prefix `x-` to avoid naming collisions with standardized Transformation
Functions.

TODO: Registry? Prefixing considered harmful? 

All Transformation Functions shall follow the following conventions:

 * To avoid information leakage to the RP, a Transformation Function shall be designed such that it does not open a side-channel to other information stored at the OP. To this end, a Transformation Function shall only make use of information that is either
   * directly provided via the static function arguments,
   * can be derived from the `Input`, or 
   * is available to the RP from other sources, e.g., public information like time and date.
 * The application of Transformation Functions shall have no side effects on other Claim values.
 * Transformation Functions shall be safe to execute for the OP for all combinations of inputs and arguments, as the requests generally come from an untrusted source. This includes security against Denial-of-Service attacks.


## OP Metadata and Predefined Transformed Claims (PTC)

An OP supporting Transformed Claims shall publish the key `transformed_claims_functions_supported` containing an array of supported functions (only the function names) in its OP Metadata.

Example:

```json
...
  "transformed_claims_functions_supported": ["eq", "match", "years_ago"],
...
```

An RP can use the presence of this key to determine general support for Transformed Claims at the OP.

An OP may predefine Transformed Claims. This avoids repetitions in requests and enables RPs to use Transformed Claims without requiring specific software support.

To predefine a Transformed Claim, the OP publishes the key `transformed_claims_predefined` in its OP metadata. Its contents follow the same syntax as `transformed_claims` in the `claims` object:

```json
...
  "transformed_claims_predefined": {
    "above_18": {
      "claim": "birthdate",
      "fn": [
        "years_ago",
        [
          "gte",
          18
        ]
      ]
    }, 
    "above_21": {
      "claim": "birthdate",
      "fn": [
        "years_ago",
        [
          "gte",
          21
        ]
      ]
    }
  }
...
```

RPs may use PTCs in a request to the OP as if the respective Transformed Claims
were defined in `transformed_claims` in the request. However, two colons (`::`) are prepended to distinguish predefined from custom Transformed Claims:

```json
{
  "id_token": {
    "given_name": null,
    "family_name": null,
    "::above_18": {
      "value": true,
      "essential": true
    }
  }
}
```

An OP may further set the key `transformed_claims_restricted` to `true` to
denote that only PTCs can be used and custom Transformed Claims are not
supported. In this case, the OP shall ignore all contents of
`transformed_claims` in the `claims` request object.

Example:

```json
...
  "transformed_claims_functions_supported": ["years_ago", "gte"],
  "transformed_claims_restricted": true,
  "transformed_claims_predefined": {
    "above_18": {
      "claim": "birthdate",
      "fn": [
        "years_ago",
        [
          "gte",
          18
        ]
      ]
    }
  },
...
```

## UX and Privacy Considerations

The consent of the End-User is typically required before data can be released by the OP to the RP. An OP cannot be expected to automatically parse and understand all potential combinations of transformation functions and their arguments in order to create a detailed consent prompt for the End-User.

OPs can use a number of strategies to ensure that End-User consent is always given in a meaningful way and to provide a good user experience (UX):

 * Simple cases, for example the combination of `years_ago` and `gte(x)` applied
   to `birthdate` shown above, can be translated into a statement like "The RP
   wants to know that you are above age `x`". OPs can prepare a number of
   patterns to match against the RP's request for common use cases in their
   ecosystem.
 * Since PTCs are predefined by the OP, the OP shall be able to provide a
   meaningful consent text for all its PTCs.
 * In all other cases, the OP can ask the End-User for
   their consent to release the full information of the base Claim, e.g., to ask
   for the consent to release the birthdate instead of verification of age. This is a safe overapproximation due to the guidelines for transformation functions described above.

## Compatibility Considerations

An OP not supporting Transformed Claims will ignore the additional element in the `claims` parameter as defined in Section 5.5 of [@!OpenID]. All Transformed Claims requested by RPs are therefore unknown to the OP and treated like other unknown claims, i.e., they will typically be ignored. If Selective Abort/Omit is supported as defined below, the `if_unknown` case will be triggered.

## Examples

The following example shows two custom Transformed Claims being defined and used. Note: Features from Selective Abort/Omit defined below are used as well.


<{{asc/examples/request/asc_tc_partial_matching.json}}

# Data Availability Feedback



# Privacy Consideration {#Privacy}

TBD
# Security Considerations {#Security}
TBD

{backmatter}

<reference anchor="OpenID" target="http://openid.net/specs/openid-connect-core-1_0.html">
  <front>
    <title>OpenID Connect Core 1.0 incorporating errata set 1</title>
    <author initials="N." surname="Sakimura" fullname="Nat Sakimura">
      <organization>NRI</organization>
    </author>
    <author initials="J." surname="Bradley" fullname="John Bradley">
      <organization>Ping Identity</organization>
    </author>
    <author initials="M." surname="Jones" fullname="Mike Jones">
      <organization>Microsoft</organization>
    </author>
    <author initials="B." surname="de Medeiros" fullname="Breno de Medeiros">
      <organization>Google</organization>
    </author>
    <author initials="C." surname="Mortimore" fullname="Chuck Mortimore">
      <organization>Salesforce</organization>
    </author>
   <date day="8" month="Nov" year="2014"/>
  </front>
</reference>
# IANA Considerations

TBD

# Acknowledgements {#Acknowledgements}

TBD
# Notices

Copyright (c) 2020 The OpenID Foundation.

The OpenID Foundation (OIDF) grants to any Contributor, developer, implementer, or other interested party a non-exclusive, royalty free, worldwide copyright license to reproduce, prepare derivative works from, distribute, perform and display, this Implementers Draft or Final Specification solely for the purposes of (i) developing specifications, and (ii) implementing Implementers Drafts and Final Specifications based on such documents, provided that attribution be made to the OIDF as the source of the material, but that such attribution does not indicate an endorsement by the OIDF.

The technology described in this specification was made available from contributions from various sources, including members of the OpenID Foundation and others. Although the OpenID Foundation has taken steps to help ensure that the technology is available for distribution, it takes no position regarding the validity or scope of any intellectual property or other rights that might be claimed to pertain to the implementation or use of the technology described in this specification or the extent to which any license under such rights might or might not be available; neither does it represent that it has made any independent effort to identify any such rights. The OpenID Foundation and the contributors to this specification make no (and hereby expressly disclaim any) warranties (express, implied, or otherwise), including implied warranties of merchantability, non-infringement, fitness for a particular purpose, or title, related to this specification, and the entire risk as to implementing this specification is assumed by the implementer. The OpenID Intellectual Property Rights policy requires contributors to offer a patent promise not to assert certain patent claims against other contributors and against implementers. The OpenID Foundation invites any interested party to bring to its attention any copyrights, patents, patent applications, or other proprietary rights that may cover technology that may be required to practice this specification.

# Document History

   [[ To be removed from the final specification ]]

   -00

   *  first version

