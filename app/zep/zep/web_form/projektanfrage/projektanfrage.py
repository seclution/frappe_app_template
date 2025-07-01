# Placeholder web form module for Projektanfrage

import frappe


def get_context(context):
    """Return context for the projektanfrage web form."""
    context.update({
        "message": "Hello from Projektanfrage web form"
    })
    return context
