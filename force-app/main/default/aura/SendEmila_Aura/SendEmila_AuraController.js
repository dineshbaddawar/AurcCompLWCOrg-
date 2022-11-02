({
	doInit : function(component, event, helper) {
		debugger;
         var action = component.get("c.fetchLeadDetails");
         var currentRecId = component.get("v.recordId");
        action.setParams({
            "leadId": currentRecId
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS"){
                console.log("response.getState() ::",response.getState());
                debugger;
                var result = response.getReturnValue();
                console.log("serverResponse ::",result);
                component.set("v.emailId",result.Email);
                component.set("v.TemplateName",result.emailTemplateName);
                component.set("v.emailTemps",result.emailTemplateList);
                
                for(var i=0; i <result.emailTemplateList.length; i++){
                    if(result.emailTemplateList[i].Name == component.get("v.selectedValue")){
                        component.set("v.subject", result.emailTemplateList[i].Subject);
                        component.set("v.myMessage", result.emailTemplateList[i].HtmlValue);
                        component.set("v.leadRecord", result.leadRec);
                    }
                }
            }
        });
         $A.enqueueAction(action);
	},
    
    Send : function(component, event, helper) {
        debugger;
      var email = helper._e('txtEmail').value;
      var Subject = helper._e('txtSubject').value;  
      var Message = component.get("v.myMessage");
        
        if(email= ''){
            alert("Email is Required")
        } else if(Subject =''){
            alert("Subject is Required")
        } else if(Message=''){
            alert("Message is Required")
        }else{
            helper.SendEmail(component);
        }
    },
    
    showSpinner : function(component, event, helper) {
        component.set("v.Spinner", true);
    },
    
    hideSpinner : function(component, event, helper) {
        component.set("v.Spinner", false);
    },
    
    onchange : function(component, event, helper) {
        debugger;
        var emailTemplateSelected = component.find('select').get('v.value');
        var emailTemplateList = component.get("v.emailTemps");
        for(var i=0; i < emailTemplateList.length;i++){
            if(emailTemplateList[i].Name == emailTemplateSelected){
                component.set("v.subject", emailTemplateList[i].Subject);
                component.set("v.myMessage", emailTemplateList[i].HtmlValue);
            }
        }
    }
    
})