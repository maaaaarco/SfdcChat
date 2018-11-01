/**
 * Created by mzeuli on 28.10.18.
 */
({
    doInit: function (component, event, helper) {
        const recordId = component.get("v.recordId");

        const action = component.get("c.getChatRoomId");

        action.setParams({
            recordId: recordId
        });

        // retrieves chat room id per current record
        action.setCallback(this, function (response) {
            const state = response.getState();

            if (state !== "SUCCESS") {
                console.log("Chat_RecordMainController.doInit: error while retrieving chat, state is: ", state);
                helper.fireAlert("Impossible to load chat room", "error");
                return;
            }

            component.set("v.roomId", response.getReturnValue());
        });

        $A.enqueueAction(action);
    }
})