/**
 * Created by mzeuli on 25.10.18.
 */

public with sharing class CtrStreamer {

    /**
     * Returns user session id to be used as api token
     *
     * @return
     */
    @AuraEnabled
    public static String getUserSessionId() {
        return UserInfo.getSessionId();
    }
}