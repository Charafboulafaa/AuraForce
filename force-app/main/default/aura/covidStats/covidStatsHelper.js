({
    dataRetrieveHelper : function(component, event) {
        
        let action = component.get('c.retrieveDataUS');

        action.setCallback(this, function(res){

            let state = res.getState();

            if(state === "SUCCESS"){
                component.set("v.countryData", res.getReturnValue());
            }
            else if (state === "ERROR") {
                var errors = res.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        })
        $A.enqueueAction(action);
    },
})