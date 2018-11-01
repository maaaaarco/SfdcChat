/**
 * Created by mzeuli on 27.10.18.
 */

public with sharing class Chat_CtrSendMessage {

    @TestVisible
    static IChat_Utils chatService = new Chat_ServiceUtils();

    /**
     * Insert a new message. If relatedTo is not null message's type will be set to
     * Record otherwise to Public
     *
     * @param text Message's text
     * @param roomId Chat room record's id
     *
     * @return True if message was saved correctly, false otherwise
     */
    @AuraEnabled
    public static Boolean insertNewMessage(String text, String roomId) {
        System.debug('Chat_CtrSendMessage.insertNewMessage: start, message is: ' + text + ', room id is: ' + roomId);

        Boolean res = true;

        if (String.isBlank(text) || String.isBlank(roomId)) {
            return false;
        }

        try {
            chatService.saveNewMessage(text, roomId);
        } catch (Exception e) {
            System.debug('Chat_CtrSendMessage.insertNewMessage: exception occurred, message is: ' + e.getMessage());
            res = false;
        }

        System.debug('Chat_CtrSendMessage.insertNewMessage: done');
        return res;
    }

}