({
    copyInputFieldValue : function(component, event, helper) {
        // get lightning:textarea field value using aura:id
        // var textForCopy = 'https://mvclouds36-dev-ed.develop.my.salesforce-sites.com/k1/XMLFeed?Id='+component.get("v.selectionCategory.Id");
        // var textForCopy = component.find('inputF').get('v.value');
        var buttonAuraId = event.getSource().getLocalId();
        console.log("Button aura:id: " , buttonAuraId);
        if(buttonAuraId == 'btn1'){
            var outputElements = document.getElementsByClassName('output-holder1');
            var outputElement;
            var outputValue;
    
            if (outputElements.length > 0) {
                outputElement = outputElements[0];
                outputValue = outputElement.value;
    
                console.log('In if-->',outputValue);
            } else {
                outputValue = 'https://houzonrealestatellc--mvcsandbox.sandbox.my.salesforce-sites.com/XMLFeedForPF?Id='+component.get("v.selectionCategory.Id");
                console.error('In else-->',outputValue);
            }
            helper.copyTextHelper(component,event,outputValue);
        } else if (buttonAuraId == 'btn2'){
            var outputElements = document.getElementsByClassName('output-holder2');
            var outputElement;
            var outputValue;
    
            if (outputElements.length > 0) {
                outputElement = outputElements[0];
                outputValue = outputElement.value;
    
                console.log('In if-->',outputValue);
            } else {
                outputValue = 'https://houzonrealestatellc--mvcsandbox.sandbox.my.salesforce-sites.com/XMLFeed?Id='+component.get("v.selectionCategory.Id");
                console.error('In else-->',outputValue);
            }
            helper.copyTextHelper(component,event,outputValue);
        }    
    },
})