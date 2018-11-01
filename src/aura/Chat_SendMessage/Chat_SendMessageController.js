/**
 * Created by mzeuli on 27.10.18.
 */
({
    setMessage: function(component, event, helper) {
        component.set("v.message", event.target.value);
    },

    /**
     * Based on current pressed key and previous one checks if has to send message.
     * Sends message only if Enter is pressed and neither ShiftLeft nor ShiftRight were pressed before.
     *
     * In this it allows user to insert a new line using the combination Shift+Enter
     * @param component
     * @param event
     * @param helper
     */
    onKeyDown: function (component, event, helper) {
        const prev = component.get("v.previousKeyCode") || "";
        const msg = component.get("v.message") || "";

        if (event.code !== "Enter") {

            // updates previous key
            component.set("v.previousKeyCode", event.code);

        } else if (!/shift/i.test(prev) && msg) {
            // user did not press Shift before and message is not empty

            // send message
            helper.sendMessage(component, msg);

            // reset values
            component.set("v.message", "");
            component.set("v.previousKeyCode", "");
            // clear text area
            event.target.value = "";
            event.preventDefault();
        }
    }
})