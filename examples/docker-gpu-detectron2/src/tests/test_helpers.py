from synaptiq.helpers import parse_email

def test_split_email():
    assert parse_email("test@example.com") == ("test", "example.com"), "Should be test, example.com"