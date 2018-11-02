/**
 * Created by mzeuli on 24.10.18.
 */
({
    doInit: function (component, event, helper) {
        // initialize offset
        component.set("v.offset", 0);
        // loads first chunk
        helper.loadMessages(component);
    },

    /**
     * Called when user scrolls messages container, saves the element scrollHeight
     * and scrollTop properties
     * @param component
     * @param event
     * @param helper
     */
    onChatScroll: function (component, event, helper) {
        component.set("v.chatScrollHeight", event.target.scrollHeight);
        component.set("v.chatScrollTop", event.target.scrollTop);
    },

    /**
     * Loads message's text when a new message is captured
     * @param component
     * @param event
     * @param helper
     */
    onNewMessage: function (component, event, helper) {
        // load new message
        helper.loadMessage(component, event.getParam("data").sobject);
    },

    /**
     * Called when user clicks on Load More link, loads another chunks of messages by incrementing
     * the offset
     * @param component
     * @param event
     * @param helper
     */
    loadMore: function (component, event, helper) {
        event.preventDefault();

        // increment offset
        var offset = component.get("v.offset");
        var size = component.get("v.chunkSize");
        component.set("v.offset", offset + size);

        helper.loadMessages(component);
    },

    /**
     * Called when a new message is rendered, checks if has to automatically scroll the chat pane.
     *
     * We have three main scenarios:
     *
     *  1) Before this message was rendered, user's focus was at the bottom of chat's pane.
     *      In this case we have to automatically scroll the pane to bottom, since this message
     *      was appended to the chat's body and we want to keep user's focus on latest messages.
     *
     *  2) Before this message was rendered, user's focus was at the top of the chat's pane.
     *      This means the user scrolled all the way up to read previous messages.
     *      We have two sub-scenarios here:
     *
     *      2.1) This message is a newly created one and was appended to chat's body.
     *          In this case we do nothing, we keep user's focus on older messages.
     *
     *      2.2) This message is older than the currently displayed one. This means the user
     *           clicked on "Load More" link to load older messages.
     *           In this case this message has been prepended to chat's body, we have to scroll down
     *           to keep user's focus on latest seen message before clicking "Load More"
     *
     *  3) Before this message was rendered, user's focus was somewhere in the middle of chat's pane.
     *      In this case we do nothing.
     *
     * @param component
     * @param event
     * @param helper
     */
    onMessageRendered: function (component, event, helper) {
        // get scrollable element
        const scroller = helper.getChatScrollerComponent(component).getElement();

        const hasToScrollToBottom = (
            // first load
            !component.get("v.chatScrollHeight")
            // previous focus was at the bottom of the chat
            || component.get("v.chatScrollHeight") - component.get("v.chatScrollTop") === scroller.clientHeight
        );

        const oldestMessageNameDisplayed = component.get("v.oldestMessageName");

        const isOlderMessage = (
            !oldestMessageNameDisplayed
            || event.getParam("messageName") < oldestMessageNameDisplayed
        );

        const hasToScrollDown = (
            // user scrolled to top
            0 === component.get("v.chatScrollTop")
            // this message is older than the oldest currently displayed
            && isOlderMessage
        );

        // TODO: one day try to implement a smooth scrolling

        if (hasToScrollToBottom) {
            scroller.scrollTop = scroller.scrollHeight;
        } else if (hasToScrollDown) {
            scroller.scrollTop = scroller.scrollHeight - component.get("v.chatScrollHeight");
        }

        // updates scrollHeight and scrollTop
        component.set("v.chatScrollHeight", scroller.scrollHeight);
        component.set("v.chatScrollTop", scroller.scrollTop);

        // updates oldest message displayed
        if (isOlderMessage) {
            component.set("v.oldestMessageName", event.getParam("messageName"));
        }
    }
})