/**
 * Created by mzeuli on 01.11.18.
 */

@IsTest
private class TEST_Chat_CtrListMessages {

    @IsTest static void getMessageByIdReturnsNullIfIdIsBlank() {
        Chat_Message__c res;

        Test.startTest();

        res = Chat_CtrListMessages.getMessageById('');

        Test.stopTest();

        System.assertEquals(null, res);
    }

    @IsTest static void getMessageByIdCallsCorrectServiceMethod() {
        Boolean called = false;
        Chat_Message__c msg;

        Test.startTest();
        DummyChatService stub = new DummyChatService();

        Chat_CtrListMessages.chatService = stub;

        msg = Chat_CtrListMessages.getMessageById('a non blank id');

        called = stub.getMessageByIdCalled;

        Test.stopTest();

        System.assert(called);
        System.assertNotEquals(null, msg);
    }

    @IsTest static void getMessagesReturnsEmptyListIfRoomIdIsBlank() {
        List<Chat_Message__c> res;

        Test.startTest();

        res = Chat_CtrListMessages.getMessages('', 1, 0);

        Test.stopTest();

        System.assertNotEquals(null, res);
        System.assert(res.isEmpty());
    }

    @IsTest static void getMessagesCallsCorrectServiceMethod() {
        Boolean called = false;

        Test.startTest();
        DummyChatService stub = new DummyChatService();

        Chat_CtrListMessages.chatService = stub;

        Chat_CtrListMessages.getMessages('a non blank id', 1, 0);

        called = stub.getMessagesCalled;

        Test.stopTest();

        System.assert(called);
    }

    public class DummyChatService implements IChat_Utils {

        public Boolean getMessagesCalled { get; private set; }
        public Boolean getMessageByIdCalled { get; private set; }

        public Chat_Message__c getMessageById(String id) {
            getMessageByIdCalled = true;
            return new Chat_Message__c();
        }

        public List<Chat_Message__c> getMessages(String roomId, Integer limitSize, Integer offset) {
            getMessagesCalled = true;
            return null;
        }

        public Chat_Room__c getOrCreateChatRoomPerRecordId(String recordId) {
            return null;
        }

        public void saveNewMessage(String text, String roomId) {
        }

        public void refreshUserPresence(String roomId) {
        }

        public List<Chat_User_Presence__c> getUsersPresenceByChatRoomId(String roomId) {
            return null;
        }

    }

}