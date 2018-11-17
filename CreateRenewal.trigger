
  // Automatically create a Renewal Opp for closed won deals
trigger CreateRenewal on Opportunity (before update) {

  // Create a Map to store all renewal opps for bulk inserting
  List<Opportunity> newRenewals = new List<Opportunity>();


  for (Opportunity opp : Trigger.new) {
    // Only create renewal opps for closed won deals
    if (opp.StageName.contains('Closed')) {
       Opportunity renewal = new Opportunity();
       renewal.AccountId   = 'opp.AccountId';
       renewal.Name        = opp.Name + 'Renewal';
       renewal.CloseDate   = opp.CloseDate + 365; // Add a year
       renewal.StageName   = 'Open';
       renewal.Type      = 'Existing Customer - Renewal';
       renewal.OwnerId     = opp.OwnerId;
       newRenewals.add(renewal);
    }
  }

  // Bulk insert all renewals to avoid Governor Limits
  insert newRenewals;
}