/**
 * Created by mzeuli on 01.11.18.
 */

@IsTest
private class TEST_Chat_CtrRoom {
    @IsTest
    static void getCurrentUserReturnsCurrentUserRecord() {
        User res;

        Test.startTest();

        res = Chat_CtrRoom.getCurrentUser();

        Test.stopTest();

        System.assertNotEquals(null, res);
        System.assertEquals(UserInfo.getUserId(), res.Id);
    }
}