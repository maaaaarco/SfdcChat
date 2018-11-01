/**
 * Created by mzeuli on 01.11.18.
 */

@IsTest
private class TEST_Chat_CtrRecordMain {
    @IsTest
    static void getChatRoomIdReturnsNullIfRecordIdIsBlank() {
        String res;

        Test.startTest();

        res = Chat_CtrRecordMain.getChatRoomId('');

        Test.stopTest();

        System.assertEquals(null, res);
    }

    @IsTest static void getChatRoomIdCatchesExceptionAndReturnsNull() {

        String res;

        Test.startTest();

        Chat_CtrRecordMain.chatService = new DummyChatServiceThatThrowsExcept();

        res = Chat_CtrRecordMain.getChatRoomId('wrong formatted id');

        Test.stopTest();

        System.assertEquals(null, res);
    }

    @IsTest static void getChatRoomIdCallsCorrectServiceMethodAndReturnsValidId() {
        Account acc = new Account(Name = 'a test account');
        insert acc;

        Boolean called = false;

        String chatRoomId;

        Test.startTest();

        DummyChatServiceThatInserts stub = new DummyChatServiceThatInserts();

        Chat_CtrRecordMain.chatService = stub;

        chatRoomId = Chat_CtrRecordMain.getChatRoomId(acc.Id);

        called = stub.getOrCreateChatRoomPerRecordIdCalled;

        Test.stopTest();

        System.assert(called);
        System.assert(String.isNotBlank(chatRoomId));

        Chat_Room__c[] room = [SELECT Id FROM Chat_Room__c WHERE Id = :chatRoomId];
        System.assertEquals(1, room.size());
    }

    public class DummyChatServiceThatThrowsExcept implements IChat_Utils {
        public Chat_Message__c getMessageById(String id) {
            return null;
        }

        public List<Chat_Message__c> getMessages(String roomId, Integer limitSize, Integer offset) {
            return null;
        }

        public Chat_Room__c getOrCreateChatRoomPerRecordId(String recordId) {
            throw new DummyException();
        }

        public void saveNewMessage(String text, String roomId) {
        }

        public void refreshUserPresence(String roomId) {
        }

        public List<Chat_User_Presence__c> getUsersPresenceByChatRoomId(String roomId) {
            return null;
        }
    }

    public class DummyChatServiceThatInserts implements IChat_Utils {

        public Boolean getOrCreateChatRoomPerRecordIdCalled {get; private set;}

        public Chat_Message__c getMessageById(String id) {
            return null;
        }

        public List<Chat_Message__c> getMessages(String roomId, Integer limitSize, Integer offset) {
            return null;
        }

        public Chat_Room__c getOrCreateChatRoomPerRecordId(String recordId) {
            getOrCreateChatRoomPerRecordIdCalled = true;
            Chat_Room__c room = new Chat_Room__c(sObject_Id__c = recordId);
            insert room;
            return room;
        }

        public void saveNewMessage(String text, String roomId) {
        }

        public void refreshUserPresence(String roomId) {
        }

        public List<Chat_User_Presence__c> getUsersPresenceByChatRoomId(String roomId) {
            return null;
        }
    }

    public class DummyException extends Exception {
    }
}