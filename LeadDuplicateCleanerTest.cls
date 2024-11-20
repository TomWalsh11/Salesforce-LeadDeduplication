@IsTest
public class LeadDuplicateCleanerTest {
    @TestSetup
    static void setupTestData() {
        // Create duplicate leads based on Email, FirstName, and LastName
        List<Lead> leads = new List<Lead>();

        // These will simulate duplicates with the same Name & Email but different creation times
        leads.add(new Lead(FirstName = 'John', LastName = 'Doe', Email = 'johndoe@example.com', Company = 'Acme Inc.'));
        leads.add(new Lead(FirstName = 'John', LastName = 'Doe', Email = 'johndoe@example.com', Company = 'Acme Inc.'));
        leads.add(new Lead(FirstName = 'John', LastName = 'Doe', Email = 'johndoe@example.com', Company = 'Acme Inc.'));

        leads.add(new Lead(FirstName = 'Jane', LastName = 'Smith', Email = 'janesmith@example.com', Company = 'Beta Corp.'));
        leads.add(new Lead(FirstName = 'Jane', LastName = 'Smith', Email = 'janesmith@example.com', Company = 'Beta Corp.'));

        // Create unique leads (non-duplicates)
        leads.add(new Lead(FirstName = 'Alice', LastName = 'Unique', Email = 'aliceunique@example.com', Company = 'Gamma Ltd.'));
        leads.add(new Lead(FirstName = 'Bob', LastName = 'Unique', Email = 'bobunique@example.com', Company = 'Delta Inc.'));

        // Insert leads to make them available for the test
        insert leads;
    }

    @IsTest
    static void testCleanUpDuplicateLeads() {
        // Verify initial lead count is as expected
        Integer initialLeadCount = [SELECT COUNT() FROM Lead];
        System.assertEquals(7, initialLeadCount, 'Expected 7 leads to be inserted initially');

        // Call the method to clean up duplicates
        Test.startTest();
        LeadDuplicateCleaner.cleanUpDuplicateLeads();
        Test.stopTest();

        // Query remaining leads
        List<Lead> remainingLeads = [SELECT FirstName, LastName, Email, Company FROM Lead ORDER BY CreatedDate ASC];
        System.assertEquals(4, remainingLeads.size(), 'Expected 4 leads remaining after cleanup');

        // Verify the remaining leads include only the oldest of duplicates and all unique leads
        Set<String> expectedRemainingLeads = new Set<String>{
            'John Doe|johndoe@example.com',
            'Jane Smith|janesmith@example.com',
            'Alice Unique|aliceunique@example.com',
            'Bob Unique|bobunique@example.com'
        };

        for (Lead lead : remainingLeads) {
            String leadKey = lead.FirstName + ' ' + lead.LastName + '|' + lead.Email;
            System.assert(expectedRemainingLeads.contains(leadKey), 'Unexpected lead found in remaining leads');
        }
    }

    @IsTest
    static void testExecuteMethod() {
        // Manually invoke the execute method to simulate the scheduler running
        Test.startTest();
        LeadDuplicateCleaner cleaner = new LeadDuplicateCleaner();
        cleaner.execute(null); // Simulating the schedulable execution
        Test.stopTest();

        // Verify the leads were cleaned up (i.e., only 4 leads should remain)
        List<Lead> remainingLeads = [SELECT FirstName, LastName, Email FROM Lead];
        System.assertEquals(4, remainingLeads.size(), 'Expected 4 leads remaining after cleanup from execute method');
    }
}
