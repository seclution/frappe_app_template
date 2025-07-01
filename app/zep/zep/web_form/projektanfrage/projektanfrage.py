import frappe

def get_context(context):
    """Context for projektanfrage web form"""
    context.no_cache = 1
    return context
