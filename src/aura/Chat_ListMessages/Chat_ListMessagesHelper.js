/**
 * Created by mzeuli on 24.10.18.
 */
({
    /**
     * Returns jump to bottom button's container
     * @param component
     * @returns Button's container
     */
    getJumpToBottomComponent: function(component) {
        return component.find("jumpToBottomBtn");
    },

    /**
     * Returns messages container component
     * @param component Current component
     * @returns Messages' container component
     */
    getMessagesContainerComponent: function (component) {
        return component.find("messagesContainer");
    },

    /**
     * Returns chat scrollable component
     * @param component Current component
     * @returns Chat's scrollable component
     */
    getChatScrollerComponent: function (component) {
        return component.find("chatScroller");
    },

    /**
     * When a new message event is captured, through Streaming API, this method loads the actual message's text.
     * This is because the Message__c field on Chat_Message__c object can't be included in PushTopic since
     * it's a Large Text Area
     * @param component Current component
     * @param message New Chat_Message__c record
     * @param event Newly created message record. Does not include Message__c field
     */
    loadMessage: function (component, message) {

        // checks that message belongs to this chat room
        if (message.Chat_Room__c !== component.get("v.roomId")) return;

        const action = component.get("c.getMessageById");

        action.setParams({
            id: message.Id
        });

        action.setCallback(this, function (response) {
            const state = response.getState();

            if (state !== "SUCCESS") {
                console.log("Chat_ListMessagesHelper.loadMessage: error while loading message, state is: ", state);
                this.fireAlert("Impossible to load last message received", "warning");
                return;
            }

            const newMessage = response.getReturnValue();

            const msgContainer = this.getMessagesContainerComponent(component);

            const self = this;

            // Dynamically create a new message component
            $A.createComponent("c:Chat_SingleMessage", {
                message: newMessage,
                currentUserId: component.get("v.currentUser").Id,
                displayDate: true
            }, function (newComponent, status) {

                if (status !== "SUCCESS") {
                    console.log("Chat_ListMessagesHelper.loadMessage.createComponent: error while creating new message component, status is: ", status);
                    self.fireAlert("Impossible to display new message", "warning");
                    return;
                }

                let body = msgContainer.get("v.body");

                // checks if has to hide the name and date field on previous message
                if (body.length) {
                    let prevUser = body[body.length - 1].get("v.message").CreatedById;
                    body[body.length - 1].set("v.displayDate", prevUser !== newMessage.CreatedById);
                }

                // add new message to chat's body
                body.push(newComponent);
                msgContainer.set("v.body", body);
            });

        });

        // since we are loading a new message we have to increment the offset for the loadMore feature
        component.set("v.offset", component.get("v.offset") + 1);

        $A.enqueueAction(action);
    },

    /**
     * Loads a chunk of messages based on chunkSize and offset values
     * @param component Current component
     */
    loadMessages: function (component) {
        const action = component.get("c.getMessages");

        const params = {
            size: component.get("v.chunkSize"),
            offsVal: component.get("v.offset"),
            roomId: component.get("v.roomId")
        };

        action.setParams(params);

        action.setCallback(this, function (response) {
            const state = response.getState();

            if (state !== "SUCCESS") {
                console.log("Chat_ListMessagesHelper.loadMessages: error while loading messages, state is: ", state);
                this.fireAlert("Impossible to load messages", "warning");
                return;
            }

            const currentUserId = component.get("v.currentUser").Id;
            let singleMessageComps = [];

            const messages = response.getReturnValue();

            // disable Load More link if there are no more messages to load
            component.set("v.showLoadMore", messages.length === component.get("v.chunkSize"));

            if (!messages.length) {
                return; // no message to display
            }

            // for every message create a new component's structure
            for (let i = 0; i < messages.length; i++) {

                // has to display date only if previous message is from a different user
                let displayDate = !i || messages[i - 1].CreatedById !== messages[i].CreatedById;

                singleMessageComps.push([
                    "c:Chat_SingleMessage", {
                        message: messages[i],
                        currentUserId: currentUserId,
                        displayDate: displayDate
                    }
                ]);
            }

            const msgContainer = this.getMessagesContainerComponent(component);

            const self = this;

            // create new components and update body
            $A.createComponents(singleMessageComps, function (newComponents, status) {

                if (status !== "SUCCESS") {
                    console.log("Chat_ListMessagesHelper.loadMessages.createComponents: error while creating new messages component, status is: ", status);
                    self.fireAlert("Impossible to display loaded messages", "warning");
                    return;
                }

                let body = msgContainer.get("v.body");

                for (let i = 0; i < newComponents.length; i++) {
                    body.unshift(newComponents[i]);
                }

                msgContainer.set("v.body", body);
            });
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