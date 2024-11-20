public class LeadDuplicateCleaner implements Schedulable {
    
    public static void cleanUpDuplicateLeads() {
        Map<String, List<Lead>> leadGroups = new Map<String, List<Lead>>();
        List<Lead> allLeads = [SELECT Id, Name, Email, CreatedDate FROM Lead WHERE CreatedDate = LAST_N_DAYS:10];

        for (Lead lead : allLeads) {
            String key = lead.Name + '|' + lead.Email;
            if (!leadGroups.containsKey(key)) {
                leadGroups.put(key, new List<Lead>());
            }
            leadGroups.get(key).add(lead);
        }

        List<Lead> leadsToDelete = new List<Lead>();

        for (String key : leadGroups.keySet()) {
            List<Lead> duplicates = leadGroups.get(key);
            if (duplicates.size() > 1) {
                // Sort duplicates by CreatedDate, oldest first using CreatedDateComparator
                duplicates.sort(new CreatedDateComparator());

                // Keep the oldest one, add others to delete list
                for (Integer i = 1; i < duplicates.size(); i++) {
                    leadsToDelete.add(duplicates[i]);
                }
            }
        }

        if (!leadsToDelete.isEmpty()) {
            delete leadsToDelete;
        }
    }

    public void execute(SchedulableContext sc) {
        cleanUpDuplicateLeads();
    }

    // Comparator class to sort leads by CreatedDate
    public class CreatedDateComparator implements Comparator<Lead> {
        public Integer compare(Lead a, Lead b) {
            if (a.CreatedDate == b.CreatedDate) return 0;
            return a.CreatedDate < b.CreatedDate ? -1 : 1;
        }
    }
}