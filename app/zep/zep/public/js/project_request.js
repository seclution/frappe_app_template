frappe.ui.form.on('Project Request', {
    refresh(frm) {
        if (!frm.doc.customer && !frm.is_new()) {
            frm.add_custom_button(__('Create Customer'), () => {
                frappe.call({
                    method: 'zep.zep.doctype.project_request.project_request.create_customer',
                    args: { docname: frm.doc.name },
                    callback: function(r) {
                        if (!r.exc && r.message) {
                            frm.set_value('customer', r.message);
                            frm.reload_doc();
                        }
                    }
                });
            });
        }
    }
});
