import json
import sys

# Read the corrupted JSON file
with open(r'd:\projects\PlanZ\assets\translations\en.json', 'r', encoding='utf-8') as f:
    content = f.read()

# Try to load as JSON to find valid sections
# Since it's corrupted, we'll need to manually extract sections

# For now, let's create a clean structure with known sections
clean_json = {
    "onboarding": {
        "title_1": "Create Your Event in Minutes",
        "subtitle_1": "Start planning your perfect event quickly and easily.",
        "title_2": "Stay Connected",
        "subtitle_2": "Enable notifications to keep track of updates.",
        "title_3": "Your Data, Secure",
        "subtitle_3": "We protect your privacy and data securely.",
        "access": "Access",
        "invalid_code": "Invalid access code",
        "get_started": "Get Started"
    },
    "welcome": {
        "welcome_to": "Welcome to",
        "app_name": "PlanZ",
        "desc_1": "Your all-in-one event planning platform",
        "desc_2": "Everything you need for your event in one place"
    },
    "stakeholder": {
        "event_owner_title": "Event Owner",
        "event_owner_desc": "I want to plan and manage my event",
        "vendor_title": "Service Vendor",
        "vendor_desc": "I provide services and products for events",
        "attendee_title": "Attendee",
        "attendee_desc": "I was invited to an event"
    }
}

# Write to a temporary file first
with open(r'd:\projects\PlanZ\assets\translations\en_temp.json', 'w', encoding='utf-8') as f:
    json.dump(clean_json, f, ensure_ascii=False, indent=4)

print("Created temporary clean file")
