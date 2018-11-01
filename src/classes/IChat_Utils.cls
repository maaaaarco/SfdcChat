/**
 * Created by mzeuli on 01.11.18.
 */

public interface IChat_Utils {

    /**
     * Returns a single Chat_Message__c record. Returned record must includes these fields:
     *      Id
     *      Name,
     *      CreatedBy.Name,
     *      CreatedDate,
     *      Message__c
     *
     * @param id Record's id to load
     *
     * @return A single Chat_Message__c record
     * @throws System.QueryException if id does not exist
     */
    Chat_Message__c getMessageById(String id);

    /**
     * Returns messages related to a specific chat room as an ordered list where newer messages are a the
     * beginning.
     * Returned records should include these fields:
     *      Id
     *      Name,
     *      CreatedBy.Name,
     *      CreatedDate,
     *      Message__c
     *
     * @param roomId Chat room id
     * @param limitSize Maximum number of records to returns
     * @param offset query's offset
     *
     * @return A list of messages related to specific chat room or an empty one
     */
    List<Chat_Message__c> getMessages(String roomId, Integer limitSize, Integer offset);

    /**
     * Loads Chat_Room__c record related to specified record's id or creates a new one.
     * Returned record must includes the Id field.
     *
     * @param recordId Record's id
     *
     * @return A Chat_Room__c record
     * @throws Exception if unable to create new Chat_Room__c record
     */
    Chat_Room__c getOrCreateChatRoomPerRecordId(String recordId);

    /**
     * Inserts a new message.
     *
     * @param text Message's text
     * @param roomId Chat room id
     *
     * @throws Exception if unable to insert new message
     */
    void saveNewMessage(String text, String roomId);

    /**
     * Refresh current user's presence record related to specified chat room
     *
     * @param roomId Chat room id
     *
     * @throw Exception if unable to upsert user presence record
     */
    void refreshUserPresence(String roomId);

    /**
     * Loads users presence active records related to specified chat room.
     * A User presence record is considered active when the difference between
     * the timestamp field Last_time_seen__c and current timestamp is less than
     * 10 seconds
     *
     * Current user's presence record is excluded from return value.
     *
     * Returned records must include these fields:
     *      Id,
     *      CreatedBy.Name
     *
     * @param roomId Chat room id
     *
     * @return A list of Chat_User_Presence__c or en empty one
     */
    List<Chat_User_Presence__c> getUsersPresenceByChatRoomId(String roomId);
}