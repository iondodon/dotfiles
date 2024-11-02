from datetime import datetime, timezone
import uuid

def get_current_datetime_iso8601_utc():
	return datetime.now(timezone.utc).isoformat()

def generate_uuid_v4():
    return str(uuid.uuid4())
 

globals = {
    "name": "Mike Barkmin",
    "get_current_datetime_iso8601_utc": get_current_datetime_iso8601_utc,
    "generate_uuid_v4": generate_uuid_v4
}
