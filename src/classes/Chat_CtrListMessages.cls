/**
 * Created by mzeuli on 24.10.18.
 */

public with sharing class Chat_CtrListMessages {

    @TestVisible
    static IChat_Utils chatService = new Chat_ServiceUtils();

    /**
     * Load a single chat message
     *
     * @param id Chat message's id to load
     *
     * @return A single Chat Message record or null
     */
    @AuraEnabled
    public static Chat_Message__c getMessageById(String id) {
        System.debug('Chat_CtrListMessages.getMessageById: start, id is: ' + id);

        if (String.isBlank(id)) {
            return null;
        }

        return chatService.getMessageById(id);
    }

    /**
     * Loads messages related to specified chat room
     *
     * @param roomId Chat room's record id
     * @param size Number of records to retrieve
     * @param offsVal Offset to load older messages
     *
     * @return A list of messages related to specific record or an empty one
     */
    @AuraEnabled
    public static List<Chat_Message__c> getMessages(String roomId, Integer size, Integer offsVal) {
        System.debug('Chat_CtrListMessages.getMessages: start, room id is: ' + roomId + ', offset is: ' + offsVal);

        if (String.isBlank(roomId)) {
            return new List<Chat_Message__c>(); // empty list
        }

        // for whatever reason, if I do not use Integer.valueOf I'll get an exception
        return chatService.getMessages(roomId, Integer.valueOf(size), Integer.valueOf(offsVal));
    }
}