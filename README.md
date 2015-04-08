# Tags API

This is a simple app demonstrating the power of JSON APIs built on Rails.

## Available endpoints
`POST /tags` -- to create (or update) a record.
* Required params: `taggable_id`, `taggable_type`, `labels`.

`GET /tags/:taggable_type/:taggable_id` -- fetch a record and its tags.
* Required params: `taggable_id`, `taggable_type`.

`DELETE /tags/:taggable_type/:taggable_id` -- delete a record and its tags.
* Required params: `taggable_id`, `taggable_type`.

`GET /stats` -- fetch tag names and their counts.
