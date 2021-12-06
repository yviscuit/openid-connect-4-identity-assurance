from jsonschema import validate
from jsonschema import Draft7Validator
from json import loads
from pathlib import Path

REQUEST_SCHEMA = Path(__file__).parent / "../schema/verified_claims_request.json"
RESPONSE_SCHEMA = Path(__file__).parent / "../schema/verified_claims.json"


def test_request_schema(request_example):
    data = loads(request_example.read_text().replace("\n", ""))
    schema = loads(REQUEST_SCHEMA.read_text())

    assert validate(schema=schema, instance=data) is None


def test_response_schema(response_example):
    data = loads(response_example.read_text().replace("\n", ""))
    schema = loads(RESPONSE_SCHEMA.read_text())

    assert validate(schema=schema, instance=data) is None
