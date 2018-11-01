/**
 * Created by mzeuli on 24.10.18.
 */
({
    onRender: function (component, event, helper) {
        const evt = component.getEvent("messageRendered");
        evt.setParams({
            messageId: component.get("v.message").Id,
            messageName: component.get("v.message").Name
        });
        evt.fire();
    }
})