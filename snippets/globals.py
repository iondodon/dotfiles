from datetime import datetime, timezone

def get_current_datetime_iso8601_utc():
	return datetime.now(timezone.utc).isoformat()
 

globals = {
    "name": "Mike Barkmin",
    "get_current_datetime_iso8601_utc": get_current_datetime_iso8601_utc
}
