trigger CreateCase on Account (after insert, after update) {

	List<Group> followUpQueue = [SELECT id
							FROM Group
							WHERE DeveloperName = 'Data_Quality'
							LIMIT 1];

	List<Case> accCase = new List<Case>();

	List<String> missingInfo = new List<String>();

	for (Account acc : Trigger.new) {  
		if (acc.ShippingStreet == null || acc.Phone == null || acc.NumberOfEmployees == null) {

			if (acc.ShippingStreet == null) {
				missingInfo.add('Address');
			}
			if (acc.Phone == null) {
				missingInfo.add('Phone Number');
			}
			if (acc.NumberOfEmployees == null) {
				missingInfo.add('Number of Employees');
			}

			Case newCase = new Case();
			newCase.AccountId = acc.Id;
			newCase.Subject = 'The following information was missing from a newly created Account: ' + missingInfo;
			newCase.OwnerId = followUpQueue.get(0).Id;
			accCase.add(newCase);
		}
	}

	insert accCase;

}


//If an account is saved without an address, without a phone number, 
//without an email, or without the number of employees, then create a case 
//and assign it to a queue so that someone can follow up to find out the details for the account. 