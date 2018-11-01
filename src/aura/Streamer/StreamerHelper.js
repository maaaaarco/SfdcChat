/**
 * Created by mzeuli on 25.10.18.
 */
({
    /**
     * Builds channel url according to channelName and one of these:
     *
     *  1) isPushTopic
     *  2) isPlatformEvent
     *  3) isChangeDataCapture
     *
     * evaluated in that order.
     *
     * If channelName begins with a / it assumes that contains full channel's url and
     * ignores isPushTopic, isPlatformEvent and isChangeDataCapture
     *
     * @param component
     * @returns {string}
     */
    buildChannelUrl: function (component) {
        const channel = component.get("v.channelName");
        let prefix;

        if (channel[0] === "/") {
            prefix = "";
        } else if (component.get("v.isPushTopic")) {
            prefix = "/topic/";
        } else if (component.get("v.isPlatformEvent")) {
            prefix = "/event/";
        } else if (component.get("v.isChangeDataCapture")) {
            prefix = "/data/";
        }

        return prefix + channel;
    },

    /**
     * Unsubscribe from current channel.
     * If no cometD connection was created do nothing.
     * @param component
     */
    cometDUnsubscribe: function(component) {
        const conn = component.get("v.connection");
        if (conn) {
            conn.disconnect();
        }
    },

    /**
     * Retrieves current user's session id, starts CometD connection and then subscribe to channel
     * @param component
     */
    getSessionIdAndStartCometD: function (component) {
        const action = component.get("c.getUserSessionId");
        const url = this.buildChannelUrl(component);

        action.setCallback(this, function (response) {
            const state = response.getState();

            if (state !== "SUCCESS") {
                console.log("StreamerController.getSessionIdAndStartCometD: error while retrieving user session, state is", state);
                this.fireAlert("Impossible to get session id, chat won't work", "error");
                return;
            }

            // creates CometD connection
            const conn = new StreamingApiWrapper({
                cometdURL: window.location.protocol + '//' + window.location.hostname + (null != window.location.port ? (':' + window.location.port) : '') + '/cometd/40.0/',
                token: response.getReturnValue(),
                debug: component.get("v.debugMode")
            });

            let self = this;

            conn.connect(function (err) {
                if (!err) {
                    self.fireAlert(component, "Unable to connect to streaming api, chat won't work");
                    return;
                }

                // successful connection, subscribes to channel
                conn.subscribe(url, function (message) {
                    let evt = component.getEvent("newMessage");

                    evt.setParams({
                        data: message,
                    });

                    evt.fire();
                });
            });

            // saves connection
            component.set("v.connection", conn);
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