/**
 * Created by mzeuli on 01.11.18.
 */

@IsTest
private class TEST_Chat_ServiceUtils {

    @TestSetup static void setup() {

        Account accWithChatRoom = new Account(Name = 'with room');
        insert accWithChatRoom;

        Account accWithoutChatRoom = new Account(Name = 'without room');
        insert accWithoutChatRoom;

        Chat_Room__c room = new Chat_Room__c(sObject_Id__c = accWithChatRoom.Id);
        insert room;

        Chat_Message__c msg1 = new Chat_Message__c(Chat_Room__c = room.Id, Message__c = 'a text message');
        insert msg1;
    }

    @IsTest
    static void getMessageByIdReturnsCorrectRecordWithRequiredFields() {
        Chat_Message__c msg = [SELECT Id FROM Chat_Message__c LIMIT 1];
        Chat_Message__c res;

        Test.startTest();

        res = new Chat_ServiceUtils().getMessageById(msg.Id);

        Test.stopTest();

        System.assertNotEquals(null, res);
        System.assertEquals(msg.Id, res.Id);
        System.assert(hasRequiredFields(res));
    }

    @IsTest static void getMessagesReturnsCorrectAmountOfRecords() {
        Chat_Room__c room = [SELECT Id FROM Chat_Room__c LIMIT 1];

        List<Chat_Message__c> msgs = new List<Chat_Message__c>();
        for (Integer i = 0; i < 10; i++) {
            msgs.add(new Chat_Message__c(Chat_Room__c = room.Id, Message__c = 'a message'));
        }
        insert msgs;


        List<Chat_Message__c> first, second;

        Test.startTest();

        first = new Chat_ServiceUtils().getMessages(room.Id, 5, 0);
        second = new Chat_ServiceUtils().getMessages(room.Id, 5, 5);

        Test.stopTest();

        System.assertNotEquals(null, first);
        System.assertNotEquals(null, second);

        System.assertEquals(5, first.size());
        System.assertEquals(5, second.size());

        for (Integer i = 0; i < 5; i++) {
            System.assert(hasRequiredFields(first[i]));
            System.assert(hasRequiredFields(second[i]));
        }
    }

    @IsTest static void getOrCreateChatRoomPerRecordIdReturnsExistingRoomPerRecordId() {
        Chat_Room__c room = [SELECT Id, sObject_Id__c FROM Chat_Room__c WHERE sObject_Id__c != '' LIMIT 1];
        Chat_Room__c res;

        Test.startTest();

        res = new Chat_ServiceUtils().getOrCreateChatRoomPerRecordId(room.sObject_Id__c);

        Test.stopTest();

        System.assertNotEquals(null, res);
        System.assertEquals(room.Id, res.Id);
    }

    @IsTest static void getOrCreateChatRoomPerRecordIdReturnsNewRoomPerRecordId() {
        Account acc = [SELECT Id FROM Account WHERE Name = 'without room' LIMIT 1];
        Chat_Room__c res;

        Test.startTest();

        res = new Chat_ServiceUtils().getOrCreateChatRoomPerRecordId(acc.Id);

        Test.stopTest();

        System.assertNotEquals(null, res);
        System.assertNotEquals(null, res.Id);
        System.assertEquals(acc.Id, res.sObject_Id__c);
    }

    @IsTest static void saveNewMessageCreatesNewMessage() {
        Chat_Room__c room = [SELECT Id FROM Chat_Room__c LIMIT 1];

        final String message = 'an incredible message';

        Test.startTest();

        new Chat_ServiceUtils().saveNewMessage(message, room.Id);

        Test.stopTest();

        Boolean found = false;

        for (Chat_Message__c msg : [
                SELECT Message__c
                FROM Chat_Message__c
                WHERE Chat_Room__c = :room.Id
        ]) {
            found |= msg.Message__c == message;
        }

        System.assert(found);
    }

    @IsTest static void refreshUserPresenceCreatesANewPresenceRecord() {

        Chat_Room__c room = [SELECT Id FROM Chat_Room__c LIMIT 1];

        Test.startTest();

        new Chat_ServiceUtils().refreshUserPresence(room.Id);

        Test.stopTest();

        Chat_User_Presence__c[] up = [
                SELECT Id, Last_time_seen__c
                FROM Chat_User_Presence__c
                WHERE Chat_Room__c = :room.Id AND CreatedById = :UserInfo.getUserId()
        ];

        System.assertEquals(1, up.size());
        System.assertNotEquals(null, up[0].Last_time_seen__c);
    }

    @IsTest static void refreshUserPresenceUpdatesExistingUserPresenceRecord() {
        Chat_Room__c room = [SELECT Id FROM Chat_Room__c LIMIT 1];
        final Long previousTimestamp = System.now().addMinutes(-1).getTime();
        Chat_User_Presence__c up = new Chat_User_Presence__c(Chat_Room__c = room.Id, Last_time_seen__c = previousTimestamp);
        insert up;

        Test.startTest();

        new Chat_ServiceUtils().refreshUserPresence(room.Id);

        Test.stopTest();

        Chat_User_Presence__c[] res = [
                SELECT Id, Last_time_seen__c
                FROM Chat_User_Presence__c
                WHERE Chat_Room__c = :room.Id AND CreatedById = :UserInfo.getUserId()
        ];

        System.assertEquals(1, res.size());
        System.assertEquals(up.Id, res[0].Id);
        System.assert(res[0].Last_time_seen__c > up.Last_time_seen__c);
    }

    private static Boolean hasRequiredFields(Chat_Message__c msg) {
        return String.isNotBlank(msg.Name)
                && String.isNotBlank(msg.CreatedBy.Name)
                && msg.CreatedDate != null
                && String.isNotBlank(msg.Message__c);
    }

    @IsTest static void getUsersPresenceByChatRoomIdReturnsOnlyActiveUsersPresence() {
        Chat_Room__c room = [SELECT Id FROM Chat_Room__c LIMIT 1];
        List<Chat_User_Presence__c> res = new List<Chat_User_Presence__c>();

        User current = [
                SELECT
                        CompanyName,
                        CommunityNickname,
                        Alias,
                        Email,
                        FirstName,
                        IsActive,
                        LanguageLocaleKey,
                        LastName,
                        LocaleSidKey,
                        ProfileId,
                        TimeZoneSidKey,
                        Title,
                        Username,
                        UserRoleId,
                        EmailEncodingKey
                FROM User
                WHERE Id = :UserInfo.getUserId()
        ];

        User activeChatUser = current.clone();
        activeChatUser.Username += '.active';
        activeChatUser.Alias = 'active';
        activeChatUser.CommunityNickname = 'active';

        User activeChatUser2 = current.clone();
        activeChatUser2.Username += '.active2';
        activeChatUser2.Alias = 'active2';
        activeChatUser2.CommunityNickname = 'active2';

        User inactiveChatUser = current.clone();
        inactiveChatUser.Username += '.inactive';
        inactiveChatUser.Alias = 'inactive';
        inactiveChatUser.CommunityNickname = 'inactive';

        insert new List<User>{
                activeChatUser, activeChatUser2, inactiveChatUser
        };

        System.runAs(activeChatUser) {
            insert new Chat_User_Presence__c(Chat_Room__c = room.Id,
                    Last_time_seen__c = System.now().getTime());
        }

        System.runAs(activeChatUser2) {
            insert new Chat_User_Presence__c(Chat_Room__c = room.Id,
                    Last_time_seen__c = System.now().addSeconds(-2).getTime());
        }

        System.runAs(inactiveChatUser) {
            insert new Chat_User_Presence__c(
                    Chat_Room__c = room.Id,
                    Last_time_seen__c = System.now().addSeconds(-11).getTime()
            );
        }

        insert new Chat_User_Presence__c(
                Chat_Room__c = room.Id,
                Last_time_seen__c = System.now().getTime()
        );

        Test.startTest();

        res = new Chat_ServiceUtils().getUsersPresenceByChatRoomId(room.Id);

        Test.stopTest();

        System.assertEquals(2, res.size());

        for (Chat_User_Presence__c up : res) {
            // exclude current user
            System.assertNotEquals(UserInfo.getUserId(), up.CreatedById);
            // exclude inactive user
            System.assertNotEquals(inactiveChatUser.Id, up.CreatedById);
            // check required fields
            System.assert(String.isNotBlank(up.CreatedBy.Name));
        }
    }
}