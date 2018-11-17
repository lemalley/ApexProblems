trigger FollowUpTask on Case (before update) {

	List<Task> createFollowUp = new List<Task>();

	for (Case closeCase : Trigger.new) {

			List<Account> accOwner = [SELECT Id,
								OwnerId,
								(SELECT FirstName,
										LastName
										FROM Contacts)
								FROM Account
								WHERE Id = :closeCase.AccountId];
								System.debug('Contacts being returned ' + accOwner.get(0));
								//nested SOQL for Contact Name associated closeCase

			if (closeCase.Status == 'Closed') {
				 Task followUp = new Task();
				 followUp.OwnerId = accOwner.get(0).OwnerId;
				 followUp.Subject = 'Case Closed: follow up with Account';
				 followUp.WhatId = accOwner.get(0).Id;
				 
				 if (closeCase.ContactId != null) {
				 	Account var = accOwner.get(0);
				 	String contactFirstName = var.Contacts.get(0).FirstName;
				 	String contactLastName = var.Contacts.get(0).LastName;
				 	followUp.Description = 'Please update ' + contactFirstName + ' ' + contactLastName + ' (' + closeCase.ContactId + ') as well.';
				 }

				 createFollowUp.add(followUp);
			}
	}

	insert createFollowUp;

}

// If a case is closed, 
// 	create a task 
// 	for the related account owner 
//	telling them to follow up with the account. 
//		If there was a contact related to the case, 
//			include the name and contact information in the task.