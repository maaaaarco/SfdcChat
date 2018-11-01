/**
 * Created by mzeuli on 31.10.18.
 */

public class Chat_ServiceUtils implements IChat_Utils {

    public Chat_Message__c getMessageById(String id) {
        System.debug('Chat_ServiceUtils.getMessageById: start, id is: ' + id);

        return [
                SELECT
                        Id,
                        Name,
                        CreatedBy.Name,
                        CreatedDate,
                        Message__c
                FROM Chat_Message__c
                WHERE Id = :id
        ];
    }

    public List<Chat_Message__c> getMessages(String roomId, Integer limitSize, Integer offset) {
        System.debug('Chat_ServiceUtils.getMessages: start, room id is: ' + roomId + ', offset is: ' + offset);

        return [
                SELECT
                        Id,
                        Name,
                        CreatedBy.Name,
                        CreatedDate,
                        Message__c
                FROM Chat_Message__c
                WHERE Chat_Room__c = :roomId
                ORDER BY CreatedDate DESC
                LIMIT :limitSize
                OFFSET :offset
        ];
    }

    public Chat_Room__c getOrCreateChatRoomPerRecordId(String recordId) {
        System.debug('Chat_ServiceUtils.getOrCreateChatRoomPerRecordId: start, recordId is: ' + recordId);

        List<Chat_Room__c> rooms = [
                SELECT Id
                FROM Chat_Room__c
                WHERE sObject_Id__c = :recordId
                LIMIT 1
        ];

        System.debug('Chat_ServiceUtils.getOrCreateChatRoomPerRecordId: rooms size is: ' + rooms.size());

        // checks if room already exists
        if (!rooms.isEmpty()) {
            return rooms[0];
        }

        // creates a new room
        Chat_Room__c newRoom = new Chat_Room__c(
                sObject_Id__c = recordId
        );

        System.debug('Chat_ServiceUtils.getOrCreateChatRoomPerRecordId: creating new room');

        insert newRoom;

        System.debug('Chat_ServiceUtils.getOrCreateChatRoomPerRecordId: done');

        return newRoom;
    }

    public void saveNewMessage(String text, String roomId) {
        System.debug('Chat_ServiceUtils.saveNewMessage: start, message is: ' + text + ', room id is: ' + roomId);

        insert new Chat_Message__c(Message__c = text, Chat_Room__c = roomId);

        System.debug('Chat_ServiceUtils.saveNewMessage: done');
    }

    public void refreshUserPresence(String roomId) {
        System.debug('Chat_ServiceUtils.refreshUserPresence: start, roomId is: ' + roomId);

        List<Chat_User_Presence__c> presence = [
                SELECT
                        Id,
                        Last_time_seen__c
                FROM Chat_User_Presence__c
                WHERE Chat_Room__c = :roomId
                AND CreatedById = :UserInfo.getUserId()
                ORDER BY Last_time_seen__c DESC
                LIMIT 1
        ];

        System.debug('Chat_ServiceUtils.refreshUserPresence: presence size is: ' + presence.size());

        if (presence.isEmpty()) {
            // creates new user presence
            presence.add(new Chat_User_Presence__c(
                    Chat_Room__c = roomId
            ));
        }

        presence[0].Last_time_seen__c = System.now().getTime();

        System.debug('Chat_CtrUsersPresence.updateLastTimeSeen: upserting presence...');

        upsert presence;

        System.debug('Chat_ServiceUtils.refreshUserPresence: done');
    }

    public List<Chat_User_Presence__c> getUsersPresenceByChatRoomId(String roomId) {
        Long lastTenSeconds = System.now().getTime() - 10000;

        return [
                SELECT
                        Id,
                        CreatedBy.Name
                FROM Chat_User_Presence__c
                WHERE Chat_Room__c = :roomId
                AND Last_time_seen__c >= :lastTenSeconds
                AND CreatedById != :UserInfo.getUserId()
                ORDER BY CreatedBy.Name ASC
        ];
    }
}