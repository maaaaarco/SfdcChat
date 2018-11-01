/**
 * Created by mzeuli on 28.10.18.
 */

public with sharing class Chat_CtrRoom {

    /**
     * Retrieve current user recor
     *
     * @return Current user record
    */
    @AuraEnabled(Cacheable=true)
    public static User getCurrentUser() {
        return [SELECT Id, Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
    }

}