/**
 * Created by mzeuli on 25.10.18.
 */
({
    /**
     * Connects to Streaming API
     * @param component
     * @param event
     * @param helper
     */
    initCometD: function(component, event, helper) {
        helper.getSessionIdAndStartCometD(component);
    },
    
    doDestroy: function (component, event, helper) {
        // unsubscribe whatever kind of connection was created
        helper.cometDUnsubscribe(component);
    }
})