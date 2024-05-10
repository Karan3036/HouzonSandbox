trigger UpdateContactTypeField on Contact (before update) {
    // List to store contacts that need to be updated
    List<Contact> contactsToUpdate = new List<Contact>();
    
    for (Contact con : Trigger.new) {
        // Check if the Multi-Select Picklist field has been changed
        if (con.ContactType_hz__c != Trigger.oldMap.get(con.Id).ContactType_hz__c) {
            // Update the Text field with the values from the Multi-Select Picklist
            if(Con.ContactType_hz__c != Null){
                con.Contact_Type_Multiselect_to_Text__c = String.join(con.ContactType_hz__c.split(';'), '; ');
            }
            else{
                con.Contact_Type_Multiselect_to_Text__c = '';
            }
            //contactsToUpdate.add(con);
        }
    }
    
    // Update the contacts
    // if (!contactsToUpdate.isEmpty()) {
    //     update contactsToUpdate;
    // }

}