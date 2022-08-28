({
    getData : function(component,event,helper){
        
        var action = component.get("c.loadData");
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == "SUCCESS"){
                var todoList = response.getReturnValue();
                for(var i=0; i < todoList.length;i++){
                   
                    todoList[i].linkToRecord = '/'+todoList[i].Id;
                }
                component.set("v.todoData",todoList);
            }
            else{
               
                console.log('Error occured while init of data '+state);
            }
        });
        $A.enqueueAction(action);
    },
    
    validateData : function(component, event, helper){
        var isValid = component.find("todoForm").reduce(function(validSoFar,inputComp){
            
            inputComp.showHelpMessageIfInvalid();
            return validSoFar && inputComp.get("v.validity").valid;
        },true);
        return isValid;
    }
})