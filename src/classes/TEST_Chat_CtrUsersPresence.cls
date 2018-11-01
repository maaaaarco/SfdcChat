/**
 * Created by mzeuli on 01.11.18.
 */

@IsTest
private class TEST_Chat_CtrUsersPresence {
    @IsTest
    static void updateLastTimeSeenReturnsCorrectlyIfRoomIdIsBlank() {

        Test.startTest();

        Chat_CtrUsersPresence.updateLastTimeSeen('');

        Test.stopTest();
    }

    @IsTest static void updateLastTimeSeenCallsCorrectServiceMethod() {
        Boolean called;

        Test.startTest();

        DummyChatService stub = new DummyChatService();
        Chat_CtrUsersPresence.chatService = stub;
        Chat_CtrUsersPresence.updateLastTimeSeen('a room id');

        called = stub.refreshUserPresenceCalled;

        Test.stopTest();

        System.assert(called);
    }

    @IsTest static void getUsersPresencePerChatRoomReturnsEmptyLitIfRoomIdIsBlank() {
        List<Chat_User_Presence__c> res;

        Test.startTest();

        res = Chat_CtrUsersPresence.getUsersPresencePerChatRoom('');

        Test.stopTest();

        System.assertNotEquals(null, res);
        System.assert(res.isEmpty());
    }

    @IsTest static void getUsersPresencePerChatRoomCallsCorrectServiceMethod() {
        List<Chat_User_Presence__c> res;
        Boolean called;

        Test.startTest();

        DummyChatService stub = new DummyChatService();

        Chat_CtrUsersPresence.chatService = stub;

        res = Chat_CtrUsersPresence.getUsersPresencePerChatRoom('a non blank id');

        called = stub.getUsersPresenceByChatRoomIdCalled;

        Test.stopTest();

        System.assert(called);
        System.assertNotEquals(null, res);
    }

    public class DummyChatService implements IChat_Utils {

        public Boolean refreshUserPresenceCalled { get; private set; }
        public Boolean getUsersPresenceByChatRoomIdCalled { get; private set; }

        public Chat_Message__c getMessageById(String id) {
            return null;
        }

        public List<Chat_Message__c> getMessages(String roomId, Integer limitSize, Integer offset) {
            return null;
        }

        public Chat_Room__c getOrCreateChatRoomPerRecordId(String recordId) {
            return null;
        }

        public void saveNewMessage(String text, String roomId) {
        }

        public void refreshUserPresence(String roomId) {
            refreshUserPresenceCalled = true;
        }

        public List<Chat_User_Presence__c> getUsersPresenceByChatRoomId(String roomId) {
            getUsersPresenceByChatRoomIdCalled = true;
            return new List<Chat_User_Presence__c>();
        }

    }
}