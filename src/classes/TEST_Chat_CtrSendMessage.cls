/**
 * Created by mzeuli on 01.11.18.
 */

@IsTest
private class TEST_Chat_CtrSendMessage {
    @IsTest
    static void insertNewMessageReturnsFalseIfTextOrRoomIdAreBlank() {
        Boolean res;

        Test.startTest();

        res = Chat_CtrSendMessage.insertNewMessage('', 'a non blank id');
        res |= Chat_CtrSendMessage.insertNewMessage('a non blank message', '');
        res |= Chat_CtrSendMessage.insertNewMessage('', '');

        Test.stopTest();

        System.assert(!res);
    }

    @IsTest static void insertNewMessageCatchesExceptionAndReturnsFalse() {
        Boolean res;

        Test.startTest();

        DummyChatServiceThatThrowsExcept stub = new DummyChatServiceThatThrowsExcept();

        Chat_CtrSendMessage.chatService = stub;

        res = Chat_CtrSendMessage.insertNewMessage('non blank text', 'fake room id');

        Test.stopTest();

        System.assert(!res);
    }

    @IsTest static void insertNewMessageCallsCorrectServiceMethodAndReturnsTrue() {
        Boolean res, called;

        Test.startTest();

        DummyChatServiceThatInserts stub = new DummyChatServiceThatInserts();

        Chat_CtrSendMessage.chatService = stub;

        res = Chat_CtrSendMessage.insertNewMessage('non blank text', ' a room id');

        called = stub.saveNewMessageCalled;

        Test.stopTest();

        System.assert(res);
        System.assert(called);
    }

    public class DummyChatServiceThatInserts implements IChat_Utils {

        public Boolean saveNewMessageCalled {get; private set;}

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
            saveNewMessageCalled = true;
        }

        public void refreshUserPresence(String roomId) {
        }

        public List<Chat_User_Presence__c> getUsersPresenceByChatRoomId(String roomId) {
            return null;
        }

    }

    public class DummyChatServiceThatThrowsExcept implements IChat_Utils {
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
            throw new DummyException();
        }

        public void refreshUserPresence(String roomId) {
        }

        public List<Chat_User_Presence__c> getUsersPresenceByChatRoomId(String roomId) {
            return null;
        }

    }

    public class DummyException extends Exception {}
}