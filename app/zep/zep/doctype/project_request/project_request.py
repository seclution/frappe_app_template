import frappe
from frappe.model.document import Document

class ProjectRequest(Document):
    pass

@frappe.whitelist()
def create_customer(docname):
    doc = frappe.get_doc('Project Request', docname)
    if doc.customer:
        return doc.customer

    customer = frappe.get_doc({
        'doctype': 'Customer',
        'customer_name': doc.contact_name or doc.project_name
    })
    customer.insert(ignore_permissions=True)
    doc.customer = customer.name
    doc.save(ignore_permissions=True)
    return customer.name
