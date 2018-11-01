/**
 * Created by mzeuli on 01.11.18.
 */

@IsTest
private class TEST_CtrStreamer {
    @IsTest
    static void getUserSessionIdReturnsCorrectly() {
        String res;

        Test.startTest();

        res = CtrStreamer.getUserSessionId();

        Test.stopTest();

        System.assert(String.isNotBlank(res));
    }
}