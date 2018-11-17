trigger UpdateWorkPhone on Account (before update) {

	List<Contact> updateContacts = new List<Contact>();

	for (Account acc : Trigger.new) {

		List<Contact> AccountContacts = [SELECT Id,
									Phone
									FROM Contact
									WHERE AccountId = :acc.Id];

		if (acc.Phone != null && (acc.Phone != Trigger.oldMap.get(acc.Id).Phone)) {

			for (Contact myContact : AccountContacts) {
				myContact.Phone = acc.Phone; 
				updateContacts.add(myContact);
			}
		}
	}
	update updateContacts;
}

// When the phone number of an account changes, 
// update the “work” phone number field on all of the related contacts.
