/**
 * Created by mzeuli on 29.10.18.
 */

public with sharing class Chat_CtrUsersPresence {

    @TestVisible
    static IChat_Utils chatService = new Chat_ServiceUtils();

    /**
     * Updates "last time seen" timestamp of current user's presence record related to
     * specified chat room
     *
     * @param roomId Chat room id
     */
    @AuraEnabled
    public static void updateLastTimeSeen(String roomId) {
        System.debug('Chat_CtrUsersPresence.updateLastTimeSeen: start, roomId is: ' + roomId);

        if (String.isBlank(roomId)) {
            return;
        }

        chatService.refreshUserPresence(roomId);
    }

    /**
     * Retrieves users presence per specified chat room. A user is considered online if his
     * user presence record, related to specified chat room, was updated less than 10 seconds
     * ago.
     * Current user's presence record is excluded from returned list
     *
     * @param roomId Chat room's id
     *
     * @return A list of users presence records or an empty list
     */
    @AuraEnabled
    public static List<Chat_User_Presence__c> getUsersPresencePerChatRoom(String roomId) {
        System.debug('Chat_CtrUsersPresence.getUsersPresencePerChatRoom: start, roomId is: ' + roomId);

        if (String.isBlank(roomId)) {
            return new List<Chat_User_Presence__c>();
        }

        return chatService.getUsersPresenceByChatRoomId(roomId);
    }

}