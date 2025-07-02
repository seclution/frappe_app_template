# Project Prompts

[Doctype] Create a Customer doctype with address field.
[Website] Add a home page template for customers.
[API] Provide a REST endpoint to fetch customer data.
[Doctype,API] Add validation when a customer is created via the API.
[Website] Document the API on the website.

## File Index

`scripts/create_index.py` scans the project and groups files by extension. The default set reflects typical Frappe projects:

- `.py` – Python modules
- `.js` – client scripts
- `.html` – Jinja templates
- `.css`, `.scss` – styles
- `.json` – fixtures or configuration
- `.md` – documentation
- `.vue` – Vue components
- `.jinja` – advanced templates

Run the script to generate `file_index.json`:

```bash
python scripts/create_index.py
```

