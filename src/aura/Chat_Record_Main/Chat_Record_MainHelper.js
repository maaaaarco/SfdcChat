/**
 * Created by mzeuli on 01.11.18.
 */
({
    fireAlert: function (message, type) {
        const evt = $A.get("e.c:AlertEvent");
        evt.setParams({
            message: message,
            alertType: type
        });
        evt.fire();
    }
})