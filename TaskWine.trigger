trigger TaskWine on Contact (before update) {

	for(Contact myContact : Trigger.new) {

		List<Task> newAddresses = new List<Task>();

		if(myContact.MailingStreet != null && (myContact.MailingStreet != Trigger.oldMap.get(myContact.Id).MailingStreet)) {
			//add to newAddress
			Task sendWine = new Task();
			String subject = 'Send Wine to new mailing address for ' + myContact.FirstName + ' ' + myContact.LastName;
			sendWine.Subject = subject;
			sendWine.Description = myContact.MailingStreet + '\n'
									+ myContact.MailingCity + ' '
									+ myContact.MailingState + ' '
									+ myContact.MailingPostalCode;
			newAddresses.add(sendWine);
			insert newAddresses;

		}
	}

}

