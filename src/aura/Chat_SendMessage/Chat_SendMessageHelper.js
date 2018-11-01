/**
 * Created by mzeuli on 27.10.18.
 */
({
    /**
     * Send message to chat room
     * @param component
     * @param message
     */
    sendMessage: function(component, message) {
        const action = component.get("c.insertNewMessage");

        action.setParams({
            text: message,
            roomId: component.get("v.roomId")
        });

        action.setCallback(this, function (response) {
            const state = response.getState();

            if (state !== "SUCCESS") {
                console.log("Chat_SendMessageHelper.sendMessage: error while sending message, state is: ", state);
                this.fireAlert("Message was not sent, please try again", "warning");
                return;
            }

            if (!response.getReturnValue()) {
                console.log("Chat_SendMessageHelper.sendMessage: message not saved");
                this.fireAlert("Message was not saved, please try again", "warning");
            }
        });

        $A.enqueueAction(action);
    },

    fireAlert: function (message, type) {
        const evt = $A.get("e.c:AlertEvent");
        evt.setParams({
            message: message,
            alertType: type
        });
        evt.fire();
    }
})