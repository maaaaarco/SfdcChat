/**
 * Created by mzeuli on 28.10.18.
 */

public with sharing class Chat_CtrRecordMain {

    @TestVisible
    static IChat_Utils chatService = new Chat_ServiceUtils();

    /**
     * Gets chat room for specified record id
     *
     * @param recordId sObject's record id
     *
     * @return Chat room id or null
     */
    @AuraEnabled
    public static String getChatRoomId(String recordId) {
        System.debug('Chat_CtrRecordMain.getChatRoomId: start, recordId is: ' + recordId);

        if (String.isBlank(recordId)) {
            return null;
        }

        Chat_Room__c room;

        try{
            room = chatService.getOrCreateChatRoomPerRecordId(recordId);
        } catch (Exception e) {
            System.debug('Chat_CtrRecordMain.getChatRoomId: exception occurred. Message is: ' + e.getMessage());
        }

        System.debug('Chat_CtrRecordMain.getChatRoomId: done');

        return room == null ? null : room.Id;
    }

}